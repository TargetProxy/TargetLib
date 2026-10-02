package manager

import (
	"context"
	"errors"
	"testing"

	targetlibapi "github.com/loafman1120/TargetLib/api/TargetLib"
	targetprofile "github.com/loafman1120/TargetLib/profile"
	"github.com/loafman1120/TargetLib/subscriptions"
	"github.com/sagernet/sing-box/option"
	"google.golang.org/protobuf/proto"
	"google.golang.org/protobuf/types/known/emptypb"
)

type failingMetadataStore struct {
	*subscriptions.MemoryStore
	fail bool
}

func (s *failingMetadataStore) Update(ctx context.Context, update func(subscriptions.StoreTx) error) error {
	if s.fail {
		return errors.New("metadata write failed")
	}
	return s.MemoryStore.Update(ctx, update)
}

func TestRuntimeConfigStoreUsesSharedMetadataStore(t *testing.T) {
	shared := &subscriptions.MemoryStore{}
	store := runtimeConfigStore{store: shared}
	first := defaultRuntimeConfig()
	if err := store.Save(context.Background(), first); err != nil {
		t.Fatal(err)
	}
	first.Settings.RouteMode = targetlibapi.RouteMode_ROUTE_MODE_ALL
	if err := store.Save(context.Background(), first); err != nil {
		t.Fatal(err)
	}
	restored, err := store.Load(context.Background())
	if err != nil {
		t.Fatal(err)
	}
	if restored.GetSettings().GetRouteMode() != targetlibapi.RouteMode_ROUTE_MODE_ALL {
		t.Fatalf("unexpected restored config: %v", restored)
	}
}

func TestManagerPersistsAuthoritativeRuntimeConfig(t *testing.T) {
	shared := &subscriptions.MemoryStore{}
	manager, err := New(context.Background(), Options{
		BasePath:          managerTestBasePath(t),
		SubscriptionStore: shared,
	})
	if err != nil {
		t.Fatal(err)
	}
	defer manager.Close()

	current, err := manager.GetRuntimeConfig(context.Background(), &emptypb.Empty{})
	if err != nil {
		t.Fatal(err)
	}
	nextSettings := cloneRuntimeSettings(current.GetSettings())
	nextSettings.RouteMode = targetlibapi.RouteMode_ROUTE_MODE_DIRECT
	updated, err := manager.UpdateRuntimeConfig(context.Background(), &targetlibapi.UpdateRuntimeConfigRequest{Settings: nextSettings})
	if err != nil {
		t.Fatal(err)
	}
	if updated.GetSettings().GetRouteMode() != targetlibapi.RouteMode_ROUTE_MODE_DIRECT {
		t.Fatalf("unexpected updated config: %v", updated)
	}
	restored, err := runtimeConfigStore{store: shared}.Load(context.Background())
	if err != nil {
		t.Fatal(err)
	}
	if restored.GetSettings().GetRouteMode() != targetlibapi.RouteMode_ROUTE_MODE_DIRECT {
		t.Fatalf("unexpected persisted config: %v", restored)
	}
}

func TestRestartUsesCurrentSubscriptionPoolAfterSubscriptionChange(t *testing.T) {
	for _, test := range []struct {
		name   string
		remove bool
	}{
		{name: "disabled"},
		{name: "deleted", remove: true},
	} {
		t.Run(test.name, func(t *testing.T) {
			shared := &subscriptions.MemoryStore{}
			node := targetprofile.Node{
				ID: "node", Name: "Node", Type: "direct", Phase: targetprofile.NodeReady,
				Outbound: &option.Outbound{Type: "direct", Options: &option.DirectOutboundOptions{}},
			}
			item := subscriptions.Subscription{
				ID: "sub", Name: "Sub", URL: "https://example.com/sub", Enabled: true,
				Profile: targetprofile.Profile{Nodes: []targetprofile.Node{node}},
			}
			if err := shared.Update(context.Background(), func(tx subscriptions.StoreTx) error {
				return tx.Put(item)
			}); err != nil {
				t.Fatal(err)
			}
			runtime := defaultRuntimeConfig()
			runtime.Selectors = []*targetlibapi.SelectorConfig{{Tag: "proxy", NodeIds: []string{"node", "direct"}, SelectedNodeId: "node"}}
			if err := (runtimeConfigStore{store: shared}).SaveSnapshot(context.Background(), runtime); err != nil {
				t.Fatal(err)
			}
			if err := shared.Update(context.Background(), func(tx subscriptions.StoreTx) error {
				if test.remove {
					return tx.Delete(item.ID)
				}
				item.Enabled = false
				return tx.Put(item)
			}); err != nil {
				t.Fatal(err)
			}
			if err := shared.Update(context.Background(), func(tx subscriptions.StoreTx) error {
				return tx.SetMetadata("runtime-nodes-v1", []byte("legacy and invalid"))
			}); err != nil {
				t.Fatal(err)
			}

			manager, err := New(context.Background(), Options{
				BasePath:          managerTestBasePath(t),
				SubscriptionStore: shared,
			})
			if err != nil {
				t.Fatal(err)
			}
			defer manager.Close()
			manager.checkConfig = func(context.Context, string) error { return nil }
			manager.applyConfig = func(string) error { return nil }
			if err := manager.activateSavedRuntime(context.Background(), false); err != nil {
				t.Fatal(err)
			}
			pool := manager.subscriptions.NodePool()
			if len(pool.Nodes) != 0 {
				t.Fatalf("current node pool retained stale nodes: %+v", pool.Nodes)
			}
			if got := manager.runtimeConfig.GetNodePoolRevision(); got != pool.Revision {
				t.Fatalf("node pool revision = %q, want current empty pool revision %q", got, pool.Revision)
			}
			if got := manager.runtimeConfig.GetSelectors()[0].GetSelectedNodeId(); got != "direct" {
				t.Fatalf("selected node = %q, want direct", got)
			}
			persisted, err := (runtimeConfigStore{store: shared}).Load(context.Background())
			if err != nil {
				t.Fatal(err)
			}
			if !proto.Equal(persisted, manager.runtimeConfig) {
				t.Fatal("activated runtime config was not persisted")
			}
		})
	}
}
