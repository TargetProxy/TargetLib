package manager

import (
	"context"
	"time"

	"github.com/google/uuid"
	api "github.com/loafman1120/TargetLib/api/TargetLib"
	"github.com/loafman1120/TargetLib/config"
	targetprofile "github.com/loafman1120/TargetLib/profile"
	"github.com/sagernet/sing-box/daemon"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"google.golang.org/protobuf/types/known/emptypb"
)

// SelectNode switches the default proxy node (proxy selector).
func (m *Manager) SelectNode(ctx context.Context, req *api.SelectNodeRequest) (*api.SelectNodeResponse, error) {
	if req == nil || req.NodeId == "" {
		return nil, status.Error(codes.InvalidArgument, "node_id is required")
	}

	m.opMu.Lock()
	pool := m.subscriptions.NodePool()
	node := findNodeByID(pool.Nodes, req.NodeId)
	if node == nil || !node.IsAvailable() {
		m.opMu.Unlock()
		return nil, status.Error(codes.NotFound, "node not found or unavailable")
	}

	next, _ := m.desiredForUpdate("")
	baseRevision := next.Revision
	next.Revision = uuid.NewString()
	next.NodePoolRevision = pool.Revision

	// Find or create proxy selector
	proxySelector := findSelector(next.Selectors, "proxy")
	previousSelected := ""
	if proxySelector != nil {
		previousSelected = proxySelector.SelectedNodeId
	}
	if proxySelector == nil {
		next.Selectors = append(next.Selectors, &api.SelectorConfig{
			Tag:            "proxy",
			SelectedNodeId: req.NodeId,
		})
	} else {
		proxySelector.SelectedNodeId = req.NodeId
	}

	// Update default binding
	defaultBinding := findBinding(next.ServiceBindings, config.DefaultServiceID)
	if defaultBinding == nil {
		next.ServiceBindings = append(next.ServiceBindings, &api.ServiceBinding{
			ServiceId:        config.DefaultServiceID,
			SelectorTag:      "proxy",
			NodeId:           req.NodeId,
			Revision:         next.Revision,
			SelectedAtUnixMs: currentTimeMillis(),
		})
	} else {
		defaultBinding.NodeId = req.NodeId
		defaultBinding.Revision = next.Revision
		defaultBinding.SelectedAtUnixMs = currentTimeMillis()
	}
	m.opMu.Unlock()

	_, content, err := m.prepareRuntimeContent(next, pool.Nodes)
	if err != nil {
		return nil, err
	}

	appliedImmediately := false

	// Serialize the live daemon/store commit, while keeping config generation
	// outside opMu so unrelated RPCs remain responsive.
	m.opMu.Lock()
	defer m.opMu.Unlock()
	if _, err := m.desiredForUpdate(baseRevision); err != nil {
		return nil, err
	}
	current, err := m.waitForStableStatus(ctx)
	if err != nil {
		return nil, err
	}
	running := current.Status == daemon.ServiceStatus_STARTED
	if running {
		// Try live select
		err = m.commitLiveSelector(ctx, next, pool.Nodes, content, "proxy", req.NodeId, previousSelected, true)
		if err != nil {
			return nil, status.Errorf(codes.Internal, "live select failed: %v", err)
		}
		appliedImmediately = true
	} else {
		// Save config for next start
		err = m.runtimeStore.SaveSnapshot(ctx, next, pool.Nodes)
		if err != nil {
			return nil, status.Errorf(codes.Internal, "save config failed: %v", err)
		}
		m.swapRuntime(next, pool.Nodes, content, false)
	}

	return &api.SelectNodeResponse{
		NodeId:             req.NodeId,
		NodeName:           node.Name,
		AppliedImmediately: appliedImmediately,
	}, nil
}

// GetProxyStatus returns current proxy status.
func (m *Manager) GetProxyStatus(ctx context.Context, _ *emptypb.Empty) (*api.ProxyStatus, error) {
	m.configMu.RLock()
	proxySelector := findSelector(m.runtimeConfig.Selectors, "proxy")
	m.configMu.RUnlock()

	pool := m.subscriptions.NodePool()
	if proxySelector == nil {
		return nil, status.Error(codes.Internal, "proxy selector not found")
	}

	// Find node info
	node := findNodeByID(pool.Nodes, proxySelector.SelectedNodeId)
	nodeName := ""
	nodeAvailable := false
	unavailableReason := ""

	if node != nil {
		nodeName = node.Name
		nodeAvailable = node.IsAvailable()
		if !nodeAvailable {
			if node.Phase == targetprofile.NodeFailed {
				unavailableReason = "node_failed"
			} else {
				unavailableReason = "node_not_ready"
			}
		}
	} else {
		unavailableReason = "node_not_in_pool"
	}

	// Get service state
	current, err := m.currentStatus()
	if err != nil {
		return nil, err
	}
	serviceState := managerState(current).State

	// SelectOutbound is synchronous, so a running service has the selected
	// node immediately after a successful live selection.
	actualNodeID := ""
	effective := false
	if current.Status == daemon.ServiceStatus_STARTED {
		actualNodeID = proxySelector.SelectedNodeId
		effective = true
	}

	// Get selection time from binding
	selectedAt := int64(0)
	m.configMu.RLock()
	defaultBinding := findBinding(m.runtimeConfig.ServiceBindings, config.DefaultServiceID)
	if defaultBinding != nil {
		selectedAt = defaultBinding.SelectedAtUnixMs
	}
	m.configMu.RUnlock()

	return &api.ProxyStatus{
		ServiceState:      serviceState,
		SelectedNodeId:    proxySelector.SelectedNodeId,
		SelectedNodeName:  nodeName,
		ActualNodeId:      actualNodeID,
		Effective:         effective,
		SelectedAtUnixMs:  selectedAt,
		NodeAvailable:     nodeAvailable,
		UnavailableReason: unavailableReason,
	}, nil
}

func currentTimeMillis() int64 {
	return time.Now().UnixMilli()
}
