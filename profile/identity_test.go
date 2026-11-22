package profile

import (
	"fmt"
	"testing"
)

func TestWithSourceKeepsNodeIdentityAcrossDisplayTagChanges(t *testing.T) {
	first, err := Parse([]byte(`{"outbounds":[{"type":"ssh","tag":"node-a","server":"127.0.0.1","server_port":22,"user":"test","password":"secret"}]}`))
	if err != nil {
		t.Fatal(err)
	}
	second, err := Parse([]byte(`{"outbounds":[{"type":"ssh","tag":"node-b","server":"127.0.0.1","server_port":22,"user":"test","password":"secret"}]}`))
	if err != nil {
		t.Fatal(err)
	}
	firstProfile := WithSource(first.Profile, "subscription")
	secondProfile := WithSource(second.Profile, "subscription")
	if firstProfile.Nodes[0].ID != secondProfile.Nodes[0].ID {
		t.Fatalf("node identity changed with display tag: %q != %q", firstProfile.Nodes[0].ID, secondProfile.Nodes[0].ID)
	}
	if first.NodesHash == second.NodesHash {
		t.Fatal("nodes hash did not change with display tag")
	}
}

func TestIdentityUsesNormalizedOutbound(t *testing.T) {
	parse := func(network string, port int, tls string) Parsed {
		t.Helper()
		body := fmt.Sprintf(`{"outbounds":[{"type":"trojan","tag":"node","server":"example.com","server_port":%d,
			"password":"secret","transport":{"type":"ws","path":"/"},"tls":%s%s}]}`, port, tls, network)
		parsed, err := Parse([]byte(body))
		if err != nil {
			t.Fatal(err)
		}
		if len(parsed.Profile.Nodes) != 1 || !parsed.Profile.Nodes[0].IsAvailable() {
			t.Fatalf("expected a ready node, got %+v", parsed.Profile.Nodes)
		}
		return parsed
	}
	const cleanTLS = `{"enabled":true,"utls":{"enabled":true,"fingerprint":"chrome"},"ech":{"enabled":true}}`
	const providerTLS = `{"enabled":true,"alpn":["h3"],"utls":{"enabled":true,"fingerprint":"chrome_pq"},
		"ech":{"enabled":true,"pq_signature_schemes_enabled":true,"dynamic_record_sizing_disabled":true}}`
	baseline := parse(`,"network":"tcp"`, 443, cleanTLS)
	baselineID := WithSource(baseline.Profile, "subscription").Nodes[0].ID
	for _, network := range []string{"", `,"network":[]`} {
		got := parse(network, 443, providerTLS)
		if WithSource(got.Profile, "subscription").Nodes[0].ID != baselineID || got.NodesHash != baseline.NodesHash {
			t.Fatalf("equivalent outbound changed the identity or hash for network %q", network)
		}
	}
	changed := parse("", 8443, cleanTLS)
	if WithSource(changed.Profile, "subscription").Nodes[0].ID == baselineID || changed.NodesHash == baseline.NodesHash {
		t.Fatal("server port change did not change both the identity and hash")
	}
	if WithSource(baseline.Profile, "another-subscription").Nodes[0].ID == baselineID {
		t.Fatal("node IDs must be scoped to their subscription")
	}
}

func TestNodesHashIgnoresOrderAndDuplicateConnections(t *testing.T) {
	const a = `{"type":"ssh","tag":"a","server":"127.0.0.1","server_port":22}`
	const alias = `{"type":"ssh","tag":"z","server":"127.0.0.1","server_port":22}`
	const b = `{"type":"ssh","tag":"b","server":"127.0.0.2","server_port":22}`
	first, err := Parse([]byte(`{"outbounds":[` + a + "," + b + `]}`))
	if err != nil {
		t.Fatal(err)
	}
	second, err := Parse([]byte(`{"outbounds":[` + b + "," + alias + "," + a + `]}`))
	if err != nil {
		t.Fatal(err)
	}
	if len(second.Profile.Nodes) != 2 || first.NodesHash != second.NodesHash {
		t.Fatalf("reordering or adding an alias changed the node set hash: %q vs %q", first.NodesHash, second.NodesHash)
	}
}
