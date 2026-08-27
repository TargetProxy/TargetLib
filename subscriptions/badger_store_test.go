package subscriptions

import (
	"context"
	"errors"
	"path/filepath"
	"strings"
	"testing"

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

func TestBadgerStoreNormalizesLegacyALPNWhenRestoringOutbound(t *testing.T) {
	store, err := OpenBadgerStore(filepath.Join(t.TempDir(), "subscriptions"), make([]byte, 32))
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { _ = store.Close() })

	legacyJSON := []byte(`{
		"type":"anytls",
		"tag":"legacy",
		"server":"example.com",
		"server_port":443,
		"password":"secret",
		"tls":{"enabled":true,"server_name":"example.com","alpn":["h3"]}
	}`)
	err = store.Update(context.Background(), func(tx StoreTx) error {
		return tx.Put(Subscription{
			ID:        "legacy",
			NodesHash: "legacy-hash",
			Profile: targetprofile.Profile{Nodes: []targetprofile.Node{{
				ID: "legacy", Name: "Legacy", Type: "anytls", Phase: targetprofile.NodeReady,
				OutboundJSON: legacyJSON,
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
	if strings.Contains(string(node.OutboundJSON), `"alpn"`) {
		t.Fatalf("restored outbound still contains ALPN: %s", node.OutboundJSON)
	}
	if node.Outbound == nil {
		t.Fatal("typed outbound was not restored")
	}
	wrapper, ok := node.Outbound.Options.(option.OutboundTLSOptionsWrapper)
	if !ok || wrapper.TakeOutboundTLSOptions().ALPN != nil {
		t.Fatalf("restored typed outbound still contains ALPN: %T", node.Outbound.Options)
	}
	if item.NodesHash == "legacy-hash" || item.NodesHash != nodesHash(item.Profile.Nodes) {
		t.Fatalf("nodes hash was not refreshed after normalization: %q", item.NodesHash)
	}
}
