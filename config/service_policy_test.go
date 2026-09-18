package config

import (
	"encoding/json"
	"github.com/loafman1120/TargetLib/profile"
	"github.com/sagernet/sing-box/option"
	"testing"
)

func TestServiceSelectorAllowsDirect(t *testing.T) {
	n := profile.Node{ID: "node", Phase: profile.NodeReady, Outbound: &option.Outbound{Type: "shadowsocks"}}
	m, err := NormalizeRuntimeModel(RuntimeModel{NodePool: NodePool{Nodes: []profile.Node{n}}, Selectors: []Selector{{Tag: "svc", NodeIDs: []string{"node", "direct"}, Selected: "direct"}}, ServiceRoutes: []ServiceRoute{{ServiceID: "svc", Selector: "svc", Domains: []string{"example.com"}}}, ServiceBindings: []ServiceBinding{{ServiceID: "svc", Selector: "svc", Outbound: "direct"}}})
	if err != nil {
		t.Fatal(err)
	}
	if len(m.Selectors) != 1 || m.Selectors[0].Selected != "direct" {
		t.Fatalf("direct selection lost: %+v", m.Selectors)
	}
}

func TestDirectOnlyServiceEmitsSelectorWithoutSubscriptions(t *testing.T) {
	model := RuntimeModel{Selectors: []Selector{{Tag: "service-direct", NodeIDs: []string{"direct"}, Selected: "direct"}},
		ServiceRoutes: []ServiceRoute{{ServiceID: "direct", Domains: []string{"example.com"}, Selector: "service-direct", Enabled: true}}}
	content, err := Build(Settings{ListenAddress: "127.0.0.1", MixedPort: 2080, ProxyMode: ProxyModeMixed, RouteMode: RouteModeAll}, model)
	if err != nil {
		t.Fatal(err)
	}
	var parsed struct{ Outbounds []struct{ Tag string } }
	if err := json.Unmarshal(content, &parsed); err != nil {
		t.Fatal(err)
	}
	for _, out := range parsed.Outbounds {
		if out.Tag == "service-direct" {
			return
		}
	}
	t.Fatalf("Direct-only service selector is missing: %s", content)
}
