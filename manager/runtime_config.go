package manager

import (
	"context"
	"runtime"
	"time"

	"github.com/sagernet/sing-box/daemon"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"google.golang.org/protobuf/proto"
	"google.golang.org/protobuf/types/known/emptypb"

	targetlibapi "github.com/loafman1120/TargetLib/api/TargetLib"
)

func defaultRuntimeConfig() *targetlibapi.RuntimeConfig {
	proxyMode := targetlibapi.ProxyMode_PROXY_MODE_MIXED
	if runtime.GOOS == "android" || runtime.GOOS == "ios" {
		proxyMode = targetlibapi.ProxyMode_PROXY_MODE_TUN
	}
	return &targetlibapi.RuntimeConfig{
		Settings: &targetlibapi.RuntimeSettings{
			ListenAddress: "127.0.0.1",
			MixedPort:     2080,
			ProxyMode:     proxyMode,
			RouteMode:     targetlibapi.RouteMode_ROUTE_MODE_RULE,
		},
	}
}

func cloneRuntimeSettings(value *targetlibapi.RuntimeSettings) *targetlibapi.RuntimeSettings {
	if value == nil {
		return nil
	}
	return proto.Clone(value).(*targetlibapi.RuntimeSettings)
}

func cloneRuntimeConfig(value *targetlibapi.RuntimeConfig) *targetlibapi.RuntimeConfig {
	return proto.Clone(value).(*targetlibapi.RuntimeConfig)
}

func canonicalRuntimeSettings(value *targetlibapi.RuntimeSettings) *targetlibapi.RuntimeSettings {
	result := cloneRuntimeSettings(value)
	if result != nil && (runtime.GOOS == "android" || runtime.GOOS == "ios") {
		result.ProxyMode = targetlibapi.ProxyMode_PROXY_MODE_TUN
	}
	return result
}

func (m *Manager) GetRuntimeConfig(context.Context, *emptypb.Empty) (*targetlibapi.RuntimeConfig, error) {
	m.configMu.RLock()
	config := m.runtimeConfig
	m.configMu.RUnlock()
	return cloneRuntimeConfig(config), nil
}

func (m *Manager) UpdateRuntimeConfig(ctx context.Context, request *targetlibapi.UpdateRuntimeConfigRequest) (*targetlibapi.RuntimeConfig, error) {
	if request == nil || request.GetSettings() == nil {
		return nil, status.Error(codes.InvalidArgument, "runtime settings are required")
	}
	m.opMu.Lock()
	defer m.opMu.Unlock()

	next := m.desiredForUpdate()
	next.Settings = canonicalRuntimeSettings(request.Settings)
	return m.applyDesired(ctx, next)
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
