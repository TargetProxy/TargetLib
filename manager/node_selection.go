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
	nodeName := ""
	if req.NodeId == "direct" {
		nodeName = "direct"
	} else if node == nil || !node.IsAvailable() {
		return nil, status.Error(codes.NotFound, "node not found or unavailable")
	} else {
		nodeName = node.Name
	}

	next := m.desiredForUpdate()
	running, err := m.selectNode(ctx, next, pool.Nodes, "proxy", req.NodeId)
	if err != nil {
		return nil, err
	}

	return &api.SelectNodeResponse{
		NodeId:             req.NodeId,
		NodeName:           nodeName,
		AppliedImmediately: running,
	}, nil
}

// GetProxyStatus returns current proxy status.
func (m *Manager) GetProxyStatus(context.Context, *emptypb.Empty) (*api.ProxyStatus, error) {
	current, err := m.currentStatus()
	if err != nil {
		return nil, err
	}

	m.configMu.RLock()
	proxySelector := m.intent.selector("proxy")
	if proxySelector == nil {
		m.configMu.RUnlock()
		return nil, status.Error(codes.Internal, "proxy selector not found")
	}
	selected := *proxySelector
	actualNodeID := ""
	if current.Status == daemon.ServiceStatus_STARTED {
		if active := m.appliedSelector("proxy"); active != nil {
			actualNodeID = active.Selected
		}
	}
	m.configMu.RUnlock()

	pool := m.subscriptions.NodePool()
	node := findNodeByID(pool.Nodes, selected.Selected)
	nodeName := ""
	nodeAvailable := false
	unavailableReason := ""

	if selected.Selected == "direct" {
		nodeName = "direct"
		nodeAvailable = true
	} else if node != nil {
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

	return &api.ProxyStatus{
		ServiceState:      managerState(current).State,
		SelectedNodeId:    selected.Selected,
		SelectedNodeName:  nodeName,
		ActualNodeId:      actualNodeID,
		Effective:         actualNodeID != "" && actualNodeID == selected.Selected,
		SelectedAtUnixMs:  selected.SelectedAtUnixMs,
		NodeAvailable:     nodeAvailable,
		UnavailableReason: unavailableReason,
	}, nil
}

func currentTimeMillis() int64 {
	return time.Now().UnixMilli()
}
