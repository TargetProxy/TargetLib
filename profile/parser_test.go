package profile

import (
	"testing"

	"github.com/sagernet/sing-box/option"
)

func TestParseProducesNodeOnlyProfile(t *testing.T) {
	parsed, err := Parse([]byte(`{
		"dns":{"servers":[{"type":"local","tag":"local"}]},
		"inbounds":[{"type":"mixed","tag":"source","listen":"127.0.0.1","listen_port":1080}],
		"outbounds":[
			{"type":"shadowsocks","tag":"node-a","server":"127.0.0.1","server_port":8388,"method":"aes-128-gcm","password":"secret"},
			{"type":"ssh","tag":"🇸🇬 Singapore 01","server":"127.0.0.1","server_port":22,"user":"test","password":"secret"},
			{"type":"vmess","tag":"Tokyo Premium","server":"127.0.0.2","server_port":443,"uuid":"00000000-0000-0000-0000-000000000000","security":"auto"},
			{"type":"tor","tag":"tor-node"},
			{"type":"selector","tag":"proxy","outbounds":["node-a","direct"]},
			{"type":"block","tag":"reject"}
		],
		"route":{"rules":[{"domain_suffix":["example.com"],"action":"route","outbound":"proxy"}]}
	}`))
	if err != nil {
		t.Fatal(err)
	}
	want := []struct {
		name, protocol, server, country string
		port                            int
	}{
		{"node-a", "shadowsocks", "127.0.0.1", "", 8388},
		{"🇸🇬 Singapore 01", "ssh", "127.0.0.1", "SG", 22},
		{"Tokyo Premium", "vmess", "127.0.0.2", "JP", 443},
		{"tor-node", "tor", "", "", 0},
	}
	if len(parsed.Profile.Nodes) != len(want) {
		t.Fatalf("nodes = %d, want %d", len(parsed.Profile.Nodes), len(want))
	}
	for i, expected := range want {
		node := parsed.Profile.Nodes[i]
		if node.Name != expected.name || node.Type != expected.protocol || node.Server != expected.server ||
			node.Port != expected.port || node.CountryCode != expected.country {
			t.Fatalf("node %d = %+v, want %+v", i, node, expected)
		}
		if node.Phase != NodeReady || node.Outbound == nil {
			t.Fatalf("node %q is not ready: %s", node.Name, node.Error)
		}
	}
	if parsed.NodesHash == "" {
		t.Fatal("nodes hash is empty")
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
	wrapper, ok := node.Outbound.Options.(option.OutboundTLSOptionsWrapper)
	if !ok {
		t.Fatalf("typed outbound %T does not expose TLS options", node.Outbound.Options)
	}
	tls := wrapper.TakeOutboundTLSOptions()
	if tls == nil || tls.ECH.PQSignatureSchemesEnabled || tls.ECH.DynamicRecordSizingDisabled || tls.UTLS.Fingerprint != "chrome" {
		t.Fatalf("legacy TLS fields were not sanitized: %+v", tls)
	}
}

func TestParseRemovesProviderALPNFromTypedOutbound(t *testing.T) {
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
	options, ok := node.Outbound.Options.(*option.TrojanOutboundOptions)
	if !ok || options.Network != "tcp" {
		t.Fatalf("implicit trojan transport network was not restricted to tcp: %+v", node.Outbound.Options)
	}
}

func TestParseRetainsOutboundDecodeFailure(t *testing.T) {
	parsed, err := Parse([]byte(`{"outbounds":[{"type":"ssh","tag":"invalid","server":true,"server_port":22}]}`))
	if err != nil {
		t.Fatal(err)
	}
	nodes := WithSource(parsed.Profile, "subscription").Nodes
	if len(nodes) != 1 || nodes[0].Phase != NodeFailed || nodes[0].Error == "" || nodes[0].Outbound != nil {
		t.Fatalf("expected a failed node without an outbound, got %+v", nodes)
	}
}
