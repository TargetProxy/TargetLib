package subscriptions

import (
	"testing"

	targetlibapi "github.com/loafman1120/TargetLib/api/TargetLib"
)

func TestGRPCProfileView(t *testing.T) {
	view := ProfileView{
		Nodes: []NodeView{
			{Tag: "b-node-id", Name: "Bravo", Type: "vless", CountryCode: "SG", Server: "b.example.com", Port: 443, Phase: NodeReady},
			{Tag: "a-node", Name: "Alpha", Type: "ss", Server: "a.example.com", Port: 8388, Phase: NodeFailed, Error: "bad"},
		},
	}

	got := grpcProfileView(view)
	if len(got.Nodes) != 2 {
		t.Fatalf("nodes = %d, want 2", len(got.Nodes))
	}
	if got.Nodes[0].GetTag() != "b-node-id" || got.Nodes[0].GetName() != "Bravo" {
		t.Fatalf("first node was not mapped: %+v", got.Nodes[0])
	}
	if got.Nodes[0].GetPhase() != targetlibapi.ProfileNodePhase_PROFILE_NODE_PHASE_READY {
		t.Fatalf("node phase = %v, want ready", got.Nodes[0].GetPhase())
	}
	if got.Nodes[0].GetCountryCode() != "SG" {
		t.Fatalf("country code = %q, want SG", got.Nodes[0].GetCountryCode())
	}
	if got.Nodes[1].GetTag() != "a-node" || got.Nodes[1].GetErrorMessage() != "bad" {
		t.Fatalf("second node was not mapped: %+v", got.Nodes[1])
	}
}
