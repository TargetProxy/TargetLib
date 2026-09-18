package manager

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"sort"

	api "github.com/loafman1120/TargetLib/api/TargetLib"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"google.golang.org/protobuf/proto"
	"google.golang.org/protobuf/types/known/emptypb"
)

func smartPolicy(snapshot *api.SmartConnectSnapshot) *api.SmartConnectPolicy {
	result := &api.SmartConnectPolicy{SchemaVersion: 1}
	for _, p := range snapshot.Probes {
		result.Probes = append(result.Probes, proto.Clone(p).(*api.ServiceProbe))
	}
	sort.Slice(result.Probes, func(i, j int) bool { return result.Probes[i].ServiceId < result.Probes[j].ServiceId })
	content, _ := proto.MarshalOptions{Deterministic: true}.Marshal(result)
	sum := sha256.Sum256(content)
	result.Revision = hex.EncodeToString(sum[:])
	return result
}

func (m *Manager) ExportSmartConnectPolicy(context.Context, *emptypb.Empty) (*api.SmartConnectPolicy, error) {
	return smartPolicy(m.smart.read()), nil
}

func (m *Manager) ImportSmartConnectPolicy(ctx context.Context, request *api.ImportSmartConnectPolicyRequest) (*api.SmartConnectPolicy, error) {
	if request.GetPolicy().GetSchemaVersion() != 1 || request.GetExpectedRevision() == "" || len(request.GetPolicy().GetProbes()) > 256 {
		return nil, status.Error(codes.InvalidArgument, "schema version 1 and local expected revision are required; maximum 256 probes")
	}
	var probes []*api.ServiceProbe
	seen := make(map[string]bool)
	for _, value := range request.Policy.Probes {
		p, err := validateProbe(value)
		if err != nil {
			return nil, err
		}
		if seen[p.ServiceId] {
			return nil, status.Error(codes.InvalidArgument, "duplicate service probe")
		}
		seen[p.ServiceId] = true
		probes = append(probes, p)
	}
	var result *api.SmartConnectPolicy
	err := m.smart.update(ctx, func(next *api.SmartConnectSnapshot) error {
		if smartPolicy(next).Revision != request.ExpectedRevision {
			return status.Error(codes.Aborted, "local policy revision changed")
		}
		// Reuse local revisions for equivalent policies; foreign revisions never
		// make remote quality authoritative on this device.
		for _, p := range probes {
			if old := findProbe(next, p.ServiceId); old != nil {
				candidate := proto.Clone(p).(*api.ServiceProbe)
				candidate.Revision = old.Revision
				if proto.Equal(candidate, old) {
					p.Revision = old.Revision
				}
			}
		}
		next.Probes = probes
		result = smartPolicy(next)
		return nil
	})
	if err != nil {
		return nil, err
	}
	m.publishRuntime(&api.RuntimeEvent{Type: api.RuntimeEventType_RUNTIME_EVENT_TYPE_PROBE_DEFINITION})
	return result, nil
}
