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

	libboxv1 "github.com/loafman1120/libbox/api/libbox/v1"
	"github.com/loafman1120/libbox/platform/systemproxy"
)

// Manager owns the single StartedService used by both gRPC APIs.
type Manager struct {
	libboxv1.UnimplementedLibboxManagerServer

	started *daemon.StartedService

	opMu     sync.Mutex
	configMu sync.RWMutex
	config   string
	close    sync.Once

	proxyMu     sync.Mutex
	proxyHost   string
	proxyPort   uint32
	proxyBypass string
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
	m := &Manager{
		proxyHost:   "127.0.0.1",
		proxyPort:   2080,
		proxyBypass: "<local>",
	}
	m.started = daemon.NewStartedService(daemon.ServiceOptions{
		Context:     serviceContext(ctx, options),
		Handler:     m,
		Debug:       options.Debug,
		LogMaxLines: options.LogMaxLines,
		OOMKiller:   options.OOMKiller,
	})
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

func (m *Manager) GetVersion(context.Context, *emptypb.Empty) (*libboxv1.VersionResponse, error) {
	return &libboxv1.VersionResponse{
		LibboxVersion:   projectVersion(),
		SingBoxVersion:  libbox.Version(),
		GoVersion:       runtime.Version(),
		ProtocolVersion: ProtocolVersion,
	}, nil
}

func (m *Manager) GetCapabilities(context.Context, *emptypb.Empty) (*libboxv1.CapabilitiesResponse, error) {
	proxyState, err := systemproxy.GetStatus()
	if err != nil {
		return nil, status.Error(codes.Internal, err.Error())
	}
	return &libboxv1.CapabilitiesResponse{
		Platform:    runtime.GOOS,
		SystemProxy: proxyState.Supported,
		PlatformVpn: false,
	}, nil
}

func (m *Manager) CheckConfig(_ context.Context, request *libboxv1.ConfigRequest) (*libboxv1.CheckConfigResponse, error) {
	if request.GetContent() == "" {
		return &libboxv1.CheckConfigResponse{Valid: false, FormattedError: "config is empty"}, nil
	}
	if err := libbox.CheckConfig(request.GetContent()); err != nil {
		return &libboxv1.CheckConfigResponse{Valid: false, FormattedError: err.Error()}, nil
	}
	return &libboxv1.CheckConfigResponse{Valid: true}, nil
}

func (m *Manager) Start(_ context.Context, request *libboxv1.StartRequest) (*libboxv1.OperationResponse, error) {
	if err := m.StartConfig(request.GetConfig()); err != nil {
		return nil, err
	}
	return m.operationResponse()
}

func (m *Manager) Reload(_ context.Context, request *libboxv1.ReloadRequest) (*libboxv1.OperationResponse, error) {
	if err := m.ReloadConfig(request.GetConfig()); err != nil {
		return nil, err
	}
	return m.operationResponse()
}

func (m *Manager) Restart(_ context.Context, request *libboxv1.RestartRequest) (*libboxv1.OperationResponse, error) {
	if err := m.RestartConfig(request.GetConfig()); err != nil {
		return nil, err
	}
	return m.operationResponse()
}

func (m *Manager) Stop(context.Context, *emptypb.Empty) (*libboxv1.OperationResponse, error) {
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
		if err := m.restoreSystemProxy(); err != nil {
			return status.Error(codes.Internal, err.Error())
		}
		return nil
	}
	if err := m.started.CloseService(); err != nil {
		return status.Error(codes.Internal, err.Error())
	}
	if err := m.restoreSystemProxy(); err != nil {
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

func (m *Manager) GetState(context.Context, *emptypb.Empty) (*libboxv1.ServiceState, error) {
	return m.State()
}

func (m *Manager) State() (*libboxv1.ServiceState, error) {
	current, err := m.currentStatus()
	if err != nil {
		return nil, err
	}
	return managerState(current), nil
}

func (m *Manager) SubscribeState(_ *emptypb.Empty, stream grpc.ServerStreamingServer[libboxv1.ServiceState]) error {
	return m.started.SubscribeServiceStatus(&emptypb.Empty{}, &statusRelay{target: stream})
}

func (m *Manager) GetSystemProxyStatus(context.Context, *emptypb.Empty) (*libboxv1.SystemProxyStatus, error) {
	return m.systemProxyStatus()
}

func (m *Manager) SetSystemProxy(_ context.Context, request *libboxv1.SetSystemProxyRequest) (*libboxv1.SystemProxyStatus, error) {
	m.proxyMu.Lock()
	defer m.proxyMu.Unlock()
	if request.GetEnabled() {
		if request.GetHost() == "" {
			return nil, status.Error(codes.InvalidArgument, "system proxy host is empty")
		}
		if request.GetPort() == 0 || request.GetPort() > 65535 {
			return nil, status.Error(codes.InvalidArgument, "system proxy port is out of range")
		}
		m.proxyHost = request.GetHost()
		m.proxyPort = request.GetPort()
		m.proxyBypass = request.GetBypass()
	}
	if err := systemproxy.Set(request.GetEnabled(), m.proxyHost, int32(m.proxyPort), m.proxyBypass); err != nil {
		return nil, status.Error(codes.Internal, err.Error())
	}
	return m.systemProxyStatus()
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

func (m *Manager) SystemProxyStatus() (*daemon.SystemProxyStatus, error) {
	value, err := systemproxy.GetStatus()
	if err != nil {
		return nil, err
	}
	return &daemon.SystemProxyStatus{Available: value.Supported, Enabled: value.Enabled}, nil
}

func (m *Manager) SetSystemProxyEnabled(enabled bool) error {
	m.proxyMu.Lock()
	defer m.proxyMu.Unlock()
	return systemproxy.Set(enabled, m.proxyHost, int32(m.proxyPort), m.proxyBypass)
}

func (*Manager) WriteDebugMessage(string) {}

func (m *Manager) Close() {
	m.close.Do(func() {
		m.opMu.Lock()
		defer m.opMu.Unlock()
		current, err := m.currentStatus()
		if err == nil && (current.Status == daemon.ServiceStatus_STARTED || current.Status == daemon.ServiceStatus_STARTING) {
			_ = m.started.CloseService()
		}
		_ = m.restoreSystemProxy()
		m.started.Close()
	})
}

func (m *Manager) operationResponse() (*libboxv1.OperationResponse, error) {
	current, err := m.currentStatus()
	if err != nil {
		return nil, err
	}
	return &libboxv1.OperationResponse{State: managerState(current)}, nil
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

func managerState(source *daemon.ServiceStatus) *libboxv1.ServiceState {
	stateType := libboxv1.ServiceStateType_SERVICE_STATE_UNSPECIFIED
	switch source.GetStatus() {
	case daemon.ServiceStatus_IDLE:
		stateType = libboxv1.ServiceStateType_SERVICE_STATE_IDLE
	case daemon.ServiceStatus_STARTING:
		stateType = libboxv1.ServiceStateType_SERVICE_STATE_STARTING
	case daemon.ServiceStatus_STARTED:
		stateType = libboxv1.ServiceStateType_SERVICE_STATE_RUNNING
	case daemon.ServiceStatus_STOPPING:
		stateType = libboxv1.ServiceStateType_SERVICE_STATE_STOPPING
	case daemon.ServiceStatus_FATAL:
		stateType = libboxv1.ServiceStateType_SERVICE_STATE_FAILED
	}
	return &libboxv1.ServiceState{
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

type statusRelay struct {
	target grpc.ServerStreamingServer[libboxv1.ServiceState]
}

func (r *statusRelay) Send(value *daemon.ServiceStatus) error {
	return r.target.Send(managerState(value))
}
func (r *statusRelay) SetHeader(md metadata.MD) error  { return r.target.SetHeader(md) }
func (r *statusRelay) SendHeader(md metadata.MD) error { return r.target.SendHeader(md) }
func (r *statusRelay) SetTrailer(md metadata.MD)       { r.target.SetTrailer(md) }
func (r *statusRelay) Context() context.Context        { return r.target.Context() }
func (r *statusRelay) SendMsg(value any) error         { return r.target.SendMsg(value) }
func (r *statusRelay) RecvMsg(value any) error         { return r.target.RecvMsg(value) }

func (m *Manager) systemProxyStatus() (*libboxv1.SystemProxyStatus, error) {
	value, err := systemproxy.GetStatus()
	if err != nil {
		return nil, status.Error(codes.Internal, err.Error())
	}
	return &libboxv1.SystemProxyStatus{
		Supported: value.Supported,
		Enabled:   value.Enabled,
		Server:    value.Server,
		Bypass:    value.Bypass,
	}, nil
}

func (m *Manager) restoreSystemProxy() error {
	value, err := systemproxy.GetStatus()
	if err != nil || !value.Enabled {
		return err
	}
	return systemproxy.Set(false, m.proxyHost, int32(m.proxyPort), m.proxyBypass)
}

func projectVersion() string {
	if info, ok := debug.ReadBuildInfo(); ok && info.Main.Version != "" && info.Main.Version != "(devel)" {
		return info.Main.Version
	}
	return "devel"
}

var _ daemon.PlatformHandler = (*Manager)(nil)
var _ libboxv1.LibboxManagerServer = (*Manager)(nil)
