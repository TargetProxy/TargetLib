package config

import (
	"encoding/json"
	"testing"

	targetprofile "github.com/loafman1120/TargetLib/profile"
	"github.com/sagernet/sing-box/option"
	"github.com/sagernet/sing/common/json/badoption"
)

func TestBuildModes(t *testing.T) {
	for _, test := range []struct {
		name      string
		proxyMode ProxyMode
		routeMode RouteMode
		wantGeoIP bool
	}{
		{"mixed/direct", ProxyModeMixed, RouteModeDirect, false},
		{"mixed/all", ProxyModeMixed, RouteModeAll, false},
		{"mixed/rule", ProxyModeMixed, RouteModeRule, true},
		{"tun/direct", ProxyModeTun, RouteModeDirect, false},
		{"tun/all", ProxyModeTun, RouteModeAll, false},
		{"tun/rule", ProxyModeTun, RouteModeRule, true},
		{"tun/unspecified", ProxyModeTun, "", false},
	} {
		t.Run(test.name, func(t *testing.T) {
			built, err := Build(Settings{
				ListenAddress: "127.0.0.1", MixedPort: 2080,
				ProxyMode: test.proxyMode, RouteMode: test.routeMode,
			}, targetprofile.Profile{})
			if err != nil {
				t.Fatal(err)
			}
			var document struct {
				Inbounds []struct{ Type string }
				DNS      *struct {
					Servers []struct{ Type, Tag, Server string }
					Final   string
				}
				Route struct {
					Final   string
					RuleSet []struct{ Type, Tag, Path string } `json:"rule_set"`
					Rules   []struct {
						Action, Outbound string
						Port             uint16
						RuleSet          string `json:"rule_set"`
					}
				}
				Log struct {
					Disabled, Timestamp bool
					Level, Output       string
				}
			}
			if err := json.Unmarshal(built.Content, &document); err != nil {
				t.Fatal(err)
			}
			if len(document.Inbounds) != 1 || document.Inbounds[0].Type != string(test.proxyMode) {
				t.Fatalf("unexpected inbounds: %+v", document.Inbounds)
			}
			if document.Log.Disabled || document.Log.Level != "error" || document.Log.Output != "target.log" || !document.Log.Timestamp {
				t.Fatalf("unexpected logging: %+v", document.Log)
			}

			rules := document.Route.Rules
			wantRules := 1
			if test.proxyMode == ProxyModeTun {
				wantRules++
			}
			if test.wantGeoIP {
				wantRules++
			}
			if document.Route.Final != "direct" || len(rules) != wantRules || rules[0].Action != "sniff" {
				t.Fatalf("unexpected routing without nodes: %+v", document.Route)
			}
			if test.proxyMode == ProxyModeTun {
				dns := document.DNS
				if dns == nil || len(dns.Servers) != 1 ||
					dns.Servers[0].Type != "udp" || dns.Servers[0].Tag != tunDNSPublicTag ||
					dns.Servers[0].Server != tunDNSPublicAddr || dns.Final != tunDNSPublicTag {
					t.Fatalf("unexpected TUN DNS: %+v", dns)
				}
				if rules[1].Action != "hijack-dns" || rules[1].Port != 53 {
					t.Fatalf("unexpected TUN DNS hijack: %+v", rules[1])
				}
			} else if document.DNS != nil {
				t.Fatalf("unexpected mixed-mode DNS: %+v", document.DNS)
			}
			ruleSets := document.Route.RuleSet
			if test.wantGeoIP {
				if len(ruleSets) != 1 || ruleSets[0].Type != "local" ||
					ruleSets[0].Tag != geoIPCNRuleSetTag || ruleSets[0].Path != geoIPCNRuleSetPath {
					t.Fatalf("unexpected China GeoIP rule set: %+v", ruleSets)
				}
				last := rules[len(rules)-1]
				if last.RuleSet != geoIPCNRuleSetTag || last.Outbound != "direct" {
					t.Fatalf("unexpected China GeoIP rule: %+v", last)
				}
			} else if len(ruleSets) != 0 {
				t.Fatalf("unexpected rule sets: %+v", ruleSets)
			}
		})
	}
}

func TestBuildUsesNodesOnlyFromProfile(t *testing.T) {
	parsed, err := targetprofile.Parse([]byte(`{
		"dns":{"servers":[{"type":"https","tag":"local","server":"1.1.1.1","detour":"direct"}]},
		"inbounds":[{"type":"mixed","tag":"source","listen":"127.0.0.1","listen_port":9999}],
		"outbounds":[
			{"type":"shadowsocks","tag":"node-a","server":"127.0.0.1","server_port":8388,"method":"aes-128-gcm","password":"secret","tcp_fast_open":true},
			{"type":"anytls","tag":"node-b","server":"example.com","server_port":443,"password":"secret","tls":{"enabled":true,"alpn":["h3"]}},
			{"type":"selector","tag":"provider","outbounds":["node-a","direct"],"default":"node-a"},
			{"type":"direct","tag":"direct","bind_interface":"loopback"},
			{"type":"block","tag":"reject"}
		],
		"route":{
			"rule_set":[{"type":"remote","tag":"provider-cn","format":"binary","url":"https://example.invalid/cn.srs","download_detour":"provider"}],
			"rules":[{"domain_suffix":["example.com"],"action":"route","outbound":"provider"}],
			"final":"provider"
		}
	}`))
	if err != nil {
		t.Fatal(err)
	}
	if len(parsed.Profile.Nodes) != 2 {
		t.Fatalf("expected two nodes, got %d", len(parsed.Profile.Nodes))
	}
	first, second := parsed.Profile.Nodes[0].ID, parsed.Profile.Nodes[1].ID
	for i := range parsed.Profile.Nodes {
		parsed.Profile.Nodes[i].Name = "same-name"
	}
	built, err := Build(Settings{ListenAddress: "127.0.0.1", MixedPort: 2080, ProxyMode: ProxyModeMixed, RouteMode: RouteModeRule}, parsed.Profile)
	if err != nil {
		t.Fatal(err)
	}
	var document struct {
		DNS      map[string]any
		Inbounds []struct {
			Tag        string
			ListenPort int `json:"listen_port"`
		}
		Outbounds []struct {
			Type, Tag     string
			TCPFastOpen   bool   `json:"tcp_fast_open"`
			BindInterface string `json:"bind_interface"`
			TLS           map[string]any
		}
		Route struct {
			RuleSet []struct{ Tag, Path string } `json:"rule_set"`
			Rules   []map[string]any
			Final   string
		}
	}
	if err := json.Unmarshal(built.Content, &document); err != nil {
		t.Fatal(err)
	}
	if document.DNS != nil {
		t.Fatalf("provider DNS was included: %+v", document.DNS)
	}
	if len(document.Inbounds) != 1 || document.Inbounds[0].Tag != "mixed" || document.Inbounds[0].ListenPort != 2080 {
		t.Fatalf("unexpected inbounds: %+v", document.Inbounds)
	}
	route := document.Route
	if route.Final != "proxy" || len(route.RuleSet) != 1 ||
		route.RuleSet[0].Tag != geoIPCNRuleSetTag || route.RuleSet[0].Path != geoIPCNRuleSetPath ||
		len(route.Rules) != 2 || route.Rules[0]["action"] != "sniff" ||
		route.Rules[1]["rule_set"] != geoIPCNRuleSetTag || route.Rules[1]["outbound"] != "direct" {
		t.Fatalf("unexpected route: %+v", route)
	}
	wantTypes := map[string]string{first: "shadowsocks", second: "anytls", "direct": "direct", "proxy": "selector", "urltest": "urltest"}
	for _, outbound := range document.Outbounds {
		if wantTypes[outbound.Tag] != outbound.Type {
			t.Fatalf("unexpected outbound %q of type %q", outbound.Tag, outbound.Type)
		}
		delete(wantTypes, outbound.Tag)
		switch outbound.Tag {
		case first:
			if !outbound.TCPFastOpen {
				t.Fatal("typed node outbound field was dropped")
			}
		case second:
			if _, ok := outbound.TLS["alpn"]; ok || outbound.TLS["enabled"] != true {
				t.Fatalf("unexpected node TLS: %+v", outbound.TLS)
			}
		case "direct":
			if outbound.BindInterface != "" {
				t.Fatalf("provider direct outbound was included: %+v", outbound)
			}
		}
	}
	if len(wantTypes) != 0 {
		t.Fatalf("missing runtime outbounds: %v", wantTypes)
	}
}

func TestEmitPreservesTargetOwnedALPN(t *testing.T) {
	content, err := emit(blueprint{
		Outbounds: []option.Outbound{{
			Type: "anytls",
			Tag:  "target-owned",
			Options: &option.AnyTLSOutboundOptions{
				ServerOptions: option.ServerOptions{Server: "example.com", ServerPort: 443},
				OutboundTLSOptionsContainer: option.OutboundTLSOptionsContainer{TLS: &option.OutboundTLSOptions{
					Enabled: true, ServerName: "example.com", ALPN: badoption.Listable[string]{"h3"},
				}},
				Password: "secret",
			},
		}},
		Route:   RoutePlan{Final: "target-owned"},
		Runtime: planRuntime(Settings{}),
	})
	if err != nil {
		t.Fatal(err)
	}
	var document any
	if err := json.Unmarshal(content, &document); err != nil {
		t.Fatal(err)
	}
	if !hasJSONField(document, "alpn") {
		t.Fatalf("Emit rewrote TargetLib-owned ALPN: %s", content)
	}
}

func hasJSONField(value any, field string) bool {
	switch typed := value.(type) {
	case map[string]any:
		if _, exists := typed[field]; exists {
			return true
		}
		for _, child := range typed {
			if hasJSONField(child, field) {
				return true
			}
		}
	case []any:
		for _, child := range typed {
			if hasJSONField(child, field) {
				return true
			}
		}
	}
	return false
}
