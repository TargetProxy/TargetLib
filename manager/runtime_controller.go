package manager

import (
	"context"
	"slices"

	api "github.com/loafman1120/TargetLib/api/TargetLib"
	"github.com/loafman1120/TargetLib/config"
	targetprofile "github.com/loafman1120/TargetLib/profile"
	"github.com/sagernet/sing-box/daemon"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"google.golang.org/protobuf/types/known/emptypb"
)

type runtimeSnapshot struct {
	settings config.Settings
	model    config.RuntimeModel
}

func findNodeByID(nodes []targetprofile.Node, nodeID string) *targetprofile.Node {
	for i := range nodes {
		if nodes[i].ID == nodeID {
			return &nodes[i]
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

func (m *Manager) desiredForUpdate() runtimeIntent {
	m.configMu.RLock()
	defer m.configMu.RUnlock()
	return m.intent.clone()
}

func (m *Manager) prepareRuntimeContent(next runtimeIntent, nodes []targetprofile.Node) (runtimeIntent, config.RuntimeModel, []byte, error) {
	model, err := next.modelForBuild(nodes)
	if err != nil {
		return runtimeIntent{}, config.RuntimeModel{}, nil, err
	}
	built, err := buildRuntimeConfigForModel(next.settings, model)
	if err != nil {
		return runtimeIntent{}, config.RuntimeModel{}, nil, err
	}
	next.selectors = built.Model.Selectors
	next.serviceRoutes = built.Model.ServiceRoutes
	return next, built.Model, built.Content, nil
}

func cloneRuntimeModel(model config.RuntimeModel) config.RuntimeModel {
	result := model
	result.NodePool.Nodes = append([]targetprofile.Node(nil), model.NodePool.Nodes...)
	result.Selectors = make([]config.Selector, len(model.Selectors))
	for index, selector := range model.Selectors {
		result.Selectors[index] = selector
		result.Selectors[index].NodeIDs = append([]string(nil), selector.NodeIDs...)
	}
	result.ServiceRoutes = make([]config.ServiceRoute, len(model.ServiceRoutes))
	for index, route := range model.ServiceRoutes {
		result.ServiceRoutes[index] = route
		result.ServiceRoutes[index].Domains = append([]string(nil), route.Domains...)
	}
	return result
}

func (m *Manager) activeRuntimeSnapshot() *runtimeSnapshot {
	m.configMu.RLock()
	defer m.configMu.RUnlock()
	if m.activeRuntime == nil {
		return nil
	}
	return &runtimeSnapshot{settings: m.activeRuntime.settings, model: cloneRuntimeModel(m.activeRuntime.model)}
}

func (m *Manager) commitRuntime(next runtimeIntent, model config.RuntimeModel, active bool) {
	m.configMu.Lock()
	m.intent = next.clone()
	if active {
		m.activeRuntime = &runtimeSnapshot{settings: next.settings, model: cloneRuntimeModel(model)}
	}
	m.configMu.Unlock()
}

// Caller holds opMu. Pool reads never wait on runtime operations.
func (m *Manager) applyDesired(ctx context.Context, next runtimeIntent) (runtimeIntent, error) {
	pool := m.subscriptions.NodePool()
	next.nodePoolRevision = pool.Revision
	normalized, model, content, err := m.prepareRuntimeContent(next, pool.Nodes)
	if err != nil {
		return runtimeIntent{}, err
	}
	current, err := m.waitForStableStatus(ctx)
	if err != nil {
		return runtimeIntent{}, err
	}
	running := current.Status == daemon.ServiceStatus_STARTED
	if err = m.applySnapshot(ctx, normalized, model, content, running, running); err != nil {
		return runtimeIntent{}, err
	}
	return normalized, nil
}

func (m *Manager) activateSavedRuntime(ctx context.Context, wasRunning bool) error {
	next := m.desiredForUpdate()
	pool := m.subscriptions.NodePool()
	next.nodePoolRevision = pool.Revision
	normalized, model, content, err := m.prepareRuntimeContent(next, pool.Nodes)
	if err != nil {
		return err
	}
	return m.applySnapshot(ctx, normalized, model, content, true, wasRunning)
}

func (m *Manager) applySnapshot(ctx context.Context, next runtimeIntent, model config.RuntimeModel, content []byte, activate, wasRunning bool) error {
	if err := m.checkConfig(ctx, string(content)); err != nil {
		return status.Error(codes.InvalidArgument, err.Error())
	}
	if err := ctx.Err(); err != nil {
		return status.FromContextError(err).Err()
	}
	rollback := func(cause error) error {
		if wasRunning {
			previous := m.activeRuntimeSnapshot()
			if previous == nil {
				return status.Errorf(codes.DataLoss, "apply failed: %v; last applied state is unavailable", cause)
			}
			previousBuild, buildErr := buildRuntimeConfigForModel(previous.settings, previous.model)
			if buildErr != nil {
				return status.Errorf(codes.DataLoss, "apply failed: %v; rebuild previous config: %v", cause, buildErr)
			}
			if restoreErr := m.applyConfig(string(previousBuild.Content)); restoreErr != nil {
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
		if err := m.applyConfig(string(content)); err != nil {
			return rollback(err)
		}
	}
	if err := m.runtimeStore.Save(context.WithoutCancel(ctx), next); err != nil {
		if activate {
			return rollback(err)
		}
		return status.Error(codes.Internal, err.Error())
	}
	m.commitRuntime(next, model, activate)
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

// Caller holds opMu, which serializes selector changes with full reloads.
func (m *Manager) selectNode(ctx context.Context, next runtimeIntent, nodes []targetprofile.Node, selectorTag, nodeID string) (bool, error) {
	current, err := m.waitForStableStatus(ctx)
	if err != nil {
		return false, err
	}
	if err := ctx.Err(); err != nil {
		return false, status.FromContextError(err).Err()
	}
	running := current.Status == daemon.ServiceStatus_STARTED
	selector := next.selector(selectorTag)
	if selector == nil && selectorTag != "proxy" {
		return false, status.Errorf(codes.FailedPrecondition, "selector %q is missing", selectorTag)
	}
	if selector == nil {
		next.selectors = append(next.selectors, config.Selector{Tag: selectorTag})
		selector = &next.selectors[len(next.selectors)-1]
	}
	selector.Selected = nodeID
	selector.SelectedAtUnixMs = currentTimeMillis()

	var active *config.Selector
	saveContext := ctx
	if running {
		active = m.appliedSelector(selectorTag)
		if active == nil || !slices.Contains(active.NodeIDs, nodeID) {
			return false, status.Error(codes.FailedPrecondition, "node is not loaded in the running selector; restart the service and retry")
		}
		if err := m.selectOutbound(ctx, selectorTag, nodeID); err != nil {
			return false, err
		}
		saveContext = context.WithoutCancel(ctx)
	} else {
		selector.NodeIDs = append(readyNodeIDs(nodes), "direct")
		slices.Sort(selector.NodeIDs)
	}
	if err := m.runtimeStore.Save(saveContext, next); err != nil {
		if active != nil && active.Selected != nodeID {
			if restoreErr := m.selectOutbound(saveContext, selectorTag, active.Selected); restoreErr != nil {
				m.configMu.Lock()
				active.Selected = nodeID
				active.SelectedAtUnixMs = selector.SelectedAtUnixMs
				m.configMu.Unlock()
				return false, status.Errorf(codes.DataLoss, "save selection failed: %v; restore active selection failed: %v", err, restoreErr)
			}
		}
		return false, status.Error(codes.Internal, err.Error())
	}
	m.configMu.Lock()
	m.intent = next
	if active != nil {
		active.Selected = nodeID
		active.SelectedAtUnixMs = selector.SelectedAtUnixMs
	}
	m.configMu.Unlock()
	return running, nil
}

func (m *Manager) appliedSelector(tag string) *config.Selector {
	if m.activeRuntime == nil {
		return nil
	}
	for i := range m.activeRuntime.model.Selectors {
		selector := &m.activeRuntime.model.Selectors[i]
		if selector.Tag == tag {
			return selector
		}
	}
	return nil
}
