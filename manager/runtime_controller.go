package manager

import (
	"context"
	"slices"
	"strings"

	"github.com/google/uuid"
	api "github.com/loafman1120/TargetLib/api/TargetLib"
	"github.com/loafman1120/TargetLib/config"
	targetprofile "github.com/loafman1120/TargetLib/profile"
	"github.com/sagernet/sing-box/daemon"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"google.golang.org/protobuf/types/known/emptypb"
)

func runtimeModel(value *api.RuntimeConfig, nodes []targetprofile.Node) config.RuntimeModel {
	model := config.RuntimeModel{NodePool: config.NodePool{Nodes: nodes}}
	for _, selector := range value.Selectors {
		model.Selectors = append(model.Selectors, config.Selector{Tag: selector.GetTag(), NodeIDs: selector.GetNodeIds(), Selected: selector.GetSelectedNodeId()})
	}
	for _, route := range value.ServiceRoutes {
		model.ServiceRoutes = append(model.ServiceRoutes, config.ServiceRoute{ServiceID: route.GetServiceId(), DisplayName: route.GetDisplayName(), Domains: route.GetDomains(), Selector: route.GetSelectorTag(), Enabled: route.GetEnabled()})
	}
	for _, binding := range value.ServiceBindings {
		model.ServiceBindings = append(model.ServiceBindings, config.ServiceBinding{ServiceID: binding.GetServiceId(), Selector: binding.GetSelectorTag(), Outbound: binding.GetNodeId(), Revision: binding.GetRevision()})
	}
	return model
}

func (m *Manager) desiredForUpdate(expected string) (*api.RuntimeConfig, error) {
	m.configMu.RLock()
	defer m.configMu.RUnlock()
	if expected != "" && expected != m.runtimeConfig.Revision {
		return nil, status.Error(codes.Aborted, "runtime revision changed")
	}
	return cloneRuntimeConfig(m.runtimeConfig), nil
}

// prepareRuntimeContent runs the shared normalize -> settings -> sing-box
// content pipeline used by full reloads and live selector commits.
func (m *Manager) prepareRuntimeContent(next *api.RuntimeConfig, nodes []targetprofile.Node) (config.Settings, []byte, error) {
	if err := normalizeDesired(next, nodes); err != nil {
		return config.Settings{}, nil, err
	}
	settings, err := buildSettings(next.Settings, m.cacheFilePath)
	if err != nil {
		return config.Settings{}, nil, err
	}
	content, err := buildRuntimeConfigForModel(settings, runtimeModel(next, nodes))
	if err != nil {
		return config.Settings{}, nil, err
	}
	return settings, content, nil
}

func (m *Manager) swapRuntime(next *api.RuntimeConfig, nodes []targetprofile.Node, content []byte, activate bool) {
	m.configMu.Lock()
	m.runtimeConfig = cloneRuntimeConfig(next)
	m.runtimeNodes = append([]targetprofile.Node(nil), nodes...)
	if activate {
		m.config = string(content)
		m.appliedConfig = cloneRuntimeConfig(next)
	}
	m.configMu.Unlock()
}

// Caller holds opMu. Pool reads never wait on runtime operations.
func (m *Manager) applyDesired(ctx context.Context, next *api.RuntimeConfig) (*api.RuntimeConfig, error) {
	next.Revision = uuid.NewString()
	if _, err := buildSettings(next.Settings, m.cacheFilePath); err != nil {
		return nil, err
	}
	pool := m.subscriptions.NodePool()
	next.NodePoolRevision = pool.Revision
	current, err := m.waitForStableStatus(ctx)
	if err == nil {
		err = m.applySnapshot(ctx, next, pool.Nodes, current.Status == daemon.ServiceStatus_STARTED, current.Status == daemon.ServiceStatus_STARTED)
	}
	if err != nil {
		return nil, err
	}
	return cloneRuntimeConfig(next), nil
}

func (m *Manager) activateSavedRuntime(ctx context.Context, wasRunning bool) error {
	next, _ := m.desiredForUpdate("")
	m.configMu.RLock()
	nodes := append([]targetprofile.Node(nil), m.runtimeNodes...)
	m.configMu.RUnlock()
	if next.Revision == "" {
		pool := m.subscriptions.NodePool()
		nodes, next.NodePoolRevision = pool.Nodes, pool.Revision
		next.Revision = uuid.NewString()
	}
	return m.applySnapshot(ctx, next, nodes, true, wasRunning)
}

func normalizeDesired(next *api.RuntimeConfig, nodes []targetprofile.Node) error {
	for _, binding := range next.ServiceBindings {
		if binding.GetExpiresAtUnixMs() < 0 {
			return status.Error(codes.InvalidArgument, "binding expiry must not be negative")
		}
	}
	hasProxy := false
	for _, selector := range next.Selectors {
		if selector.GetTag() == "proxy" {
			hasProxy = true
		}
	}
	if !hasProxy {
		selected := "direct"
		for _, node := range nodes {
			if node.IsAvailable() {
				selected = node.ID
				break
			}
		}
		next.Selectors = append(next.Selectors, &api.SelectorConfig{Tag: "proxy", SelectedNodeId: selected})
	}
	model, err := config.NormalizeRuntimeModel(runtimeModel(next, nodes))
	if err != nil {
		return status.Error(codes.InvalidArgument, err.Error())
	}
	next.Selectors = nil
	for _, selector := range model.Selectors {
		next.Selectors = append(next.Selectors, &api.SelectorConfig{Tag: selector.Tag, NodeIds: selector.NodeIDs, SelectedNodeId: selector.Selected})
	}
	next.ServiceRoutes = nil
	for _, route := range model.ServiceRoutes {
		next.ServiceRoutes = append(next.ServiceRoutes, &api.ServiceRoute{ServiceId: route.ServiceID, DisplayName: route.DisplayName, Domains: route.Domains, SelectorTag: route.Selector, Enabled: route.Enabled})
	}
	for _, binding := range next.ServiceBindings {
		binding.Revision = next.Revision
	}
	slices.SortFunc(next.ServiceBindings, func(a, b *api.ServiceBinding) int {
		return strings.Compare(a.ServiceId, b.ServiceId)
	})
	return nil
}

// sing-box closes the old instance before attempting the new one. Both load
// and persistence failures therefore explicitly reload the last good config.
func (m *Manager) applySnapshot(ctx context.Context, next *api.RuntimeConfig, nodes []targetprofile.Node, activate, wasRunning bool) error {
	_, content, err := m.prepareRuntimeContent(next, nodes)
	if err != nil {
		return err
	}
	if err = m.checkConfig(ctx, string(content)); err != nil {
		return status.Error(codes.InvalidArgument, err.Error())
	}
	if err = ctx.Err(); err != nil {
		return status.FromContextError(err).Err()
	}
	m.configMu.RLock()
	previousContent := m.config
	m.configMu.RUnlock()
	rollback := func(cause error) error {
		if wasRunning {
			if restoreErr := m.applyConfig(previousContent); restoreErr != nil {
				m.configMu.Lock()
				m.appliedConfig = nil
				m.configMu.Unlock()
				return status.Errorf(codes.DataLoss, "apply failed: %v; rollback failed: %v", cause, restoreErr)
			}
		} else if activate && m.started != nil {
			if closeErr := m.started.CloseService(); closeErr != nil {
				return status.Errorf(codes.DataLoss, "apply failed: %v; stop failed: %v", cause, closeErr)
			}
		}
		return status.Error(codes.Internal, cause.Error())
	}
	if activate {
		if err = m.applyConfig(string(content)); err != nil {
			return rollback(err)
		}
	}
	// Once activation begins, complete the atomic commit even if the RPC ends.
	err = m.runtimeStore.SaveSnapshot(context.WithoutCancel(ctx), next, nodes)
	if err != nil {
		if activate {
			return rollback(err)
		}
		return status.Error(codes.Internal, err.Error())
	}
	m.swapRuntime(next, nodes, content, activate)
	return nil
}

func (m *Manager) GetNodePool(_ context.Context, _ *emptypb.Empty) (*api.NodePool, error) {
	pool := m.subscriptions.NodePool()
	result := &api.NodePool{Revision: pool.Revision}
	for _, node := range pool.Nodes {
		phase := api.ProfileNodePhase_PROFILE_NODE_PHASE_READY
		if node.Phase == targetprofile.NodeFailed {
			phase = api.ProfileNodePhase_PROFILE_NODE_PHASE_FAILED
		}
		result.Nodes = append(result.Nodes, &api.ProfileNode{Tag: node.ID, SubscriptionId: node.SubscriptionID, Name: node.Name, Type: node.Type, Server: node.Server, Port: int32(node.Port), CountryCode: node.CountryCode, Phase: phase, ErrorMessage: node.Error})
	}
	return result, nil
}

// commitLiveSelector applies a sing-box selector change without a full
// reload, persists the model, and reverts the live selector on persistence
// failure.
func (m *Manager) commitLiveSelector(ctx context.Context, next *api.RuntimeConfig, nodes []targetprofile.Node, content []byte, selectorTag, nodeID, previousSelected string, running bool) error {
	if running {
		if m.daemon == nil {
			return status.Error(codes.FailedPrecondition, "runtime selector is unavailable")
		}
		if _, err := m.daemon.SelectOutbound(ctx, selectorTag, nodeID); err != nil {
			return err
		}
	}
	err := m.runtimeStore.SaveSnapshot(context.WithoutCancel(ctx), next, nodes)
	if err != nil {
		if running && previousSelected != "" {
			_, _ = m.daemon.SelectOutbound(context.WithoutCancel(ctx), selectorTag, previousSelected)
		}
		return err
	}
	m.swapRuntime(next, nodes, content, running)
	return nil
}
