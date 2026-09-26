package manager

import (
	"context"
	"fmt"
	"io"
	"net"
	"net/http"
	"net/http/httptest"
	"strconv"
	"strings"
	"sync/atomic"
	"testing"
	"time"

	api "github.com/loafman1120/TargetLib/api/TargetLib"
	"github.com/loafman1120/TargetLib/profile"
	"github.com/loafman1120/TargetLib/subscriptions"
	"github.com/sagernet/sing-box/daemon"
	"github.com/sagernet/sing-box/option"
	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/credentials/insecure"
	"google.golang.org/grpc/status"
	"google.golang.org/grpc/test/bufconn"
	"google.golang.org/protobuf/proto"
	"google.golang.org/protobuf/types/known/emptypb"
)

func smartTestManager(t *testing.T, store subscriptions.Store) *Manager {
	t.Helper()
	ctx := context.Background()
	if store == nil {
		store = &subscriptions.MemoryStore{}
	}
	node := profile.Node{ID: "n", Phase: profile.NodeReady, CountryCode: "JP", OutboundJSON: []byte(`{"type":"direct","tag":"n"}`), Outbound: &option.Outbound{Type: "direct", Tag: "n", Options: &option.DirectOutboundOptions{}}}
	if err := store.Update(ctx, func(tx subscriptions.StoreTx) error {
		for _, id := range []string{"a", "b"} {
			if err := tx.Put(subscriptions.Subscription{ID: id, Enabled: true, Profile: profile.Profile{Nodes: []profile.Node{node}}}); err != nil {
				return err
			}
		}
		return nil
	}); err != nil {
		t.Fatal(err)
	}
	sub := subscriptions.NewManager(subscriptions.Options{Store: store})
	if err := sub.Load(ctx); err != nil {
		t.Fatal(err)
	}
	smart, err := newRuntimeStateStore(ctx, store)
	if err != nil {
		t.Fatal(err)
	}
	m := &Manager{Handler: subscriptions.NewHandler(sub), subscriptions: sub, runtimeState: smart, runtimeConfig: defaultRuntimeConfig(), runtimeStore: runtimeConfigStore{store: store}, readStatus: func() (*daemon.ServiceStatus, error) {
		return &daemon.ServiceStatus{Status: daemon.ServiceStatus_IDLE}, nil
	}, checkConfig: func(context.Context, string) error { return nil }, applyConfig: func(string) error { return nil }}
	t.Cleanup(func() { smart.close(); sub.Close() })
	return m
}

// upsertProbePolicy creates a v14 service policy carrying a single probe and
// returns the stored probe definition.
func upsertProbePolicy(t *testing.T, m *Manager, serviceID, url, key string) *api.ServiceProbe {
	t.Helper()
	_, err := m.UpsertServicePolicy(context.Background(), &api.UpsertServicePolicyRequest{
		Policy: &api.ServicePolicy{
			ServiceId: serviceID,
			Domains:   []string{"service.example"},
			Probes:    []*api.ServiceProbe{{Url: url, TimeoutMilliseconds: 5000}},
		},
		IdempotencyKey: key,
	})
	if err != nil {
		t.Fatal(err)
	}
	p := findProbe(m.runtimeState.read(), serviceID)
	if p == nil {
		t.Fatal("probe not stored")
	}
	return p
}

func TestSmartProbeStagesAndRegions(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		switch r.URL.Path {
		case "/auth":
			w.WriteHeader(401)
		case "/http":
			w.WriteHeader(503)
		case "/redirect":
			w.Header().Set("Location", "/ok")
			w.WriteHeader(302)
		case "/slow":
			select {
			case <-r.Context().Done():
			case <-time.After(time.Second):
			}
		case "/geo":
			if r.Header.Get("Authorization") != "" {
				t.Error("credentials leaked to egress endpoint")
			}
			fmt.Fprint(w, `{"ip":"203.0.113.1","country":"US"}`)
		default:
			w.Header().Set("X-Country", "US")
			fmt.Fprint(w, "available")
		}
	}))
	defer server.Close()
	transport := &nodeProbeTransport{dial: (&net.Dialer{}).DialContext, close: func() error { return nil }}
	for _, tc := range []struct {
		name, path, body string
		countries        []string
		stage            api.ProbeStage
	}{
		{"ready", "/ok", "available", []string{"US"}, api.ProbeStage_PROBE_STAGE_READY},
		{"auth", "/auth", "", nil, api.ProbeStage_PROBE_STAGE_AUTH},
		{"http", "/http", "", nil, api.ProbeStage_PROBE_STAGE_HTTP},
		{"redirect", "/redirect", "", nil, api.ProbeStage_PROBE_STAGE_HTTP},
		{"content", "/ok", "missing", nil, api.ProbeStage_PROBE_STAGE_CONTENT},
		{"region", "/ok", "", []string{"JP"}, api.ProbeStage_PROBE_STAGE_REGION},
		{"timeout", "/slow", "", nil, api.ProbeStage_PROBE_STAGE_TIMEOUT},
	} {
		t.Run(tc.name, func(t *testing.T) {
			p := &api.ServiceProbe{Url: server.URL + tc.path, BodyContains: tc.body, AllowedCountries: tc.countries, EgressUrl: server.URL + "/geo", ServiceCountryHeader: "X-Country", TimeoutMilliseconds: 100}
			got := probeHTTP(context.Background(), p, transport, map[string]string{"Authorization": "Bearer transient"})
			if got.Stage != tc.stage {
				t.Fatalf("stage=%v want=%v (%s)", got.Stage, tc.stage, got.ErrorMessage)
			}
			if tc.name == "ready" && (got.ObservedCountry != "US" || got.ServiceCountry != "US" || got.EgressIp != "203.0.113.1") {
				t.Fatalf("bad regions: %v", got)
			}
		})
	}
}

func TestSmartProbeDNSAndTLSFailures(t *testing.T) {
	p := &api.ServiceProbe{Url: "http://invalid.example", TimeoutMilliseconds: 1000}
	transport := &nodeProbeTransport{dial: func(context.Context, string, string) (net.Conn, error) {
		return nil, &net.DNSError{Err: "lookup failed", Name: "secret.example"}
	}}
	result := probeHTTP(context.Background(), p, transport, nil)
	if result.Stage != api.ProbeStage_PROBE_STAGE_DNS || strings.Contains(result.ErrorMessage, "secret") {
		t.Fatalf("unexpected DNS result: %v", result)
	}
	server := httptest.NewTLSServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) { w.WriteHeader(204) }))
	defer server.Close()
	p.Url = server.URL
	result = probeHTTP(context.Background(), p, &nodeProbeTransport{dial: (&net.Dialer{}).DialContext}, nil)
	if result.Stage != api.ProbeStage_PROBE_STAGE_TLS {
		t.Fatalf("unexpected TLS result: %v", result)
	}
}

func TestSmartProbeUsesSelectedOutbound(t *testing.T) {
	var connects atomic.Int32
	upstream := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) { fmt.Fprint(w, "via node") }))
	defer upstream.Close()
	proxy := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.Method != http.MethodConnect || r.Host != "service.invalid:80" {
			t.Errorf("unexpected proxy request %s %s", r.Method, r.Host)
			w.WriteHeader(400)
			return
		}
		target, err := net.Dial("tcp", strings.TrimPrefix(upstream.URL, "http://"))
		if err != nil {
			t.Error(err)
			return
		}
		defer target.Close()
		conn, _, err := w.(http.Hijacker).Hijack()
		if err != nil {
			t.Error(err)
			return
		}
		defer conn.Close()
		connects.Add(1)
		fmt.Fprint(conn, "HTTP/1.1 200 Connection Established\r\n\r\n")
		done := make(chan struct{})
		go func() { io.Copy(target, conn); target.Close(); close(done) }()
		io.Copy(conn, target)
		conn.Close()
		<-done
	}))
	defer proxy.Close()
	host, portString, _ := net.SplitHostPort(strings.TrimPrefix(proxy.URL, "http://"))
	port, _ := strconv.Atoi(portString)
	node := profile.Node{ID: "isolated-node", Phase: profile.NodeReady, Outbound: &option.Outbound{Type: "http", Options: &option.HTTPOutboundOptions{ServerOptions: option.ServerOptions{Server: host, ServerPort: uint16(port)}}}}
	m := &Manager{}
	result := m.probeNode(context.Background(), &api.ServiceProbe{ServiceId: "service", Url: "http://service.invalid/", BodyContains: "via node", TimeoutMilliseconds: 2000, ValiditySeconds: 60}, node, "pool", nil, 1)
	if result.Stage != api.ProbeStage_PROBE_STAGE_READY || connects.Load() != 1 {
		t.Fatalf("probe did not use node: result=%v connects=%d", result, connects.Load())
	}
}

func TestSmartQualityPersistenceExpiryAndRanking(t *testing.T) {
	store := &subscriptions.MemoryStore{}
	m := smartTestManager(t, store)
	p := upsertProbePolicy(t, m, "svc", "https://service.example", "quality-persist")
	nodes := m.subscriptions.NodePool().Nodes
	now := time.Now().UnixMilli()
	for i, node := range nodes {
		if err := m.saveQuality(context.Background(), &api.ProbeResult{Id: node.ID, NodeId: node.ID, ServiceId: "svc", ProbeRevision: p.Revision, Stage: api.ProbeStage_PROBE_STAGE_READY, TestedAtUnixMs: now, ExpiresAtUnixMs: now + 60000, Attempts: 2, Successes: uint32(2 - i), LatencyMilliseconds: uint32(100 + i*200)}); err != nil {
			t.Fatal(err)
		}
	}
	before := proto.Clone(m.runtimeConfig)
	evaluation, err := m.evaluateService(context.Background(), &api.EvaluateServiceRequest{ServiceId: "svc"})
	if err != nil {
		t.Fatal(err)
	}
	if len(evaluation.Candidates) != 2 || evaluation.Candidates[0].NodeId != nodes[0].ID || !evaluation.Candidates[0].Eligible || evaluation.Candidates[0].Score <= evaluation.Candidates[1].Score {
		t.Fatalf("unexpected ranking: %v", evaluation)
	}
	if !proto.Equal(before, m.runtimeConfig) {
		t.Fatal("evaluation changed runtime")
	}
	restored, err := newRuntimeStateStore(context.Background(), store)
	if err != nil {
		t.Fatal(err)
	}
	defer restored.close()
	if !proto.Equal(restored.read(), m.runtimeState.read()) {
		t.Fatal("history not restored")
	}
	if got := qualityReason(restored.read(), "svc", nodes[0].ID, now+60001); got != "quality_expired" {
		t.Fatal(got)
	}
	staleRevision := m.runtimeState.read().Revision
	upsertProbePolicy(t, m, "svc", "https://changed.example", "quality-update")
	updated := findProbe(m.runtimeState.read(), "svc")
	if updated.Revision == p.Revision {
		t.Fatal("definition revision unchanged")
	}
	if got := qualityReason(m.runtimeState.read(), "svc", nodes[0].ID, now); got != "probe_definition_changed" {
		t.Fatal(got)
	}
	if _, err := m.UpsertServicePolicy(context.Background(), &api.UpsertServicePolicyRequest{
		Policy: &api.ServicePolicy{
			ServiceId: "svc",
			Domains:   []string{"service.example"},
			Probes:    []*api.ServiceProbe{{Url: "https://stale.example"}},
		},
		ExpectedRevision: staleRevision,
		IdempotencyKey:   "quality-stale",
	}); status.Code(err) != codes.Aborted {
		t.Fatalf("stale definition accepted: %v", err)
	}
}

func TestSmartQualityFailureDoesNotCommitOrPublish(t *testing.T) {
	store := &failingMetadataStore{MemoryStore: &subscriptions.MemoryStore{}}
	m := smartTestManager(t, store)
	before := m.runtimeState.read()
	store.fail = true
	if _, err := m.UpsertServicePolicy(context.Background(), &api.UpsertServicePolicyRequest{
		Policy: &api.ServicePolicy{
			ServiceId: "svc",
			Probes:    []*api.ServiceProbe{{Url: "https://service.example"}},
		},
		IdempotencyKey: "failing-save",
	}); err == nil {
		t.Fatal("save succeeded")
	}
	if !proto.Equal(before, m.runtimeState.read()) || m.runtimeState.sequence != 0 {
		t.Fatal("failed save changed state or published an event")
	}
}

func TestSmartGRPCProbeHistoryAndEvents(t *testing.T) {
	m := smartTestManager(t, nil)
	endpoint := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) { w.WriteHeader(204) }))
	defer endpoint.Close()
	m.probeTransport = func(context.Context, profile.Node) (*nodeProbeTransport, error) {
		return &nodeProbeTransport{dial: (&net.Dialer{}).DialContext, close: func() error { return nil }}, nil
	}
	listener := bufconn.Listen(1 << 20)
	server := grpc.NewServer()
	api.RegisterTargetLibServer(server, m)
	go server.Serve(listener)
	defer server.Stop()
	conn, err := grpc.NewClient("passthrough:///smart", grpc.WithTransportCredentials(insecure.NewCredentials()), grpc.WithContextDialer(func(context.Context, string) (net.Conn, error) { return listener.Dial() }))
	if err != nil {
		t.Fatal(err)
	}
	defer conn.Close()
	client := api.NewTargetLibClient(conn)
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	events, err := client.SubscribeRuntimeEvents(ctx, &emptypb.Empty{})
	if err != nil {
		t.Fatal(err)
	}
	initial, err := events.Recv()
	if err != nil || initial.GetType() != api.RuntimeEventType_RUNTIME_EVENT_TYPE_SNAPSHOT {
		t.Fatalf("missing snapshot: %v %v", initial, err)
	}
	if _, err = m.UpsertServicePolicy(ctx, &api.UpsertServicePolicyRequest{
		Policy: &api.ServicePolicy{
			ServiceId: "svc",
			Domains:   []string{"service.example"},
			Probes:    []*api.ServiceProbe{{Url: endpoint.URL}},
		},
		IdempotencyKey: "grpc-probe-events",
	}); err != nil {
		t.Fatal(err)
	}
	seen := 0
	sequence := initial.Sequence
	for seen < 1 {
		event, err := events.Recv()
		if err != nil {
			t.Fatal(err)
		}
		if event.Sequence <= sequence {
			t.Fatal("event order regressed")
		}
		sequence = event.Sequence
		if event.Type == api.RuntimeEventType_RUNTIME_EVENT_TYPE_SNAPSHOT {
			seen++
		}
	}
}

func TestSmartEventsDisconnectSlowConsumer(t *testing.T) {
	m := smartTestManager(t, nil)
	ch := make(chan *api.RuntimeEvent, 1)
	m.runtimeState.subscribers[ch] = struct{}{}
	m.publishRuntime(&api.RuntimeEvent{Type: api.RuntimeEventType_RUNTIME_EVENT_TYPE_CONFIG})
	m.publishRuntime(&api.RuntimeEvent{Type: api.RuntimeEventType_RUNTIME_EVENT_TYPE_CONFIG})
	<-ch
	if _, ok := <-ch; ok {
		t.Fatal("slow subscriber remained open")
	}
	if len(m.runtimeState.subscribers) != 0 {
		t.Fatal("slow subscriber leaked")
	}
}

func TestSmartBindingExpiryAndPoolRemovalDoNotSwitch(t *testing.T) {
	m := smartTestManager(t, nil)
	node := m.subscriptions.NodePool().Nodes[0]
	m.runtimeConfig.ServiceBindings = []*api.ServiceBinding{{ServiceId: "svc", SelectorTag: "svc-out", NodeId: node.ID, ExpiresAtUnixMs: time.Now().Add(-time.Minute).UnixMilli()}}
	before := proto.Clone(m.runtimeConfig)
	state, err := m.GetRuntimeState(context.Background(), &emptypb.Empty{})
	if err != nil {
		t.Fatal(err)
	}
	if got := state.ServiceBindings[0]; !got.NeedsEvaluation || got.EvaluationReason != "binding_expired" {
		t.Fatalf("unexpected binding %v", got)
	}
	if err := m.subscriptions.Remove(context.Background(), node.SubscriptionID); err != nil {
		t.Fatal(err)
	}
	state, err = m.GetRuntimeState(context.Background(), &emptypb.Empty{})
	if err != nil {
		t.Fatal(err)
	}
	if got := state.ServiceBindings[0]; got.NodeAvailable || got.EvaluationReason != "node_unavailable" {
		t.Fatalf("unexpected binding %v", got)
	}
	if !proto.Equal(before, m.runtimeConfig) {
		t.Fatal("expiry or removal switched binding")
	}
}

func TestSmartApplyPersistenceFailureRestoresRuntime(t *testing.T) {
	store := &failingMetadataStore{MemoryStore: &subscriptions.MemoryStore{}}
	m := smartTestManager(t, store)
	m.config = "old-config"
	m.runtimeConfig.Revision = "old-revision"
	m.readStatus = func() (*daemon.ServiceStatus, error) {
		return &daemon.ServiceStatus{Status: daemon.ServiceStatus_STARTED}, nil
	}
	var applied []string
	m.applyConfig = func(content string) error { applied = append(applied, content); return nil }
	next := cloneRuntimeConfig(m.runtimeConfig)
	next.Settings.RouteMode = api.RouteMode_ROUTE_MODE_ALL
	store.fail = true
	_, err := m.applyDesired(context.Background(), next)
	if err == nil || len(applied) != 2 || applied[1] != "old-config" || m.runtimeConfig.Revision != "old-revision" || m.applyState.Phase != api.ConfigApplyPhase_CONFIG_APPLY_PHASE_FAILED {
		t.Fatalf("rollback failed: %v %v %v", err, applied, m.applyState.Phase)
	}
}

func TestSmartPacketLossUsesEchoAcknowledgements(t *testing.T) {
	listener, err := net.ListenPacket("udp", "127.0.0.1:0")
	if err != nil {
		t.Fatal(err)
	}
	defer listener.Close()
	done := make(chan struct{})
	go func() {
		defer close(done)
		buffer := make([]byte, 2048)
		count := 0
		for {
			n, addr, err := listener.ReadFrom(buffer)
			if err != nil {
				return
			}
			count++
			if count%2 == 1 {
				listener.WriteTo(buffer[:n], addr)
			}
		}
	}()
	p := &api.ServiceProbe{UdpEchoAddress: listener.LocalAddr().String(), PacketCount: 4, PacketTimeoutMilliseconds: 50}
	result := new(api.ProbeResult)
	probePackets(context.Background(), p, &nodeProbeTransport{dial: (&net.Dialer{}).DialContext}, result)
	listener.Close()
	<-done
	if !result.PacketLossAvailable || result.PacketsSent != 4 || result.PacketsReceived != 2 || result.PacketLossRatio != 0.5 {
		t.Fatalf("unexpected packet loss: %v", result)
	}
}

func TestSmartValidationRejectsInvalidInputs(t *testing.T) {
	nan := 0.0
	nan = nan / nan
	for _, p := range []*api.ServiceProbe{
		nil, {ServiceId: "svc"}, {ServiceId: "svc", Url: "https://user:secret@example.com"},
		{ServiceId: "svc", Url: "https://example.com", AllowedCountries: []string{"US"}},
		{ServiceId: "svc", Url: "https://example.com", UdpEchoAddress: "224.0.0.1:7"},
		{ServiceId: "svc", Url: "https://example.com", UdpEchoAddress: "127.0.0.1:7", MaximumPacketLoss: &nan},
		{ServiceId: "svc", Url: "https://example.com", ServiceCountryHeader: "bad\r\nheader"},
	} {
		if _, err := validateProbe(p); status.Code(err) != codes.InvalidArgument {
			t.Fatalf("accepted invalid probe: %v (%v)", p, err)
		}
	}
}

func TestSmartHistoryRetentionAndOldRevisionCompletion(t *testing.T) {
	m := smartTestManager(t, nil)
	p := upsertProbePolicy(t, m, "svc", "https://service.example", "history-retention")
	for i := 0; i < 40; i++ {
		if err := m.saveQuality(context.Background(), &api.ProbeResult{Id: strconv.Itoa(i), ServiceId: "svc", NodeId: "n", ProbeRevision: p.Revision, TestedAtUnixMs: int64(i), ExpiresAtUnixMs: 10000, Stage: api.ProbeStage_PROBE_STAGE_READY}); err != nil {
			t.Fatal(err)
		}
	}
	if len(m.runtimeState.read().Results) != 32 {
		t.Fatal("per-node retention not enforced")
	}
	m.saveQuality(context.Background(), &api.ProbeResult{Id: "old-definition", ServiceId: "svc", NodeId: "n", ProbeRevision: "old", TestedAtUnixMs: 100, ExpiresAtUnixMs: 10000, Stage: api.ProbeStage_PROBE_STAGE_HTTP})
	if got := qualityReason(m.runtimeState.read(), "svc", "n", 101); got != "" {
		t.Fatalf("late old definition replaced current result: %s", got)
	}
}

func TestProbeRemoval(t *testing.T) {
	m := smartTestManager(t, nil)
	upsertProbePolicy(t, m, "svc", "https://service.example", "removal-create")
	stale := m.runtimeState.read().Revision
	upsertProbePolicy(t, m, "svc", "https://changed.example", "removal-update")
	if _, err := m.DeleteServicePolicy(context.Background(), &api.DeleteServicePolicyRequest{ServiceId: "svc", ExpectedRevision: stale, IdempotencyKey: "removal-stale"}); status.Code(err) != codes.Aborted {
		t.Fatal(err)
	}
	if _, err := m.DeleteServicePolicy(context.Background(), &api.DeleteServicePolicyRequest{ServiceId: "svc", IdempotencyKey: "removal-delete"}); err != nil {
		t.Fatal(err)
	}
	if got := qualityReason(m.runtimeState.read(), "svc", "node", time.Now().UnixMilli()); got != "probe_not_configured" {
		t.Fatal(got)
	}
}

func TestSmartPoolChangePublishesWithoutApplying(t *testing.T) {
	m := smartTestManager(t, nil)
	ch := make(chan *api.RuntimeEvent, 64)
	m.runtimeState.subscribers[ch] = struct{}{}
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()
	m.watchRuntimeState(ctx)
	before := proto.Clone(m.runtimeConfig)
	if err := m.subscriptions.Remove(ctx, "a"); err != nil {
		t.Fatal(err)
	}
	timeout := time.NewTimer(2 * time.Second)
	defer timeout.Stop()
	for {
		select {
		case event := <-ch:
			if event.Type == api.RuntimeEventType_RUNTIME_EVENT_TYPE_NODE_POOL {
				if event.State.NodePoolRevision != m.subscriptions.NodePool().Revision {
					t.Fatal("published stale pool")
				}
				if !proto.Equal(before, m.runtimeConfig) {
					t.Fatal("pool change applied runtime")
				}
				return
			}
		case <-timeout.C:
			t.Fatal("missing pool change event")
		}
	}
}


