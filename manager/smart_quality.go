package manager

import (
	"context"
	"fmt"
	"math"
	"net/http"
	"net/netip"
	"net/url"
	"sort"
	"strings"
	"sync"
	"time"

	"github.com/google/uuid"
	api "github.com/loafman1120/TargetLib/api/TargetLib"
	"github.com/loafman1120/TargetLib/profile"
	"github.com/loafman1120/TargetLib/subscriptions"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"google.golang.org/protobuf/proto"
	"google.golang.org/protobuf/types/known/emptypb"
)

const smartMetadataKey = "smart-connect-v1"

type smartConnect struct {
	mu                sync.Mutex
	store             subscriptions.Store
	snapshot          *api.SmartConnectSnapshot
	subscribers       map[chan *api.RuntimeEvent]struct{}
	intentSubscribers map[chan *api.SmartConnectEvent]struct{}
	sequence          uint64
	epoch             string
	closed            bool
	done              chan struct{}
	workers           sync.WaitGroup
	slots             chan struct{}
}

func newSmartConnect(ctx context.Context, store subscriptions.Store) (*smartConnect, error) {
	s := &smartConnect{store: store, snapshot: new(api.SmartConnectSnapshot), subscribers: make(map[chan *api.RuntimeEvent]struct{}), intentSubscribers: make(map[chan *api.SmartConnectEvent]struct{}), epoch: uuid.NewString(), done: make(chan struct{}), slots: make(chan struct{}, 4)}
	content, err := store.GetMetadata(ctx, smartMetadataKey)
	if err != nil {
		return nil, err
	}
	if err := proto.Unmarshal(content, s.snapshot); err != nil {
		return nil, fmt.Errorf("decode smart connect: %w", err)
	}
	if s.snapshot.Revision == "" {
		s.snapshot.Revision = uuid.NewString()
	}
	s.snapshot.RecoveryState = api.SmartRecoveryState_SMART_RECOVERY_STATE_READY
	return s, nil
}

func (s *smartConnect) read() *api.SmartConnectSnapshot {
	s.mu.Lock()
	defer s.mu.Unlock()
	return proto.Clone(s.snapshot).(*api.SmartConnectSnapshot)
}

func (s *smartConnect) update(ctx context.Context, change func(*api.SmartConnectSnapshot) error) error {
	s.mu.Lock()
	defer s.mu.Unlock()
	if s.closed {
		return status.Error(codes.Unavailable, "manager is closed")
	}
	next := proto.Clone(s.snapshot).(*api.SmartConnectSnapshot)
	if err := change(next); err != nil {
		return err
	}
	content, err := proto.Marshal(next)
	if err != nil {
		return err
	}
	if err := s.store.Update(ctx, func(tx subscriptions.StoreTx) error { return tx.SetMetadata(smartMetadataKey, content) }); err != nil {
		if ctx.Err() != nil {
			return status.FromContextError(ctx.Err()).Err()
		}
		return status.Error(codes.Internal, "persist smart connect: "+err.Error())
	}
	s.snapshot = next
	return nil
}

func (s *smartConnect) close() {
	s.mu.Lock()
	if !s.closed {
		s.closed = true
		close(s.done)
		for ch := range s.subscribers {
			close(ch)
			delete(s.subscribers, ch)
		}
		for ch := range s.intentSubscribers {
			close(ch)
			delete(s.intentSubscribers, ch)
		}
	}
	s.mu.Unlock()
	s.workers.Wait()
}

func validateProbe(value *api.ServiceProbe) (*api.ServiceProbe, error) {
	if value == nil || strings.TrimSpace(value.ServiceId) == "" || strings.TrimSpace(value.ServiceId) != value.ServiceId || strings.ContainsRune(value.ServiceId, '\x00') || len(value.ServiceId) > 128 {
		return nil, status.Error(codes.InvalidArgument, "service ID is required (maximum 128 bytes)")
	}
	p := proto.Clone(value).(*api.ServiceProbe)
	for _, raw := range []string{p.Url, p.EgressUrl} {
		if raw == "" && raw == p.EgressUrl && p.Url != "" {
			continue
		}
		u, err := url.Parse(raw)
		if err != nil || len(raw) > 4096 || u.Hostname() == "" || u.User != nil || u.Fragment != "" || (u.Scheme != "http" && u.Scheme != "https") {
			return nil, status.Error(codes.InvalidArgument, "probe URLs must be absolute HTTP(S) URLs without credentials or fragments")
		}
	}
	if p.TimeoutMilliseconds == 0 {
		p.TimeoutMilliseconds = 10000
	}
	if p.ValiditySeconds == 0 {
		p.ValiditySeconds = 1800
	}
	if p.TimeoutMilliseconds > 60000 || p.ValiditySeconds > 86400 || len(p.BodyContains) > 4096 || len(p.ExpectedStatus) > 100 || len(p.AllowedCountries) > 250 {
		return nil, status.Error(codes.InvalidArgument, "probe limits exceeded")
	}
	if p.ServiceCountryHeader != "" && !validHeaderName(p.ServiceCountryHeader) {
		return nil, status.Error(codes.InvalidArgument, "invalid service country header")
	}
	if p.UdpEchoAddress != "" {
		addr, err := netip.ParseAddrPort(p.UdpEchoAddress)
		if err != nil || addr.Port() == 0 || addr.Addr().IsUnspecified() || addr.Addr().IsMulticast() {
			return nil, status.Error(codes.InvalidArgument, "UDP echo address must be a unicast IP:port")
		}
		if p.PacketCount == 0 {
			p.PacketCount = 5
		}
		if p.PacketTimeoutMilliseconds == 0 {
			p.PacketTimeoutMilliseconds = 500
		}
		if p.PacketCount > 20 || p.PacketTimeoutMilliseconds > 2000 {
			return nil, status.Error(codes.InvalidArgument, "UDP probe limits: 20 packets, 2000 ms per packet")
		}
	}
	if p.UdpEchoAddress == "" && (p.PacketCount != 0 || p.PacketTimeoutMilliseconds != 0) {
		return nil, status.Error(codes.InvalidArgument, "packet options require a UDP echo address")
	}
	if p.MaximumPacketLoss != nil && (p.UdpEchoAddress == "" || math.IsNaN(*p.MaximumPacketLoss) || *p.MaximumPacketLoss < 0 || *p.MaximumPacketLoss > 1) {
		return nil, status.Error(codes.InvalidArgument, "maximum packet loss requires UDP echo and a ratio in [0,1]")
	}
	for _, code := range p.ExpectedStatus {
		if code < 100 || code > 599 {
			return nil, status.Error(codes.InvalidArgument, "invalid expected HTTP status")
		}
	}
	for i, country := range p.AllowedCountries {
		country = strings.ToUpper(strings.TrimSpace(country))
		if !validCountry(country) {
			return nil, status.Error(codes.InvalidArgument, "countries must be two ASCII letters")
		}
		p.AllowedCountries[i] = country
	}
	if len(p.AllowedCountries) > 0 && p.EgressUrl == "" && p.ServiceCountryHeader == "" {
		return nil, status.Error(codes.InvalidArgument, "region requirements need an egress URL or service country header")
	}
	p.Revision = uuid.NewString()
	return p, nil
}

func validCountry(s string) bool {
	return len(s) == 2 && s[0] >= 'A' && s[0] <= 'Z' && s[1] >= 'A' && s[1] <= 'Z'
}
func validHeaderName(s string) bool {
	if s == "" {
		return false
	}
	for _, c := range s {
		if !(c >= 'a' && c <= 'z' || c >= 'A' && c <= 'Z' || c >= '0' && c <= '9' || strings.ContainsRune("!#$%&'*+-.^_`|~", c)) {
			return false
		}
	}
	return true
}

func (m *Manager) PutServiceProbe(ctx context.Context, value *api.ServiceProbe) (*api.ServiceProbe, error) {
	p, err := validateProbe(value)
	if err != nil {
		return nil, err
	}
	err = m.smart.update(ctx, func(next *api.SmartConnectSnapshot) error {
		for i, old := range next.Probes {
			if old.ServiceId == p.ServiceId {
				if value.Revision != "" && value.Revision != old.Revision {
					return status.Error(codes.Aborted, "probe revision changed")
				}
				next.Probes[i] = p
				return nil
			}
		}
		if value.Revision != "" {
			return status.Error(codes.Aborted, "probe no longer exists")
		}
		if len(next.Probes) >= 256 {
			return status.Error(codes.ResourceExhausted, "maximum 256 service probes")
		}
		next.Probes = append(next.Probes, p)
		return nil
	})
	if err != nil {
		return nil, err
	}
	m.publishRuntime(&api.RuntimeEvent{Type: api.RuntimeEventType_RUNTIME_EVENT_TYPE_PROBE_DEFINITION, ServiceId: p.ServiceId})
	return proto.Clone(p).(*api.ServiceProbe), nil
}

func (m *Manager) ListServiceProbes(context.Context, *emptypb.Empty) (*api.ServiceProbeList, error) {
	probes := m.smart.read().Probes
	sort.Slice(probes, func(i, j int) bool { return probes[i].ServiceId < probes[j].ServiceId })
	return &api.ServiceProbeList{Probes: probes}, nil
}

func findProbe(snapshot *api.SmartConnectSnapshot, id string) *api.ServiceProbe {
	for _, p := range snapshot.Probes {
		if p.ServiceId == id {
			return p
		}
	}
	return nil
}

func (m *Manager) RemoveServiceProbe(ctx context.Context, request *api.RemoveServiceProbeRequest) (*emptypb.Empty, error) {
	if request.GetServiceId() == "" {
		return nil, status.Error(codes.InvalidArgument, "service ID is required")
	}
	err := m.smart.update(ctx, func(next *api.SmartConnectSnapshot) error {
		probe := findProbe(next, request.ServiceId)
		if probe != nil {
			if request.ExpectedRevision != "" && request.ExpectedRevision != probe.Revision {
				return status.Error(codes.Aborted, "probe revision changed")
			}
			next.Probes = removeIf(next.Probes, func(candidate *api.ServiceProbe) bool { return candidate.ServiceId == request.ServiceId })
			return nil
		}
		return status.Error(codes.NotFound, "service probe not found")
	})
	if err != nil {
		return nil, err
	}
	m.publishRuntime(&api.RuntimeEvent{Type: api.RuntimeEventType_RUNTIME_EVENT_TYPE_PROBE_DEFINITION, ServiceId: request.ServiceId})
	return &emptypb.Empty{}, nil
}

func (m *Manager) GetQualityHistory(_ context.Context, request *api.QualityHistoryRequest) (*api.QualityHistory, error) {
	limit := request.GetLimit()
	if limit == 0 {
		limit = 100
	}
	if limit > 1024 {
		return nil, status.Error(codes.InvalidArgument, "history limit exceeds 1024")
	}
	result := new(api.QualityHistory)
	history := m.smart.read().Results
	for i := len(history) - 1; i >= 0 && len(result.Results) < int(limit); i-- {
		row := history[i]
		if (request.GetServiceId() == "" || row.ServiceId == request.GetServiceId()) && (request.GetNodeId() == "" || row.NodeId == request.GetNodeId()) {
			result.Results = append(result.Results, row)
		}
	}
	return result, nil
}

func (m *Manager) saveQuality(ctx context.Context, result *api.ProbeResult) error {
	return m.smart.update(ctx, func(next *api.SmartConnectSnapshot) error {
		next.Results = append(next.Results, proto.Clone(result).(*api.ProbeResult))
		sort.SliceStable(next.Results, func(i, j int) bool { return next.Results[i].TestedAtUnixMs < next.Results[j].TestedAtUnixMs })
		// Retain at most 32 observations per service/node and 1024 globally.
		counts := make(map[string]int)
		kept := make([]*api.ProbeResult, 0, len(next.Results))
		for i := len(next.Results) - 1; i >= 0 && len(kept) < 1024; i-- {
			row := next.Results[i]
			key := row.ServiceId + "\x00" + row.NodeId
			counts[key]++
			if counts[key] <= 32 {
				kept = append(kept, row)
			}
		}
		for i, j := 0, len(kept)-1; i < j; i, j = i+1, j-1 {
			kept[i], kept[j] = kept[j], kept[i]
		}
		next.Results = kept
		return nil
	})
}

func latestQuality(snapshot *api.SmartConnectSnapshot, serviceID, nodeID string) *api.ProbeResult {
	p := findProbe(snapshot, serviceID)
	var fallback *api.ProbeResult
	for i := len(snapshot.Results) - 1; i >= 0; i-- {
		r := snapshot.Results[i]
		if r.ServiceId == serviceID && r.NodeId == nodeID {
			if fallback == nil {
				fallback = r
			}
			if p == nil || r.ProbeRevision == p.Revision {
				return r
			}
		}
	}
	return fallback
}

func qualityReason(snapshot *api.SmartConnectSnapshot, serviceID, nodeID string, now int64) string {
	p := findProbe(snapshot, serviceID)
	if p == nil {
		return "probe_not_configured"
	}
	latest := latestQuality(snapshot, serviceID, nodeID)
	if latest == nil {
		return "not_probed"
	}
	if latest.ProbeRevision != p.Revision {
		return "probe_definition_changed"
	}
	if latest.ExpiresAtUnixMs <= now {
		return "quality_expired"
	}
	if latest.Stage != api.ProbeStage_PROBE_STAGE_READY {
		return "probe_failed:" + latest.Stage.String()
	}
	if p.MaximumPacketLoss != nil && (!latest.PacketLossAvailable || latest.PacketLossRatio > *p.MaximumPacketLoss) {
		return "packet_loss_requirement_failed"
	}
	return ""
}

func (m *Manager) EvaluateService(_ context.Context, request *api.EvaluateServiceRequest) (*api.ServiceEvaluation, error) {
	if request.GetServiceId() == "" {
		return nil, status.Error(codes.InvalidArgument, "service ID is required")
	}
	snapshot := m.smart.read()
	p := findProbe(snapshot, request.ServiceId)
	if p == nil {
		return nil, status.Error(codes.NotFound, "service probe not found")
	}
	pool := m.subscriptions.NodePool()
	var policy *api.ServiceSelectionPolicy
	for _, candidate := range snapshot.SelectionPolicies {
		if candidate.ServiceId == request.ServiceId {
			policy = candidate
			break
		}
	}
	allowedSubs, excluded, preferred, favorites := map[string]bool{}, map[string]bool{}, map[string]bool{}, map[string]bool{}
	if policy != nil {
		for _, v := range policy.SubscriptionIds {
			allowedSubs[v] = true
		}
		for _, v := range policy.ExcludedNodeIds {
			excluded[v] = true
		}
		for _, v := range policy.PreferredCountries {
			preferred[strings.ToUpper(v)] = true
		}
		for _, v := range policy.FavoriteNodeIds {
			favorites[v] = true
		}
	}
	desired, _ := m.desiredForUpdate("")
	now := time.Now().UnixMilli()
	result := &api.ServiceEvaluation{ServiceId: p.ServiceId, NodePoolRevision: pool.Revision, RuntimeRevision: desired.Revision, EvaluatedAtUnixMs: now}
	result.ProbeRevision = p.Revision
	for _, node := range pool.Nodes {
		if excluded[node.ID] || (len(allowedSubs) > 0 && !allowedSubs[node.SubscriptionID]) {
			continue
		}
		if servicePolicy := findServicePolicy(snapshot, request.ServiceId); servicePolicy != nil && !m.nodeAllowed(snapshot, servicePolicy, node.ID) {
			continue
		}
		candidate := &api.ServiceCandidate{NodeId: node.ID, Latest: latestQuality(snapshot, p.ServiceId, node.ID), Reason: qualityReason(snapshot, p.ServiceId, node.ID, now)}
		preferenceBonus := float64(0)
		for _, preference := range snapshot.NodePreferences {
			if preference.NodeId == node.ID {
				if preference.Favorite {
					preferenceBonus += 5
				}
				preferenceBonus += math.Max(-5, math.Min(5, float64(preference.SubscriptionPriority)/10))
				break
			}
		}
		if node.Outbound == nil || node.Phase == profile.NodeFailed || node.Error != "" {
			candidate.Reason = "node_unavailable"
		}
		var samples []*api.ProbeResult
		var successes, attempts uint32
		var sum float64
		for _, row := range snapshot.Results {
			if row.NodeId == node.ID && row.ServiceId == p.ServiceId && row.ProbeRevision == p.Revision && row.ExpiresAtUnixMs > now {
				attempts += row.Attempts
				successes += row.Successes
				if row.Successes > 0 {
					samples = append(samples, row)
					sum += float64(row.LatencyMilliseconds)
				}
			}
		}
		if attempts > 0 {
			candidate.SuccessRatio = float64(successes) / float64(attempts)
		}
		if len(samples) > 0 {
			candidate.MeanLatencyMilliseconds = sum / float64(len(samples))
		}
		if len(samples) >= 2 {
			split := len(samples) / 2
			var older, newer float64
			for i, row := range samples {
				if i < split {
					older += float64(row.LatencyMilliseconds)
				} else {
					newer += float64(row.LatencyMilliseconds)
				}
			}
			candidate.LatencyTrendMilliseconds = newer/float64(len(samples)-split) - older/float64(split)
		}
		candidate.Eligible = candidate.Reason == ""
		if candidate.Eligible {
			jitter := float64(candidate.Latest.GetJitterMilliseconds())
			candidate.Score = math.Round(10000*candidate.SuccessRatio/(1+candidate.MeanLatencyMilliseconds/1000+jitter/1000)) / 100
			if candidate.Latest.PacketLossAvailable {
				candidate.Score = math.Round(candidate.Score*(1-candidate.Latest.PacketLossRatio)*100) / 100
			}
			if favorites[node.ID] {
				candidate.Score = math.Round((candidate.Score+5)*100) / 100
			}
			candidate.Score += preferenceBonus
			if preferred[strings.ToUpper(candidate.Latest.GetObservedCountry())] ||
				(candidate.Latest.GetObservedCountry() == "" && preferred[strings.ToUpper(node.CountryCode)]) {
				candidate.Score += 3
			}
		}
		result.Candidates = append(result.Candidates, candidate)
	}
	if policy != nil && policy.AllowDirect {
		result.Candidates = append(result.Candidates, &api.ServiceCandidate{NodeId: "direct", Eligible: true, Score: 1, Reason: "direct"})
	}
	sort.Slice(result.Candidates, func(i, j int) bool {
		a, b := result.Candidates[i], result.Candidates[j]
		if a.Eligible != b.Eligible {
			return a.Eligible
		}
		if a.Score != b.Score {
			return a.Score > b.Score
		}
		return a.NodeId < b.NodeId
	})
	if policy != nil && policy.MaxCandidates > 0 && len(result.Candidates) > int(policy.MaxCandidates) {
		result.Candidates = result.Candidates[:policy.MaxCandidates]
	}
	return result, nil
}

func validateProbeHeaders(headers map[string]string) error {
	if len(headers) > 32 {
		return status.Error(codes.InvalidArgument, "too many probe headers")
	}
	for k, v := range headers {
		if !validHeaderName(k) || len(v) > 8192 || strings.ContainsAny(v, "\r\n\x00") || http.CanonicalHeaderKey(k) == "Host" {
			return status.Error(codes.InvalidArgument, "invalid probe header")
		}
	}
	return nil
}
