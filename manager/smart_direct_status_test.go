package manager

import (
	"context"
	api "github.com/loafman1120/TargetLib/api/TargetLib"
	"google.golang.org/protobuf/types/known/emptypb"
	"testing"
	"time"
)

func TestDirectBindingStatusDoesNotRequireNodePoolOrProbe(t *testing.T) {
	m := smartTestManager(t, nil)
	m.runtimeConfig.ServiceBindings = []*api.ServiceBinding{{ServiceId: "direct-service", SelectorTag: "direct-selector", NodeId: "direct", ExpiresAtUnixMs: time.Now().Add(time.Hour).UnixMilli()}}
	state, err := m.GetRuntimeState(context.Background(), &emptypb.Empty{})
	if err != nil {
		t.Fatal(err)
	}
	b := state.ServiceBindings[0]
	if !b.NodeAvailable || b.NeedsEvaluation || b.EvaluationReason != "" {
		t.Fatalf("explicit Direct was treated as an unavailable/probe-dependent node: %v", b)
	}
	m.runtimeConfig.ServiceBindings[0].ExpiresAtUnixMs = time.Now().Add(-time.Minute).UnixMilli()
	state, err = m.GetRuntimeState(context.Background(), &emptypb.Empty{})
	if err != nil {
		t.Fatal(err)
	}
	if state.ServiceBindings[0].EvaluationReason != "binding_expired" {
		t.Fatal("Direct must still honor binding expiry")
	}
}
