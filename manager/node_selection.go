package manager

import (
	"context"
	"time"

	api "github.com/loafman1120/TargetLib/api/TargetLib"
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
	defer m.opMu.Unlock()
	pool := m.subscriptions.NodePool()
	node := findNodeByID(pool.Nodes, req.NodeId)
	if node == nil || !node.IsAvailable() {
		return nil, status.Error(codes.NotFound, "node not found or unavailable")
	}

	next := m.desiredForUpdate()
	next.NodePoolRevision = pool.Revision

	// Find or create proxy selector
	proxySelector := findSelector(next.Selectors, "proxy")
	previousSelected := ""
	if proxySelector != nil {
		previousSelected = proxySelector.SelectedNodeId
	}
	if proxySelector == nil {
		proxySelector = &api.SelectorConfig{
			Tag:            "proxy",
			SelectedNodeId: req.NodeId,
		}
		next.Selectors = append(next.Selectors, proxySelector)
	} else {
		proxySelector.SelectedNodeId = req.NodeId
	}

	proxySelector.SelectedAtUnixMs = currentTimeMillis()

	content, err := m.prepareRuntimeContent(next, pool.Nodes)
	if err != nil {
		return nil, err
	}

	appliedImmediately := false

	current, err := m.waitForStableStatus(ctx)
	if err != nil {
		return nil, err
	}
	running := current.Status == daemon.ServiceStatus_STARTED
	if running {
		// Try live select
		err = m.commitLiveSelector(ctx, next, content, "proxy", req.NodeId, previousSelected, true)
		if err != nil {
			return nil, status.Errorf(codes.Internal, "live select failed: %v", err)
		}
		appliedImmediately = true
	} else {
		// Save config for next start
		err = m.runtimeStore.SaveSnapshot(ctx, next)
		if err != nil {
			return nil, status.Errorf(codes.Internal, "save config failed: %v", err)
		}
		m.swapRuntime(next, content, false)
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

	return &api.ProxyStatus{
		ServiceState:      serviceState,
		SelectedNodeId:    proxySelector.SelectedNodeId,
		SelectedNodeName:  nodeName,
		ActualNodeId:      actualNodeID,
		Effective:         effective,
		SelectedAtUnixMs:  proxySelector.SelectedAtUnixMs,
		NodeAvailable:     nodeAvailable,
		UnavailableReason: unavailableReason,
	}, nil
}

func currentTimeMillis() int64 {
	return time.Now().UnixMilli()
}
