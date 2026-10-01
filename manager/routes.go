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
	next, err := m.desiredForUpdate("")
	if err != nil {
		return nil, err
	}
	route := findRoute(next.ServiceRoutes, req.GetServiceId())
	selectorTag := "route-" + req.GetServiceId()
	if route != nil {
		selectorTag = route.SelectorTag
	}
	selector := findSelector(next.Selectors, selectorTag)
	if selector == nil {
		selector = &api.SelectorConfig{Tag: selectorTag}
		next.Selectors = append(next.Selectors, selector)
	}
	selector.NodeIds = readyNodeIDs(pool.Nodes)
	selector.NodeIds = append(selector.NodeIds, "direct")
	selector.SelectedNodeId = req.GetNodeId()
	if route == nil {
		next.ServiceRoutes = append(next.ServiceRoutes, &api.ServiceRoute{ServiceId: req.GetServiceId(), SelectorTag: selectorTag})
		route = next.ServiceRoutes[len(next.ServiceRoutes)-1]
	}
	route.Domains = append([]string(nil), req.GetDomains()...)
	route.Enabled = req.GetEnabled()
	route.DisplayName = req.GetDisplayName()
	next.Revision = ""
	next, err = m.applyDesired(ctx, next)
	if err != nil {
		return nil, err
	}
	return m.routeInfo(next, route.ServiceId)
}

func (m *Manager) DeleteRoute(ctx context.Context, req *api.DeleteRouteRequest) (*emptypb.Empty, error) {
	if req == nil || strings.TrimSpace(req.GetServiceId()) == "" {
		return nil, status.Error(codes.InvalidArgument, "service_id is required")
	}
	m.opMu.Lock()
	defer m.opMu.Unlock()
	next, err := m.desiredForUpdate("")
	if err != nil {
		return nil, err
	}
	index := -1
	selectorTag := ""
	for i, route := range next.ServiceRoutes {
		if route.GetServiceId() == req.GetServiceId() {
			index, selectorTag = i, route.GetSelectorTag()
			break
		}
	}
	if index < 0 {
		return nil, status.Error(codes.NotFound, "route not found")
	}
	next.ServiceRoutes = append(next.ServiceRoutes[:index], next.ServiceRoutes[index+1:]...)
	for i, selector := range next.Selectors {
		if selector.GetTag() == selectorTag {
			next.Selectors = append(next.Selectors[:i], next.Selectors[i+1:]...)
			break
		}
	}
	for i := len(next.ServiceBindings) - 1; i >= 0; i-- {
		if next.ServiceBindings[i].GetServiceId() == req.GetServiceId() {
			next.ServiceBindings = append(next.ServiceBindings[:i], next.ServiceBindings[i+1:]...)
		}
	}
	if _, err := m.applyDesired(ctx, next); err != nil {
		return nil, err
	}
	return &emptypb.Empty{}, nil
}

func (m *Manager) ListRoutes(_ context.Context, _ *emptypb.Empty) (*api.RouteList, error) {
	m.configMu.RLock()
	serviceRoutes := m.runtimeConfig.ServiceRoutes
	proxySelector := findSelector(m.runtimeConfig.Selectors, "proxy")
	m.configMu.RUnlock()

	result := &api.RouteList{DefaultRoute: &api.RouteInfo{ServiceId: config.DefaultServiceID, SelectorTag: "proxy"}}
	for _, route := range serviceRoutes {
		m.configMu.RLock()
		info, err := m.routeInfo(m.runtimeConfig, route.GetServiceId())
		m.configMu.RUnlock()
		if err != nil {
			return nil, err
		}
		result.Routes = append(result.Routes, info)
	}
	if proxySelector != nil {
		result.DefaultRoute.CurrentNodeId = proxySelector.GetSelectedNodeId()
		if node := findNodeByID(m.subscriptions.NodePool().Nodes, proxySelector.GetSelectedNodeId()); node != nil {
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
	if node == nil || !node.IsAvailable() {
		return nil, status.Error(codes.NotFound, "node not found or unavailable")
	}
	next, _ := m.desiredForUpdate("")
	route := findRoute(next.ServiceRoutes, req.GetServiceId())
	if route == nil {
		return nil, status.Error(codes.NotFound, "route not found")
	}
	selector := findSelector(next.Selectors, route.GetSelectorTag())
	if selector == nil {
		return nil, status.Error(codes.Internal, "route selector not found")
	}
	previous := selector.GetSelectedNodeId()
	selector.SelectedNodeId = req.GetNodeId()
	next.Revision = ""
	_, content, err := m.prepareRuntimeContent(next, pool.Nodes)
	if err != nil {
		return nil, err
	}
	current, err := m.waitForStableStatus(ctx)
	if err != nil {
		return nil, err
	}
	running := current.Status == daemon.ServiceStatus_STARTED
	if err := m.commitLiveSelector(ctx, next, pool.Nodes, content, selector.Tag, req.GetNodeId(), previous, running); err != nil {
		return nil, err
	}
	return &api.SelectNodeResponse{NodeId: req.GetNodeId(), NodeName: node.Name, AppliedImmediately: running}, nil
}

func (m *Manager) routeInfo(runtime *api.RuntimeConfig, serviceID string) (*api.RouteInfo, error) {
	route := findRoute(runtime.ServiceRoutes, serviceID)
	if route == nil {
		return nil, status.Error(codes.NotFound, "route not found")
	}
	selector := findSelector(runtime.Selectors, route.GetSelectorTag())
	if selector == nil {
		return nil, status.Error(codes.Internal, "route selector not found")
	}
	info := &api.RouteInfo{ServiceId: route.GetServiceId(), DisplayName: route.GetDisplayName(), Domains: route.GetDomains(), SelectorTag: route.GetSelectorTag(), CurrentNodeId: selector.GetSelectedNodeId(), Enabled: route.GetEnabled()}
	if node := findNodeByID(m.subscriptions.NodePool().Nodes, info.CurrentNodeId); node != nil {
		info.CurrentNodeName = node.Name
	}
	info.Effective = route.GetEnabled() && runtime.GetSettings().GetRouteMode() != api.RouteMode_ROUTE_MODE_DIRECT
	if info.Effective {
		current, err := m.currentStatus()
		if err != nil {
			return nil, err
		}
		info.Effective = current.Status == daemon.ServiceStatus_STARTED
	}
	return info, nil
}
