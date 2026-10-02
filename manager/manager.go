package manager

import (
	"context"
	"errors"
	"io"
	"os"
	"path/filepath"
	"sync"
	"time"

	"github.com/loafman1120/TargetLib/config"
	box "github.com/sagernet/sing-box"
	"github.com/sagernet/sing-box/adapter"
	"github.com/sagernet/sing-box/daemon"
	"github.com/sagernet/sing-box/experimental/libbox"
	"github.com/sagernet/sing-box/include"
	"github.com/sagernet/sing/service"
	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"google.golang.org/protobuf/proto"
	"google.golang.org/protobuf/types/known/emptypb"

	targetlibapi "github.com/loafman1120/TargetLib/api/TargetLib"
	subscriptioncore "github.com/loafman1120/TargetLib/subscriptions"
)

type Options struct {
	BasePath          string
	WorkingPath       string
	TempPath          string
	Locale            string
	LogMaxLines       int
	Debug             bool
	OOMKiller         bool
	ControlToken      string
	SubscriptionStore subscriptioncore.Store
}

// Manager 持有 TargetLib gRPC API 使用的唯一 StartedService 实例。
type Manager struct {
	*subscriptioncore.Handler

	started            *daemon.StartedService
	daemon             *daemonAdapter
	subscriptions      *subscriptioncore.Manager
	subscriptionCancel context.CancelFunc
	subscriptionDone   chan struct{}
	subscriptionStore  io.Closer

	opMu          sync.Mutex
	configMu      sync.RWMutex
	config        string
	runtimeConfig *targetlibapi.RuntimeConfig
	checkConfig   func(context.Context, string) error
	readStatus    func() (*daemon.ServiceStatus, error)
	runtimeStore  runtimeConfigStore
	cacheFilePath string
	applyConfig   func(string) error
	close         sync.Once
	controlToken  string
}

func Setup(options Options) error {
	options = normalizeOptions(options)
	if options.Locale != "" {
		libbox.SetLocale(options.Locale)
	}
	return libbox.Setup(&libbox.SetupOptions{
		BasePath:    options.BasePath,
		WorkingPath: options.WorkingPath,
		TempPath:    options.TempPath,
		LogMaxLines: options.LogMaxLines,
		Debug:       options.Debug,
	})
}

func New(ctx context.Context, options Options) (*Manager, error) {
	options = normalizeOptions(options)
	controlToken, err := loadControlToken(options.BasePath, options.ControlToken)
	if err != nil {
		return nil, err
	}
	if err := Setup(options); err != nil {
		return nil, err
	}
	sharedStore := options.SubscriptionStore
	if sharedStore == nil {
		sharedStore = &subscriptioncore.MemoryStore{}
	}
	subscriptionManager := subscriptioncore.NewManager(subscriptioncore.Options{Store: sharedStore})
	if err := subscriptionManager.Load(ctx); err != nil {
		subscriptionManager.Close()
		if closer, ok := sharedStore.(io.Closer); ok {
			_ = closer.Close()
		}
		return nil, err
	}
	subscriptionContext, cancelSubscriptions := context.WithCancel(ctx)
	runtimeStore := runtimeConfigStore{store: sharedStore}
	runtimeConfig, err := runtimeStore.Load(ctx)
	if err != nil {
		cancelSubscriptions()
		subscriptionManager.Close()
		return nil, err
	}
	if runtimeConfig == nil {
		runtimeConfig = defaultRuntimeConfig()
		if err := runtimeStore.Save(ctx, runtimeConfig); err != nil {
			cancelSubscriptions()
			subscriptionManager.Close()
			return nil, err
		}
	}
	canonicalSettings := canonicalRuntimeSettings(runtimeConfig.GetSettings())
	if !proto.Equal(canonicalSettings, runtimeConfig.GetSettings()) {
		runtimeConfig.Settings = canonicalSettings
		if err := runtimeStore.Save(ctx, runtimeConfig); err != nil {
			cancelSubscriptions()
			subscriptionManager.Close()
			return nil, err
		}
	}
	cacheFilePath := filepath.Join(options.BasePath, "cache.db")
	if _, err := buildSettings(runtimeConfig.GetSettings(), cacheFilePath); err != nil {
		cancelSubscriptions()
		subscriptionManager.Close()
		return nil, err
	}
	m := &Manager{
		Handler:            subscriptioncore.NewHandler(subscriptionManager),
		subscriptions:      subscriptionManager,
		subscriptionCancel: cancelSubscriptions,
		subscriptionDone:   make(chan struct{}),
		runtimeConfig:      runtimeConfig,
		runtimeStore:       runtimeStore,
		cacheFilePath:      cacheFilePath,
		controlToken:       controlToken,
	}
	if closer, ok := sharedStore.(io.Closer); ok {
		m.subscriptionStore = closer
	}
	m.started = daemon.NewStartedService(daemon.ServiceOptions{
		Context:          serviceContext(ctx, options),
		Handler:          platformHandler{manager: m},
		Debug:            options.Debug,
		LogMaxLines:      options.LogMaxLines,
		OOMKillerEnabled: options.OOMKiller,
	})
	m.applyConfig = func(content string) error {
		return m.started.StartOrReloadService(ctx, content, &daemon.OverrideOptions{})
	}
	m.checkConfig = m.started.CheckConfig
	m.daemon = newDaemonAdapter(m.started)
	m.readStatus = m.daemon.Status
	go func() {
		defer close(m.subscriptionDone)
		_ = subscriptionManager.Run(subscriptionContext)
	}()
	return m, nil
}

func normalizeOptions(options Options) Options {
	if options.WorkingPath == "" {
		options.WorkingPath = options.BasePath
	}
	if options.TempPath == "" {
		options.TempPath = options.WorkingPath
	}
	if options.LogMaxLines <= 0 {
		options.LogMaxLines = 300
	}
	return options
}

func serviceContext(ctx context.Context, options Options) context.Context {
	ctx = withFileManager(ctx, options.WorkingPath, options.TempPath, os.Getuid(), os.Getgid())
	ctx = box.Context(ctx,
		include.InboundRegistry(),
		include.OutboundRegistry(),
		include.EndpointRegistry(),
		include.DNSTransportRegistry(),
		include.ServiceRegistry(),
		include.CertificateProviderRegistry(),
	)
	if platform := newPlatformInterface(); platform != nil {
		service.MustRegister[adapter.PlatformInterface](ctx, platform)
	}
	return ctx
}

func (m *Manager) Start(_ context.Context, _ *emptypb.Empty) (*targetlibapi.OperationResponse, error) {
	if err := m.startRuntime(); err != nil {
		return nil, err
	}
	return m.operationResponse()
}

func (m *Manager) Restart(_ context.Context, _ *emptypb.Empty) (*targetlibapi.OperationResponse, error) {
	if err := m.restartRuntime(); err != nil {
		return nil, err
	}
	return m.operationResponse()
}

func (m *Manager) Stop(context.Context, *emptypb.Empty) (*targetlibapi.OperationResponse, error) {
	if err := m.StopService(); err != nil {
		return nil, err
	}
	return m.operationResponse()
}

func (m *Manager) startRuntime() error {
	m.opMu.Lock()
	defer m.opMu.Unlock()
	current, err := m.currentStatus()
	if err != nil {
		return err
	}
	if current.Status == daemon.ServiceStatus_STARTED || current.Status == daemon.ServiceStatus_STARTING {
		return status.Error(codes.FailedPrecondition, "service is already running")
	}
	return m.activateSavedRuntime(context.Background(), false)
}

func (m *Manager) restartRuntime() error {
	m.opMu.Lock()
	defer m.opMu.Unlock()
	current, err := m.currentStatus()
	if err != nil {
		return err
	}
	return m.activateSavedRuntime(context.Background(), current.Status == daemon.ServiceStatus_STARTED)
}

func (m *Manager) StopService() error {
	m.opMu.Lock()
	defer m.opMu.Unlock()
	current, err := m.currentStatus()
	if err != nil {
		return err
	}
	if current.Status == daemon.ServiceStatus_IDLE || current.Status == daemon.ServiceStatus_FATAL {
		return nil
	}
	if err := m.started.CloseService(); err != nil {
		return status.Error(codes.Internal, err.Error())
	}
	return nil
}

func (m *Manager) startOrReload(config string) error {
	if err := m.applyConfig(config); err != nil {
		return status.Error(codes.Internal, err.Error())
	}
	m.configMu.Lock()
	m.config = config
	m.configMu.Unlock()
	return nil
}

func (m *Manager) GetState(context.Context, *emptypb.Empty) (*targetlibapi.ServiceState, error) {
	return m.State()
}

func (m *Manager) State() (*targetlibapi.ServiceState, error) {
	current, err := m.currentStatus()
	if err != nil {
		return nil, err
	}
	return managerState(current), nil
}

func (m *Manager) SubscribeState(_ *emptypb.Empty, stream grpc.ServerStreamingServer[targetlibapi.ServiceState]) error {
	return m.started.SubscribeServiceStatus(&emptypb.Empty{}, &statusRelay{stream})
}

func (m *Manager) SubscribeLogs(_ *emptypb.Empty, stream grpc.ServerStreamingServer[targetlibapi.LogBatch]) error {
	return m.started.SubscribeLog(&emptypb.Empty{}, &logRelay{stream})
}

func (m *Manager) SubscribeTraffic(request *targetlibapi.TrafficRequest, stream grpc.ServerStreamingServer[targetlibapi.TrafficStatus]) error {
	interval, err := trafficInterval(request.GetIntervalMilliseconds())
	if err != nil {
		return err
	}
	return m.started.SubscribeStatus(
		&daemon.SubscribeStatusRequest{Interval: int64(interval)},
		&trafficRelay{ServerStreamingServer: stream, interval: interval},
	)
}

// UpdateSubscription adds a one-shot generated configuration to the update
// response so clients can compare it with the fetched provider document.
func (m *Manager) UpdateSubscription(ctx context.Context, request *targetlibapi.SubscriptionId) (*targetlibapi.SubscriptionUpdateResult, error) {
	result, err := m.Handler.UpdateSubscription(ctx, request)
	if err != nil || len(result.GetOriginalConfig()) == 0 {
		return result, err
	}
	subscription, ok := m.subscriptions.Get(request.GetId())
	if !ok {
		return nil, status.Errorf(codes.NotFound, "subscription %q not found", request.GetId())
	}
	m.configMu.RLock()
	settingsProto := cloneRuntimeSettings(m.runtimeConfig.GetSettings())
	m.configMu.RUnlock()
	settings, err := buildSettings(settingsProto, m.cacheFilePath)
	if err != nil {
		return nil, err
	}
	model, err := normalizeRuntimeModel(config.RuntimeModel{NodePool: config.NodePool{Nodes: subscription.Profile.Nodes}})
	if err != nil {
		return nil, err
	}
	content, err := buildRuntimeConfigForModel(settings, model)
	if err != nil {
		return nil, err
	}
	result.GeneratedConfig = content
	return result, nil
}

func (m *Manager) CloseConnection(ctx context.Context, request *targetlibapi.CloseConnectionRequest) (*emptypb.Empty, error) {
	if request == nil || request.GetId() == "" {
		return nil, status.Error(codes.InvalidArgument, "connection id is required")
	}
	return m.started.CloseConnection(ctx, &daemon.CloseConnectionRequest{Id: request.GetId()})
}

func (m *Manager) CloseAllConnections(ctx context.Context, request *emptypb.Empty) (*emptypb.Empty, error) {
	return m.started.CloseAllConnections(ctx, request)
}

func (m *Manager) ServiceStop() error { return m.StopService() }

func (m *Manager) ServiceReload() error {
	m.configMu.RLock()
	config := m.config
	m.configMu.RUnlock()
	if config == "" {
		return status.Error(codes.FailedPrecondition, "no active configuration")
	}
	m.opMu.Lock()
	defer m.opMu.Unlock()
	current, err := m.currentStatus()
	if err != nil {
		return err
	}
	if current.Status != daemon.ServiceStatus_STARTED {
		return status.Error(codes.FailedPrecondition, "service is not running")
	}
	return m.startOrReload(config)
}

type platformHandler struct{ manager *Manager }

func (h platformHandler) ServiceStop() error   { return h.manager.ServiceStop() }
func (h platformHandler) ServiceReload() error { return h.manager.ServiceReload() }
func (platformHandler) SystemProxyStatus() (*daemon.SystemProxyStatus, error) {
	return &daemon.SystemProxyStatus{Available: false, Enabled: false}, nil
}
func (platformHandler) SetSystemProxyEnabled(bool) error {
	return status.Error(codes.Unimplemented, "system proxy is managed by the desktop client")
}
func (platformHandler) WriteDebugMessage(string) {}
func (platformHandler) ConnectSSHAgent() (int32, error) {
	return -1, status.Error(codes.Unimplemented, "SSH agent is managed by the host")
}

func (m *Manager) Close() {
	m.close.Do(func() {
		m.subscriptionCancel()
		<-m.subscriptionDone
		m.subscriptions.Close()
		m.opMu.Lock()
		defer m.opMu.Unlock()
		current, err := m.currentStatus()
		if err == nil && (current.Status == daemon.ServiceStatus_STARTED || current.Status == daemon.ServiceStatus_STARTING) {
			_ = m.started.CloseService()
		}
		m.daemon.Close()
		if m.subscriptionStore != nil {
			_ = m.subscriptionStore.Close()
		}
	})
}

func (m *Manager) operationResponse() (*targetlibapi.OperationResponse, error) {
	current, err := m.currentStatus()
	if err != nil {
		return nil, err
	}
	return &targetlibapi.OperationResponse{State: managerState(current)}, nil
}

func (m *Manager) currentStatus() (*daemon.ServiceStatus, error) {
	if m.readStatus != nil {
		return m.readStatus()
	}
	if m.daemon != nil {
		return m.daemon.Status()
	}
	receiver := new(firstStatusReceiver)
	err := m.started.SubscribeServiceStatus(&emptypb.Empty{}, receiver)
	if errors.Is(err, errStatusReceived) && receiver.status != nil {
		return receiver.status, nil
	}
	if err == nil && receiver.status != nil {
		return receiver.status, nil
	}
	return nil, err
}

func managerState(source *daemon.ServiceStatus) *targetlibapi.ServiceState {
	stateType := targetlibapi.ServiceStateType_SERVICE_STATE_UNSPECIFIED
	switch source.GetStatus() {
	case daemon.ServiceStatus_IDLE:
		stateType = targetlibapi.ServiceStateType_SERVICE_STATE_IDLE
	case daemon.ServiceStatus_STARTING:
		stateType = targetlibapi.ServiceStateType_SERVICE_STATE_STARTING
	case daemon.ServiceStatus_STARTED:
		stateType = targetlibapi.ServiceStateType_SERVICE_STATE_RUNNING
	case daemon.ServiceStatus_STOPPING:
		stateType = targetlibapi.ServiceStateType_SERVICE_STATE_STOPPING
	case daemon.ServiceStatus_FATAL:
		stateType = targetlibapi.ServiceStateType_SERVICE_STATE_FAILED
	}
	return &targetlibapi.ServiceState{
		State:           stateType,
		ErrorMessage:    source.GetErrorMessage(),
		ChangedAtUnixMs: time.Now().UnixMilli(),
	}
}

type statusRelay struct {
	grpc.ServerStreamingServer[targetlibapi.ServiceState]
}
type logRelay struct {
	grpc.ServerStreamingServer[targetlibapi.LogBatch]
}
type trafficRelay struct {
	grpc.ServerStreamingServer[targetlibapi.TrafficStatus]
	interval time.Duration
}

func (r *logRelay) Send(value *daemon.Log) error {
	batch := &targetlibapi.LogBatch{Reset_: value.GetReset_()}
	for _, message := range value.GetMessages() {
		// sing-box 会转发低于配置级别的平台日志；公开 TargetLib 流只保留 ERROR 及以上。
		if message == nil || message.GetLevel() > daemon.LogLevel_ERROR {
			continue
		}
		batch.Messages = append(batch.Messages, &targetlibapi.LogMessage{
			Level:   targetlibapi.LogLevel(message.GetLevel() + 1),
			Message: message.GetMessage(),
		})
	}
	if len(batch.Messages) == 0 && !batch.Reset_ {
		return nil
	}
	return r.ServerStreamingServer.Send(batch)
}

func (r *statusRelay) Send(value *daemon.ServiceStatus) error {
	return r.ServerStreamingServer.Send(managerState(value))
}

func (r *trafficRelay) Send(value *daemon.Status) error {
	return r.ServerStreamingServer.Send(trafficStatus(value, r.interval, time.Now()))
}

const (
	defaultTrafficInterval = time.Second
	minimumTrafficInterval = 250 * time.Millisecond
	maximumTrafficInterval = 5 * time.Second
)

func trafficInterval(milliseconds uint32) (time.Duration, error) {
	if milliseconds == 0 {
		return defaultTrafficInterval, nil
	}
	interval := time.Duration(milliseconds) * time.Millisecond
	if interval < minimumTrafficInterval || interval > maximumTrafficInterval {
		return 0, status.Errorf(codes.InvalidArgument, "interval_milliseconds must be between %d and %d", minimumTrafficInterval.Milliseconds(), maximumTrafficInterval.Milliseconds())
	}
	return interval, nil
}

func trafficStatus(source *daemon.Status, interval time.Duration, sampledAt time.Time) *targetlibapi.TrafficStatus {
	return &targetlibapi.TrafficStatus{
		Available:              source.GetTrafficAvailable(),
		UploadBytesPerSecond:   bytesPerSecond(source.GetUplink(), interval),
		DownloadBytesPerSecond: bytesPerSecond(source.GetDownlink(), interval),
		UploadTotalBytes:       source.GetUplinkTotal(),
		DownloadTotalBytes:     source.GetDownlinkTotal(),
		InboundConnections:     source.GetConnectionsIn(),
		OutboundConnections:    source.GetConnectionsOut(),
		SampledAtUnixMs:        sampledAt.UnixMilli(),
		IntervalMilliseconds:   uint32(interval.Milliseconds()),
	}
}

func bytesPerSecond(bytes int64, interval time.Duration) int64 {
	if bytes <= 0 || interval <= 0 {
		return 0
	}
	return int64(float64(bytes) / interval.Seconds())
}

var _ daemon.PlatformHandler = platformHandler{}
var _ targetlibapi.TargetLibServer = (*Manager)(nil)
