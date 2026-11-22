package manager

import (
	"runtime"
	"slices"

	api "github.com/loafman1120/TargetLib/api/TargetLib"
	"github.com/loafman1120/TargetLib/config"
	targetprofile "github.com/loafman1120/TargetLib/profile"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

type runtimeIntent struct {
	settings         config.Settings
	selectors        []config.Selector
	serviceRoutes    []config.ServiceRoute
	nodePoolRevision string
}

func (intent runtimeIntent) clone() runtimeIntent {
	result := intent
	result.selectors = make([]config.Selector, len(intent.selectors))
	for index, selector := range intent.selectors {
		result.selectors[index] = selector
		result.selectors[index].NodeIDs = append([]string(nil), selector.NodeIDs...)
	}
	result.serviceRoutes = make([]config.ServiceRoute, len(intent.serviceRoutes))
	for index, route := range intent.serviceRoutes {
		result.serviceRoutes[index] = route
		result.serviceRoutes[index].Domains = append([]string(nil), route.Domains...)
	}
	return result
}

func (intent runtimeIntent) proto() *api.RuntimeConfig {
	proxyMode := api.ProxyMode_PROXY_MODE_MIXED
	if intent.settings.ProxyMode == config.ProxyModeTun {
		proxyMode = api.ProxyMode_PROXY_MODE_TUN
	}
	routeMode := api.RouteMode_ROUTE_MODE_RULE
	switch intent.settings.RouteMode {
	case config.RouteModeDirect:
		routeMode = api.RouteMode_ROUTE_MODE_DIRECT
	case config.RouteModeAll:
		routeMode = api.RouteMode_ROUTE_MODE_ALL
	}
	if runtime.GOOS == "android" || runtime.GOOS == "ios" {
		proxyMode = api.ProxyMode_PROXY_MODE_TUN
	}
	result := &api.RuntimeConfig{
		Settings: &api.RuntimeSettings{
			ListenAddress: intent.settings.ListenAddress,
			MixedPort:     uint32(intent.settings.MixedPort), ProxyMode: proxyMode,
			Ipv6: intent.settings.IPv6, RouteMode: routeMode,
		},
		NodePoolRevision: intent.nodePoolRevision,
		Selectors:        make([]*api.SelectorConfig, 0, len(intent.selectors)),
		ServiceRoutes:    make([]*api.ServiceRoute, 0, len(intent.serviceRoutes)),
	}
	for _, selector := range intent.selectors {
		result.Selectors = append(result.Selectors, &api.SelectorConfig{
			Tag: selector.Tag, NodeIds: append([]string(nil), selector.NodeIDs...),
			SelectedNodeId: selector.Selected, SelectedAtUnixMs: selector.SelectedAtUnixMs,
		})
	}
	for _, route := range intent.serviceRoutes {
		result.ServiceRoutes = append(result.ServiceRoutes, &api.ServiceRoute{
			ServiceId: route.ServiceID, DisplayName: route.DisplayName,
			Domains: append([]string(nil), route.Domains...), SelectorTag: route.Selector,
			Enabled: route.Enabled,
		})
	}
	return result
}

func (intent runtimeIntent) modelForBuild(nodes []targetprofile.Node) (config.RuntimeModel, error) {
	intent.selectors = slices.Clone(intent.selectors)
	if intent.selector("proxy") == nil {
		return config.RuntimeModel{}, status.Error(codes.FailedPrecondition,
			"default selector is missing; select a node before starting or reloading")
	}
	members := append(readyNodeIDs(nodes), "direct")
	available := make(map[string]bool, len(members))
	for _, id := range members {
		available[id] = true
	}
	for index := range intent.selectors {
		selector := &intent.selectors[index]
		if selector.Tag == "proxy" {
			selector.NodeIDs = nil
		} else {
			selector.NodeIDs = members
		}
		if !available[selector.Selected] {
			return config.RuntimeModel{}, status.Errorf(codes.FailedPrecondition,
				"selected node %q for selector %q is unavailable; select an available node before starting or reloading", selector.Selected, selector.Tag)
		}
	}

	return config.RuntimeModel{
		NodePool:  config.NodePool{Nodes: nodes},
		Selectors: intent.selectors, ServiceRoutes: intent.serviceRoutes,
	}, nil
}

func (intent runtimeIntent) selector(tag string) *config.Selector {
	for index := range intent.selectors {
		if intent.selectors[index].Tag == tag {
			return &intent.selectors[index]
		}
	}
	return nil
}

func (intent runtimeIntent) route(serviceID string) *config.ServiceRoute {
	for index := range intent.serviceRoutes {
		if intent.serviceRoutes[index].ServiceID == serviceID {
			return &intent.serviceRoutes[index]
		}
	}
	return nil
}

func (intent *runtimeIntent) removeRoute(serviceID string) (string, bool) {
	index := -1
	selectorTag := ""
	for current, route := range intent.serviceRoutes {
		if route.ServiceID == serviceID {
			index, selectorTag = current, route.Selector
			break
		}
	}
	if index < 0 {
		return "", false
	}
	intent.serviceRoutes = slices.Delete(intent.serviceRoutes, index, index+1)
	for current, selector := range intent.selectors {
		if selector.Tag == selectorTag {
			intent.selectors = slices.Delete(intent.selectors, current, current+1)
			break
		}
	}
	return selectorTag, true
}
