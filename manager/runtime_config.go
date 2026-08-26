package manager

import (
	"context"
	"errors"
	"os"
	"runtime"
	"time"

	"github.com/sagernet/sing-box/daemon"
	"github.com/sagernet/sing-box/experimental/libbox"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"google.golang.org/protobuf/proto"
	"google.golang.org/protobuf/types/known/emptypb"

	targetlibapi "github.com/loafman1120/TargetLib/api/TargetLib"
	"github.com/loafman1120/TargetLib/subscriptions"
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
	defer m.configMu.RUnlock()
	return cloneRuntimeConfig(m.runtimeConfig), nil
}

func (m *Manager) UpdateRuntimeConfig(ctx context.Context, request *targetlibapi.UpdateRuntimeConfigRequest) (*targetlibapi.RuntimeConfig, error) {
	if request == nil || request.GetSettings() == nil {
		return nil, status.Error(codes.InvalidArgument, "runtime settings are required")
	}
	m.opMu.Lock()
	defer m.opMu.Unlock()

	canonical := canonicalRuntimeSettings(request.GetSettings())
	settings, err := buildSettings(canonical, m.cacheFilePath)
	if err != nil {
		return nil, err
	}
	content, err := m.buildRuntimeConfigWithSettings(settings)
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
	if current.Status != daemon.ServiceStatus_STARTED && current.Status != daemon.ServiceStatus_IDLE && current.Status != daemon.ServiceStatus_FATAL {
		return nil, status.Errorf(codes.FailedPrecondition, "service is not ready to update runtime config: %s", current.Status.String())
	}
	next := &targetlibapi.RuntimeConfig{Settings: canonical}
	if err := m.commitRuntimeConfig(ctx, next, string(content), current.Status == daemon.ServiceStatus_STARTED); err != nil {
		return nil, err
	}
	return cloneRuntimeConfig(next), nil
}

func (m *Manager) commitRuntimeConfig(ctx context.Context, next *targetlibapi.RuntimeConfig, content string, running bool) error {
	m.configMu.Lock()
	defer m.configMu.Unlock()
	previousContent := m.config

	if running {
		if err := m.applyConfig(content); err != nil {
			return runtimeSettingsError("update runtime config", daemon.ServiceStatus_STARTED, err)
		}
	}
	if err := m.runtimeStore.Save(ctx, next); err != nil {
		if running {
			if rollbackErr := m.applyConfig(previousContent); rollbackErr != nil {
				return status.Errorf(codes.DataLoss, "save runtime config: %v; rollback active config: %v", err, rollbackErr)
			}
		}
		return status.Error(codes.Internal, err.Error())
	}

	m.runtimeConfig = next
	if running {
		m.config = content
	}
	return nil
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

func (m *Manager) reloadActiveSubscription(ctx context.Context, active *subscriptions.Subscription) error {
	m.opMu.Lock()
	defer m.opMu.Unlock()
	current, err := m.currentStatus()
	if err != nil {
		return err
	}
	if current.Status != daemon.ServiceStatus_STARTED {
		return nil
	}
	m.configMu.RLock()
	settingsProto := cloneRuntimeSettings(m.runtimeConfig.GetSettings())
	m.configMu.RUnlock()
	settings, err := buildSettings(settingsProto, m.cacheFilePath)
	if err != nil {
		return err
	}
	content, err := buildRuntimeConfigForSubscription(settings, active)
	if err != nil {
		return err
	}
	if err := libbox.CheckConfig(string(content)); err != nil {
		return status.Error(codes.InvalidArgument, err.Error())
	}
	if err := m.applyConfig(string(content)); err != nil {
		return runtimeSettingsError("reload active subscription", current.Status, err)
	}
	m.configMu.Lock()
	m.config = string(content)
	m.configMu.Unlock()
	return nil
}
