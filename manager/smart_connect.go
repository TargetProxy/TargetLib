package manager

import (
	"context"
	"encoding/json"
	"fmt"
	"sort"
	"time"

	"github.com/google/uuid"
	api "github.com/loafman1120/TargetLib/api/TargetLib"
	"github.com/loafman1120/TargetLib/config"
	targetprofile "github.com/loafman1120/TargetLib/profile"
	"github.com/loafman1120/TargetLib/subscriptions"
	"github.com/sagernet/sing-box/daemon"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"google.golang.org/protobuf/proto"
	"google.golang.org/protobuf/types/known/emptypb"
)

func (m *Manager) commitSmartRuntime(ctx context.Context, next *api.RuntimeConfig, nodes []targetprofile.Node, operationID string) error {
	content, err := proto.Marshal(next)
	if err != nil {
		return err
	}
	nodeContent, err := json.Marshal(nodes)
	if err != nil {
		return err
	}
	s := m.smart
	s.mu.Lock()
	defer s.mu.Unlock()
	if s.closed {
		return status.Error(codes.Unavailable, "manager is closed")
	}
	snapshot := proto.Clone(s.snapshot).(*api.SmartConnectSnapshot)
	if operationID != "" {
		operation := findOperation(snapshot, operationID)
		if operation != nil {
			now := time.Now().UnixMilli()
			operation.Phase = "runtime_committed"
			operation.RuntimeRevision = next.Revision
			operation.UpdatedAtUnixMs = now
		}
	}
	smartContent, err := proto.Marshal(snapshot)
	if err != nil {
		return err
	}
	if err := m.runtimeStore.store.Update(ctx, func(tx subscriptions.StoreTx) error {
		if err := tx.SetMetadata(runtimeConfigMetadataKey, content); err != nil {
			return err
		}
		if err := tx.SetMetadata(runtimeNodesMetadataKey, nodeContent); err != nil {
			return err
		}
		return tx.SetMetadata(smartMetadataKey, smartContent)
	}); err != nil {
		return err
	}
	s.snapshot = snapshot
	return nil
}

func runtimeModel(value *api.RuntimeConfig, nodes []targetprofile.Node) config.RuntimeModel {
	model := config.RuntimeModel{NodePool: config.NodePool{Nodes: nodes}}
	for _, selector := range value.Selectors {
		model.Selectors = append(model.Selectors, config.Selector{Tag: selector.GetTag(), NodeIDs: selector.GetNodeIds(), Selected: selector.GetSelectedNodeId()})
	}
	for _, route := range value.ServiceRoutes {
		model.ServiceRoutes = append(model.ServiceRoutes, config.ServiceRoute{ServiceID: route.GetServiceId(), Domains: route.GetDomains(), Selector: route.GetSelectorTag(), Enabled: route.GetEnabled()})
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

func (m *Manager) setApplyPhase(phase api.ConfigApplyPhase, revision string, err error) {
	m.configMu.Lock()
	m.applyState.Phase, m.applyState.AttemptedRevision = phase, revision
	m.applyState.ErrorMessage = ""
	if err != nil {
		m.applyState.ErrorMessage = err.Error()
	}
	state := proto.Clone(&m.applyState).(*api.RuntimeState)
	state.DesiredRevision = m.runtimeConfig.GetRevision()
	m.configMu.Unlock()
	m.publishRuntime(&api.RuntimeEvent{Type: api.RuntimeEventType_RUNTIME_EVENT_TYPE_CONFIG, State: state})
}

// Caller holds opMu. Pool reads never wait on runtime operations.
func (m *Manager) applyDesired(ctx context.Context, next *api.RuntimeConfig) (*api.RuntimeConfig, error) {
	return m.applyDesiredWithOperation(ctx, next, "")
}

func (m *Manager) applyDesiredWithOperation(ctx context.Context, next *api.RuntimeConfig, operationID string) (*api.RuntimeConfig, error) {
	next.Revision = uuid.NewString()
	m.setApplyPhase(api.ConfigApplyPhase_CONFIG_APPLY_PHASE_VALIDATING, next.Revision, nil)
	if _, err := buildSettings(next.Settings, m.cacheFilePath); err != nil {
		m.setApplyPhase(api.ConfigApplyPhase_CONFIG_APPLY_PHASE_FAILED, next.Revision, err)
		return nil, err
	}
	pool := m.subscriptions.NodePool()
	next.NodePoolRevision = pool.Revision
	current, err := m.waitForStableStatus(ctx)
	if err == nil {
		err = m.applySnapshot(ctx, next, pool.Nodes, current.Status == daemon.ServiceStatus_STARTED, current.Status == daemon.ServiceStatus_STARTED, operationID)
	}
	if err != nil {
		m.setApplyPhase(api.ConfigApplyPhase_CONFIG_APPLY_PHASE_FAILED, next.Revision, err)
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
	err := m.applySnapshot(ctx, next, nodes, true, wasRunning, "")
	if err != nil {
		m.setApplyPhase(api.ConfigApplyPhase_CONFIG_APPLY_PHASE_FAILED, next.Revision, err)
	}
	return err
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
			if node.Outbound != nil && node.Phase != targetprofile.NodeFailed {
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
		next.ServiceRoutes = append(next.ServiceRoutes, &api.ServiceRoute{ServiceId: route.ServiceID, Domains: route.Domains, SelectorTag: route.Selector, Enabled: route.Enabled})
	}
	for _, binding := range next.ServiceBindings {
		binding.Revision = next.Revision
	}
	sort.Slice(next.ServiceBindings, func(i, j int) bool { return next.ServiceBindings[i].ServiceId < next.ServiceBindings[j].ServiceId })
	return nil
}

// sing-box closes the old instance before attempting the new one. Both load
// and persistence failures therefore explicitly reload the last good config.
func (m *Manager) applySnapshot(ctx context.Context, next *api.RuntimeConfig, nodes []targetprofile.Node, activate, wasRunning bool, operationID string) error {
	m.setApplyPhase(api.ConfigApplyPhase_CONFIG_APPLY_PHASE_VALIDATING, next.Revision, nil)
	if err := normalizeDesired(next, nodes); err != nil {
		return err
	}
	settings, err := buildSettings(next.Settings, m.cacheFilePath)
	if err != nil {
		return err
	}
	m.setApplyPhase(api.ConfigApplyPhase_CONFIG_APPLY_PHASE_BUILDING, next.Revision, nil)
	content, err := buildRuntimeConfigForModel(settings, runtimeModel(next, nodes))
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
	m.setApplyPhase(api.ConfigApplyPhase_CONFIG_APPLY_PHASE_APPLYING, next.Revision, nil)
	if activate {
		if err = m.applyConfig(string(content)); err != nil {
			return rollback(err)
		}
	}
	// Once activation begins, complete the atomic commit even if the RPC ends.
	if operationID != "" {
		err = m.commitSmartRuntime(context.WithoutCancel(ctx), next, nodes, operationID)
	} else {
		err = m.runtimeStore.SaveSnapshot(context.WithoutCancel(ctx), next, nodes)
	}
	if err != nil {
		if activate {
			return rollback(err)
		}
		return status.Error(codes.Internal, err.Error())
	}
	m.configMu.Lock()
	m.runtimeConfig = cloneRuntimeConfig(next)
	m.runtimeNodes = append([]targetprofile.Node(nil), nodes...)
	if activate {
		m.config = string(content)
		m.appliedConfig = cloneRuntimeConfig(next)
	}
	m.configMu.Unlock()
	m.setApplyPhase(api.ConfigApplyPhase_CONFIG_APPLY_PHASE_READY, next.Revision, nil)
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

func (m *Manager) ListServiceBindings(_ context.Context, _ *emptypb.Empty) (*api.ServiceBindingList, error) {
	desired, _ := m.desiredForUpdate("")
	return &api.ServiceBindingList{Bindings: desired.ServiceBindings}, nil
}

func (m *Manager) ApplyServiceBinding(ctx context.Context, request *api.ApplyServiceBindingRequest) (*api.RuntimeConfig, error) {
	if request == nil || request.Binding == nil {
		return nil, status.Error(codes.InvalidArgument, "binding is required")
	}
	m.opMu.Lock()
	defer m.opMu.Unlock()
	next, err := m.desiredForUpdate(request.ExpectedRevision)
	if err != nil {
		return nil, err
	}
	binding := proto.Clone(request.Binding).(*api.ServiceBinding)
	if binding.SelectedAtUnixMs == 0 {
		binding.SelectedAtUnixMs = time.Now().UnixMilli()
	}
	if binding.SelectionReason == "" {
		binding.SelectionReason = "manual"
	}
	var route *api.ServiceRoute
	for _, candidate := range next.ServiceRoutes {
		if candidate.ServiceId == binding.ServiceId {
			route = candidate
		}
	}
	if route == nil || route.SelectorTag != binding.SelectorTag {
		return nil, status.Error(codes.InvalidArgument, "binding requires a matching service route")
	}
	found := false
	for _, selector := range next.Selectors {
		if selector.Tag == binding.SelectorTag {
			for _, id := range selector.NodeIds {
				if id == binding.NodeId {
					found = true
				}
			}
			selector.SelectedNodeId = binding.NodeId
		}
	}
	if !found {
		return nil, status.Error(codes.InvalidArgument, "binding node is not a selector member")
	}
	route.Enabled = true
	replaced := false
	for i, old := range next.ServiceBindings {
		if old.ServiceId == binding.ServiceId {
			next.ServiceBindings[i] = binding
			replaced = true
		}
	}
	if !replaced {
		next.ServiceBindings = append(next.ServiceBindings, binding)
	}
	return m.applyDesired(ctx, next)
}

func (m *Manager) RemoveServiceBinding(ctx context.Context, request *api.RemoveServiceBindingRequest) (*api.RuntimeConfig, error) {
	if request == nil || request.ServiceId == "" {
		return nil, status.Error(codes.InvalidArgument, "service ID is required")
	}
	m.opMu.Lock()
	defer m.opMu.Unlock()
	next, err := m.desiredForUpdate(request.ExpectedRevision)
	if err != nil {
		return nil, err
	}
	before := len(next.ServiceBindings)
	next.ServiceBindings = removeIf(next.ServiceBindings, func(binding *api.ServiceBinding) bool { return binding.ServiceId == request.ServiceId })
	if len(next.ServiceBindings) == before {
		return nil, status.Error(codes.NotFound, "service binding not found")
	}
	for _, route := range next.ServiceRoutes {
		if route.ServiceId == request.ServiceId {
			route.Enabled = false
		}
	}
	return m.applyDesired(ctx, next)
}

func (m *Manager) selectRuntimeOutbound(ctx context.Context, request *api.SelectOutboundRequest) (*emptypb.Empty, error) {
	m.opMu.Lock()
	defer m.opMu.Unlock()
	next, _ := m.desiredForUpdate("")
	found := false
	previousSelected := ""
	for _, selector := range next.Selectors {
		if selector.Tag == request.GroupTag {
			previousSelected = selector.SelectedNodeId
			selector.SelectedNodeId = request.OutboundTag
			found = true
		}
	}
	if !found && request.GroupTag == "proxy" {
		next.Selectors = append(next.Selectors, &api.SelectorConfig{Tag: "proxy", SelectedNodeId: request.OutboundTag})
		found = true
	}
	if !found {
		return nil, status.Error(codes.NotFound, "selector not found")
	}
	for _, binding := range next.ServiceBindings {
		if binding.SelectorTag == request.GroupTag {
			binding.NodeId = request.OutboundTag
		}
	}

	// Selecting an outbound is a live selector operation. Rebuilding the
	// entire service here closes active connections and cancels in-flight
	// dials, which is especially disruptive for AnyTLS connections.
	next.Revision = uuid.NewString()
	nodes := append([]targetprofile.Node(nil), m.runtimeNodes...)
	if err := normalizeDesired(next, nodes); err != nil {
		return nil, err
	}
	settings, err := buildSettings(next.Settings, m.cacheFilePath)
	if err != nil {
		return nil, err
	}
	content, err := buildRuntimeConfigForModel(settings, runtimeModel(next, nodes))
	if err != nil {
		return nil, err
	}

	current, err := m.waitForStableStatus(ctx)
	if err != nil {
		return nil, err
	}
	running := current.Status == daemon.ServiceStatus_STARTED
	if running {
		if m.daemon == nil {
			return nil, status.Error(codes.FailedPrecondition, "runtime selector is unavailable")
		}
		if _, err := m.daemon.SelectOutbound(ctx, request.GroupTag, request.OutboundTag); err != nil {
			return nil, err
		}
	}

	if err := m.runtimeStore.SaveSnapshot(context.WithoutCancel(ctx), next, nodes); err != nil {
		if running && previousSelected != "" {
			_, _ = m.daemon.SelectOutbound(context.WithoutCancel(ctx), request.GroupTag, previousSelected)
		}
		return nil, err
	}
	m.configMu.Lock()
	m.runtimeConfig = cloneRuntimeConfig(next)
	m.runtimeNodes = append([]targetprofile.Node(nil), nodes...)
	if running {
		m.config = string(content)
		m.appliedConfig = cloneRuntimeConfig(next)
	}
	m.configMu.Unlock()
	return &emptypb.Empty{}, nil
}

func (m *Manager) GetRuntimeState(ctx context.Context, _ *emptypb.Empty) (*api.RuntimeState, error) {
	// TryLock allows clients to observe transaction phases without blocking behind
	// a reload. Such snapshots intentionally make no effectiveness claims.
	stable := m.opMu.TryLock()
	if stable {
		defer m.opMu.Unlock()
	}
	m.configMu.RLock()
	result := proto.Clone(&m.applyState).(*api.RuntimeState)
	desired := cloneRuntimeConfig(m.runtimeConfig)
	var applied *api.RuntimeConfig
	if m.appliedConfig != nil {
		applied = cloneRuntimeConfig(m.appliedConfig)
	}
	m.configMu.RUnlock()
	result.DesiredRevision = desired.Revision
	pool := m.subscriptions.NodePool()
	result.NodePoolRevision = pool.Revision
	available := map[string]bool{"direct": true}
	for _, node := range pool.Nodes {
		available[node.ID] = node.Outbound != nil && node.Phase != targetprofile.NodeFailed
	}
	actual := make(map[string]string)
	if stable {
		current, err := m.currentStatus()
		if err != nil {
			return nil, err
		}
		result.Running = current.Status == daemon.ServiceStatus_STARTED
		if result.Running && applied != nil {
			groups, err := m.readInitialGroups(ctx)
			if err != nil {
				return nil, fmt.Errorf("read runtime selectors: %w", err)
			}
			for _, group := range groups.Group {
				actual[group.Tag] = group.Selected
			}
			result.AppliedRevision = applied.Revision
		}
	}
	same := stable && result.Running && applied != nil && applied.Revision == desired.Revision
	for _, selector := range desired.Selectors {
		selected, ok := actual[selector.Tag]
		result.Selectors = append(result.Selectors, &api.SelectorState{Desired: selector, ActualNodeId: selected, Effective: same && ok && selected == selector.SelectedNodeId})
	}
	routeEffective := make(map[string]bool)
	for _, route := range desired.ServiceRoutes {
		_, exists := actual[route.SelectorTag]
		effective := same && route.Enabled && desired.Settings.RouteMode != api.RouteMode_ROUTE_MODE_DIRECT && exists
		routeEffective[route.ServiceId] = effective
		result.ServiceRoutes = append(result.ServiceRoutes, &api.ServiceRouteState{Desired: route, Effective: effective})
	}
	var quality *api.SmartConnectSnapshot
	if m.smart != nil {
		quality = m.smart.read()
	}
	for _, binding := range desired.ServiceBindings {
		reason := ""
		now := time.Now().UnixMilli()
		if quality != nil && binding.NodeId != "direct" {
			reason = qualityReason(quality, binding.ServiceId, binding.NodeId, now)
		}
		if binding.ExpiresAtUnixMs > 0 && binding.ExpiresAtUnixMs <= now {
			reason = "binding_expired"
		}
		if !available[binding.NodeId] {
			reason = "node_unavailable"
		}
		result.ServiceBindings = append(result.ServiceBindings, &api.ServiceBindingState{Desired: binding, Effective: routeEffective[binding.ServiceId] && actual[binding.SelectorTag] == binding.NodeId, NodeAvailable: available[binding.NodeId], NeedsEvaluation: reason != "", EvaluationReason: reason})
	}
	return result, nil
}
