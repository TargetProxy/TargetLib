package subscriptions

import (
	"context"
	"testing"
)

func TestNodePoolRevisionTracksEnabledNodeChanges(t *testing.T) {
	manager := NewManager(Options{
		Fetcher: fixedFetcher{body: []byte(`{"outbounds":[{"type":"ssh","tag":"node","server":"127.0.0.1","server_port":22,"user":"test","password":"secret"}]}`)},
		Store:   &MemoryStore{},
	})
	t.Cleanup(manager.Close)
	item, err := manager.AddRequest(context.Background(), AddRequest{
		ID: "sub", Name: "Sub", URL: "https://example.com/sub", Enabled: true,
	})
	if err != nil {
		t.Fatal(err)
	}
	if _, err := manager.Update(context.Background(), item.ID); err != nil {
		t.Fatal(err)
	}

	first := manager.NodePool()
	second := manager.NodePool()
	if first.Revision == "" || first.Revision != second.Revision {
		t.Fatalf("revision changed between reads: %q and %q", first.Revision, second.Revision)
	}
	if len(first.Nodes) != 1 {
		t.Fatalf("nodes = %d, want 1", len(first.Nodes))
	}

	if err := manager.SetEnabled(context.Background(), item.ID, false); err != nil {
		t.Fatal(err)
	}
	disabled := manager.NodePool()
	if disabled.Revision == first.Revision || len(disabled.Nodes) != 0 {
		t.Fatalf("disabled pool did not update: %+v", disabled)
	}
	if err := manager.SetEnabled(context.Background(), item.ID, true); err != nil {
		t.Fatal(err)
	}
	reenabled := manager.NodePool()
	if reenabled.Revision != first.Revision {
		t.Fatalf("reenabled revision = %q, want %q", reenabled.Revision, first.Revision)
	}
}
