package manager

import (
	"context"
	"strings"

	api "github.com/loafman1120/TargetLib/api/TargetLib"
	"github.com/loafman1120/TargetLib/config"
	"github.com/sagernet/sing-box/daemon"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"google.golang.org/protobuf/types/known/emptypb"
)

func (m *Manager) UpsertRoute(ctx context.Context, req *api.UpsertRouteRequest) (*api.RouteInfo, error) {
	if req == nil || strings.TrimSpace(req.GetServiceId()) == "" {
		return nil, status.Error(codes.InvalidArgument, "service_id is required")
	}
	if len(req.GetDomains()) == 0 {
		return nil, status.Error(codes.InvalidArgument, "domains are required")
	}
	m.opMu.Lock()
	defer m.opMu.Unlock()

	pool := m.subscriptions.NodePool()
	node := findNodeByID(pool.Nodes, req.GetNodeId())
	if node == nil || !node.IsAvailable() {
		return nil, status.Error(codes.NotFound, "node not found or unavailable")
	}
	next := m.desiredForUpdate()
	route := next.route(req.GetServiceId())
	selectorTag := "route-" + req.GetServiceId()
	if route != nil {
		selectorTag = route.Selector
	}
	selector := next.selector(selectorTag)
	if selector == nil {
		next.selectors = append(next.selectors, config.Selector{Tag: selectorTag})
		selector = next.selector(selectorTag)
	}
	selector.Selected = req.GetNodeId()
	selector.SelectedAtUnixMs = currentTimeMillis()
	if route == nil {
		next.serviceRoutes = append(next.serviceRoutes, config.ServiceRoute{ServiceID: req.GetServiceId(), Selector: selectorTag})
		route = next.route(req.GetServiceId())
	}
	route.Domains = append([]string(nil), req.GetDomains()...)
	route.Enabled = req.GetEnabled()
	route.DisplayName = req.GetDisplayName()
	next, err := m.applyDesired(ctx, next)
	if err != nil {
		return nil, err
	}
	return m.routeInfo(next, route.ServiceID)
}

func (m *Manager) DeleteRoute(ctx context.Context, req *api.DeleteRouteRequest) (*emptypb.Empty, error) {
	if req == nil || strings.TrimSpace(req.GetServiceId()) == "" {
		return nil, status.Error(codes.InvalidArgument, "service_id is required")
	}
	m.opMu.Lock()
	defer m.opMu.Unlock()
	next := m.desiredForUpdate()
	if _, ok := next.removeRoute(req.GetServiceId()); !ok {
		return nil, status.Error(codes.NotFound, "route not found")
	}
	if _, err := m.applyDesired(ctx, next); err != nil {
		return nil, err
	}
	return &emptypb.Empty{}, nil
}

func (m *Manager) ListRoutes(_ context.Context, _ *emptypb.Empty) (*api.RouteList, error) {
	intent := m.desiredForUpdate()
	result := &api.RouteList{DefaultRoute: &api.RouteInfo{ServiceId: config.DefaultServiceID, SelectorTag: "proxy"}}
	for _, route := range intent.serviceRoutes {
		info, err := m.routeInfo(intent, route.ServiceID)
		if err != nil {
			return nil, err
		}
		result.Routes = append(result.Routes, info)
	}
	if proxy := intent.selector("proxy"); proxy != nil {
		result.DefaultRoute.CurrentNodeId = proxy.Selected
		if node := findNodeByID(m.subscriptions.NodePool().Nodes, proxy.Selected); node != nil {
			result.DefaultRoute.CurrentNodeName = node.Name
		}
	}
	return result, nil
}

func (m *Manager) SelectRouteNode(ctx context.Context, req *api.SelectRouteNodeRequest) (*api.SelectNodeResponse, error) {
	if req == nil || strings.TrimSpace(req.GetServiceId()) == "" || strings.TrimSpace(req.GetNodeId()) == "" {
		return nil, status.Error(codes.InvalidArgument, "service_id and node_id are required")
	}
	m.opMu.Lock()
	defer m.opMu.Unlock()
	pool := m.subscriptions.NodePool()
	node := findNodeByID(pool.Nodes, req.GetNodeId())
	nodeName := ""
	if req.GetNodeId() == "direct" {
		nodeName = "direct"
	} else if node == nil || !node.IsAvailable() {
		return nil, status.Error(codes.NotFound, "node not found or unavailable")
	} else {
		nodeName = node.Name
	}
	next := m.desiredForUpdate()
	route := next.route(req.GetServiceId())
	if route == nil {
		return nil, status.Error(codes.NotFound, "route not found")
	}
	running, err := m.selectNode(ctx, next, pool.Nodes, route.Selector, req.GetNodeId())
	if err != nil {
		return nil, err
	}
	return &api.SelectNodeResponse{NodeId: req.GetNodeId(), NodeName: nodeName, AppliedImmediately: running}, nil
}

func (m *Manager) routeInfo(intent runtimeIntent, serviceID string) (*api.RouteInfo, error) {
	route := intent.route(serviceID)
	if route == nil {
		return nil, status.Error(codes.NotFound, "route not found")
	}
	selector := intent.selector(route.Selector)
	if selector == nil {
		return nil, status.Error(codes.Internal, "route selector not found")
	}
	info := &api.RouteInfo{
		ServiceId: route.ServiceID, DisplayName: route.DisplayName,
		Domains: append([]string(nil), route.Domains...), SelectorTag: route.Selector,
		CurrentNodeId: selector.Selected, Enabled: route.Enabled,
	}
	if node := findNodeByID(m.subscriptions.NodePool().Nodes, info.CurrentNodeId); node != nil {
		info.CurrentNodeName = node.Name
	}
	info.Effective = route.Enabled && intent.settings.RouteMode != config.RouteModeDirect
	if info.Effective {
		current, err := m.currentStatus()
		if err != nil {
			return nil, err
		}
		info.Effective = current.Status == daemon.ServiceStatus_STARTED
	}
	return info, nil
}
