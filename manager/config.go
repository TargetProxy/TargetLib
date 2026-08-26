package manager

import (
	"errors"
	"runtime"

	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	targetlibapi "github.com/loafman1120/TargetLib/api/TargetLib"
	"github.com/loafman1120/TargetLib/config"
	targetprofile "github.com/loafman1120/TargetLib/profile"
	"github.com/loafman1120/TargetLib/subscriptions"
)

// buildRuntimeConfig 是唯一的运行配置生成路径，使用后端持有的设置和已持久化的活动订阅。
func (m *Manager) buildRuntimeConfig() ([]byte, error) {
	m.configMu.RLock()
	settingsProto := cloneRuntimeSettings(m.runtimeConfig.GetSettings())
	m.configMu.RUnlock()
	settings, err := buildSettings(settingsProto, m.cacheFilePath)
	if err != nil {
		return nil, err
	}
	return m.buildRuntimeConfigWithSettings(settings)
}

func (m *Manager) buildRuntimeConfigWithSettings(settings config.Settings) ([]byte, error) {
	var active *subscriptions.Subscription
	if id := m.subscriptions.ActiveID(); id != "" {
		if subscription, ok := m.subscriptions.Get(id); ok {
			active = &subscription
		}
	}
	return buildRuntimeConfigForSubscription(settings, active)
}

func buildRuntimeConfigForSubscription(settings config.Settings, active *subscriptions.Subscription) ([]byte, error) {
	var content []byte
	var err error
	if active != nil {
		content, err = config.Build(settings, active.Profile)
	}
	if content == nil && err == nil {
		content, err = config.Build(settings, targetprofile.Profile{})
	}
	if err != nil {
		if errors.Is(err, config.ErrInvalidSettings) || errors.Is(err, config.ErrInvalidSource) {
			return nil, status.Error(codes.InvalidArgument, err.Error())
		}
		return nil, status.Error(codes.Internal, err.Error())
	}
	return content, nil
}

func buildSettings(source *targetlibapi.RuntimeSettings, cacheFilePath string) (config.Settings, error) {
	if source == nil {
		return config.Settings{}, status.Error(codes.InvalidArgument, "runtime settings are required")
	}
	settings := config.Settings{
		ListenAddress: source.GetListenAddress(),
		MixedPort:     int(source.GetMixedPort()),
		IPv6:          source.GetIpv6(),
		CacheFilePath: cacheFilePath,
	}
	switch source.GetRouteMode() {
	case targetlibapi.RouteMode_ROUTE_MODE_DIRECT:
		settings.RouteMode = config.RouteModeDirect
	case targetlibapi.RouteMode_ROUTE_MODE_ALL:
		settings.RouteMode = config.RouteModeAll
	case targetlibapi.RouteMode_ROUTE_MODE_RULE:
		settings.RouteMode = config.RouteModeRule
	default:
		return config.Settings{}, status.Error(codes.InvalidArgument, "route mode is required")
	}
	if runtime.GOOS == "android" || runtime.GOOS == "ios" {
		settings.ProxyMode = config.ProxyModeTun
	} else {
		switch source.GetProxyMode() {
		case targetlibapi.ProxyMode_PROXY_MODE_MIXED:
			settings.ProxyMode = config.ProxyModeMixed
		case targetlibapi.ProxyMode_PROXY_MODE_TUN:
			settings.ProxyMode = config.ProxyModeTun
		default:
			return config.Settings{}, status.Error(codes.InvalidArgument, "proxy mode is required")
		}
	}
	if err := settings.Validate(); err != nil {
		return config.Settings{}, status.Error(codes.InvalidArgument, err.Error())
	}
	return settings, nil
}
