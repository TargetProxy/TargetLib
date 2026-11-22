package subscriptions

import (
	"context"
	"errors"
	"path/filepath"
	"testing"

	"github.com/dgraph-io/badger/v4"
	targetprofile "github.com/loafman1120/TargetLib/profile"
	"github.com/sagernet/sing-box/option"
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
		if err := tx.SetMetadata("revision", []byte("discarded")); err != nil {
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
	metadata, _ := store.GetMetadata(context.Background(), "revision")
	if len(stored.Subscriptions) != 0 || len(metadata) != 0 {
		t.Fatalf("aborted Badger transaction was committed: %+v", stored)
	}

	err = store.Update(context.Background(), func(tx StoreTx) error {
		if err := tx.Put(Subscription{ID: "active"}); err != nil {
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
	metadata, err = store.GetMetadata(context.Background(), "revision")
	if err != nil {
		t.Fatal(err)
	}
	if len(stored.Subscriptions) != 1 || string(metadata) != "1" {
		t.Fatalf("committed Badger state is incomplete: state=%+v metadata=%q", stored, metadata)
	}
}

func TestBadgerStoreRestoresTypedOutbound(t *testing.T) {
	store, err := OpenBadgerStore(filepath.Join(t.TempDir(), "subscriptions"), make([]byte, 32))
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { _ = store.Close() })

	if err := store.db.Update(func(tx *badger.Txn) error {
		return tx.Set([]byte("subscription/b2xk"), []byte("old data"))
	}); err != nil {
		t.Fatal(err)
	}

	outbound := &option.Outbound{Type: "anytls", Tag: "node", Options: &option.AnyTLSOutboundOptions{
		ServerOptions: option.ServerOptions{Server: "example.com", ServerPort: 443}, Password: "secret",
	}}
	err = store.Update(context.Background(), func(tx StoreTx) error {
		return tx.Put(Subscription{
			ID:        "subscription",
			NodesHash: "stored-hash",
			Profile: targetprofile.Profile{Nodes: []targetprofile.Node{{
				ID: "node", Name: "Node", Type: "anytls", Phase: targetprofile.NodeReady,
				Outbound: outbound,
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
	if len(state.Subscriptions) != 1 {
		t.Fatalf("loaded subscriptions = %d, want 1", len(state.Subscriptions))
	}
	item := state.Subscriptions[0]
	node := item.Profile.Nodes[0]
	if node.Outbound == nil {
		t.Fatal("typed outbound was not restored")
	}
	if node.Outbound.Tag != "node" || node.Outbound.Type != "anytls" {
		t.Fatalf("typed outbound changed during persistence: %+v", node.Outbound)
	}
	if item.NodesHash != "stored-hash" {
		t.Fatalf("nodes hash was mutated: %q", item.NodesHash)
	}
}
