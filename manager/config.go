package manager

import (
	"errors"
	"runtime"

	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	targetlibapi "github.com/loafman1120/TargetLib/api/TargetLib"
	"github.com/loafman1120/TargetLib/config"
)

func buildRuntimeConfigForModel(settings config.Settings, model config.RuntimeModel) ([]byte, error) {
	content, err := config.Build(settings, model)
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
		// Selector state is persisted with the runtime revision. A sing-box
		// selection cache would override these authoritative defaults on reload.
		CacheFilePath: "",
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
