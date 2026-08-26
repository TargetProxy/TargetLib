package profile

import "testing"

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
