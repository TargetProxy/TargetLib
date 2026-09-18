package manager

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"sort"
	"strings"
	"sync"
	"time"

	"github.com/google/uuid"
	api "github.com/loafman1120/TargetLib/api/TargetLib"
	targetprofile "github.com/loafman1120/TargetLib/profile"
	"github.com/sagernet/sing-box/daemon"
	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"google.golang.org/protobuf/proto"
	"google.golang.org/protobuf/types/known/emptypb"
)

const smartPolicySchemaVersion = 1

func (m *Manager) GetSmartConnectSnapshot(context.Context, *emptypb.Empty) (*api.SmartConnectSnapshot, error) {
	return m.smart.read(), nil
}

func (m *Manager) ListServicePolicies(context.Context, *emptypb.Empty) (*api.ServicePolicyList, error) {
	policies := m.smart.read().Policies
	sort.Slice(policies, func(i, j int) bool { return policies[i].ServiceId < policies[j].ServiceId })
	return &api.ServicePolicyList{Policies: policies}, nil
}

func validateIntentKey(key string) error {
	if strings.TrimSpace(key) == "" || len(key) > 128 || strings.ContainsRune(key, '\x00') {
		return status.Error(codes.InvalidArgument, "idempotency key is required (maximum 128 bytes)")
	}
	return nil
}

func validateExpected(snapshot *api.SmartConnectSnapshot, expected string) error {
	if expected != "" && expected != snapshot.Revision {
		return status.Error(codes.Aborted, "smart connect revision changed")
	}
	return nil
}

func operationSignature(message proto.Message) string {
	content, _ := proto.MarshalOptions{Deterministic: true}.Marshal(message)
	sum := sha256.Sum256(content)
	return hex.EncodeToString(sum[:])
}

func findOperation(snapshot *api.SmartConnectSnapshot, key string) *api.Operation {
	for _, operation := range snapshot.Operations {
		if operation.IdempotencyKey == key {
			return operation
		}
	}
	return nil
}

func trimOperations(snapshot *api.SmartConnectSnapshot) {
	if len(snapshot.Operations) > 256 {
		snapshot.Operations = append([]*api.Operation(nil), snapshot.Operations[len(snapshot.Operations)-256:]...)
	}
}

func newOperation(kind, resource, key, signature string) *api.Operation {
	now := time.Now().UnixMilli()
	return &api.Operation{Id: uuid.NewString(), Kind: kind, ResourceId: resource, IdempotencyKey: key, RequestSignature: signature, Status: api.OperationStatus_OPERATION_STATUS_QUEUED, Phase: "accepted", CreatedAtUnixMs: now, UpdatedAtUnixMs: now}
}

func (m *Manager) acceptOperation(ctx context.Context, kind, resource, key, expected, signature string, change func(*api.SmartConnectSnapshot, *api.Operation) error) (*api.Operation, bool, error) {
	if err := validateIntentKey(key); err != nil {
		return nil, false, err
	}
	var result *api.Operation
	created := false
	err := m.smart.update(ctx, func(next *api.SmartConnectSnapshot) error {
		if existing := findOperation(next, key); existing != nil {
			if existing.Kind != kind || existing.ResourceId != resource || existing.RequestSignature != signature {
				return status.Error(codes.AlreadyExists, "idempotency key was used for a different command")
			}
			result = proto.Clone(existing).(*api.Operation)
			return nil
		}
		if err := validateExpected(next, expected); err != nil {
			return err
		}
		operation := newOperation(kind, resource, key, signature)
		if err := change(next, operation); err != nil {
			return err
		}
		next.Revision = uuid.NewString()
		next.Operations = append(next.Operations, operation)
		trimOperations(next)
		result = proto.Clone(operation).(*api.Operation)
		created = true
		return nil
	})
	if err != nil {
		return nil, false, err
	}
	if created {
		m.publishSmartConnect(result.Id, resource)
	}
	return result, created, nil
}

func completeImmediate(operation *api.Operation, summary string) {
	now := time.Now().UnixMilli()
	operation.Status = api.OperationStatus_OPERATION_STATUS_SUCCEEDED
	operation.Phase = "committed"
	operation.StartedAtUnixMs = now
	operation.UpdatedAtUnixMs = now
	operation.CompletedAtUnixMs = now
	operation.ProgressCurrent = 1
	operation.ProgressTotal = 1
	operation.ResultSummary = summary
}

func (m *Manager) SetSmartConnectEnabled(ctx context.Context, request *api.SetSmartConnectEnabledRequest) (*api.Operation, error) {
	if request == nil {
		return nil, status.Error(codes.InvalidArgument, "request is required")
	}
	signature := operationSignature(request)
	operation, created, err := m.acceptOperation(ctx, "set_enabled", "smart-connect", request.IdempotencyKey, request.ExpectedRevision, signature, func(next *api.SmartConnectSnapshot, operation *api.Operation) error {
		next.Enabled = request.Enabled
		if request.Enabled {
			completeImmediate(operation, "enabled=true")
		} else {
			operation.Phase = "cleanup"
		}
		return nil
	})
	if err == nil && created && !request.Enabled {
		m.smart.workers.Add(1)
		go func() { defer m.smart.workers.Done(); m.runDisableCleanup(operation.Id) }()
	}
	return operation, err
}

func (m *Manager) runDisableCleanup(operationID string) {
	m.updateOperation(operationID, "smart-connect", func(_ *api.SmartConnectSnapshot, operation *api.Operation) error {
		operation.Status = api.OperationStatus_OPERATION_STATUS_RUNNING
		operation.Phase = "cleanup"
		operation.StartedAtUnixMs = time.Now().UnixMilli()
		return nil
	})
	m.opMu.Lock()
	next, _ := m.desiredForUpdate("")
	owned := func(tag string) bool {
		return strings.HasPrefix(tag, "smart-") || strings.HasPrefix(tag, "target.smart.")
	}
	next.Selectors = removeIf(next.Selectors, func(selector *api.SelectorConfig) bool { return owned(selector.Tag) })
	next.ServiceRoutes = removeIf(next.ServiceRoutes, func(route *api.ServiceRoute) bool { return owned(route.SelectorTag) })
	next.ServiceBindings = removeIf(next.ServiceBindings, func(binding *api.ServiceBinding) bool { return owned(binding.SelectorTag) })
	result, err := m.applyDesired(context.Background(), next)
	m.opMu.Unlock()
	if err != nil {
		m.failOperation(operationID, "smart-connect", "CLEANUP_FAILED", err)
		return
	}
	m.updateOperation(operationID, "smart-connect", func(_ *api.SmartConnectSnapshot, operation *api.Operation) error {
		operation.Status = api.OperationStatus_OPERATION_STATUS_SUCCEEDED
		operation.Phase = "committed"
		operation.CompletedAtUnixMs = time.Now().UnixMilli()
		operation.RuntimeRevision = result.Revision
		operation.ProgressCurrent = 1
		operation.ProgressTotal = 1
		operation.ResultSummary = "enabled=false"
		return nil
	})
}

func filter[T any](values []T, keep func(T) bool) []T {
	result := values[:0]
	for _, value := range values {
		if keep(value) {
			result = append(result, value)
		}
	}
	return result
}

func removeIf[T any](values []T, remove func(T) bool) []T {
	return filter(values, func(value T) bool { return !remove(value) })
}

func validateServicePolicy(value *api.ServicePolicy) (*api.ServicePolicy, error) {
	if value == nil || strings.TrimSpace(value.ServiceId) == "" || strings.TrimSpace(value.ServiceId) != value.ServiceId || len(value.ServiceId) > 128 {
		return nil, status.Error(codes.InvalidArgument, "service ID is required (maximum 128 bytes)")
	}
	policy := proto.Clone(value).(*api.ServicePolicy)
	if policy.EvaluationIntervalSeconds > 30*24*60*60 || policy.BindingValiditySeconds > 30*24*60*60 || policy.QualityValiditySeconds > 7*24*60*60 {
		return nil, status.Error(codes.InvalidArgument, "policy validity or evaluation interval exceeds limit")
	}
	if policy.SwitchPolicy == nil {
		policy.SwitchPolicy = &api.SwitchPolicy{Mode: api.SwitchMode_SWITCH_MODE_MANUAL}
	}
	if policy.SwitchPolicy.Mode == api.SwitchMode_SWITCH_MODE_UNSPECIFIED {
		policy.SwitchPolicy.Mode = api.SwitchMode_SWITCH_MODE_MANUAL
	}
	seen := make(map[string]bool)
	for i, domain := range policy.Domains {
		domain = strings.ToLower(strings.TrimSpace(domain))
		if domain == "" || strings.ContainsAny(domain, "/:\x00") || seen[domain] {
			return nil, status.Error(codes.InvalidArgument, "service domains must be unique DNS suffixes")
		}
		seen[domain] = true
		policy.Domains[i] = domain
	}
	for i, probe := range policy.Probes {
		probe.ServiceId = policy.ServiceId
		validated, err := validateProbe(probe)
		if err != nil {
			return nil, err
		}
		policy.Probes[i] = validated
	}
	policy.SchemaVersion = smartPolicySchemaVersion
	policy.Revision = uuid.NewString()
	if policy.Selection == nil {
		policy.Selection = &api.ServiceSelectionPolicy{ServiceId: policy.ServiceId}
	}
	policy.Selection.ServiceId = policy.ServiceId
	return policy, nil
}

func (m *Manager) UpsertServicePolicy(ctx context.Context, request *api.UpsertServicePolicyRequest) (*api.Operation, error) {
	if request == nil {
		return nil, status.Error(codes.InvalidArgument, "request is required")
	}
	policy, err := validateServicePolicy(request.Policy)
	if err != nil {
		return nil, err
	}
	signature := operationSignature(request)
	operation, _, err := m.acceptOperation(ctx, "upsert_policy", policy.ServiceId, request.IdempotencyKey, request.ExpectedRevision, signature, func(next *api.SmartConnectSnapshot, operation *api.Operation) error {
		replaced := false
		for i, existing := range next.Policies {
			if existing.ServiceId == policy.ServiceId {
				next.Policies[i] = policy
				replaced = true
			}
		}
		if !replaced {
			next.Policies = append(next.Policies, policy)
		}
		// Keep v12 diagnostic queries backed by the authoritative policy.
		next.Probes = removeIf(next.Probes, func(probe *api.ServiceProbe) bool { return probe.ServiceId == policy.ServiceId })
		if len(policy.Probes) > 0 {
			probe := proto.Clone(policy.Probes[0]).(*api.ServiceProbe)
			probe.Revision = uuid.NewString()
			next.Probes = append(next.Probes, probe)
		}
		next.SelectionPolicies = removeIf(next.SelectionPolicies, func(selection *api.ServiceSelectionPolicy) bool { return selection.ServiceId == policy.ServiceId })
		selection := proto.Clone(policy.Selection).(*api.ServiceSelectionPolicy)
		selection.Revision = policy.Revision
		next.SelectionPolicies = append(next.SelectionPolicies, selection)
		next.Tasks = removeIf(next.Tasks, func(task *api.SchedulerTask) bool { return task.ServiceId == policy.ServiceId })
		if policy.EvaluationIntervalSeconds > 0 {
			next.Tasks = append(next.Tasks, &api.SchedulerTask{Id: uuid.NewString(), ServiceId: policy.ServiceId, Kind: "evaluate", Reason: "periodic", PolicyRevision: policy.Revision, NodePoolRevision: m.subscriptions.NodePool().Revision, NextRunAtUnixMs: time.Now().Add(time.Duration(policy.EvaluationIntervalSeconds) * time.Second).UnixMilli()})
		}
		operation.PolicyRevision = policy.Revision
		completeImmediate(operation, "policy committed")
		return nil
	})
	return operation, err
}

func (m *Manager) DeleteServicePolicy(ctx context.Context, request *api.DeleteServicePolicyRequest) (*api.Operation, error) {
	if request == nil || request.ServiceId == "" {
		return nil, status.Error(codes.InvalidArgument, "service ID is required")
	}
	signature := operationSignature(request)
	operation, created, err := m.acceptOperation(ctx, "delete_policy", request.ServiceId, request.IdempotencyKey, request.ExpectedRevision, signature, func(next *api.SmartConnectSnapshot, operation *api.Operation) error {
		before := len(next.Policies)
		next.Policies = removeIf(next.Policies, func(policy *api.ServicePolicy) bool { return policy.ServiceId == request.ServiceId })
		if len(next.Policies) == before {
			return status.Error(codes.NotFound, "service policy not found")
		}
		next.Proposals = removeIf(next.Proposals, func(proposal *api.SwitchProposal) bool { return proposal.ServiceId == request.ServiceId })
		next.Tasks = removeIf(next.Tasks, func(task *api.SchedulerTask) bool { return task.ServiceId == request.ServiceId })
		operation.Phase = "cleanup"
		return nil
	})
	if err == nil && created {
		m.smart.workers.Add(1)
		go func() { defer m.smart.workers.Done(); m.runPolicyCleanup(operation.Id, request.ServiceId) }()
	}
	return operation, err
}

func (m *Manager) runPolicyCleanup(operationID, serviceID string) {
	m.updateOperation(operationID, serviceID, func(_ *api.SmartConnectSnapshot, operation *api.Operation) error {
		operation.Status = api.OperationStatus_OPERATION_STATUS_RUNNING
		operation.StartedAtUnixMs = time.Now().UnixMilli()
		return nil
	})
	m.opMu.Lock()
	next, _ := m.desiredForUpdate("")
	next.ServiceRoutes = removeIf(next.ServiceRoutes, func(route *api.ServiceRoute) bool { return route.ServiceId == serviceID })
	next.ServiceBindings = removeIf(next.ServiceBindings, func(binding *api.ServiceBinding) bool { return binding.ServiceId == serviceID })
	tag := selectorTag(serviceID)
	next.Selectors = removeIf(next.Selectors, func(selector *api.SelectorConfig) bool { return selector.Tag == tag })
	result, err := m.applyDesired(context.Background(), next)
	m.opMu.Unlock()
	if err != nil {
		m.failOperation(operationID, serviceID, "CLEANUP_FAILED", err)
		return
	}
	m.updateOperation(operationID, serviceID, func(_ *api.SmartConnectSnapshot, operation *api.Operation) error {
		completeImmediate(operation, "policy and route deleted")
		operation.RuntimeRevision = result.Revision
		return nil
	})
}

func (m *Manager) SetNodePreference(ctx context.Context, request *api.SetNodePreferenceRequest) (*api.Operation, error) {
	if request == nil || request.Preference == nil || request.Preference.NodeId == "" {
		return nil, status.Error(codes.InvalidArgument, "node preference is required")
	}
	preference := proto.Clone(request.Preference).(*api.NodePreference)
	preference.Revision = uuid.NewString()
	signature := operationSignature(request)
	operation, _, err := m.acceptOperation(ctx, "set_node_preference", preference.NodeId, request.IdempotencyKey, request.ExpectedRevision, signature, func(next *api.SmartConnectSnapshot, operation *api.Operation) error {
		found := false
		for i, old := range next.NodePreferences {
			if old.NodeId == preference.NodeId {
				next.NodePreferences[i] = preference
				found = true
			}
		}
		if !found {
			next.NodePreferences = append(next.NodePreferences, preference)
		}
		completeImmediate(operation, "node preference committed")
		return nil
	})
	return operation, err
}

func (m *Manager) GetOperation(_ context.Context, request *api.GetOperationRequest) (*api.Operation, error) {
	if request.GetOperationId() == "" {
		return nil, status.Error(codes.InvalidArgument, "operation ID is required")
	}
	for _, operation := range m.smart.read().Operations {
		if operation.Id == request.OperationId {
			return operation, nil
		}
	}
	return nil, status.Error(codes.NotFound, "operation not found")
}

func (m *Manager) ListOperations(_ context.Context, request *api.ListOperationsRequest) (*api.OperationList, error) {
	limit := request.GetLimit()
	if limit == 0 {
		limit = 100
	}
	if limit > 256 {
		return nil, status.Error(codes.InvalidArgument, "operation limit exceeds 256")
	}
	operations := m.smart.read().Operations
	result := new(api.OperationList)
	for i := len(operations) - 1; i >= 0 && len(result.Operations) < int(limit); i-- {
		if request.GetResourceId() == "" || operations[i].ResourceId == request.ResourceId {
			result.Operations = append(result.Operations, operations[i])
		}
	}
	return result, nil
}

func (m *Manager) publishSmartConnect(operationID, resourceID string) {
	s := m.smart
	s.mu.Lock()
	defer s.mu.Unlock()
	if s.closed {
		return
	}
	s.sequence++
	event := &api.SmartConnectEvent{Sequence: s.sequence, Epoch: s.epoch, OperationId: operationID, ResourceId: resourceID, OccurredAtUnixMs: time.Now().UnixMilli(), Snapshot: proto.Clone(s.snapshot).(*api.SmartConnectSnapshot)}
	for ch := range s.intentSubscribers {
		select {
		case ch <- event:
		default:
			close(ch)
			delete(s.intentSubscribers, ch)
		}
	}
}

func (m *Manager) SubscribeSmartConnectEvents(request *api.SmartConnectEventsRequest, stream grpc.ServerStreamingServer[api.SmartConnectEvent]) error {
	s := m.smart
	s.mu.Lock()
	if s.closed {
		s.mu.Unlock()
		return status.Error(codes.Unavailable, "manager is closed")
	}
	ch := make(chan *api.SmartConnectEvent, 32)
	s.intentSubscribers[ch] = struct{}{}
	initial := &api.SmartConnectEvent{Sequence: s.sequence, Epoch: s.epoch, OccurredAtUnixMs: time.Now().UnixMilli(), Snapshot: proto.Clone(s.snapshot).(*api.SmartConnectSnapshot)}
	if request.GetAfterSequence() > s.sequence {
		initial.Sequence = 0
	}
	s.mu.Unlock()
	defer func() { s.mu.Lock(); delete(s.intentSubscribers, ch); s.mu.Unlock() }()
	if err := stream.Send(initial); err != nil {
		return err
	}
	for {
		select {
		case <-stream.Context().Done():
			return status.FromContextError(stream.Context().Err()).Err()
		case <-s.done:
			return status.Error(codes.Unavailable, "manager is closed")
		case event, ok := <-ch:
			if !ok {
				return status.Error(codes.ResourceExhausted, "smart connect event consumer fell behind; reload snapshot")
			}
			if err := stream.Send(proto.Clone(event).(*api.SmartConnectEvent)); err != nil {
				return err
			}
		}
	}
}

func findServicePolicy(snapshot *api.SmartConnectSnapshot, serviceID string) *api.ServicePolicy {
	for _, policy := range snapshot.Policies {
		if policy.ServiceId == serviceID {
			return policy
		}
	}
	return nil
}

func updateStoredOperation(snapshot *api.SmartConnectSnapshot, operationID string, change func(*api.Operation)) bool {
	for _, operation := range snapshot.Operations {
		if operation.Id == operationID {
			change(operation)
			operation.UpdatedAtUnixMs = time.Now().UnixMilli()
			return true
		}
	}
	return false
}

func (m *Manager) updateOperation(operationID, resourceID string, change func(*api.SmartConnectSnapshot, *api.Operation) error) {
	err := m.smart.update(context.Background(), func(next *api.SmartConnectSnapshot) error {
		var operation *api.Operation
		for _, candidate := range next.Operations {
			if candidate.Id == operationID {
				operation = candidate
				break
			}
		}
		if operation == nil {
			return status.Error(codes.NotFound, "operation not found")
		}
		if err := change(next, operation); err != nil {
			return err
		}
		next.Revision = uuid.NewString()
		return nil
	})
	if err == nil {
		m.publishSmartConnect(operationID, resourceID)
	}
}

func (m *Manager) RequestServiceEvaluation(ctx context.Context, request *api.RequestServiceEvaluationRequest) (*api.Operation, error) {
	if request == nil || request.ServiceId == "" {
		return nil, status.Error(codes.InvalidArgument, "service ID is required")
	}
	signature := operationSignature(request)
	operation, created, err := m.acceptOperation(ctx, "evaluate_service", request.ServiceId, request.IdempotencyKey, request.ExpectedRevision, signature, func(next *api.SmartConnectSnapshot, operation *api.Operation) error {
		if !next.Enabled {
			return status.Error(codes.FailedPrecondition, "smart connect is disabled")
		}
		policy := findServicePolicy(next, request.ServiceId)
		if policy == nil {
			return status.Error(codes.NotFound, "service policy not found")
		}
		for _, active := range next.Operations {
			if active.ResourceId == request.ServiceId && active.Kind == "evaluate_service" && (active.Status == api.OperationStatus_OPERATION_STATUS_QUEUED || active.Status == api.OperationStatus_OPERATION_STATUS_RUNNING) {
				return status.Error(codes.FailedPrecondition, "service evaluation is already active")
			}
		}
		operation.PolicyRevision = policy.Revision
		operation.NodePoolRevision = m.subscriptions.NodePool().Revision
		operation.ProgressTotal = 1
		return nil
	})
	if err != nil || !created {
		return operation, err
	}
	m.smart.workers.Add(1)
	go func(id, serviceID, policyRevision, poolRevision string) {
		defer m.smart.workers.Done()
		defer m.rescheduleService(serviceID, id)
		m.runEvaluation(id, serviceID, policyRevision, poolRevision)
	}(operation.Id, operation.ResourceId, operation.PolicyRevision, operation.NodePoolRevision)
	return operation, nil
}

func (m *Manager) runEvaluation(operationID, serviceID, policyRevision, poolRevision string) {
	m.updateOperation(operationID, serviceID, func(_ *api.SmartConnectSnapshot, operation *api.Operation) error {
		now := time.Now().UnixMilli()
		operation.Status = api.OperationStatus_OPERATION_STATUS_RUNNING
		operation.Phase = "evaluating"
		operation.StartedAtUnixMs = now
		return nil
	})
	snapshot := m.smart.read()
	policy := findServicePolicy(snapshot, serviceID)
	if policy == nil || policy.Revision != policyRevision {
		m.failOperation(operationID, serviceID, "REVISION_CHANGED", status.Error(codes.Aborted, "policy changed during evaluation"))
		return
	}
	var evaluation *api.ServiceEvaluation
	var err error
	if policy.SwitchPolicy.GetMode() == api.SwitchMode_SWITCH_MODE_DIRECT {
		evaluation = &api.ServiceEvaluation{ServiceId: serviceID, Candidates: []*api.ServiceCandidate{{NodeId: "direct", Eligible: true, Reason: "explicit direct"}}}
	} else {
		if len(policy.Probes) == 0 {
			m.failOperation(operationID, serviceID, "PROBE_NOT_CONFIGURED", status.Error(codes.FailedPrecondition, "service probe is required"))
			return
		}
		pool := m.subscriptions.NodePool()
		primary := findProbe(snapshot, serviceID)
		if primary == nil {
			m.failOperation(operationID, serviceID, "PROBE_NOT_CONFIGURED", status.Error(codes.FailedPrecondition, "service probe is required"))
			return
		}
		failures := make(map[string]string)
		var mu sync.Mutex
		var workers sync.WaitGroup
		limit := make(chan struct{}, 4)
		for _, node := range pool.Nodes {
			if !m.nodeAllowed(snapshot, policy, node.ID) || node.Outbound == nil {
				continue
			}
			if len(policy.Probes) == 1 && qualityReason(snapshot, serviceID, node.ID, time.Now().UnixMilli()) == "" {
				continue
			}
			limit <- struct{}{}
			workers.Add(1)
			go func(node targetprofile.Node) {
				defer workers.Done()
				defer func() { <-limit }()
				for i, probe := range policy.Probes {
					if i == 0 {
						probe = primary
					}
					result := m.probeNode(context.Background(), probe, node, pool.Revision, nil, 1)
					if i == 0 {
						if saveErr := m.saveQuality(context.Background(), result); saveErr != nil {
							mu.Lock()
							failures[node.ID] = saveErr.Error()
							mu.Unlock()
							return
						}
					}
					if result.Stage != api.ProbeStage_PROBE_STAGE_READY || result.Successes == 0 {
						mu.Lock()
						failures[node.ID] = fmt.Sprintf("probe_%d:%s", i+1, result.Stage)
						mu.Unlock()
						return
					}
				}
			}(node)
		}
		workers.Wait()
		evaluation, err = m.EvaluateService(context.Background(), &api.EvaluateServiceRequest{ServiceId: serviceID})
		if err == nil {
			for _, candidate := range evaluation.Candidates {
				if reason := failures[candidate.NodeId]; reason != "" {
					candidate.Eligible, candidate.Score, candidate.Reason = false, 0, reason
				}
			}
			sort.Slice(evaluation.Candidates, func(i, j int) bool {
				a, b := evaluation.Candidates[i], evaluation.Candidates[j]
				if a.Eligible != b.Eligible {
					return a.Eligible
				}
				if a.Score != b.Score {
					return a.Score > b.Score
				}
				return a.NodeId < b.NodeId
			})
		}
	}
	if err != nil {
		m.failOperation(operationID, serviceID, "evaluation_failed", err)
		return
	}
	m.updateOperation(operationID, serviceID, func(next *api.SmartConnectSnapshot, operation *api.Operation) error {
		policy := findServicePolicy(next, serviceID)
		if policy == nil || policy.Revision != policyRevision || m.subscriptions.NodePool().Revision != poolRevision {
			operation.Status = api.OperationStatus_OPERATION_STATUS_CANCELLED
			operation.Phase = "stale"
			operation.ErrorCode = "REVISION_CHANGED"
			operation.ErrorMessage = "policy or node pool changed during evaluation"
			operation.CompletedAtUnixMs = time.Now().UnixMilli()
			return nil
		}
		var best *api.ServiceCandidate
		for _, candidate := range evaluation.Candidates {
			if candidate.Eligible {
				best = candidate
				break
			}
		}
		if best == nil {
			operation.Status = api.OperationStatus_OPERATION_STATUS_FAILED
			operation.Phase = "no_candidate"
			operation.ErrorCode = "NO_ELIGIBLE_CANDIDATE"
			operation.ErrorMessage = "no eligible service candidate"
			operation.CompletedAtUnixMs = time.Now().UnixMilli()
			return nil
		}
		proposal := &api.SwitchProposal{Id: uuid.NewString(), ServiceId: serviceID, SuggestedNodeId: best.NodeId, Candidates: evaluation.Candidates, Reason: "evaluation", PolicyRevision: policy.Revision, NodePoolRevision: poolRevision, CreatedAtUnixMs: time.Now().UnixMilli(), ExpiresAtUnixMs: time.Now().Add(30 * time.Minute).UnixMilli()}
		desired, _ := m.desiredForUpdate("")
		for _, binding := range desired.GetServiceBindings() {
			if binding.ServiceId == serviceID {
				proposal.CurrentNodeId = binding.NodeId
				proposal.BindingRevision = binding.Revision
			}
		}
		next.Proposals = removeIf(next.Proposals, func(proposal *api.SwitchProposal) bool { return proposal.ServiceId == serviceID })
		next.Proposals = append(next.Proposals, proposal)
		operation.ProposalId = proposal.Id
		operation.ProgressCurrent = 1
		if policy.SwitchPolicy.GetMode() == api.SwitchMode_SWITCH_MODE_AUTO_CONSTRAINED && m.autoAuthorized(next, policy, proposal) {
			proposal.AutoAuthorized = true
			operation.Status = api.OperationStatus_OPERATION_STATUS_RUNNING
			operation.Phase = "applying"
		} else {
			operation.Status = api.OperationStatus_OPERATION_STATUS_WAITING_APPROVAL
			operation.Phase = "waiting_approval"
			operation.ResultSummary = "proposal ready"
		}
		return nil
	})
	latest, getErr := m.GetOperation(context.Background(), &api.GetOperationRequest{OperationId: operationID})
	if getErr == nil && latest.Status == api.OperationStatus_OPERATION_STATUS_RUNNING {
		m.runBindingOperation(operationID, serviceID, latest.ProposalId, "")
	}
}

func (m *Manager) failOperation(operationID, resourceID, code string, cause error) {
	m.updateOperation(operationID, resourceID, func(_ *api.SmartConnectSnapshot, operation *api.Operation) error {
		operation.Status = api.OperationStatus_OPERATION_STATUS_FAILED
		operation.Phase = "failed"
		operation.ErrorCode = code
		operation.ErrorMessage = cause.Error()
		operation.CompletedAtUnixMs = time.Now().UnixMilli()
		return nil
	})
}

func findProposal(snapshot *api.SmartConnectSnapshot, id string) *api.SwitchProposal {
	for _, proposal := range snapshot.Proposals {
		if proposal.Id == id {
			return proposal
		}
	}
	return nil
}

func (m *Manager) RejectSwitchProposal(ctx context.Context, request *api.ProposalCommandRequest) (*api.Operation, error) {
	if request == nil || request.ProposalId == "" {
		return nil, status.Error(codes.InvalidArgument, "proposal ID is required")
	}
	signature := operationSignature(request)
	operation, _, err := m.acceptOperation(ctx, "reject_proposal", request.ProposalId, request.IdempotencyKey, request.ExpectedRevision, signature, func(next *api.SmartConnectSnapshot, operation *api.Operation) error {
		proposal := findProposal(next, request.ProposalId)
		if proposal == nil {
			return status.Error(codes.NotFound, "proposal not found")
		}
		next.Proposals = removeIf(next.Proposals, func(candidate *api.SwitchProposal) bool { return candidate.Id == request.ProposalId })
		for _, active := range next.Operations {
			if active.ProposalId == request.ProposalId && active.Status == api.OperationStatus_OPERATION_STATUS_WAITING_APPROVAL {
				active.Status = api.OperationStatus_OPERATION_STATUS_CANCELLED
				active.Phase = "rejected"
				active.CompletedAtUnixMs = time.Now().UnixMilli()
			}
		}
		completeImmediate(operation, "proposal rejected")
		return nil
	})
	return operation, err
}

func (m *Manager) ApproveSwitchProposal(ctx context.Context, request *api.ProposalCommandRequest) (*api.Operation, error) {
	if request == nil || request.ProposalId == "" {
		return nil, status.Error(codes.InvalidArgument, "proposal ID is required")
	}
	signature := operationSignature(request)
	serviceID := ""
	operation, created, err := m.acceptOperation(ctx, "approve_proposal", request.ProposalId, request.IdempotencyKey, request.ExpectedRevision, signature, func(next *api.SmartConnectSnapshot, operation *api.Operation) error {
		proposal := findProposal(next, request.ProposalId)
		if proposal == nil {
			return status.Error(codes.NotFound, "proposal not found")
		}
		if proposal.ExpiresAtUnixMs <= time.Now().UnixMilli() {
			return status.Error(codes.FailedPrecondition, "proposal expired")
		}
		policy := findServicePolicy(next, proposal.ServiceId)
		if policy == nil || policy.Revision != proposal.PolicyRevision {
			return status.Error(codes.Aborted, "proposal policy revision changed")
		}
		serviceID = proposal.ServiceId
		proposal.Approved = true
		operation.ProposalId = proposal.Id
		operation.PolicyRevision = policy.Revision
		operation.NodePoolRevision = proposal.NodePoolRevision
		return nil
	})
	if err != nil || !created {
		return operation, err
	}
	m.smart.workers.Add(1)
	go func() {
		defer m.smart.workers.Done()
		m.runBindingOperation(operation.Id, serviceID, operation.ProposalId, "")
	}()
	return operation, nil
}

func (m *Manager) ForceServiceBinding(ctx context.Context, request *api.ForceServiceBindingRequest) (*api.Operation, error) {
	if request == nil || request.ServiceId == "" || request.NodeId == "" {
		return nil, status.Error(codes.InvalidArgument, "service ID and node ID are required")
	}
	signature := operationSignature(request)
	operation, created, err := m.acceptOperation(ctx, "force_binding", request.ServiceId, request.IdempotencyKey, request.ExpectedRevision, signature, func(next *api.SmartConnectSnapshot, operation *api.Operation) error {
		if !next.Enabled {
			return status.Error(codes.FailedPrecondition, "smart connect is disabled")
		}
		policy := findServicePolicy(next, request.ServiceId)
		if policy == nil {
			return status.Error(codes.NotFound, "service policy not found")
		}
		if !m.nodeAllowed(next, policy, request.NodeId) {
			return status.Error(codes.FailedPrecondition, "node is outside policy constraints")
		}
		operation.PolicyRevision = policy.Revision
		operation.NodePoolRevision = m.subscriptions.NodePool().Revision
		operation.DesiredNodeId = request.NodeId
		return nil
	})
	if err != nil || !created {
		return operation, err
	}
	m.smart.workers.Add(1)
	go func() {
		defer m.smart.workers.Done()
		m.runBindingOperation(operation.Id, request.ServiceId, "", request.NodeId)
	}()
	return operation, nil
}

func (m *Manager) rescheduleService(serviceID, operationID string) {
	_ = m.smart.update(context.Background(), func(next *api.SmartConnectSnapshot) error {
		policy := findServicePolicy(next, serviceID)
		if policy == nil || policy.EvaluationIntervalSeconds == 0 {
			return nil
		}
		for _, task := range next.Tasks {
			if task.ServiceId == serviceID {
				task.PolicyRevision = policy.Revision
				task.NodePoolRevision = m.subscriptions.NodePool().Revision
				task.NextRunAtUnixMs = time.Now().Add(time.Duration(policy.EvaluationIntervalSeconds) * time.Second).UnixMilli()
				task.Attempt = 0
				task.BackoffSeconds = 0
				task.OperationId = operationID
				return nil
			}
		}
		next.Tasks = append(next.Tasks, &api.SchedulerTask{Id: uuid.NewString(), ServiceId: serviceID, Kind: "evaluate", Reason: "periodic", PolicyRevision: policy.Revision, NodePoolRevision: m.subscriptions.NodePool().Revision, NextRunAtUnixMs: time.Now().Add(time.Duration(policy.EvaluationIntervalSeconds) * time.Second).UnixMilli(), OperationId: operationID})
		return nil
	})
}

func (m *Manager) dispatchDueSmartTasks() {
	snapshot := m.smart.read()
	now := time.Now().UnixMilli()
	for _, task := range snapshot.Tasks {
		if task.Kind != "evaluate" || task.NextRunAtUnixMs > now {
			continue
		}
		key := fmt.Sprintf("task:%s:%d", task.Id, task.NextRunAtUnixMs)
		_, err := m.RequestServiceEvaluation(context.Background(), &api.RequestServiceEvaluationRequest{ServiceId: task.ServiceId, ExpectedRevision: snapshot.Revision, IdempotencyKey: key})
		if err != nil {
			_ = m.smart.update(context.Background(), func(next *api.SmartConnectSnapshot) error {
				for _, current := range next.Tasks {
					if current.Id == task.Id {
						current.Attempt++
						delay := time.Duration(1<<min(current.Attempt, uint32(8))) * time.Second
						current.BackoffSeconds = uint32(delay.Seconds())
						current.NextRunAtUnixMs = time.Now().Add(delay).UnixMilli()
					}
				}
				return nil
			})
		}
		return
	}
}

// NotifyNetworkChanged invalidates network-scoped observations and advances
// persistent evaluation tasks. Platform hosts call it from their native
// connectivity callback; no client process needs to stay alive.
func (m *Manager) NotifyNetworkChanged() {
	changed := false
	_ = m.smart.update(context.Background(), func(next *api.SmartConnectSnapshot) error {
		now := time.Now().UnixMilli()
		for _, result := range next.Results {
			if result.ExpiresAtUnixMs > now {
				result.ExpiresAtUnixMs = now
				changed = true
			}
		}
		for _, task := range next.Tasks {
			if task.NextRunAtUnixMs > now {
				task.NextRunAtUnixMs = now
				task.Reason = "network_changed"
				changed = true
			}
		}
		if changed {
			next.Revision = uuid.NewString()
		}
		return nil
	})
	if changed {
		m.publishSmartConnect("", "network")
	}
}

func (m *Manager) recoverSmartConnectOperations() {
	for _, operation := range m.smart.read().Operations {
		if operation.Status != api.OperationStatus_OPERATION_STATUS_QUEUED && operation.Status != api.OperationStatus_OPERATION_STATUS_RUNNING {
			continue
		}
		m.smart.workers.Add(1)
		go func(operation *api.Operation) {
			defer m.smart.workers.Done()
			switch operation.Kind {
			case "set_enabled":
				if !m.smart.read().Enabled {
					m.runDisableCleanup(operation.Id)
				} else {
					m.failOperation(operation.Id, operation.ResourceId, "RECOVERY_FAILED", status.Error(codes.Internal, "incomplete enable operation"))
				}
			case "evaluate_service":
				if operation.ProposalId != "" && operation.Phase == "applying" {
					m.runBindingOperation(operation.Id, operation.ResourceId, operation.ProposalId, "")
				} else {
					m.runEvaluation(operation.Id, operation.ResourceId, operation.PolicyRevision, operation.NodePoolRevision)
				}
			case "approve_proposal":
				snapshot := m.smart.read()
				proposal := findProposal(snapshot, operation.ProposalId)
				if proposal == nil {
					m.failOperation(operation.Id, operation.ResourceId, "RECOVERY_FAILED", status.Error(codes.NotFound, "proposal not found during recovery"))
					return
				}
				m.runBindingOperation(operation.Id, proposal.ServiceId, operation.ProposalId, "")
			case "force_binding":
				m.runBindingOperation(operation.Id, operation.ResourceId, "", operation.DesiredNodeId)
			default:
				m.failOperation(operation.Id, operation.ResourceId, "RECOVERY_FAILED", status.Error(codes.Internal, "unsupported unfinished operation"))
			}
		}(proto.Clone(operation).(*api.Operation))
	}
}

func (m *Manager) nodeAllowed(snapshot *api.SmartConnectSnapshot, policy *api.ServicePolicy, nodeID string) bool {
	if nodeID == "direct" {
		return policy.SwitchPolicy.GetMode() == api.SwitchMode_SWITCH_MODE_DIRECT || policy.SwitchPolicy.GetAllowDirect()
	}
	for _, preference := range snapshot.NodePreferences {
		if preference.NodeId == nodeID && (!preference.Enabled || preference.Excluded) {
			return false
		}
	}
	for _, node := range m.subscriptions.NodePool().Nodes {
		if node.ID != nodeID || node.Outbound == nil {
			continue
		}
		selection := policy.Selection
		if selection != nil {
			for _, excluded := range selection.ExcludedNodeIds {
				if excluded == nodeID {
					return false
				}
			}
			if len(selection.SubscriptionIds) > 0 {
				allowed := false
				for _, id := range selection.SubscriptionIds {
					if id == node.SubscriptionID {
						allowed = true
					}
				}
				if !allowed {
					return false
				}
			}
		}
		switchPolicy := policy.SwitchPolicy
		if switchPolicy != nil {
			if len(switchPolicy.AllowedCountries) > 0 {
				allowed := false
				for _, country := range switchPolicy.AllowedCountries {
					if strings.EqualFold(country, node.CountryCode) {
						allowed = true
					}
				}
				if !allowed {
					return false
				}
			}
			if len(switchPolicy.AllowedSubscriptionIds) > 0 {
				allowed := false
				for _, id := range switchPolicy.AllowedSubscriptionIds {
					if id == node.SubscriptionID {
						allowed = true
					}
				}
				if !allowed {
					return false
				}
			}
		}
		return true
	}
	return false
}

func (m *Manager) autoAuthorized(snapshot *api.SmartConnectSnapshot, policy *api.ServicePolicy, proposal *api.SwitchProposal) bool {
	rules := policy.SwitchPolicy
	if rules == nil || rules.Mode != api.SwitchMode_SWITCH_MODE_AUTO_CONSTRAINED || !m.nodeAllowed(snapshot, policy, proposal.SuggestedNodeId) {
		return false
	}
	var suggested, current *api.ServiceCandidate
	for _, candidate := range proposal.Candidates {
		if candidate.NodeId == proposal.SuggestedNodeId {
			suggested = candidate
		}
		if candidate.NodeId == proposal.CurrentNodeId {
			current = candidate
		}
	}
	if suggested == nil || !suggested.Eligible || suggested.Score < rules.MinimumHealthScore {
		return false
	}
	if current != nil && current.Eligible && suggested.Score-current.Score < rules.MinimumScoreDelta {
		return false
	}
	now := time.Now()
	desired, _ := m.desiredForUpdate("")
	for _, binding := range desired.ServiceBindings {
		if binding.ServiceId == policy.ServiceId && rules.MinimumDwellSeconds > 0 && now.Sub(time.UnixMilli(binding.SelectedAtUnixMs)) < time.Duration(rules.MinimumDwellSeconds)*time.Second {
			return false
		}
	}
	var recent int
	for _, operation := range snapshot.Operations {
		if operation.ResourceId != policy.ServiceId || operation.Status != api.OperationStatus_OPERATION_STATUS_SUCCEEDED || operation.BindingRevision == "" {
			continue
		}
		age := now.Sub(time.UnixMilli(operation.CompletedAtUnixMs))
		if rules.CooldownSeconds > 0 && age < time.Duration(rules.CooldownSeconds)*time.Second {
			return false
		}
		if age < time.Hour {
			recent++
		}
	}
	if rules.MaxSwitchesPerHour > 0 && recent >= int(rules.MaxSwitchesPerHour) {
		return false
	}
	if proposal.CurrentNodeId != "" && proposal.CurrentNodeId != "direct" && proposal.SuggestedNodeId != "direct" {
		pool := m.subscriptions.NodePool()
		var oldCountry, newCountry, oldSubscription, newSubscription string
		for _, node := range pool.Nodes {
			if node.ID == proposal.CurrentNodeId {
				oldCountry, oldSubscription = node.CountryCode, node.SubscriptionID
			}
			if node.ID == proposal.SuggestedNodeId {
				newCountry, newSubscription = node.CountryCode, node.SubscriptionID
			}
		}
		if !rules.AllowCrossCountry && oldCountry != "" && newCountry != oldCountry {
			return false
		}
		if !rules.AllowCrossSubscription && oldSubscription != "" && newSubscription != oldSubscription {
			return false
		}
	}
	return true
}

func selectorTag(serviceID string) string {
	sum := sha256.Sum256([]byte(serviceID))
	return "smart-" + hex.EncodeToString(sum[:6])
}

func (m *Manager) runBindingOperation(operationID, serviceID, proposalID, forcedNodeID string) {
	snapshot := m.smart.read()
	policy := findServicePolicy(snapshot, serviceID)
	if policy == nil {
		m.failOperation(operationID, serviceID, "POLICY_NOT_FOUND", status.Error(codes.NotFound, "service policy not found"))
		return
	}
	operation, err := m.GetOperation(context.Background(), &api.GetOperationRequest{OperationId: operationID})
	if err != nil || operation.PolicyRevision != policy.Revision || operation.NodePoolRevision != m.subscriptions.NodePool().Revision {
		m.failOperation(operationID, serviceID, "REVISION_CHANGED", status.Error(codes.Aborted, "policy or node pool changed before binding commit"))
		return
	}
	nodeID := forcedNodeID
	if proposalID != "" {
		proposal := findProposal(snapshot, proposalID)
		if proposal == nil {
			m.failOperation(operationID, serviceID, "PROPOSAL_NOT_FOUND", status.Error(codes.NotFound, "proposal not found"))
			return
		}
		desired, _ := m.desiredForUpdate("")
		currentRevision := ""
		for _, binding := range desired.ServiceBindings {
			if binding.ServiceId == serviceID {
				currentRevision = binding.Revision
			}
		}
		if proposal.BindingRevision != currentRevision {
			m.failOperation(operationID, serviceID, "BINDING_REVISION_CHANGED", status.Error(codes.Aborted, "binding changed before proposal commit"))
			return
		}
		nodeID = proposal.SuggestedNodeId
	}
	if !m.nodeAllowed(snapshot, policy, nodeID) {
		m.failOperation(operationID, serviceID, "POLICY_CONSTRAINT", status.Error(codes.FailedPrecondition, "node is outside policy constraints"))
		return
	}
	m.updateOperation(operationID, serviceID, func(_ *api.SmartConnectSnapshot, operation *api.Operation) error {
		operation.Status = api.OperationStatus_OPERATION_STATUS_RUNNING
		operation.Phase = "applying"
		if operation.StartedAtUnixMs == 0 {
			operation.StartedAtUnixMs = time.Now().UnixMilli()
		}
		return nil
	})
	m.opMu.Lock()
	next, _ := m.desiredForUpdate("")
	previous := cloneRuntimeConfig(next)
	tag := selectorTag(serviceID)
	members := []string{nodeID}
	if policy.Selection != nil && policy.Selection.AllowDirect && nodeID != "direct" {
		members = append(members, "direct")
	}
	selectorFound := false
	liveMember := false
	previousSelected := ""
	for _, selector := range next.Selectors {
		if selector.Tag == tag {
			previousSelected = selector.SelectedNodeId
			selector.SelectedNodeId = nodeID
			found := false
			for _, member := range selector.NodeIds {
				if member == nodeID {
					found = true
				}
			}
			liveMember = found
			if !found {
				selector.NodeIds = append(selector.NodeIds, nodeID)
			}
			selectorFound = true
		}
	}
	if !selectorFound {
		next.Selectors = append(next.Selectors, &api.SelectorConfig{Tag: tag, NodeIds: members, SelectedNodeId: nodeID})
	}
	routeFound := false
	for _, route := range next.ServiceRoutes {
		if route.ServiceId == serviceID {
			route.Domains = append([]string(nil), policy.Domains...)
			route.SelectorTag = tag
			route.Enabled = true
			routeFound = true
		}
	}
	if !routeFound {
		next.ServiceRoutes = append(next.ServiceRoutes, &api.ServiceRoute{ServiceId: serviceID, Domains: append([]string(nil), policy.Domains...), SelectorTag: tag, Enabled: true})
	}
	binding := &api.ServiceBinding{ServiceId: serviceID, SelectorTag: tag, NodeId: nodeID, SelectedAtUnixMs: time.Now().UnixMilli(), SelectionReason: "smart-connect", SelectionPolicyRevision: policy.Revision}
	if policy.BindingValiditySeconds > 0 {
		binding.ExpiresAtUnixMs = binding.SelectedAtUnixMs + int64(policy.BindingValiditySeconds)*1000
	}
	if proposalID != "" {
		if proposal := findProposal(snapshot, proposalID); proposal != nil {
			binding.SelectionReason = proposal.Reason
			for _, candidate := range proposal.Candidates {
				if candidate.NodeId == nodeID {
					binding.SelectedScore = candidate.Score
					break
				}
			}
		}
	}
	replaced := false
	for i, old := range next.ServiceBindings {
		if old.ServiceId == serviceID {
			next.ServiceBindings[i] = binding
			replaced = true
		}
	}
	if !replaced {
		next.ServiceBindings = append(next.ServiceBindings, binding)
	}
	result, err := m.applySmartBindingDesired(context.Background(), next, tag, nodeID, previousSelected, selectorFound && liveMember, operationID)
	m.opMu.Unlock()
	if err != nil {
		m.failOperation(operationID, serviceID, "RUNTIME_APPLY_FAILED", err)
		return
	}
	if policy.SwitchPolicy.GetVerifyAfterSwitch() {
		if verifyErr := m.verifyServiceBinding(serviceID, tag, nodeID); verifyErr != nil {
			if policy.SwitchPolicy.GetRollbackOnVerificationFailure() {
				m.opMu.Lock()
				_, rollbackErr := m.applyDesired(context.Background(), previous)
				m.opMu.Unlock()
				m.updateOperation(operationID, serviceID, func(_ *api.SmartConnectSnapshot, operation *api.Operation) error {
					operation.CompletedAtUnixMs = time.Now().UnixMilli()
					operation.ErrorCode = "VERIFICATION_FAILED"
					operation.ErrorMessage = verifyErr.Error()
					if rollbackErr != nil {
						operation.Status = api.OperationStatus_OPERATION_STATUS_FAILED
						operation.Phase = "degraded"
						operation.ErrorMessage += "; rollback failed: " + rollbackErr.Error()
					} else {
						operation.Status = api.OperationStatus_OPERATION_STATUS_ROLLED_BACK
						operation.Phase = "rolled_back"
					}
					return nil
				})
				return
			}
			m.failOperation(operationID, serviceID, "VERIFICATION_FAILED", verifyErr)
			return
		}
	}
	m.updateOperation(operationID, serviceID, func(next *api.SmartConnectSnapshot, operation *api.Operation) error {
		operation.Status = api.OperationStatus_OPERATION_STATUS_SUCCEEDED
		operation.Phase = "committed"
		operation.RuntimeRevision = result.Revision
		operation.BindingRevision = result.Revision
		operation.CompletedAtUnixMs = time.Now().UnixMilli()
		operation.ProgressCurrent = 1
		operation.ProgressTotal = 1
		operation.ResultSummary = "binding committed"
		if proposalID != "" {
			next.Proposals = removeIf(next.Proposals, func(proposal *api.SwitchProposal) bool { return proposal.Id == proposalID })
		}
		return nil
	})
}

// Caller holds opMu. Existing selector members use sing-box's live selector
// API; model or route changes fall back to the full validated reload path.
func (m *Manager) applySmartBindingDesired(ctx context.Context, next *api.RuntimeConfig, selectorTag, nodeID, previousSelected string, preferLive bool, operationID string) (*api.RuntimeConfig, error) {
	current, err := m.waitForStableStatus(ctx)
	if err != nil {
		return nil, err
	}
	if !preferLive || current.Status != daemon.ServiceStatus_STARTED {
		return m.applyDesiredWithOperation(ctx, next, operationID)
	}
	next.Revision = uuid.NewString()
	m.configMu.RLock()
	nodes := append([]targetprofile.Node(nil), m.runtimeNodes...)
	m.configMu.RUnlock()
	if err := normalizeDesired(next, nodes); err != nil {
		return nil, err
	}
	settings, err := buildSettings(next.Settings, m.cacheFilePath)
	if err != nil {
		return nil, err
	}
	content, err := buildRuntimeConfigForModel(settings, runtimeModel(next, nodes))
	if err != nil {
		return nil, err
	}
	m.setApplyPhase(api.ConfigApplyPhase_CONFIG_APPLY_PHASE_APPLYING, next.Revision, nil)
	if m.daemon == nil {
		return nil, status.Error(codes.FailedPrecondition, "runtime selector is unavailable")
	}
	if _, err := m.daemon.SelectOutbound(ctx, selectorTag, nodeID); err != nil {
		m.setApplyPhase(api.ConfigApplyPhase_CONFIG_APPLY_PHASE_FAILED, next.Revision, err)
		return nil, err
	}
	if err := m.commitSmartRuntime(context.WithoutCancel(ctx), next, nodes, operationID); err != nil {
		if previousSelected != "" {
			_, _ = m.daemon.SelectOutbound(context.WithoutCancel(ctx), selectorTag, previousSelected)
		}
		m.setApplyPhase(api.ConfigApplyPhase_CONFIG_APPLY_PHASE_FAILED, next.Revision, err)
		return nil, err
	}
	m.configMu.Lock()
	m.runtimeConfig = cloneRuntimeConfig(next)
	m.runtimeNodes = append([]targetprofile.Node(nil), nodes...)
	m.config = string(content)
	m.appliedConfig = cloneRuntimeConfig(next)
	m.configMu.Unlock()
	m.setApplyPhase(api.ConfigApplyPhase_CONFIG_APPLY_PHASE_READY, next.Revision, nil)
	return cloneRuntimeConfig(next), nil
}

func (m *Manager) verifyServiceBinding(serviceID, selectorTag, nodeID string) error {
	state, err := m.GetRuntimeState(context.Background(), &emptypb.Empty{})
	if err != nil {
		return fmt.Errorf("read actual selector: %w", err)
	}
	if state.Running {
		matched := false
		for _, selector := range state.Selectors {
			if selector.Desired.GetTag() == selectorTag && selector.ActualNodeId == nodeID && selector.Effective {
				matched = true
			}
		}
		if !matched {
			return status.Error(codes.FailedPrecondition, "runtime selector did not apply requested node")
		}
	}
	snapshot := m.smart.read()
	probe := findProbe(snapshot, serviceID)
	if probe == nil || nodeID == "direct" {
		return nil
	}
	for _, node := range m.subscriptions.NodePool().Nodes {
		if node.ID != nodeID {
			continue
		}
		result := m.probeNode(context.Background(), probe, node, m.subscriptions.NodePool().Revision, nil, 1)
		if result.Stage != api.ProbeStage_PROBE_STAGE_READY {
			return status.Errorf(codes.FailedPrecondition, "post-switch service verification failed: %s", result.Stage.String())
		}
		return nil
	}
	return status.Error(codes.NotFound, "binding node disappeared during verification")
}
