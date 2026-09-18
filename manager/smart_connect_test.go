package manager

import (
	"context"
	"errors"
	"fmt"
	"io"
	"net"
	"net/http"
	"net/http/httptest"
	"strconv"
	"strings"
	"sync"
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
	smart, err := newSmartConnect(ctx, store)
	if err != nil {
		t.Fatal(err)
	}
	m := &Manager{Handler: subscriptions.NewHandler(sub), subscriptions: sub, smart: smart, runtimeConfig: defaultRuntimeConfig(), runtimeStore: runtimeConfigStore{store: store}, readStatus: func() (*daemon.ServiceStatus, error) {
		return &daemon.ServiceStatus{Status: daemon.ServiceStatus_IDLE}, nil
	}, checkConfig: func(context.Context, string) error { return nil }, applyConfig: func(string) error { return nil }}
	t.Cleanup(func() { smart.close(); sub.Close() })
	return m
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
	p, err := m.PutServiceProbe(context.Background(), &api.ServiceProbe{ServiceId: "svc", Url: "https://service.example"})
	if err != nil {
		t.Fatal(err)
	}
	nodes := m.subscriptions.NodePool().Nodes
	now := time.Now().UnixMilli()
	for i, node := range nodes {
		if err := m.saveQuality(context.Background(), &api.ProbeResult{Id: node.ID, NodeId: node.ID, ServiceId: "svc", ProbeRevision: p.Revision, Stage: api.ProbeStage_PROBE_STAGE_READY, TestedAtUnixMs: now, ExpiresAtUnixMs: now + 60000, Attempts: 2, Successes: uint32(2 - i), LatencyMilliseconds: uint32(100 + i*200)}); err != nil {
			t.Fatal(err)
		}
	}
	before := proto.Clone(m.runtimeConfig)
	evaluation, err := m.EvaluateService(context.Background(), &api.EvaluateServiceRequest{ServiceId: "svc"})
	if err != nil {
		t.Fatal(err)
	}
	if len(evaluation.Candidates) != 2 || evaluation.Candidates[0].NodeId != nodes[0].ID || !evaluation.Candidates[0].Eligible || evaluation.Candidates[0].Score <= evaluation.Candidates[1].Score {
		t.Fatalf("unexpected ranking: %v", evaluation)
	}
	if !proto.Equal(before, m.runtimeConfig) {
		t.Fatal("evaluation changed runtime")
	}
	restored, err := newSmartConnect(context.Background(), store)
	if err != nil {
		t.Fatal(err)
	}
	defer restored.close()
	if !proto.Equal(restored.read(), m.smart.read()) {
		t.Fatal("history not restored")
	}
	if got := qualityReason(restored.read(), "svc", nodes[0].ID, now+60001); got != "quality_expired" {
		t.Fatal(got)
	}
	p.Url = "https://changed.example"
	updated, err := m.PutServiceProbe(context.Background(), p)
	if err != nil {
		t.Fatal(err)
	}
	if updated.Revision == p.Revision {
		t.Fatal("definition revision unchanged")
	}
	if got := qualityReason(m.smart.read(), "svc", nodes[0].ID, now); got != "probe_definition_changed" {
		t.Fatal(got)
	}
	if _, err := m.PutServiceProbe(context.Background(), p); status.Code(err) != codes.Aborted {
		t.Fatalf("stale definition accepted: %v", err)
	}
}

func TestSmartQualityFailureDoesNotCommitOrPublish(t *testing.T) {
	store := &failingMetadataStore{MemoryStore: &subscriptions.MemoryStore{}}
	m := smartTestManager(t, store)
	before := m.smart.read()
	store.fail = true
	if _, err := m.PutServiceProbe(context.Background(), &api.ServiceProbe{ServiceId: "svc", Url: "https://service.example"}); err == nil {
		t.Fatal("save succeeded")
	}
	if !proto.Equal(before, m.smart.read()) || m.smart.sequence != 0 {
		t.Fatal("failed save changed state or published an event")
	}
}

type probeTestStream struct {
	grpc.ServerStream
	ctx  context.Context
	send func(*api.ProbeResult) error
}

func (s probeTestStream) Context() context.Context      { return s.ctx }
func (s probeTestStream) Send(r *api.ProbeResult) error { return s.send(r) }

func TestSmartProbeCancellationAndGlobalConcurrency(t *testing.T) {
	m := smartTestManager(t, nil)
	_, err := m.PutServiceProbe(context.Background(), &api.ServiceProbe{ServiceId: "svc", Url: "http://service.example", TimeoutMilliseconds: 5000})
	if err != nil {
		t.Fatal(err)
	}
	var active, maxActive atomic.Int32
	entered := make(chan struct{}, 32)
	m.probeTransport = func(context.Context, profile.Node) (*nodeProbeTransport, error) {
		return &nodeProbeTransport{dial: func(ctx context.Context, _, _ string) (net.Conn, error) {
			n := active.Add(1)
			defer active.Add(-1)
			for old := maxActive.Load(); n > old; old = maxActive.Load() {
				if maxActive.CompareAndSwap(old, n) {
					break
				}
			}
			entered <- struct{}{}
			<-ctx.Done()
			return nil, ctx.Err()
		}, close: func() error { return nil }}, nil
	}
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()
	var wg sync.WaitGroup
	for i := 0; i < 4; i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			err := m.ProbeService(&api.ProbeServiceRequest{ServiceId: "svc"}, probeTestStream{ctx: ctx, send: func(*api.ProbeResult) error { return nil }})
			if status.Code(err) != codes.Canceled {
				t.Errorf("unexpected cancellation: %v", err)
			}
		}()
	}
	for i := 0; i < 4; i++ {
		select {
		case <-entered:
		case <-time.After(3 * time.Second):
			t.Fatal("probes did not start")
		}
	}
	cancel()
	wg.Wait()
	if maxActive.Load() > 4 || active.Load() != 0 {
		t.Fatalf("workers leaked or exceeded limit: max=%d active=%d", maxActive.Load(), active.Load())
	}
	if len(m.smart.read().Results) != 0 {
		t.Fatal("canceled probes saved as failures")
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
	_, err = client.PutServiceProbe(ctx, &api.ServiceProbe{ServiceId: "svc", Url: endpoint.URL})
	if err != nil {
		t.Fatal(err)
	}
	stream, err := client.ProbeService(ctx, &api.ProbeServiceRequest{ServiceId: "svc", Attempts: 2})
	if err != nil {
		t.Fatal(err)
	}
	count := 0
	for {
		r, err := stream.Recv()
		if errors.Is(err, io.EOF) {
			break
		}
		if err != nil {
			t.Fatal(err)
		}
		count++
		if r.Stage != api.ProbeStage_PROBE_STAGE_READY || r.Successes != 2 {
			t.Fatalf("bad result %v", r)
		}
	}
	history, err := client.GetQualityHistory(ctx, &api.QualityHistoryRequest{ServiceId: "svc"})
	if err != nil || len(history.GetResults()) != count || count != 2 {
		t.Fatalf("history mismatch %v %v", history, err)
	}
	seen := 0
	sequence := initial.Sequence
	for seen < 2 {
		event, err := events.Recv()
		if err != nil {
			t.Fatal(err)
		}
		if event.Sequence <= sequence {
			t.Fatal("event order regressed")
		}
		sequence = event.Sequence
		if event.Type == api.RuntimeEventType_RUNTIME_EVENT_TYPE_PROBE_COMPLETED {
			seen++
		}
	}
}

func TestSmartEventsDisconnectSlowConsumer(t *testing.T) {
	m := smartTestManager(t, nil)
	ch := make(chan *api.RuntimeEvent, 1)
	m.smart.subscribers[ch] = struct{}{}
	m.publishRuntime(&api.RuntimeEvent{Type: api.RuntimeEventType_RUNTIME_EVENT_TYPE_CONFIG})
	m.publishRuntime(&api.RuntimeEvent{Type: api.RuntimeEventType_RUNTIME_EVENT_TYPE_CONFIG})
	<-ch
	if _, ok := <-ch; ok {
		t.Fatal("slow subscriber remained open")
	}
	if len(m.smart.subscribers) != 0 {
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

func TestSmartPolicyImportIsAtomicAndDeviceLocal(t *testing.T) {
	m := smartTestManager(t, nil)
	p, err := m.PutServiceProbe(context.Background(), &api.ServiceProbe{ServiceId: "local", Url: "https://local.example"})
	if err != nil {
		t.Fatal(err)
	}
	exported, err := m.ExportSmartConnectPolicy(context.Background(), &emptypb.Empty{})
	if err != nil {
		t.Fatal(err)
	}
	original := proto.Clone(m.runtimeConfig)
	imported, err := m.ImportSmartConnectPolicy(context.Background(), &api.ImportSmartConnectPolicyRequest{ExpectedRevision: exported.Revision, Policy: exported})
	if err != nil {
		t.Fatal(err)
	}
	if imported.Probes[0].Revision != p.Revision {
		t.Fatal("equivalent policy invalidated local quality")
	}
	exported.Probes[0].Url = "https://remote.example"
	exported.Probes[0].Revision = "foreign-revision"
	updated, err := m.ImportSmartConnectPolicy(context.Background(), &api.ImportSmartConnectPolicyRequest{ExpectedRevision: imported.Revision, Policy: exported})
	if err != nil {
		t.Fatal(err)
	}
	if updated.Probes[0].Revision == "foreign-revision" || updated.Probes[0].Revision == p.Revision {
		t.Fatal("foreign policy did not receive a local revision")
	}
	if !proto.Equal(original, m.runtimeConfig) {
		t.Fatal("policy import changed runtime binding")
	}
	if _, err := m.ImportSmartConnectPolicy(context.Background(), &api.ImportSmartConnectPolicyRequest{ExpectedRevision: imported.Revision, Policy: exported}); status.Code(err) != codes.Aborted {
		t.Fatalf("stale policy accepted: %v", err)
	}
	before := m.smart.read()
	bad := &api.SmartConnectPolicy{SchemaVersion: 1, Probes: []*api.ServiceProbe{{ServiceId: "valid", Url: "https://valid.example"}, {ServiceId: "bad", Url: "file:///bad"}}}
	if _, err := m.ImportSmartConnectPolicy(context.Background(), &api.ImportSmartConnectPolicyRequest{ExpectedRevision: updated.Revision, Policy: bad}); status.Code(err) != codes.InvalidArgument {
		t.Fatal(err)
	}
	if !proto.Equal(before, m.smart.read()) {
		t.Fatal("invalid import partially committed")
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
	p, err := m.PutServiceProbe(context.Background(), &api.ServiceProbe{ServiceId: "svc", Url: "https://service.example"})
	if err != nil {
		t.Fatal(err)
	}
	for i := 0; i < 40; i++ {
		if err := m.saveQuality(context.Background(), &api.ProbeResult{Id: strconv.Itoa(i), ServiceId: "svc", NodeId: "n", ProbeRevision: p.Revision, TestedAtUnixMs: int64(i), ExpiresAtUnixMs: 10000, Stage: api.ProbeStage_PROBE_STAGE_READY}); err != nil {
			t.Fatal(err)
		}
	}
	if len(m.smart.read().Results) != 32 {
		t.Fatal("per-node retention not enforced")
	}
	m.saveQuality(context.Background(), &api.ProbeResult{Id: "old-definition", ServiceId: "svc", NodeId: "n", ProbeRevision: "old", TestedAtUnixMs: 100, ExpiresAtUnixMs: 10000, Stage: api.ProbeStage_PROBE_STAGE_HTTP})
	if got := qualityReason(m.smart.read(), "svc", "n", 101); got != "" {
		t.Fatalf("late old definition replaced current result: %s", got)
	}
}

func TestSmartDiagnosticsAndProbeRemoval(t *testing.T) {
	m := smartTestManager(t, nil)
	p, err := m.PutServiceProbe(context.Background(), &api.ServiceProbe{ServiceId: "svc", Url: "https://service.example"})
	if err != nil {
		t.Fatal(err)
	}
	report, err := m.GetSmartConnectDiagnostics(context.Background(), &api.EvaluateServiceRequest{})
	if err != nil {
		t.Fatal(err)
	}
	if len(report.Evaluations) != 1 || report.Evaluations[0].ProbeRevision != p.Revision || len(report.Evaluations[0].Candidates) != 2 || report.PolicyRevision == "" {
		t.Fatalf("bad report %v", report)
	}
	if _, err := m.RemoveServiceProbe(context.Background(), &api.RemoveServiceProbeRequest{ServiceId: p.ServiceId, ExpectedRevision: "stale"}); status.Code(err) != codes.Aborted {
		t.Fatal(err)
	}
	if _, err := m.RemoveServiceProbe(context.Background(), &api.RemoveServiceProbeRequest{ServiceId: p.ServiceId, ExpectedRevision: p.Revision}); err != nil {
		t.Fatal(err)
	}
	if got := qualityReason(m.smart.read(), p.ServiceId, "node", time.Now().UnixMilli()); got != "probe_not_configured" {
		t.Fatal(got)
	}
	if _, err := m.EvaluateService(context.Background(), &api.EvaluateServiceRequest{ServiceId: p.ServiceId}); status.Code(err) != codes.NotFound {
		t.Fatal(err)
	}
}

func TestSmartPoolChangePublishesWithoutApplying(t *testing.T) {
	m := smartTestManager(t, nil)
	ch := make(chan *api.RuntimeEvent, 64)
	m.smart.subscribers[ch] = struct{}{}
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()
	m.watchSmartConnect(ctx)
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

func TestSmartCloseCancelsActiveProbes(t *testing.T) {
	m := smartTestManager(t, nil)
	_, err := m.PutServiceProbe(context.Background(), &api.ServiceProbe{ServiceId: "svc", Url: "http://service.example"})
	if err != nil {
		t.Fatal(err)
	}
	entered := make(chan struct{}, 2)
	m.probeTransport = func(context.Context, profile.Node) (*nodeProbeTransport, error) {
		return &nodeProbeTransport{dial: func(ctx context.Context, _, _ string) (net.Conn, error) {
			entered <- struct{}{}
			<-ctx.Done()
			return nil, ctx.Err()
		}, close: func() error { return nil }}, nil
	}
	done := make(chan error, 1)
	go func() {
		done <- m.ProbeService(&api.ProbeServiceRequest{ServiceId: "svc"}, probeTestStream{ctx: context.Background(), send: func(*api.ProbeResult) error { return nil }})
	}()
	select {
	case <-entered:
	case <-time.After(time.Second):
		t.Fatal("probe not started")
	}
	closed := make(chan struct{})
	go func() { m.smart.close(); close(closed) }()
	select {
	case <-closed:
	case <-time.After(time.Second):
		t.Fatal("close did not cancel active probes")
	}
	if err := <-done; status.Code(err) != codes.Canceled {
		t.Fatal(err)
	}
}
