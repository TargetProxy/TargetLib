package manager

import (
	"context"
	"strings"
	"time"

	api "github.com/loafman1120/TargetLib/api/TargetLib"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"google.golang.org/protobuf/proto"
)

func (m *Manager) GetServiceSelectionPolicy(_ context.Context, req *api.ServiceSelectionPolicyRequest) (*api.ServiceSelectionPolicy, error) {
	if req == nil || strings.TrimSpace(req.ServiceId) == "" {
		return nil, status.Error(codes.InvalidArgument, "service ID is required")
	}
	for _, p := range m.smart.read().SelectionPolicies {
		if p.ServiceId == req.ServiceId {
			return p, nil
		}
	}
	return &api.ServiceSelectionPolicy{ServiceId: req.ServiceId, AllowDirect: false, MaxCandidates: 20}, nil
}

func (m *Manager) PutServiceSelectionPolicy(ctx context.Context, value *api.ServiceSelectionPolicy) (*api.ServiceSelectionPolicy, error) {
	if value == nil || strings.TrimSpace(value.ServiceId) == "" {
		return nil, status.Error(codes.InvalidArgument, "service ID is required")
	}
	p := proto.Clone(value).(*api.ServiceSelectionPolicy)
	if p.MaxCandidates == 0 {
		p.MaxCandidates = 20
	}
	if p.MaxCandidates > 256 {
		return nil, status.Error(codes.InvalidArgument, "max candidates exceeds 256")
	}
	for i := range p.PreferredCountries {
		p.PreferredCountries[i] = strings.ToUpper(strings.TrimSpace(p.PreferredCountries[i]))
	}
	requestedRevision := p.ExpectedRevision
	p.ExpectedRevision = ""
	if err := m.smart.update(ctx, func(next *api.SmartConnectSnapshot) error {
		for i, old := range next.SelectionPolicies {
			if old.ServiceId == p.ServiceId {
				if requestedRevision != "" && requestedRevision != old.Revision {
					return status.Error(codes.Aborted, "selection policy revision changed")
				}
				p.Revision = time.Now().UTC().Format("20060102T150405.000000000Z")
				next.SelectionPolicies[i] = p
				return nil
			}
		}
		next.SelectionPolicies = append(next.SelectionPolicies, p)
		return nil
	}); err != nil {
		return nil, err
	}
	m.publishRuntime(&api.RuntimeEvent{Type: api.RuntimeEventType_RUNTIME_EVENT_TYPE_PROBE_DEFINITION, ServiceId: p.ServiceId})
	return proto.Clone(p).(*api.ServiceSelectionPolicy), nil
}
