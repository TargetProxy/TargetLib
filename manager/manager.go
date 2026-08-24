package manager

import (
	"context"
	"errors"
	"io"
	"os"
	"runtime"
	"runtime/debug"
	"sync"
	"time"

	box "github.com/sagernet/sing-box"
	"github.com/sagernet/sing-box/daemon"
	"github.com/sagernet/sing-box/experimental/libbox"
	"github.com/sagernet/sing-box/include"
	"github.com/sagernet/sing/service/filemanager"
	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/metadata"
	"google.golang.org/grpc/status"
	"google.golang.org/protobuf/types/known/emptypb"

	targetlibapi "github.com/loafman1120/TargetLib/api/TargetLib"
	subscriptioncore "github.com/loafman1120/TargetLib/subscriptions"
)

// Manager owns the single StartedService used by the TargetLib gRPC API.
type Manager struct {
	*subscriptioncore.Handler

	started            *daemon.StartedService
	subscriptions      *subscriptioncore.Manager
	subscriptionCancel context.CancelFunc
	subscriptionDone   chan struct{}
	subscriptionStore  io.Closer

	opMu          sync.Mutex
	configMu      sync.RWMutex
	config        string
	lastSettings  *targetlibapi.BuildConfigSettings
	latency       latencyService
	latencyMu     sync.Mutex
	latencyGroups map[string]chan struct{}
	close         sync.Once
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
	if err := Setup(options); err != nil {
		return nil, err
	}
	subscriptionManager := subscriptioncore.NewManager(subscriptioncore.Options{Store: options.SubscriptionStore})
	if err := subscriptionManager.Load(ctx); err != nil {
		if closer, ok := options.SubscriptionStore.(io.Closer); ok {
			_ = closer.Close()
		}
		return nil, err
	}
	subscriptionContext, cancelSubscriptions := context.WithCancel(ctx)
	m := &Manager{
		Handler: subscriptioncore.NewHandler(subscriptionManager), subscriptions: subscriptionManager,
		subscriptionCancel: cancelSubscriptions, subscriptionDone: make(chan struct{}),
	}
	m.Handler.SetActiveChangedCallback(m.reloadActiveSubscription)
	if closer, ok := options.SubscriptionStore.(io.Closer); ok {
		m.subscriptionStore = closer
	}
	m.started = daemon.NewStartedService(daemon.ServiceOptions{
		Context:     serviceContext(ctx, options),
		Handler:     platformHandler{manager: m},
		Debug:       options.Debug,
		LogMaxLines: options.LogMaxLines,
		OOMKiller:   options.OOMKiller,
	})
	m.latency = m.started
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
	ctx = filemanager.WithDefault(ctx, options.WorkingPath, options.TempPath, os.Getuid(), os.Getgid())
	return box.Context(ctx,
		include.InboundRegistry(),
		include.OutboundRegistry(),
		include.EndpointRegistry(),
		include.DNSTransportRegistry(),
		include.ServiceRegistry(),
	)
}

func (m *Manager) StartedService() *daemon.StartedService { return m.started }

func (m *Manager) GetVersion(context.Context, *emptypb.Empty) (*targetlibapi.VersionResponse, error) {
	return &targetlibapi.VersionResponse{
		TargetlibVersion: projectVersion(),
		SingBoxVersion:   libbox.Version(),
		GoVersion:        runtime.Version(),
		ProtocolVersion:  ProtocolVersion,
	}, nil
}

func (m *Manager) GetCapabilities(context.Context, *emptypb.Empty) (*targetlibapi.CapabilitiesResponse, error) {
	return &targetlibapi.CapabilitiesResponse{
		Platform:               runtime.GOOS,
		PlatformVpn:            false,
		SubscriptionManagement: true,
	}, nil
}

func (m *Manager) CheckConfig(_ context.Context, request *targetlibapi.ConfigRequest) (*targetlibapi.CheckConfigResponse, error) {
	if request.GetContent() == "" {
		return &targetlibapi.CheckConfigResponse{Valid: false, FormattedError: "config is empty"}, nil
	}
	if err := libbox.CheckConfig(request.GetContent()); err != nil {
		return &targetlibapi.CheckConfigResponse{Valid: false, FormattedError: err.Error()}, nil
	}
	return &targetlibapi.CheckConfigResponse{Valid: true}, nil
}

func (m *Manager) Start(_ context.Context, request *targetlibapi.StartRequest) (*targetlibapi.OperationResponse, error) {
	if err := m.StartConfig(request.GetConfig()); err != nil {
		return nil, err
	}
	return m.operationResponse()
}

func (m *Manager) Reload(_ context.Context, request *targetlibapi.ReloadRequest) (*targetlibapi.OperationResponse, error) {
	if err := m.ReloadConfig(request.GetConfig()); err != nil {
		return nil, err
	}
	return m.operationResponse()
}

func (m *Manager) Restart(_ context.Context, request *targetlibapi.RestartRequest) (*targetlibapi.OperationResponse, error) {
	if err := m.RestartConfig(request.GetConfig()); err != nil {
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

func (m *Manager) StartConfig(config string) error {
	if config == "" {
		return status.Error(codes.InvalidArgument, "config is empty")
	}
	m.opMu.Lock()
	defer m.opMu.Unlock()
	current, err := m.currentStatus()
	if err != nil {
		return err
	}
	if current.Status == daemon.ServiceStatus_STARTED || current.Status == daemon.ServiceStatus_STARTING {
		return status.Error(codes.FailedPrecondition, "service is already running")
	}
	return m.startOrReload(config)
}

func (m *Manager) ReloadConfig(config string) error {
	if config == "" {
		return status.Error(codes.InvalidArgument, "config is empty")
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

func (m *Manager) RestartConfig(config string) error {
	if config == "" {
		return status.Error(codes.InvalidArgument, "config is empty")
	}
	m.opMu.Lock()
	defer m.opMu.Unlock()
	current, err := m.currentStatus()
	if err != nil {
		return err
	}
	if current.Status == daemon.ServiceStatus_STARTED || current.Status == daemon.ServiceStatus_STARTING {
		if err := m.started.CloseService(); err != nil {
			return status.Error(codes.Internal, err.Error())
		}
	}
	return m.startOrReload(config)
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
	if err := m.started.StartOrReloadService(config, &daemon.OverrideOptions{}); err != nil {
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
	return m.started.SubscribeServiceStatus(&emptypb.Empty{}, newStatusRelay(stream))
}

func (m *Manager) SubscribeLogs(_ *emptypb.Empty, stream grpc.ServerStreamingServer[targetlibapi.LogBatch]) error {
	return m.started.SubscribeLog(&emptypb.Empty{}, newLogRelay(stream))
}

func (m *Manager) SelectOutbound(ctx context.Context, request *targetlibapi.SelectOutboundRequest) (*emptypb.Empty, error) {
	if request == nil || request.GetGroupTag() == "" || request.GetOutboundTag() == "" {
		return nil, status.Error(codes.InvalidArgument, "group_tag and outbound_tag are required")
	}
	return m.started.SelectOutbound(ctx, &daemon.SelectOutboundRequest{
		GroupTag: request.GetGroupTag(), OutboundTag: request.GetOutboundTag(),
	})
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
	return m.ReloadConfig(config)
}

// platformHandler exists only to satisfy sing-box's internal daemon contract.
// System proxy ownership stays in the user-session UI process.
type platformHandler struct {
	manager *Manager
}

func (h platformHandler) ServiceStop() error { return h.manager.ServiceStop() }

func (h platformHandler) ServiceReload() error { return h.manager.ServiceReload() }

func (platformHandler) SystemProxyStatus() (*daemon.SystemProxyStatus, error) {
	return &daemon.SystemProxyStatus{Available: false, Enabled: false}, nil
}

func (platformHandler) SetSystemProxyEnabled(bool) error {
	return status.Error(codes.Unimplemented, "system proxy is managed by the desktop client")
}

func (platformHandler) WriteDebugMessage(string) {}

func (m *Manager) Close() {
	m.close.Do(func() {
		m.subscriptionCancel()
		<-m.subscriptionDone
		m.opMu.Lock()
		defer m.opMu.Unlock()
		current, err := m.currentStatus()
		if err == nil && (current.Status == daemon.ServiceStatus_STARTED || current.Status == daemon.ServiceStatus_STARTING) {
			_ = m.started.CloseService()
		}
		m.started.Close()
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

var errStatusReceived = errors.New("status received")

func (m *Manager) currentStatus() (*daemon.ServiceStatus, error) {
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

type firstStatusReceiver struct {
	status *daemon.ServiceStatus
}

func (r *firstStatusReceiver) Send(value *daemon.ServiceStatus) error {
	r.status = value
	return errStatusReceived
}
func (*firstStatusReceiver) SetHeader(metadata.MD) error  { return nil }
func (*firstStatusReceiver) SendHeader(metadata.MD) error { return nil }
func (*firstStatusReceiver) SetTrailer(metadata.MD)       {}
func (*firstStatusReceiver) Context() context.Context     { return context.Background() }
func (*firstStatusReceiver) SendMsg(any) error            { return nil }
func (*firstStatusReceiver) RecvMsg(any) error            { return io.EOF }

type streamRelay struct{ target grpc.ServerStream }

func (r streamRelay) SetHeader(md metadata.MD) error  { return r.target.SetHeader(md) }
func (r streamRelay) SendHeader(md metadata.MD) error { return r.target.SendHeader(md) }
func (r streamRelay) SetTrailer(md metadata.MD)       { r.target.SetTrailer(md) }
func (r streamRelay) Context() context.Context        { return r.target.Context() }
func (r streamRelay) SendMsg(value any) error         { return r.target.SendMsg(value) }
func (r streamRelay) RecvMsg(value any) error         { return r.target.RecvMsg(value) }

type statusRelay struct {
	streamRelay
	server grpc.ServerStreamingServer[targetlibapi.ServiceState]
}

func newStatusRelay(server grpc.ServerStreamingServer[targetlibapi.ServiceState]) *statusRelay {
	return &statusRelay{streamRelay: streamRelay{target: server}, server: server}
}

type logRelay struct {
	streamRelay
	server grpc.ServerStreamingServer[targetlibapi.LogBatch]
}

func newLogRelay(server grpc.ServerStreamingServer[targetlibapi.LogBatch]) *logRelay {
	return &logRelay{streamRelay: streamRelay{target: server}, server: server}
}

func (r *logRelay) Send(value *daemon.Log) error {
	batch := &targetlibapi.LogBatch{Reset_: value.GetReset_()}
	for _, message := range value.GetMessages() {
		// sing-box forwards platform logs below its configured level. Keep
		// the public TargetLib stream at info and above.
		if message == nil || message.GetLevel() > daemon.LogLevel_INFO {
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
	return r.server.Send(batch)
}

func (r *statusRelay) Send(value *daemon.ServiceStatus) error {
	return r.server.Send(managerState(value))
}

func projectVersion() string {
	if info, ok := debug.ReadBuildInfo(); ok && info.Main.Version != "" && info.Main.Version != "(devel)" {
		return info.Main.Version
	}
	return "devel"
}

var _ daemon.PlatformHandler = platformHandler{}
var _ targetlibapi.TargetLibServer = (*Manager)(nil)
