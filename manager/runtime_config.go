package manager

import (
	"context"
	"runtime"
	"time"

	"github.com/loafman1120/TargetLib/config"
	"github.com/sagernet/sing-box/daemon"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"google.golang.org/protobuf/types/known/emptypb"

	targetlibapi "github.com/loafman1120/TargetLib/api/TargetLib"
)

func defaultRuntimeIntent() runtimeIntent {
	proxyMode := config.ProxyModeMixed
	if runtime.GOOS == "android" || runtime.GOOS == "ios" {
		proxyMode = config.ProxyModeTun
	}
	return runtimeIntent{
		selectors: []config.Selector{{Tag: "proxy", NodeIDs: []string{"direct"}, Selected: "direct"}},
		settings: config.Settings{
			ListenAddress: "127.0.0.1",
			MixedPort:     2080,
			ProxyMode:     proxyMode,
			RouteMode:     config.RouteModeRule,
		},
	}
}

func (m *Manager) GetRuntimeConfig(context.Context, *emptypb.Empty) (*targetlibapi.RuntimeConfig, error) {
	m.configMu.RLock()
	intent := m.intent.clone()
	m.configMu.RUnlock()
	return intent.proto(), nil
}

func (m *Manager) UpdateRuntimeConfig(ctx context.Context, request *targetlibapi.UpdateRuntimeConfigRequest) (*targetlibapi.RuntimeConfig, error) {
	if request == nil || request.GetSettings() == nil {
		return nil, status.Error(codes.InvalidArgument, "runtime settings are required")
	}
	m.opMu.Lock()
	defer m.opMu.Unlock()

	next := m.desiredForUpdate()
	settings, err := buildSettings(request.GetSettings())
	if err != nil {
		return nil, err
	}
	next.settings = settings
	updated, err := m.applyDesired(ctx, next)
	if err != nil {
		return nil, err
	}
	return updated.proto(), nil
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
