package config

import (
	"fmt"
	"sort"
	"strings"
)

// NormalizeRuntimeModel validates all references before any runtime is touched.
// Each service owns one selector; sharing node outbounds is allowed.
func NormalizeRuntimeModel(model RuntimeModel) (RuntimeModel, error) {
	fail := func(message string) (RuntimeModel, error) {
		return RuntimeModel{}, fmt.Errorf("%w: %s", ErrInvalidSource, message)
	}
	nodes := make(map[string]bool)
	nodeIDs := make(map[string]bool)
	for _, node := range model.NodePool.Nodes {
		if node.ID == "" || nodeIDs[node.ID] || node.ID == "direct" || node.ID == "proxy" || node.ID == "urltest" {
			return fail("invalid or duplicate node ID")
		}
		nodeIDs[node.ID] = true
		if node.Outbound != nil && node.Phase != "failed" {
			nodes[node.ID] = true
		}
	}
	selectors := make(map[string]Selector)
	for _, selector := range model.Selectors {
		if selector.Tag == "" || strings.TrimSpace(selector.Tag) != selector.Tag || selector.Tag == "direct" || selector.Tag == "urltest" || nodes[selector.Tag] {
			return fail("invalid selector tag")
		}
		if _, ok := selectors[selector.Tag]; ok {
			return fail("duplicate selector")
		}
		selector.NodeIDs = append([]string(nil), selector.NodeIDs...)
		if selector.Tag == "proxy" {
			selector.NodeIDs = nil
			for id := range nodes {
				selector.NodeIDs = append(selector.NodeIDs, id)
			}
			selector.NodeIDs = append(selector.NodeIDs, "direct")
		}
		sort.Strings(selector.NodeIDs)
		found := false
		seen := make(map[string]bool)
		for _, id := range selector.NodeIDs {
			if (!nodes[id] && id != "direct") || seen[id] {
				return fail("selector contains missing or duplicate node")
			}
			seen[id] = true
			if id == selector.Selected {
				found = true
			}
		}
		if !found {
			return fail("selector requires an explicit selected member")
		}
		selectors[selector.Tag] = selector
	}
	routes := make(map[string]ServiceRoute)
	owners := make(map[string]bool)
	domains := make(map[string]string)
	model.ServiceRoutes = append([]ServiceRoute(nil), model.ServiceRoutes...)
	for index, route := range model.ServiceRoutes {
		if strings.TrimSpace(route.ServiceID) == "" || route.ServiceID != strings.TrimSpace(route.ServiceID) {
			return fail("service ID is required")
		}
		if _, ok := routes[route.ServiceID]; ok {
			return fail("duplicate service")
		}
		if _, ok := selectors[route.Selector]; !ok || route.Selector == "proxy" || owners[route.Selector] {
			return fail("service requires an independent selector")
		}
		owners[route.Selector] = true
		route.Domains = append([]string(nil), route.Domains...)
		if len(route.Domains) == 0 {
			return fail("service requires domains")
		}
		for i, raw := range route.Domains {
			domain := strings.ToLower(strings.TrimSuffix(strings.TrimSpace(raw), "."))
			if !validDomain(domain) {
				return fail("invalid service domain: " + raw)
			}
			if route.Enabled {
				if owner, ok := domains[domain]; ok {
					return fail("duplicate domain in services: " + owner + ", " + route.ServiceID)
				}
				domains[domain] = route.ServiceID
			}
			route.Domains[i] = domain
		}
		sort.Strings(route.Domains)
		routes[route.ServiceID] = route
		model.ServiceRoutes[index] = route
	}
	bound := make(map[string]bool)
	for _, binding := range model.ServiceBindings {
		route, ok := routes[binding.ServiceID]
		if !ok || route.Selector != binding.Selector || bound[binding.ServiceID] {
			return fail("invalid or duplicate service binding")
		}
		selector := selectors[binding.Selector]
		if binding.Outbound != selector.Selected {
			return fail("binding and selector selection disagree")
		}
		bound[binding.ServiceID] = true
	}
	model.Selectors = nil
	for _, selector := range selectors {
		model.Selectors = append(model.Selectors, selector)
	}
	sort.Slice(model.Selectors, func(i, j int) bool { return model.Selectors[i].Tag < model.Selectors[j].Tag })
	// More-specific suffixes take precedence; lexical order breaks ties.
	sort.Slice(model.ServiceRoutes, func(i, j int) bool {
		return model.ServiceRoutes[i].ServiceID < model.ServiceRoutes[j].ServiceID
	})
	return model, nil
}

func validDomain(domain string) bool {
	if len(domain) == 0 || len(domain) > 253 {
		return false
	}
	for _, label := range strings.Split(domain, ".") {
		if len(label) == 0 || len(label) > 63 || label[0] == '-' || label[len(label)-1] == '-' {
			return false
		}
		for _, c := range label {
			if !(c >= 'a' && c <= 'z' || c >= '0' && c <= '9' || c == '-') {
				return false
			}
		}
	}
	return true
}
