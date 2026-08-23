package manager

import (
	"context"
	"errors"
	"fmt"
	"strings"

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
func (m *Manager) ApplyRuntimeSettings(_ context.Context, request *targetlibapi.BuildConfigRequest) (*targetlibapi.OperationResponse, error) {
	m.opMu.Lock()
	defer m.opMu.Unlock()

	content, err := m.buildConfig(request)
	if err != nil {
		return nil, err
	}
	if err := libbox.CheckConfig(string(content)); err != nil {
		return nil, status.Error(codes.InvalidArgument, err.Error())
	}

	current, err := m.currentStatus()
	if err != nil {
		return nil, err
	}
	switch current.Status {
	case daemon.ServiceStatus_IDLE, daemon.ServiceStatus_FATAL:
	case daemon.ServiceStatus_STARTED, daemon.ServiceStatus_STARTING:
	default:
		return nil, status.Error(codes.FailedPrecondition, "service is stopping")
	}

	m.configMu.RLock()
	previousConfig := m.config
	m.configMu.RUnlock()
	wasRunning := current.Status == daemon.ServiceStatus_STARTED || current.Status == daemon.ServiceStatus_STARTING
	if err := m.started.StartOrReloadService(string(content), &daemon.OverrideOptions{}); err != nil {
		if wasRunning && previousConfig != "" {
			if rollbackErr := m.started.StartOrReloadService(previousConfig, &daemon.OverrideOptions{}); rollbackErr != nil {
				return nil, status.Error(codes.Internal, fmt.Sprintf("apply runtime settings: %v; restore previous config: %v", err, rollbackErr))
			}
			return nil, status.Error(codes.Internal, fmt.Sprintf("apply runtime settings: %v; previous config restored", err))
		}
		return nil, status.Error(codes.Internal, fmt.Sprintf("apply runtime settings: %v", err))
	}

	m.configMu.Lock()
	m.config = string(content)
	m.lastSettings = proto.Clone(request.GetSettings()).(*targetlibapi.BuildConfigSettings)
	m.configMu.Unlock()
	return m.operationResponse()
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
	switch proto.GetProxyMode() {
	case targetlibapi.ProxyMode_PROXY_MODE_MIXED:
		settings.ProxyMode = config.ProxyModeMixed
	case targetlibapi.ProxyMode_PROXY_MODE_TUN:
		settings.ProxyMode = config.ProxyModeTun
	}
	if err := settings.Validate(); err != nil {
		return config.Settings{}, status.Error(codes.InvalidArgument, err.Error())
	}
	return settings, nil
}
