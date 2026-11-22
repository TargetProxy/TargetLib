package manager

import (
	"context"
	"slices"
	"testing"

	api "github.com/loafman1120/TargetLib/api/TargetLib"
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

func TestSelectNodeRequiresExplicitReload(t *testing.T) {
	ctx := context.Background()
	store := &failingMetadataStore{MemoryStore: &subscriptions.MemoryStore{}}
	subs := subscriptions.NewManager(subscriptions.Options{Store: store})
	t.Cleanup(subs.Close)
	setNode := func(id string, enabled bool) {
		t.Helper()
		err := store.Update(ctx, func(tx subscriptions.StoreTx) error {
			node := targetprofile.Node{
				ID: id, SubscriptionID: id, Phase: targetprofile.NodeReady,
				Outbound: &option.Outbound{Type: "direct", Options: &option.DirectOutboundOptions{}},
			}
			return tx.Put(subscriptions.Subscription{
				ID: id, Enabled: enabled, Profile: targetprofile.Profile{Nodes: []targetprofile.Node{node}},
			})
		})
		if err != nil {
			t.Fatal(err)
		}
		if err := subs.Load(ctx); err != nil {
			t.Fatal(err)
		}
	}
	setNode("old", true)
	setNode("loaded", true)

	intent := defaultRuntimeIntent()
	intent.selectors = []config.Selector{{Tag: "proxy", Selected: "old"}, {Tag: "route-video", Selected: "old"}}
	intent.serviceRoutes = []config.ServiceRoute{{ServiceID: "video", Selector: "route-video", Domains: []string{"example.com"}, Enabled: true}}
	var applies, checks int
	var selections []string
	m := &Manager{
		subscriptions: subs,
		intent:        intent,
		runtimeStore:  runtimeConfigStore{store: store},
		readStatus: func() (*daemon.ServiceStatus, error) {
			return &daemon.ServiceStatus{Status: daemon.ServiceStatus_STARTED}, nil
		},
		applyConfig: func(string) error { applies++; return nil },
		checkConfig: func(context.Context, string) error { checks++; return nil },
		selectOutbound: func(_ context.Context, tag, id string) error {
			selections = append(selections, tag+"/"+id)
			return nil
		},
	}
	if err := m.activateSavedRuntime(ctx, false); err != nil {
		t.Fatal(err)
	}
	setNode("new", true)
	setNode("old", false)

	before := m.intent.proto()
	for _, err := range []error{
		selectProxy(t, m, "new", false),
		selectVideo(t, m, "new", false),
	} {
		if status.Code(err) != codes.FailedPrecondition {
			t.Fatalf("new node error = %v, want FailedPrecondition", err)
		}
	}
	saved, err := m.runtimeStore.Load(ctx)
	if err != nil || saved == nil || !proto.Equal(saved.proto(), before) || !proto.Equal(m.intent.proto(), before) {
		t.Fatalf("selection changed after rejected request: %v, %v", saved, err)
	}
	if len(selections) != 0 || applies != 1 || checks != 1 {
		t.Fatalf("rejected selection reached sing-box: selections=%v applies=%d checks=%d", selections, applies, checks)
	}

	if err := selectVideo(t, m, "loaded", true); err != nil {
		t.Fatal(err)
	}
	proxy, err := m.GetProxyStatus(ctx, &emptypb.Empty{})
	if err != nil || proxy.GetSelectedNodeId() != "old" || proxy.GetActualNodeId() != "old" || proxy.GetNodeAvailable() {
		t.Fatalf("unrelated proxy selection changed: %v, %v", proxy, err)
	}
	if m.intent.nodePoolRevision != before.GetNodePoolRevision() {
		t.Fatal("live selection advanced the applied pool revision")
	}
	store.fail = true
	if err := selectProxy(t, m, "loaded", false); status.Code(err) != codes.Internal {
		t.Fatalf("persistence failure = %v, want Internal", err)
	}
	store.fail = false
	if !slices.Equal(selections, []string{"route-video/loaded", "proxy/loaded", "proxy/old"}) ||
		m.intent.selector("proxy").Selected != "old" || m.appliedSelector("proxy").Selected != "old" {
		t.Fatalf("selection was not restored: calls=%v", selections)
	}
	if applies != 1 || checks != 1 {
		t.Fatalf("live selection built a full config: applies=%d checks=%d", applies, checks)
	}

	if _, err := m.Restart(ctx, &emptypb.Empty{}); status.Code(err) != codes.FailedPrecondition {
		t.Fatalf("restart with unavailable selection = %v, want FailedPrecondition", err)
	}
	if err := selectProxy(t, m, "direct", true); err != nil {
		t.Fatal(err)
	}
	if _, err := m.Restart(ctx, &emptypb.Empty{}); err != nil {
		t.Fatal(err)
	}
	if err := selectProxy(t, m, "new", true); err != nil {
		t.Fatal(err)
	}
	if err := selectVideo(t, m, "new", true); err != nil {
		t.Fatal(err)
	}
	if applies != 2 || checks != 2 || m.intent.nodePoolRevision != subs.NodePool().Revision {
		t.Fatalf("explicit restart did not apply current pool: applies=%d checks=%d", applies, checks)
	}
}

func selectProxy(t *testing.T, m *Manager, nodeID string, applied bool) error {
	t.Helper()
	response, err := m.SelectNode(context.Background(), &api.SelectNodeRequest{NodeId: nodeID})
	if err == nil && response.GetAppliedImmediately() != applied {
		t.Fatalf("SelectNode applied_immediately = %v, want %v", response.GetAppliedImmediately(), applied)
	}
	return err
}

func selectVideo(t *testing.T, m *Manager, nodeID string, applied bool) error {
	t.Helper()
	response, err := m.SelectRouteNode(context.Background(), &api.SelectRouteNodeRequest{ServiceId: "video", NodeId: nodeID})
	if err == nil && response.GetAppliedImmediately() != applied {
		t.Fatalf("SelectRouteNode applied_immediately = %v, want %v", response.GetAppliedImmediately(), applied)
	}
	return err
}
