package manager

import (
	"context"

	api "github.com/loafman1120/TargetLib/api/TargetLib"
	"github.com/loafman1120/TargetLib/config"
	targetprofile "github.com/loafman1120/TargetLib/profile"
	"github.com/sagernet/sing-box/daemon"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"google.golang.org/protobuf/types/known/emptypb"
)

func findNodeByID(nodes []targetprofile.Node, nodeID string) *targetprofile.Node {
	for i := range nodes {
		if nodes[i].ID == nodeID {
			return &nodes[i]
		}
	}
	return nil
}

func findSelector(selectors []*api.SelectorConfig, tag string) *api.SelectorConfig {
	for _, sel := range selectors {
		if sel.Tag == tag {
			return sel
		}
	}
	return nil
}

func findRoute(routes []*api.ServiceRoute, id string) *api.ServiceRoute {
	for _, route := range routes {
		if route.GetServiceId() == id {
			return route
		}
	}
	return nil
}

func readyNodeIDs(nodes []targetprofile.Node) []string {
	ids := make([]string, 0, len(nodes))
	for _, node := range nodes {
		if node.IsAvailable() {
			ids = append(ids, node.ID)
		}
	}
	return ids
}

func runtimeModel(value *api.RuntimeConfig, nodes []targetprofile.Node) config.RuntimeModel {
	model := config.RuntimeModel{NodePool: config.NodePool{Nodes: nodes}}
	for _, selector := range value.Selectors {
		model.Selectors = append(model.Selectors, config.Selector{Tag: selector.GetTag(), NodeIDs: selector.GetNodeIds(), Selected: selector.GetSelectedNodeId(), SelectedAtUnixMs: selector.GetSelectedAtUnixMs()})
	}
	for _, route := range value.ServiceRoutes {
		model.ServiceRoutes = append(model.ServiceRoutes, config.ServiceRoute{ServiceID: route.GetServiceId(), DisplayName: route.GetDisplayName(), Domains: route.GetDomains(), Selector: route.GetSelectorTag(), Enabled: route.GetEnabled()})
	}
	return model
}

func (m *Manager) desiredForUpdate() *api.RuntimeConfig {
	m.configMu.RLock()
	defer m.configMu.RUnlock()
	return cloneRuntimeConfig(m.runtimeConfig)
}

// prepareRuntimeContent runs the shared settings -> normalize -> sing-box
// pipeline used by full reloads and live selector commits.
func (m *Manager) prepareRuntimeContent(next *api.RuntimeConfig, nodes []targetprofile.Node) ([]byte, error) {
	settings, err := buildSettings(next.Settings, m.cacheFilePath)
	if err != nil {
		return nil, err
	}
	return m.buildRuntimeContent(next, nodes, settings)
}

func (m *Manager) buildRuntimeContent(next *api.RuntimeConfig, nodes []targetprofile.Node, settings config.Settings) ([]byte, error) {
	model, err := normalizeDesired(next, nodes)
	if err != nil {
		return nil, err
	}
	content, err := buildRuntimeConfigForModel(settings, model)
	if err != nil {
		return nil, err
	}
	return content, nil
}

func (m *Manager) swapRuntime(next *api.RuntimeConfig, content []byte, activate bool) {
	m.configMu.Lock()
	m.runtimeConfig = cloneRuntimeConfig(next)
	if activate {
		m.config = string(content)
	}
	m.configMu.Unlock()
}

// Caller holds opMu. Pool reads never wait on runtime operations.
func (m *Manager) applyDesired(ctx context.Context, next *api.RuntimeConfig) (*api.RuntimeConfig, error) {
	settings, err := buildSettings(next.Settings, m.cacheFilePath)
	if err != nil {
		return nil, err
	}
	pool := m.subscriptions.NodePool()
	next.NodePoolRevision = pool.Revision
	content, err := m.buildRuntimeContent(next, pool.Nodes, settings)
	if err != nil {
		return nil, err
	}
	current, err := m.waitForStableStatus(ctx)
	if err == nil {
		err = m.applySnapshot(ctx, next, content, current.Status == daemon.ServiceStatus_STARTED, current.Status == daemon.ServiceStatus_STARTED)
	}
	if err != nil {
		return nil, err
	}
	return cloneRuntimeConfig(next), nil
}

func (m *Manager) activateSavedRuntime(ctx context.Context, wasRunning bool) error {
	next := m.desiredForUpdate()
	pool := m.subscriptions.NodePool()
	nodes := pool.Nodes
	next.NodePoolRevision = pool.Revision
	content, err := m.prepareRuntimeContent(next, nodes)
	if err != nil {
		return err
	}
	return m.applySnapshot(ctx, next, content, true, wasRunning)
}

func normalizeDesired(next *api.RuntimeConfig, nodes []targetprofile.Node) (config.RuntimeModel, error) {
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
	reconcileRuntimeSelections(next, nodes)
	model, err := normalizeRuntimeModel(runtimeModel(next, nodes))
	if err != nil {
		return config.RuntimeModel{}, err
	}
	next.Selectors = nil
	for _, selector := range model.Selectors {
		next.Selectors = append(next.Selectors, &api.SelectorConfig{Tag: selector.Tag, NodeIds: selector.NodeIDs, SelectedNodeId: selector.Selected, SelectedAtUnixMs: selector.SelectedAtUnixMs})
	}
	next.ServiceRoutes = nil
	for _, route := range model.ServiceRoutes {
		next.ServiceRoutes = append(next.ServiceRoutes, &api.ServiceRoute{ServiceId: route.ServiceID, DisplayName: route.DisplayName, Domains: route.Domains, SelectorTag: route.Selector, Enabled: route.Enabled})
	}
	return model, nil
}

func reconcileRuntimeSelections(next *api.RuntimeConfig, nodes []targetprofile.Node) {
	available := make(map[string]bool, len(nodes))
	for _, node := range nodes {
		if node.IsAvailable() {
			available[node.ID] = true
		}
	}
	for _, selector := range next.Selectors {
		if selector == nil {
			continue
		}
		if selector.GetSelectedNodeId() != "direct" && !available[selector.GetSelectedNodeId()] {
			selector.SelectedNodeId = "direct"
		}
		if selector.GetTag() == "proxy" {
			continue
		}
		filtered := make([]string, 0, len(selector.GetNodeIds())+1)
		for _, nodeID := range selector.GetNodeIds() {
			if nodeID == "direct" || available[nodeID] {
				filtered = append(filtered, nodeID)
			}
		}
		if len(filtered) == 0 {
			filtered = []string{"direct"}
		}
		selector.NodeIds = filtered
	}
}

// sing-box closes the old instance before attempting the new one. Both load
// and persistence failures therefore explicitly reload the last good config.
func (m *Manager) applySnapshot(ctx context.Context, next *api.RuntimeConfig, content []byte, activate, wasRunning bool) error {
	var err error
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
	err = m.runtimeStore.SaveSnapshot(context.WithoutCancel(ctx), next)
	if err != nil {
		if activate {
			return rollback(err)
		}
		return status.Error(codes.Internal, err.Error())
	}
	m.swapRuntime(next, content, activate)
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
func (m *Manager) commitLiveSelector(ctx context.Context, next *api.RuntimeConfig, content []byte, selectorTag, nodeID, previousSelected string, running bool) error {
	if running {
		if m.daemon == nil {
			return status.Error(codes.FailedPrecondition, "runtime selector is unavailable")
		}
		if _, err := m.daemon.SelectOutbound(ctx, selectorTag, nodeID); err != nil {
			return err
		}
	}
	err := m.runtimeStore.SaveSnapshot(context.WithoutCancel(ctx), next)
	if err != nil {
		if running && previousSelected != "" {
			_, _ = m.daemon.SelectOutbound(context.WithoutCancel(ctx), selectorTag, previousSelected)
		}
		return err
	}
	m.swapRuntime(next, content, running)
	return nil
}
