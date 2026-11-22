package manager

import (
	"context"
	"strings"
	"testing"

	"github.com/sagernet/sing-box/option"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	targetlibapi "github.com/loafman1120/TargetLib/api/TargetLib"
	targetprofile "github.com/loafman1120/TargetLib/profile"
	"github.com/loafman1120/TargetLib/subscriptions"
)

func TestUpdateRuntimeConfigRejectsInvalidSettingsBeforeReplacingConfig(t *testing.T) {
	previous := defaultRuntimeIntent()
	sharedStore := &subscriptions.MemoryStore{}
	subscriptionManager := subscriptions.NewManager(subscriptions.Options{Store: sharedStore})
	t.Cleanup(subscriptionManager.Close)
	manager := &Manager{
		subscriptions: subscriptionManager,
		intent:        previous,
		runtimeStore:  runtimeConfigStore{store: sharedStore},
	}

	_, err := manager.UpdateRuntimeConfig(context.Background(), &targetlibapi.UpdateRuntimeConfigRequest{
		Settings: &targetlibapi.RuntimeSettings{
			ListenAddress: "127.0.0.1",
			MixedPort:     0,
			ProxyMode:     targetlibapi.ProxyMode_PROXY_MODE_MIXED,
			RouteMode:     targetlibapi.RouteMode_ROUTE_MODE_RULE,
		},
	})

	if status.Code(err) != codes.InvalidArgument {
		t.Fatalf("expected InvalidArgument, got %v", err)
	}
	if manager.intent.settings != previous.settings {
		t.Fatal("runtime config changed after validation failure")
	}
}

func TestUpdateRuntimeConfigChecksGeneratedConfigBeforeSaving(t *testing.T) {
	ctx := context.Background()
	shared := &subscriptions.MemoryStore{}
	const invalidType = "unregistered-outbound"
	if err := shared.Update(ctx, func(tx subscriptions.StoreTx) error {
		return tx.Put(subscriptions.Subscription{
			ID: "sub", Enabled: true,
			Profile: targetprofile.Profile{Nodes: []targetprofile.Node{{
				ID: "node", Phase: targetprofile.NodeReady,
				Outbound: &option.Outbound{Type: invalidType, Options: &option.DirectOutboundOptions{}},
			}}},
		})
	}); err != nil {
		t.Fatal(err)
	}
	m, err := New(ctx, Options{BasePath: managerTestBasePath(t), SubscriptionStore: shared})
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(m.Close)
	initial := m.desiredForUpdate()
	settings := initial.proto().GetSettings()
	settings.MixedPort++
	_, err = m.UpdateRuntimeConfig(ctx, &targetlibapi.UpdateRuntimeConfigRequest{Settings: settings})
	if status.Code(err) != codes.InvalidArgument || !strings.Contains(err.Error(), invalidType) {
		t.Fatalf("expected sing-box to reject the generated outbound, got %v", err)
	}
	saved, err := m.runtimeStore.Load(ctx)
	if err != nil {
		t.Fatal(err)
	}
	if saved == nil || saved.settings != initial.settings || m.desiredForUpdate().settings != initial.settings {
		t.Fatal("failed config check changed the runtime settings")
	}
}
