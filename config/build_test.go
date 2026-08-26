package config

import (
	"encoding/json"
	"os"
	"testing"

	targetprofile "github.com/loafman1120/TargetLib/profile"
)

func TestTunModeDoesNotCreateMixedInbound(t *testing.T) {
	content, err := Build(Settings{
		ListenAddress: "127.0.0.1",
		MixedPort:     2080,
		ProxyMode:     ProxyModeTun,
	}, targetprofile.Profile{})
	if err != nil {
		t.Fatal(err)
	}
	var document struct {
		Inbounds []struct {
			Type string `json:"type"`
		} `json:"inbounds"`
	}
	if err := json.Unmarshal(content, &document); err != nil {
		t.Fatal(err)
	}
	if len(document.Inbounds) != 1 || document.Inbounds[0].Type != "tun" {
		t.Fatalf("unexpected inbounds: %+v", document.Inbounds)
	}
}

func TestBuildTunRouteModesKeepDNSHijackAndUpstream(t *testing.T) {
	parsed, err := targetprofile.Parse([]byte(`{
		"dns":{"servers":[{"type":"local","tag":"system-dns"}],"final":"system-dns"},
		"outbounds":[{"type":"direct","tag":"direct"}]
	}`))
	if err != nil {
		t.Fatal(err)
	}
	for _, mode := range []RouteMode{RouteModeDirect, RouteModeAll} {
		t.Run(string(mode), func(t *testing.T) {
			content, err := Build(Settings{
				ListenAddress: "127.0.0.1",
				MixedPort:     2080,
				ProxyMode:     ProxyModeTun,
				RouteMode:     mode,
			}, parsed.Profile)
			if err != nil {
				t.Fatal(err)
			}
			var document struct {
				DNS struct {
					Servers []struct {
						Type   string `json:"type"`
						Tag    string `json:"tag"`
						Server string `json:"server"`
					} `json:"servers"`
					Final string `json:"final"`
				} `json:"dns"`
				Route struct {
					Rules []struct {
						Port   uint16 `json:"port"`
						Action string `json:"action"`
					} `json:"rules"`
				} `json:"route"`
			}
			if err := json.Unmarshal(content, &document); err != nil {
				t.Fatal(err)
			}
			if len(document.DNS.Servers) != 1 ||
				document.DNS.Servers[0].Type != "udp" ||
				document.DNS.Servers[0].Tag != tunDNSPublicTag ||
				document.DNS.Servers[0].Server != tunDNSPublicAddr ||
				document.DNS.Final != tunDNSPublicTag {
				t.Fatalf("unexpected TUN DNS: %+v", document.DNS)
			}
			if len(document.Route.Rules) == 0 ||
				document.Route.Rules[0].Action != "hijack-dns" ||
				document.Route.Rules[0].Port != 53 {
				t.Fatalf("TUN DNS hijack rule missing: %+v", document.Route.Rules)
			}
		})
	}
}

func TestBuildAlwaysUsesInfoLoggingWithoutFileOutput(t *testing.T) {
	parsed, err := targetprofile.Parse([]byte(`{
		"log":{"level":"trace","output":"trace.log"},
		"outbounds":[{"type":"direct","tag":"direct"}]
	}`))
	if err != nil {
		t.Fatal(err)
	}
	content, err := Build(Settings{
		ListenAddress: "127.0.0.1",
		MixedPort:     2080,
		ProxyMode:     ProxyModeTun,
		RouteMode:     RouteModeDirect,
	}, parsed.Profile)
	if err != nil {
		t.Fatal(err)
	}
	var document struct {
		Log struct {
			Disabled bool   `json:"disabled"`
			Level    string `json:"level"`
			Output   string `json:"output"`
		} `json:"log"`
	}
	if err := json.Unmarshal(content, &document); err != nil {
		t.Fatal(err)
	}
	if document.Log.Disabled || document.Log.Level != "info" || document.Log.Output != os.DevNull {
		t.Fatalf("core logging was not normalized to non-persistent info: %+v", document.Log)
	}
}

func TestBuildRouteModesWithoutProfile(t *testing.T) {
	for _, test := range []struct {
		name string
		mode RouteMode
		want string
	}{
		{"direct", RouteModeDirect, "direct"},
		{"all", RouteModeAll, "direct"},
	} {
		t.Run(test.name, func(t *testing.T) {
			content, err := Build(Settings{ListenAddress: "127.0.0.1", MixedPort: 2080, ProxyMode: ProxyModeMixed, RouteMode: test.mode}, targetprofile.Profile{})
			if err != nil {
				t.Fatal(err)
			}
			var document struct {
				Route struct {
					Final string `json:"final"`
				} `json:"route"`
			}
			if err := json.Unmarshal(content, &document); err != nil {
				t.Fatal(err)
			}
			if document.Route.Final != test.want {
				t.Fatalf("expected final %q, got %q", test.want, document.Route.Final)
			}
		})
	}
}

func TestBuildUsesNodesOnlyFromProfile(t *testing.T) {
	parsed, err := targetprofile.Parse([]byte(`{
		"dns":{"servers":[{"type":"local","tag":"local"}]},
		"inbounds":[{"type":"mixed","tag":"source","listen":"127.0.0.1","listen_port":9999}],
		"outbounds":[
			{"type":"shadowsocks","tag":"node-a","server":"127.0.0.1","server_port":8388,"method":"aes-128-gcm","password":"secret","tcp_fast_open":true},
			{"type":"selector","tag":"proxy","outbounds":["node-a","direct"],"default":"node-a"},
			{"type":"block","tag":"reject"}
		],
		"route":{"rules":[{"domain_suffix":["example.com"],"action":"route","outbound":"proxy"}],"final":"proxy"}
	}`))
	if err != nil {
		t.Fatal(err)
	}
	content, err := Build(Settings{ListenAddress: "127.0.0.1", MixedPort: 2080, ProxyMode: ProxyModeMixed, RouteMode: RouteModeRule}, parsed.Profile)
	if err != nil {
		t.Fatal(err)
	}
	var document struct {
		DNS      map[string]any `json:"dns"`
		Inbounds []struct {
			Tag        string `json:"tag"`
			ListenPort int    `json:"listen_port"`
		} `json:"inbounds"`
		Outbounds []struct {
			Type        string `json:"type"`
			Tag         string `json:"tag"`
			TCPFastOpen bool   `json:"tcp_fast_open"`
		} `json:"outbounds"`
		Route struct {
			Rules []map[string]any `json:"rules"`
			Final string           `json:"final"`
		} `json:"route"`
	}
	if err := json.Unmarshal(content, &document); err != nil {
		t.Fatal(err)
	}
	if document.DNS != nil {
		t.Fatalf("provider DNS was unexpectedly included: %+v", document.DNS)
	}
	if len(document.Inbounds) != 1 || document.Inbounds[0].Tag != "mixed" || document.Inbounds[0].ListenPort != 2080 {
		t.Fatalf("source inbounds were not replaced: %+v", document.Inbounds)
	}
	if document.Route.Final != "proxy" || len(document.Route.Rules) != 0 {
		t.Fatalf("provider route was unexpectedly included: %+v", document.Route)
	}
	wantTags := map[string]bool{"direct": true, "node-a": true, "proxy": true, "urltest": true}
	for _, outbound := range document.Outbounds {
		if outbound.Tag == "node-a" && !outbound.TCPFastOpen {
			t.Fatal("typed node outbound field was dropped")
		}
		delete(wantTags, outbound.Tag)
	}
	if len(wantTags) != 0 {
		t.Fatalf("outbounds missing after Profile build: %v", wantTags)
	}
}

func TestBuildDropsProviderRuleSetsAndRules(t *testing.T) {
	parsed, err := targetprofile.Parse([]byte(`{
		"outbounds":[{"type":"shadowsocks","tag":"node-a","server":"127.0.0.1","server_port":8388,"method":"aes-128-gcm","password":"secret"}],
		"route":{
			"rule_set":[{"type":"remote","tag":"provider-cn","format":"binary","url":"https://example.invalid/cn.srs","download_detour":"自动选择"}],
			"rules":[{"rule_set":["provider-cn"],"action":"route","outbound":"自动选择"}],
			"final":"自动选择"
		}
	}`))
	if err != nil {
		t.Fatal(err)
	}
	content, err := Build(Settings{ListenAddress: "127.0.0.1", MixedPort: 2080, ProxyMode: ProxyModeMixed, RouteMode: RouteModeRule}, parsed.Profile)
	if err != nil {
		t.Fatal(err)
	}
	var document struct {
		Route struct {
			RuleSet []any  `json:"rule_set"`
			Rules   []any  `json:"rules"`
			Final   string `json:"final"`
		} `json:"route"`
	}
	if err := json.Unmarshal(content, &document); err != nil {
		t.Fatal(err)
	}
	if len(document.Route.RuleSet) != 0 || len(document.Route.Rules) != 0 || document.Route.Final != "proxy" {
		t.Fatalf("provider routing data was unexpectedly included: %+v", document.Route)
	}
}

func TestBuildDropsUpstreamDNS(t *testing.T) {
	parsed, err := targetprofile.Parse([]byte(`{
		"dns":{"servers":[{
			"type":"https",
			"tag":"local",
			"server":"1.1.1.1",
			"detour":"direct"
		}]},
		"outbounds":[
			{"type":"direct","tag":"direct"},
			{
				"type":"ssh",
				"tag":"node",
				"server":"127.0.0.1",
				"server_port":22,
				"user":"test",
				"password":"secret"
			}
		]
	}`))
	if err != nil {
		t.Fatal(err)
	}
	content, err := Build(Settings{
		ListenAddress: "127.0.0.1",
		MixedPort:     2080,
		ProxyMode:     ProxyModeMixed,
		RouteMode:     RouteModeRule,
	}, parsed.Profile)
	if err != nil {
		t.Fatal(err)
	}
	var document struct {
		DNS map[string]any `json:"dns"`
	}
	if err := json.Unmarshal(content, &document); err != nil {
		t.Fatal(err)
	}
	if document.DNS != nil {
		t.Fatalf("provider DNS was unexpectedly included: %+v", document.DNS)
	}
}

func TestBuildDropsDNSWhenManagedDirect(t *testing.T) {
	parsed, err := targetprofile.Parse([]byte(`{
		"dns":{"servers":[{
			"type":"https",
			"tag":"local",
			"server":"1.1.1.1",
			"detour":"direct"
		}]},
		"outbounds":[
			{"type":"direct","tag":"direct","bind_interface":"loopback"},
			{"type":"ssh","tag":"node","server":"127.0.0.1","server_port":22,"user":"test","password":"secret"}
		]
	}`))
	if err != nil {
		t.Fatal(err)
	}
	content, err := Build(Settings{
		ListenAddress: "127.0.0.1",
		MixedPort:     2080,
		ProxyMode:     ProxyModeMixed,
		RouteMode:     RouteModeRule,
	}, parsed.Profile)
	if err != nil {
		t.Fatal(err)
	}
	var document struct {
		DNS map[string]any `json:"dns"`
	}
	if err := json.Unmarshal(content, &document); err != nil {
		t.Fatal(err)
	}
	if document.DNS != nil {
		t.Fatalf("provider DNS was unexpectedly included: %+v", document.DNS)
	}
}
