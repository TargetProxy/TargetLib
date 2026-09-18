package manager

import (
	"context"
	"net"
	"net/http"
	"net/http/httptest"
	"testing"
	"time"

	api "github.com/loafman1120/TargetLib/api/TargetLib"
	"github.com/loafman1120/TargetLib/profile"
	"github.com/loafman1120/TargetLib/subscriptions"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"google.golang.org/protobuf/types/known/emptypb"
)

func waitSmartOperation(t *testing.T, m *Manager, id string) *api.Operation {
	t.Helper()
	deadline := time.Now().Add(5 * time.Second)
	for time.Now().Before(deadline) {
		operation, err := m.GetOperation(context.Background(), &api.GetOperationRequest{OperationId: id})
		if err != nil {
			t.Fatal(err)
		}
		switch operation.Status {
		case api.OperationStatus_OPERATION_STATUS_WAITING_APPROVAL, api.OperationStatus_OPERATION_STATUS_FAILED, api.OperationStatus_OPERATION_STATUS_SUCCEEDED:
			return operation
		}
		time.Sleep(10 * time.Millisecond)
	}
	t.Fatal("smart operation timed out")
	return nil
}

func TestSmartIntentEvaluationProbesEveryTargetAndDirect(t *testing.T) {
	m := smartTestManager(t, nil)
	good := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, _ *http.Request) { w.WriteHeader(204) }))
	defer good.Close()
	bad := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, _ *http.Request) { w.WriteHeader(403) }))
	defer bad.Close()
	m.probeTransport = func(context.Context, profile.Node) (*nodeProbeTransport, error) {
		return &nodeProbeTransport{dial: (&net.Dialer{}).DialContext, close: func() error { return nil }}, nil
	}
	if _, err := m.SetSmartConnectEnabled(context.Background(), &api.SetSmartConnectEnabledRequest{Enabled: true, IdempotencyKey: "enable-probes"}); err != nil {
		t.Fatal(err)
	}
	policy := &api.ServicePolicy{ServiceId: "multi", Domains: []string{"service.example"}, Probes: []*api.ServiceProbe{{Url: good.URL, ExpectedStatus: []uint32{204}}, {Url: bad.URL, ExpectedStatus: []uint32{204}}}}
	if _, err := m.UpsertServicePolicy(context.Background(), &api.UpsertServicePolicyRequest{Policy: policy, IdempotencyKey: "multi-policy"}); err != nil {
		t.Fatal(err)
	}
	op, err := m.RequestServiceEvaluation(context.Background(), &api.RequestServiceEvaluationRequest{ServiceId: "multi", IdempotencyKey: "multi-fail"})
	if err != nil {
		t.Fatal(err)
	}
	if result := waitSmartOperation(t, m, op.Id); result.Status != api.OperationStatus_OPERATION_STATUS_FAILED || result.ErrorCode != "NO_ELIGIBLE_CANDIDATE" {
		t.Fatalf("second failed target was accepted: %v", result)
	}
	policy.Probes = policy.Probes[:1]
	if _, err := m.UpsertServicePolicy(context.Background(), &api.UpsertServicePolicyRequest{Policy: policy, IdempotencyKey: "single-policy"}); err != nil {
		t.Fatal(err)
	}
	op, err = m.RequestServiceEvaluation(context.Background(), &api.RequestServiceEvaluationRequest{ServiceId: "multi", IdempotencyKey: "single-success"})
	if err != nil {
		t.Fatal(err)
	}
	if result := waitSmartOperation(t, m, op.Id); result.Status != api.OperationStatus_OPERATION_STATUS_WAITING_APPROVAL || result.ProposalId == "" {
		t.Fatalf("live probe did not create proposal: %v", result)
	}
	direct := &api.ServicePolicy{ServiceId: "direct-service", Domains: []string{"direct.example"}, SwitchPolicy: &api.SwitchPolicy{Mode: api.SwitchMode_SWITCH_MODE_DIRECT}, Selection: &api.ServiceSelectionPolicy{AllowDirect: true}}
	if _, err := m.UpsertServicePolicy(context.Background(), &api.UpsertServicePolicyRequest{Policy: direct, IdempotencyKey: "direct-policy"}); err != nil {
		t.Fatal(err)
	}
	op, err = m.RequestServiceEvaluation(context.Background(), &api.RequestServiceEvaluationRequest{ServiceId: direct.ServiceId, IdempotencyKey: "direct-eval"})
	if err != nil {
		t.Fatal(err)
	}
	if result := waitSmartOperation(t, m, op.Id); result.Status != api.OperationStatus_OPERATION_STATUS_WAITING_APPROVAL || result.ProposalId == "" {
		t.Fatalf("direct evaluation did not create proposal: %v", result)
	}
}

func TestSmartIntentCommandsPersistAndAreIdempotent(t *testing.T) {
	store := &subscriptions.MemoryStore{}
	m := smartTestManager(t, store)
	initial, err := m.GetSmartConnectSnapshot(context.Background(), &emptypb.Empty{})
	if err != nil {
		t.Fatal(err)
	}
	enable := &api.SetSmartConnectEnabledRequest{Enabled: true, ExpectedRevision: initial.Revision, IdempotencyKey: "enable-1"}
	first, err := m.SetSmartConnectEnabled(context.Background(), enable)
	if err != nil {
		t.Fatal(err)
	}
	second, err := m.SetSmartConnectEnabled(context.Background(), enable)
	if err != nil {
		t.Fatal(err)
	}
	if first.Id != second.Id || second.Status != api.OperationStatus_OPERATION_STATUS_SUCCEEDED {
		t.Fatalf("idempotent operation mismatch: %v %v", first, second)
	}
	if _, err := m.SetSmartConnectEnabled(context.Background(), &api.SetSmartConnectEnabledRequest{Enabled: false, IdempotencyKey: "enable-1"}); status.Code(err) != codes.AlreadyExists {
		t.Fatalf("changed idempotent command accepted: %v", err)
	}
	if _, err := m.SetSmartConnectEnabled(context.Background(), &api.SetSmartConnectEnabledRequest{Enabled: false, ExpectedRevision: initial.Revision, IdempotencyKey: "enable-stale"}); status.Code(err) != codes.Aborted {
		t.Fatalf("stale revision accepted: %v", err)
	}

	policyRequest := &api.UpsertServicePolicyRequest{ExpectedRevision: m.smart.read().Revision, IdempotencyKey: "policy-1", Policy: &api.ServicePolicy{ServiceId: "video", DisplayName: "Video", Domains: []string{"Example.COM"}, EvaluationIntervalSeconds: 60, Probes: []*api.ServiceProbe{{Url: "https://example.com/health"}}}}
	operation, err := m.UpsertServicePolicy(context.Background(), policyRequest)
	if err != nil {
		t.Fatal(err)
	}
	if operation.PolicyRevision == "" || operation.Status != api.OperationStatus_OPERATION_STATUS_SUCCEEDED {
		t.Fatalf("policy operation incomplete: %v", operation)
	}
	policies, err := m.ListServicePolicies(context.Background(), &emptypb.Empty{})
	if err != nil || len(policies.Policies) != 1 || policies.Policies[0].Domains[0] != "example.com" || policies.Policies[0].SwitchPolicy.Mode != api.SwitchMode_SWITCH_MODE_MANUAL {
		t.Fatalf("unexpected policies: %v, %v", policies, err)
	}

	restored, err := newSmartConnect(context.Background(), store)
	if err != nil {
		t.Fatal(err)
	}
	defer restored.close()
	if !restored.read().Enabled || len(restored.read().Policies) != 1 || len(restored.read().Operations) != 2 || len(restored.read().Tasks) != 1 {
		t.Fatalf("intent state was not restored: %v", restored.read())
	}
}

func TestSmartIntentForceBindingBuildsCoreOwnedRuntimeModel(t *testing.T) {
	m := smartTestManager(t, nil)
	_, err := m.SetSmartConnectEnabled(context.Background(), &api.SetSmartConnectEnabledRequest{Enabled: true, ExpectedRevision: m.smart.read().Revision, IdempotencyKey: "enable-force"})
	if err != nil {
		t.Fatal(err)
	}
	_, err = m.UpsertServicePolicy(context.Background(), &api.UpsertServicePolicyRequest{ExpectedRevision: m.smart.read().Revision, IdempotencyKey: "policy-force", Policy: &api.ServicePolicy{ServiceId: "svc", Domains: []string{"service.example"}}})
	if err != nil {
		t.Fatal(err)
	}
	nodeID := m.subscriptions.NodePool().Nodes[0].ID
	operation, err := m.ForceServiceBinding(context.Background(), &api.ForceServiceBindingRequest{ServiceId: "svc", NodeId: nodeID, ExpectedRevision: m.smart.read().Revision, IdempotencyKey: "force"})
	if err != nil {
		t.Fatal(err)
	}
	deadline := time.Now().Add(2 * time.Second)
	for time.Now().Before(deadline) {
		operation, err = m.GetOperation(context.Background(), &api.GetOperationRequest{OperationId: operation.Id})
		if err != nil {
			t.Fatal(err)
		}
		if operation.Status == api.OperationStatus_OPERATION_STATUS_SUCCEEDED || operation.Status == api.OperationStatus_OPERATION_STATUS_FAILED {
			break
		}
		time.Sleep(10 * time.Millisecond)
	}
	if operation.Status != api.OperationStatus_OPERATION_STATUS_SUCCEEDED {
		t.Fatalf("force binding failed: %v", operation)
	}
	desired, _ := m.desiredForUpdate("")
	if len(desired.ServiceBindings) != 1 || desired.ServiceBindings[0].NodeId != nodeID || len(desired.ServiceRoutes) != 1 || desired.ServiceRoutes[0].Domains[0] != "service.example" {
		t.Fatalf("core did not build runtime model: %v", desired)
	}
	disable, err := m.SetSmartConnectEnabled(context.Background(), &api.SetSmartConnectEnabledRequest{Enabled: false, ExpectedRevision: m.smart.read().Revision, IdempotencyKey: "disable"})
	if err != nil {
		t.Fatal(err)
	}
	deadline = time.Now().Add(2 * time.Second)
	for time.Now().Before(deadline) {
		disable, err = m.GetOperation(context.Background(), &api.GetOperationRequest{OperationId: disable.Id})
		if err != nil {
			t.Fatal(err)
		}
		if disable.Status == api.OperationStatus_OPERATION_STATUS_SUCCEEDED || disable.Status == api.OperationStatus_OPERATION_STATUS_FAILED {
			break
		}
		time.Sleep(10 * time.Millisecond)
	}
	if disable.Status != api.OperationStatus_OPERATION_STATUS_SUCCEEDED {
		t.Fatalf("disable cleanup failed: %v", disable)
	}
	desired, _ = m.desiredForUpdate("")
	if len(desired.ServiceBindings) != 0 || len(desired.ServiceRoutes) != 0 {
		t.Fatalf("disable left smart runtime state: %v", desired)
	}
}

func TestSmartIntentEvaluationCreatesDurableProposal(t *testing.T) {
	m := smartTestManager(t, nil)
	_, err := m.SetSmartConnectEnabled(context.Background(), &api.SetSmartConnectEnabledRequest{Enabled: true, ExpectedRevision: m.smart.read().Revision, IdempotencyKey: "enable"})
	if err != nil {
		t.Fatal(err)
	}
	_, err = m.UpsertServicePolicy(context.Background(), &api.UpsertServicePolicyRequest{ExpectedRevision: m.smart.read().Revision, IdempotencyKey: "policy", Policy: &api.ServicePolicy{ServiceId: "svc", Domains: []string{"service.example"}, EvaluationIntervalSeconds: 60, Probes: []*api.ServiceProbe{{Url: "https://service.example"}}}})
	if err != nil {
		t.Fatal(err)
	}
	probe := findProbe(m.smart.read(), "svc")
	pool := m.subscriptions.NodePool()
	now := time.Now().UnixMilli()
	for _, node := range pool.Nodes {
		if err := m.saveQuality(context.Background(), &api.ProbeResult{Id: node.ID, ServiceId: "svc", NodeId: node.ID, NodePoolRevision: pool.Revision, ProbeRevision: probe.Revision, Stage: api.ProbeStage_PROBE_STAGE_READY, TestedAtUnixMs: now, ExpiresAtUnixMs: now + 60_000, Attempts: 1, Successes: 1, LatencyMilliseconds: 20}); err != nil {
			t.Fatal(err)
		}
	}
	operation, err := m.RequestServiceEvaluation(context.Background(), &api.RequestServiceEvaluationRequest{ServiceId: "svc", ExpectedRevision: m.smart.read().Revision, IdempotencyKey: "evaluation"})
	if err != nil {
		t.Fatal(err)
	}
	deadline := time.Now().Add(2 * time.Second)
	for time.Now().Before(deadline) {
		operation, err = m.GetOperation(context.Background(), &api.GetOperationRequest{OperationId: operation.Id})
		if err != nil {
			t.Fatal(err)
		}
		if operation.Status == api.OperationStatus_OPERATION_STATUS_WAITING_APPROVAL {
			break
		}
		time.Sleep(10 * time.Millisecond)
	}
	if operation.Status != api.OperationStatus_OPERATION_STATUS_WAITING_APPROVAL || operation.ProposalId == "" {
		t.Fatalf("evaluation did not create proposal: %v", operation)
	}
	snapshot := m.smart.read()
	if len(snapshot.Proposals) != 1 || snapshot.Proposals[0].SuggestedNodeId == "" || snapshot.Proposals[0].PolicyRevision == "" {
		t.Fatalf("invalid proposal: %v", snapshot.Proposals)
	}
	listed, err := m.ListOperations(context.Background(), &api.ListOperationsRequest{ResourceId: "svc", Limit: 10})
	if err != nil || len(listed.Operations) < 2 {
		t.Fatalf("operation query failed: %v %v", listed, err)
	}
	m.NotifyNetworkChanged()
	invalidated := m.smart.read()
	if invalidated.Results[0].ExpiresAtUnixMs > time.Now().UnixMilli() || invalidated.Tasks[0].NextRunAtUnixMs > time.Now().UnixMilli() || invalidated.Tasks[0].Reason != "network_changed" {
		t.Fatalf("network change did not invalidate quality/task: %v", invalidated)
	}
}
