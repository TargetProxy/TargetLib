package manager

import (
	api "github.com/loafman1120/TargetLib/api/TargetLib"
	targetprofile "github.com/loafman1120/TargetLib/profile"
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

func findBinding(bindings []*api.ServiceBinding, serviceID string) *api.ServiceBinding {
	for _, binding := range bindings {
		if binding.ServiceId == serviceID {
			return binding
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
