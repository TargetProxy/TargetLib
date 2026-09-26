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
