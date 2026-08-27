package profile

import (
	"strings"
	"testing"

	"github.com/sagernet/sing-box/option"
)

func TestParseProducesNodeOnlyProfile(t *testing.T) {
	parsed, err := Parse([]byte(`{
		"dns":{"servers":[{"type":"local","tag":"local"}]},
		"inbounds":[{"type":"mixed","tag":"source","listen":"127.0.0.1","listen_port":1080}],
		"outbounds":[
			{"type":"shadowsocks","tag":"node-a","server":"127.0.0.1","server_port":8388,"method":"aes-128-gcm","password":"secret"},
			{"type":"selector","tag":"proxy","outbounds":["node-a","direct"]},
			{"type":"block","tag":"reject"}
		],
		"route":{"rules":[{"domain_suffix":["example.com"],"action":"route","outbound":"proxy"}]}
	}`))
	if err != nil {
		t.Fatal(err)
	}
	if len(parsed.Profile.Nodes) != 1 {
		t.Fatalf("nodes = %d, want 1: %+v", len(parsed.Profile.Nodes), parsed.Profile.Nodes)
	}
	node := parsed.Profile.Nodes[0]
	if node.Name != "node-a" || node.Type != "shadowsocks" || node.Server != "127.0.0.1" || node.Port != 8388 {
		t.Fatalf("unexpected node: %+v", node)
	}
	if node.Phase != NodeReady {
		t.Fatalf("node phase = %q, want ready: %s", node.Phase, node.Error)
	}
	if len(node.OutboundJSON) == 0 || node.Outbound == nil {
		t.Fatalf("node outbound was not preserved: %+v", node)
	}
	if parsed.NodesHash == "" {
		t.Fatal("nodes hash is empty")
	}
}

func TestParseClassifiesRegisteredRemoteOutboundsAsNodes(t *testing.T) {
	parsed, err := Parse([]byte(`{
		"outbounds":[
			{"type":"ssh","tag":"ssh-node","server":"127.0.0.1","server_port":22,"user":"test","password":"secret"},
			{"type":"tor","tag":"tor-node"}
		]
	}`))
	if err != nil {
		t.Fatal(err)
	}
	if len(parsed.Profile.Nodes) != 2 {
		t.Fatalf("nodes = %d, want 2: %+v", len(parsed.Profile.Nodes), parsed.Profile.Nodes)
	}
	for _, node := range parsed.Profile.Nodes {
		if node.Phase != NodeReady {
			t.Fatalf("node %q phase = %q, want ready: %s", node.Name, node.Phase, node.Error)
		}
		if len(node.OutboundJSON) == 0 || node.Outbound == nil {
			t.Fatalf("node outbound was not preserved: %+v", node)
		}
	}
}

func TestParseInfersCountryCodeFromNodeName(t *testing.T) {
	parsed, err := Parse([]byte(`{
		"outbounds":[
			{"type":"shadowsocks","tag":"🇸🇬 Singapore 01","server":"127.0.0.1","server_port":8388,"method":"aes-128-gcm","password":"secret"},
			{"type":"vmess","tag":"Tokyo Premium","server":"127.0.0.2","server_port":443,"uuid":"00000000-0000-0000-0000-000000000000","security":"auto"}
		]
	}`))
	if err != nil {
		t.Fatal(err)
	}
	if got := parsed.Profile.Nodes[0].CountryCode; got != "SG" {
		t.Fatalf("first country = %q, want SG", got)
	}
	if got := parsed.Profile.Nodes[1].CountryCode; got != "JP" {
		t.Fatalf("second country = %q, want JP", got)
	}
}

func TestParseSkipsRemovedOutboundsAndSanitizesLegacyTLS(t *testing.T) {
	parsed, err := Parse([]byte(`{
		"outbounds":[
			{"type":"dns","tag":"legacy-dns"},
			{"type":"shadowsocksr","tag":"legacy-ssr","server":"127.0.0.9","server_port":8388},
			{
				"type":"vless",
				"tag":"Japan Legacy TLS",
				"server":"example.com",
				"server_port":443,
				"uuid":"00000000-0000-0000-0000-000000000000",
				"tls":{
					"enabled":true,
					"utls":{"enabled":true,"fingerprint":"chrome_pq"},
					"ech":{
						"enabled":true,
						"pq_signature_schemes_enabled":true,
						"dynamic_record_sizing_disabled":true
					}
				}
			}
		]
	}`))
	if err != nil {
		t.Fatal(err)
	}
	if len(parsed.Profile.Nodes) != 1 {
		t.Fatalf("nodes = %d, want 1: %+v", len(parsed.Profile.Nodes), parsed.Profile.Nodes)
	}
	node := parsed.Profile.Nodes[0]
	if node.Phase != NodeReady {
		t.Fatalf("node phase = %q, want ready: %s", node.Phase, node.Error)
	}
	if got := string(node.OutboundJSON); strings.Contains(got, "pq_signature_schemes_enabled") || strings.Contains(got, "chrome_pq") {
		t.Fatalf("legacy TLS fields were not sanitized: %s", got)
	}
}

func TestParseRemovesProviderALPNFromPersistedAndTypedOutbounds(t *testing.T) {
	parsed, err := Parse([]byte(`{
		"outbounds":[{
			"type":"anytls",
			"tag":"Hong Kong",
			"server":"example.com",
			"server_port":443,
			"password":"secret",
			"tls":{"enabled":true,"server_name":"example.com","alpn":["h3"]}
		}]
	}`))
	if err != nil {
		t.Fatal(err)
	}
	node := parsed.Profile.Nodes[0]
	if strings.Contains(string(node.OutboundJSON), `"alpn"`) {
		t.Fatalf("persisted outbound still contains ALPN: %s", node.OutboundJSON)
	}
	wrapper, ok := node.Outbound.Options.(option.OutboundTLSOptionsWrapper)
	if !ok {
		t.Fatalf("typed outbound %T does not expose TLS options", node.Outbound.Options)
	}
	if tls := wrapper.TakeOutboundTLSOptions(); tls == nil || tls.ALPN != nil {
		t.Fatalf("typed outbound ALPN was not cleared: %+v", tls)
	}
}

func TestParseRestrictsTrojanTransportToTCPWhenNetworkIsImplicit(t *testing.T) {
	parsed, err := Parse([]byte(`{
		"outbounds":[
			{
				"type":"trojan",
				"tag":"美国-TROJAN-63",
				"server":"123.dnscloudcloud.top",
				"server_port":443,
				"password":"secret",
				"tls":{"enabled":true,"server_name":"example.com"},
				"transport":{"type":"ws","path":"/"}
			}
		]
	}`))
	if err != nil {
		t.Fatal(err)
	}
	if len(parsed.Profile.Nodes) != 1 {
		t.Fatalf("nodes = %d, want 1: %+v", len(parsed.Profile.Nodes), parsed.Profile.Nodes)
	}
	node := parsed.Profile.Nodes[0]
	if node.Phase != NodeReady {
		t.Fatalf("node phase = %q, want ready: %s", node.Phase, node.Error)
	}
	if got := string(node.OutboundJSON); !strings.Contains(got, `"network":"tcp"`) {
		t.Fatalf("implicit trojan transport network was not restricted to tcp: %s", got)
	}
}
