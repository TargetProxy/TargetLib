package manager

import (
	"context"
	"errors"
	"fmt"
	"os"
	"runtime"
	"strings"
	"time"

	"github.com/sagernet/sing-box/daemon"
	"github.com/sagernet/sing-box/experimental/libbox"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"google.golang.org/protobuf/proto"

	targetlibapi "github.com/loafman1120/TargetLib/api/TargetLib"
	"github.com/loafman1120/TargetLib/config"
	subscriptioncore "github.com/loafman1120/TargetLib/subscriptions"
)

// BuildConfig 把应用设置与订阅中间态（或原始配置）合成为可运行的 sing-box 配置，
// 替代客户端侧的配置拼装逻辑。
func (m *Manager) BuildConfig(_ context.Context, request *targetlibapi.BuildConfigRequest) (*targetlibapi.SubscriptionConfig, error) {
	content, err := m.buildConfig(request)
	if err != nil {
		return nil, err
	}
	return &targetlibapi.SubscriptionConfig{Content: content}, nil
}

// ApplyRuntimeSettings builds and validates the requested configuration while
// holding the lifecycle lock, then starts or reloads the core. A failed reload
// is followed by a best-effort restoration of the last known good config.
func (m *Manager) ApplyRuntimeSettings(ctx context.Context, request *targetlibapi.BuildConfigRequest) (*targetlibapi.OperationResponse, error) {
	m.opMu.Lock()
	defer m.opMu.Unlock()

	content, err := m.buildConfig(request)
	if err != nil {
		return nil, err
	}
	if err := libbox.CheckConfig(string(content)); err != nil {
		return nil, status.Error(codes.InvalidArgument, err.Error())
	}

	current, err := m.waitForStableStatus(ctx)
	if err != nil {
		return nil, err
	}
	switch current.Status {
	case daemon.ServiceStatus_IDLE, daemon.ServiceStatus_FATAL:
	case daemon.ServiceStatus_STARTED:
	default:
		return nil, status.Errorf(codes.FailedPrecondition, "service is not ready to apply settings: %s", current.Status.String())
	}

	m.configMu.RLock()
	previousConfig := m.config
	m.configMu.RUnlock()
	wasRunning := current.Status == daemon.ServiceStatus_STARTED
	if err := m.started.StartOrReloadService(string(content), &daemon.OverrideOptions{}); err != nil {
		applyErr := runtimeSettingsError("apply runtime settings", current.Status, err)
		// os.ErrInvalid is rejected before sing-box changes the active instance,
		// so attempting a rollback would only repeat the same invalid transition.
		if errors.Is(err, os.ErrInvalid) {
			return nil, applyErr
		}
		if wasRunning && previousConfig != "" {
			if rollbackErr := m.started.StartOrReloadService(previousConfig, &daemon.OverrideOptions{}); rollbackErr != nil {
				return nil, status.Error(codes.Internal, fmt.Sprintf("%v; restore previous config: %v", applyErr, rollbackErr))
			}
			return nil, status.Error(status.Code(applyErr), fmt.Sprintf("%v; previous config restored", applyErr))
		}
		return nil, applyErr
	}

	m.configMu.Lock()
	m.config = string(content)
	m.lastSettings = proto.Clone(request.GetSettings()).(*targetlibapi.BuildConfigSettings)
	m.configMu.Unlock()
	return m.operationResponse()
}

const stableStatusTimeout = 15 * time.Second

func (m *Manager) waitForStableStatus(ctx context.Context) (*daemon.ServiceStatus, error) {
	if ctx == nil {
		ctx = context.Background()
	}
	ctx, cancel := context.WithTimeout(ctx, stableStatusTimeout)
	defer cancel()

	ticker := time.NewTicker(50 * time.Millisecond)
	defer ticker.Stop()
	for {
		current, err := m.currentStatus()
		if err != nil {
			return nil, err
		}
		if current.Status != daemon.ServiceStatus_STARTING && current.Status != daemon.ServiceStatus_STOPPING {
			return current, nil
		}
		select {
		case <-ctx.Done():
			return nil, status.Errorf(codes.FailedPrecondition, "service remained in %s state: %v", current.Status.String(), ctx.Err())
		case <-ticker.C:
		}
	}
}

func runtimeSettingsError(operation string, serviceStatus daemon.ServiceStatus_Type, err error) error {
	if errors.Is(err, os.ErrInvalid) {
		return status.Errorf(codes.FailedPrecondition, "%s rejected while service state is %s: %v", operation, serviceStatus.String(), err)
	}
	return status.Errorf(codes.Internal, "%s: %v", operation, err)
}

// reloadActiveSubscription rebuilds the persisted active subscription using
// the last UI settings after a subscription mutation.
func (m *Manager) reloadActiveSubscription(ctx context.Context) error {
	m.configMu.RLock()
	settings := m.lastSettings
	if settings != nil {
		settings = proto.Clone(settings).(*targetlibapi.BuildConfigSettings)
	}
	m.configMu.RUnlock()
	if settings == nil {
		return nil
	}
	current, err := m.currentStatus()
	if err != nil {
		return err
	}
	if current.Status != daemon.ServiceStatus_STARTED && current.Status != daemon.ServiceStatus_STARTING {
		return nil
	}
	_, err = m.ApplyRuntimeSettings(ctx, &targetlibapi.BuildConfigRequest{Settings: settings})
	return err
}

func (m *Manager) buildConfig(request *targetlibapi.BuildConfigRequest) ([]byte, error) {
	if request == nil {
		return nil, status.Error(codes.InvalidArgument, "request is required")
	}
	settings, err := buildSettings(request.GetSettings())
	if err != nil {
		return nil, err
	}
	var content []byte
	switch source := request.GetSource().(type) {
	case *targetlibapi.BuildConfigRequest_SubscriptionId:
		id := strings.TrimSpace(source.SubscriptionId)
		if id == "" {
			return nil, status.Error(codes.InvalidArgument, "subscription ID is required")
		}
		subscription, ok := m.subscriptions.Get(id)
		if !ok {
			return nil, status.Errorf(codes.NotFound, "subscription %q not found", id)
		}
		content, err = config.BuildFromNodes(settings, subscription.Nodes)
	case *targetlibapi.BuildConfigRequest_RawConfig:
		content, err = config.BuildFromRaw(settings, source.RawConfig)
	default:
		// No explicit source: build from the persisted active subscription.
		// Without one (or with a stale reference) fall back to a direct-only
		// configuration so the core always has a runnable config.
		var nodes []subscriptioncore.Node
		if id := m.subscriptions.ActiveID(); id != "" {
			if subscription, ok := m.subscriptions.Get(id); ok {
				nodes = subscription.Nodes
			}
		}
		content, err = config.BuildFromNodes(settings, nodes)
	}
	if err != nil {
		if errors.Is(err, config.ErrInvalidSettings) || errors.Is(err, config.ErrInvalidSource) {
			return nil, status.Error(codes.InvalidArgument, err.Error())
		}
		return nil, status.Error(codes.Internal, err.Error())
	}
	return content, nil
}

func buildSettings(proto *targetlibapi.BuildConfigSettings) (config.Settings, error) {
	if proto == nil {
		return config.Settings{}, status.Error(codes.InvalidArgument, "settings are required")
	}
	settings := config.Settings{
		ListenAddress: proto.GetListenAddress(),
		MixedPort:     int(proto.GetMixedPort()),
		IPv6:          proto.GetIpv6(),
		CacheFilePath: proto.GetCacheFilePath(),
	}
	switch proto.GetRouteMode() {
	case targetlibapi.RouteMode_ROUTE_MODE_DIRECT:
		settings.RouteMode = config.RouteModeDirect
	case targetlibapi.RouteMode_ROUTE_MODE_ALL:
		settings.RouteMode = config.RouteModeAll
	case targetlibapi.RouteMode_ROUTE_MODE_UNSPECIFIED, targetlibapi.RouteMode_ROUTE_MODE_RULE:
		settings.RouteMode = config.RouteModeRule
	default:
		return config.Settings{}, status.Error(codes.InvalidArgument, "unknown route mode")
	}
	if runtime.GOOS == "android" || runtime.GOOS == "ios" {
		settings.ProxyMode = config.ProxyModeTun
	} else {
		switch proto.GetProxyMode() {
		case targetlibapi.ProxyMode_PROXY_MODE_MIXED:
			settings.ProxyMode = config.ProxyModeMixed
		case targetlibapi.ProxyMode_PROXY_MODE_TUN:
			settings.ProxyMode = config.ProxyModeTun
		}
	}
	if err := settings.Validate(); err != nil {
		return config.Settings{}, status.Error(codes.InvalidArgument, err.Error())
	}
	return settings, nil
}
