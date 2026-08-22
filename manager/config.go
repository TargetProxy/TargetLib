package manager

import (
	"context"
	"errors"
	"strings"

	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	targetlibapi "github.com/loafman1120/TargetLib/api/TargetLib"
	"github.com/loafman1120/TargetLib/config"
)

// BuildConfig 把应用设置与订阅中间态（或原始配置）合成为可运行的 sing-box 配置，
// 替代客户端侧的配置拼装逻辑。
func (m *Manager) BuildConfig(_ context.Context, request *targetlibapi.BuildConfigRequest) (*targetlibapi.SubscriptionConfig, error) {
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
		return nil, status.Error(codes.InvalidArgument, "build source is required")
	}
	if err != nil {
		if errors.Is(err, config.ErrInvalidSettings) || errors.Is(err, config.ErrInvalidSource) {
			return nil, status.Error(codes.InvalidArgument, err.Error())
		}
		return nil, status.Error(codes.Internal, err.Error())
	}
	return &targetlibapi.SubscriptionConfig{Content: content}, nil
}

func buildSettings(proto *targetlibapi.BuildConfigSettings) (config.Settings, error) {
	if proto == nil {
		return config.Settings{}, status.Error(codes.InvalidArgument, "settings are required")
	}
	settings := config.Settings{
		ListenAddress: proto.GetListenAddress(),
		MixedPort:     int(proto.GetMixedPort()),
		SystemProxy:   proto.GetSystemProxy(),
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
