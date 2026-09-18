package manager

import (
	"context"
	"time"

	api "github.com/loafman1120/TargetLib/api/TargetLib"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"google.golang.org/protobuf/types/known/emptypb"
)

func (m *Manager) GetSmartConnectDiagnostics(ctx context.Context, request *api.EvaluateServiceRequest) (*api.SmartConnectDiagnostics, error) {
	policy := smartPolicy(m.smart.read())
	state, err := m.GetRuntimeState(ctx, &emptypb.Empty{})
	if err != nil {
		return nil, err
	}
	report := &api.SmartConnectDiagnostics{Runtime: state, PolicyRevision: policy.Revision, GeneratedAtUnixMs: time.Now().UnixMilli()}
	ids := []string{request.GetServiceId()}
	if request.GetServiceId() == "" {
		ids = nil
		for _, p := range policy.Probes {
			ids = append(ids, p.ServiceId)
		}
	}
	for _, id := range ids {
		evaluation, err := m.EvaluateService(ctx, &api.EvaluateServiceRequest{ServiceId: id})
		if err != nil {
			return nil, err
		}
		if evaluation.RuntimeRevision != state.DesiredRevision || evaluation.NodePoolRevision != state.NodePoolRevision {
			return nil, status.Error(codes.Aborted, "runtime or node pool changed during diagnostics; retry")
		}
		report.Evaluations = append(report.Evaluations, evaluation)
	}
	if smartPolicy(m.smart.read()).Revision != policy.Revision {
		return nil, status.Error(codes.Aborted, "probe policy changed during diagnostics; retry")
	}
	return report, nil
}
