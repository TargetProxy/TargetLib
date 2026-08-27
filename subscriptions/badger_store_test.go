package subscriptions

import (
	"context"
	"errors"
	"path/filepath"
	"testing"

	targetprofile "github.com/loafman1120/TargetLib/profile"
)

func TestBadgerStoreUpdateIsAtomic(t *testing.T) {
	store, err := OpenBadgerStore(filepath.Join(t.TempDir(), "subscriptions"), make([]byte, 32))
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { _ = store.Close() })

	errAbort := errors.New("abort")
	err = store.Update(context.Background(), func(tx StoreTx) error {
		if err := tx.Put(Subscription{ID: "discarded"}); err != nil {
			return err
		}
		if err := tx.SetActiveID("discarded"); err != nil {
			return err
		}
		return errAbort
	})
	if !errors.Is(err, errAbort) {
		t.Fatalf("update error = %v", err)
	}
	stored, err := store.Load(context.Background())
	if err != nil {
		t.Fatal(err)
	}
	if len(stored.Subscriptions) != 0 || stored.ActiveID != "" {
		t.Fatalf("aborted Badger transaction was committed: %+v", stored)
	}

	err = store.Update(context.Background(), func(tx StoreTx) error {
		if err := tx.Put(Subscription{ID: "active"}); err != nil {
			return err
		}
		if err := tx.SetActiveID("active"); err != nil {
			return err
		}
		return tx.SetMetadata("revision", []byte("1"))
	})
	if err != nil {
		t.Fatal(err)
	}
	stored, err = store.Load(context.Background())
	if err != nil {
		t.Fatal(err)
	}
	metadata, err := store.GetMetadata(context.Background(), "revision")
	if err != nil {
		t.Fatal(err)
	}
	if len(stored.Subscriptions) != 1 || stored.ActiveID != "active" || string(metadata) != "1" {
		t.Fatalf("committed Badger state is incomplete: state=%+v metadata=%q", stored, metadata)
	}
}

func TestBadgerStoreRestoresTypedOutbound(t *testing.T) {
	store, err := OpenBadgerStore(filepath.Join(t.TempDir(), "subscriptions"), make([]byte, 32))
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { _ = store.Close() })

	outboundJSON := []byte(`{
		"type":"anytls",
		"tag":"node",
		"server":"example.com",
		"server_port":443,
		"password":"secret",
		"tls":{"enabled":true,"server_name":"example.com"}
	}`)
	err = store.Update(context.Background(), func(tx StoreTx) error {
		return tx.Put(Subscription{
			ID:        "subscription",
			NodesHash: "stored-hash",
			Profile: targetprofile.Profile{Nodes: []targetprofile.Node{{
				ID: "node", Name: "Node", Type: "anytls", Phase: targetprofile.NodeReady,
				OutboundJSON: outboundJSON,
			}}},
		})
	})
	if err != nil {
		t.Fatal(err)
	}

	state, err := store.Load(context.Background())
	if err != nil {
		t.Fatal(err)
	}
	item := state.Subscriptions[0]
	node := item.Profile.Nodes[0]
	if node.Outbound == nil {
		t.Fatal("typed outbound was not restored")
	}
	if string(node.OutboundJSON) != string(outboundJSON) {
		t.Fatalf("persisted outbound was mutated: %s", node.OutboundJSON)
	}
	if item.NodesHash != "stored-hash" {
		t.Fatalf("nodes hash was mutated: %q", item.NodesHash)
	}
}
