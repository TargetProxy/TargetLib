package manager

import (
	"context"
	"errors"
	"reflect"
	"testing"

	targetlibapi "github.com/loafman1120/TargetLib/api/TargetLib"
	"github.com/loafman1120/TargetLib/config"
	targetprofile "github.com/loafman1120/TargetLib/profile"
	"github.com/loafman1120/TargetLib/subscriptions"
	"github.com/sagernet/sing-box/daemon"
	"github.com/sagernet/sing-box/option"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
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
	first := defaultRuntimeIntent()
	if err := store.Save(context.Background(), first); err != nil {
		t.Fatal(err)
	}
	first.settings.RouteMode = config.RouteModeAll
	first.selectors = []config.Selector{{Tag: "route-video", NodeIDs: []string{"node"}, Selected: "node", SelectedAtUnixMs: 123}}
	first.serviceRoutes = []config.ServiceRoute{{ServiceID: "video", Selector: "route-video", Domains: []string{"example.com"}, Enabled: true}}
	first.nodePoolRevision = "current-pool"
	if err := store.Save(context.Background(), first); err != nil {
		t.Fatal(err)
	}
	restored, err := store.Load(context.Background())
	if err != nil {
		t.Fatal(err)
	}
	if restored == nil || !reflect.DeepEqual(*restored, first) {
		t.Fatalf("unexpected restored config: %v", restored)
	}
}

func TestRuntimeIntentStoreSkipsOldMetadata(t *testing.T) {
	ctx := context.Background()
	shared := &subscriptions.MemoryStore{}
	if err := shared.Update(ctx, func(tx subscriptions.StoreTx) error {
		return tx.SetMetadata("runtime-config-v1", []byte("old data"))
	}); err != nil {
		t.Fatal(err)
	}
	intent, err := (runtimeConfigStore{store: shared}).Load(ctx)
	if err != nil || intent != nil {
		t.Fatalf("load from new key = %v, %v", intent, err)
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
	nextSettings := current.GetSettings()
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
	if restored.settings.RouteMode != config.RouteModeDirect {
		t.Fatalf("unexpected persisted config: %v", restored)
	}
}

func TestFailedReloadRebuildsLastAppliedConfig(t *testing.T) {
	ctx := context.Background()
	shared := &subscriptions.MemoryStore{}
	subs := subscriptions.NewManager(subscriptions.Options{Store: shared})
	t.Cleanup(subs.Close)
	if err := subs.Load(ctx); err != nil {
		t.Fatal(err)
	}
	var applied []string
	m := &Manager{
		subscriptions: subs,
		intent:        defaultRuntimeIntent(),
		runtimeStore:  runtimeConfigStore{store: shared},
		checkConfig:   func(context.Context, string) error { return nil },
		readStatus: func() (*daemon.ServiceStatus, error) {
			return &daemon.ServiceStatus{Status: daemon.ServiceStatus_STARTED}, nil
		},
		applyConfig: func(content string) error {
			applied = append(applied, content)
			if len(applied) == 2 {
				return errors.New("reload failed")
			}
			return nil
		},
	}
	if err := m.activateSavedRuntime(ctx, false); err != nil {
		t.Fatal(err)
	}
	before := m.desiredForUpdate().proto()
	settings := m.desiredForUpdate().proto().GetSettings()
	settings.MixedPort++
	settings.RouteMode = targetlibapi.RouteMode_ROUTE_MODE_DIRECT
	_, err := m.UpdateRuntimeConfig(ctx, &targetlibapi.UpdateRuntimeConfigRequest{Settings: settings})
	if status.Code(err) != codes.Internal {
		t.Fatalf("reload error = %v", err)
	}
	if len(applied) != 3 || applied[1] == applied[0] || applied[2] != applied[0] {
		t.Fatalf("reload did not restore the previously built JSON: got %d applications", len(applied))
	}
	saved, err := m.runtimeStore.Load(ctx)
	if err != nil || saved == nil || !proto.Equal(saved.proto(), before) || !proto.Equal(m.desiredForUpdate().proto(), before) {
		t.Fatalf("failed reload changed saved or in-memory intent: %v, %v", saved, err)
	}
}

func TestRestartRejectsUnavailableSavedNode(t *testing.T) {
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
			intent := defaultRuntimeIntent()
			intent.selectors = []config.Selector{{Tag: "proxy", NodeIDs: []string{"node", "direct"}, Selected: "node"}}
			if err := (runtimeConfigStore{store: shared}).Save(context.Background(), intent); err != nil {
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
			manager, err := New(context.Background(), Options{
				BasePath:          managerTestBasePath(t),
				SubscriptionStore: shared,
			})
			if err != nil {
				t.Fatal(err)
			}
			defer manager.Close()
			manager.checkConfig = func(context.Context, string) error { return nil }
			applies := 0
			manager.applyConfig = func(string) error { applies++; return nil }
			ctx := context.Background()
			before := manager.desiredForUpdate().proto()
			if _, err := manager.Restart(ctx, &emptypb.Empty{}); status.Code(err) != codes.FailedPrecondition {
				t.Fatalf("restart error = %v, want FailedPrecondition", err)
			}
			saved, err := manager.runtimeStore.Load(ctx)
			if err != nil || saved == nil || !proto.Equal(saved.proto(), before) ||
				!proto.Equal(manager.desiredForUpdate().proto(), before) || applies != 0 {
				t.Fatalf("restart with unavailable selection changed state: %v, %v, applies=%d", saved, err, applies)
			}
			response, err := manager.SelectNode(ctx, &targetlibapi.SelectNodeRequest{NodeId: "direct"})
			if err != nil || response.GetAppliedImmediately() {
				t.Fatalf("explicit direct selection while stopped = %v, %v", response, err)
			}
			if _, err := manager.Restart(ctx, &emptypb.Empty{}); err != nil {
				t.Fatal(err)
			}
			pool := manager.subscriptions.NodePool()
			if len(pool.Nodes) != 0 {
				t.Fatalf("current node pool retained stale nodes: %+v", pool.Nodes)
			}
			active := manager.desiredForUpdate().proto()
			if got := active.GetNodePoolRevision(); got != pool.Revision {
				t.Fatalf("node pool revision = %q, want current empty pool revision %q", got, pool.Revision)
			}
			if got := active.GetSelectors()[0].GetSelectedNodeId(); got != "direct" {
				t.Fatalf("selected node = %q, want direct", got)
			}
			persisted, err := (runtimeConfigStore{store: shared}).Load(context.Background())
			if err != nil {
				t.Fatal(err)
			}
			if !proto.Equal(persisted.proto(), active) {
				t.Fatal("activated runtime config was not persisted")
			}
		})
	}
}
