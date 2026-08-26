package manager

import (
	"context"
	"errors"
	"testing"

	targetlibapi "github.com/loafman1120/TargetLib/api/TargetLib"
	"github.com/loafman1120/TargetLib/subscriptions"
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
		BasePath:          t.TempDir(),
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

func TestCommitRuntimeConfigDoesNotCommitWhenCoreRejects(t *testing.T) {
	shared := &subscriptions.MemoryStore{}
	store := runtimeConfigStore{store: shared}
	previous := defaultRuntimeConfig()
	if err := store.Save(context.Background(), previous); err != nil {
		t.Fatal(err)
	}
	next := cloneRuntimeConfig(previous)
	next.Settings.RouteMode = targetlibapi.RouteMode_ROUTE_MODE_DIRECT
	m := &Manager{
		runtimeConfig: previous,
		runtimeStore:  store,
		config:        "old config",
		applyConfig: func(string) error {
			return errors.New("core rejected config")
		},
	}

	if err := m.commitRuntimeConfig(context.Background(), next, "new config", true); err == nil {
		t.Fatal("update unexpectedly succeeded")
	}
	assertRuntimeConfigState(t, m, store, targetlibapi.RouteMode_ROUTE_MODE_RULE, "old config")
}

func TestCommitRuntimeConfigRollsBackCoreWhenPersistenceFails(t *testing.T) {
	shared := &failingMetadataStore{MemoryStore: &subscriptions.MemoryStore{}}
	store := runtimeConfigStore{store: shared}
	previous := defaultRuntimeConfig()
	if err := store.Save(context.Background(), previous); err != nil {
		t.Fatal(err)
	}
	shared.fail = true
	next := cloneRuntimeConfig(previous)
	next.Settings.RouteMode = targetlibapi.RouteMode_ROUTE_MODE_DIRECT
	var applied []string
	m := &Manager{
		runtimeConfig: previous,
		runtimeStore:  store,
		config:        "old config",
		applyConfig: func(content string) error {
			applied = append(applied, content)
			return nil
		},
	}

	if err := m.commitRuntimeConfig(context.Background(), next, "new config", true); err == nil {
		t.Fatal("update unexpectedly succeeded")
	}
	if len(applied) != 2 || applied[0] != "new config" || applied[1] != "old config" {
		t.Fatalf("unexpected core apply sequence: %v", applied)
	}
	shared.fail = false
	assertRuntimeConfigState(t, m, store, targetlibapi.RouteMode_ROUTE_MODE_RULE, "old config")
}

func assertRuntimeConfigState(t *testing.T, m *Manager, store runtimeConfigStore, wantMode targetlibapi.RouteMode, wantContent string) {
	t.Helper()
	m.configMu.RLock()
	memory := cloneRuntimeConfig(m.runtimeConfig)
	content := m.config
	m.configMu.RUnlock()
	if memory.GetSettings().GetRouteMode() != wantMode || content != wantContent {
		t.Fatalf("unexpected in-memory state: config=%v content=%q", memory, content)
	}
	persisted, err := store.Load(context.Background())
	if err != nil {
		t.Fatal(err)
	}
	if persisted.GetSettings().GetRouteMode() != wantMode {
		t.Fatalf("unexpected persisted config: %v", persisted)
	}
}
