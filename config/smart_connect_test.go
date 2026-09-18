package config

import (
	"encoding/json"
	"testing"

	"github.com/loafman1120/TargetLib/profile"
	"github.com/sagernet/sing-box/option"
)

func TestSmartConnectIndependentSelectorsAndDomainPrecedence(t *testing.T) {
	node := func(id string) profile.Node {
		return profile.Node{ID: id, Phase: profile.NodeReady, Outbound: &option.Outbound{Type: "direct", Options: &option.DirectOutboundOptions{}}}
	}
	model := RuntimeModel{NodePool: NodePool{Nodes: []profile.Node{node("a"), node("b")}}, Selectors: []Selector{{Tag: "one", NodeIDs: []string{"a", "b"}, Selected: "a"}, {Tag: "two", NodeIDs: []string{"a", "b"}, Selected: "b"}}, ServiceRoutes: []ServiceRoute{{ServiceID: "one", Domains: []string{"example.com"}, Selector: "one", Enabled: true}, {ServiceID: "two", Domains: []string{"api.example.com"}, Selector: "two", Enabled: true}}}
	content, err := Build(Settings{ListenAddress: "127.0.0.1", MixedPort: 2080, ProxyMode: ProxyModeMixed, RouteMode: RouteModeAll}, model)
	if err != nil {
		t.Fatal(err)
	}
	var document struct {
		Outbounds []struct{ Tag, Type, Default string }
		Route     struct {
			Rules []struct {
				DomainSuffix json.RawMessage `json:"domain_suffix"`
				Outbound     string
			}
		}
	}
	if err := json.Unmarshal(content, &document); err != nil {
		t.Fatal(err)
	}
	counts := make(map[string]int)
	selected := make(map[string]string)
	for _, out := range document.Outbounds {
		counts[out.Tag]++
		selected[out.Tag] = out.Default
	}
	if counts["a"] != 1 || counts["b"] != 1 || selected["one"] != "a" || selected["two"] != "b" {
		t.Fatalf("shared nodes or selectors incorrect: %s", content)
	}
	var routes []string
	for _, rule := range document.Route.Rules {
		if len(rule.DomainSuffix) > 0 {
			routes = append(routes, rule.Outbound)
		}
	}
	if len(routes) != 2 || routes[0] != "two" || routes[1] != "one" {
		t.Fatalf("domain precedence incorrect: %v", routes)
	}
}

func TestSmartProbeRuntimeHasNoListenersCacheOrBackgroundURLTest(t *testing.T) {
	content, err := Build(Settings{ProbeOnly: true, ListenAddress: "127.0.0.1", MixedPort: 2080, ProxyMode: ProxyModeMixed, RouteMode: RouteModeAll, CacheFilePath: "should-not-exist.db"}, profile.Profile{Nodes: []profile.Node{{ID: "node", Phase: profile.NodeReady, Outbound: &option.Outbound{Type: "direct", Options: &option.DirectOutboundOptions{}}}}})
	if err != nil {
		t.Fatal(err)
	}
	var document struct {
		Inbounds     []json.RawMessage
		Experimental struct {
			CacheFile json.RawMessage `json:"cache_file"`
			ClashAPI  json.RawMessage `json:"clash_api"`
		}
		Log struct {
			Disabled bool
			Output   string
		}
		Outbounds []struct{ Type string }
	}
	if err := json.Unmarshal(content, &document); err != nil {
		t.Fatal(err)
	}
	if len(document.Inbounds) != 0 || len(document.Experimental.CacheFile) != 0 || len(document.Experimental.ClashAPI) != 0 || !document.Log.Disabled || document.Log.Output != "" {
		t.Fatalf("probe runtime has side effects: %s", content)
	}
	for _, out := range document.Outbounds {
		if out.Type == "urltest" {
			t.Fatal("probe runtime has automatic URLTest")
		}
	}
}

func TestSmartConnectRejectsDuplicateFailedIdentity(t *testing.T) {
	_, err := NormalizeRuntimeModel(RuntimeModel{NodePool: NodePool{Nodes: []profile.Node{{ID: "duplicate", Phase: profile.NodeFailed}, {ID: "duplicate", Phase: profile.NodeFailed}}}})
	if err == nil {
		t.Fatal("duplicate failed node IDs accepted")
	}
}
