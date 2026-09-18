package manager

import (
	"context"
	"crypto/tls"
	"encoding/json"
	"errors"
	"io"
	"net"
	"net/http"
	"net/http/httptrace"
	"net/netip"
	"sort"
	"strings"
	"sync"
	"time"

	"github.com/google/uuid"
	api "github.com/loafman1120/TargetLib/api/TargetLib"
	"github.com/loafman1120/TargetLib/config"
	"github.com/loafman1120/TargetLib/profile"
	box "github.com/sagernet/sing-box"
	"github.com/sagernet/sing-box/option"
	singjson "github.com/sagernet/sing/common/json"
	M "github.com/sagernet/sing/common/metadata"
	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

type nodeProbeTransport struct {
	dial  func(context.Context, string, string) (net.Conn, error)
	close func() error
}

func (m *Manager) openProbeTransport(ctx context.Context, node profile.Node) (*nodeProbeTransport, error) {
	if m.probeTransport != nil {
		return m.probeTransport(ctx, node)
	}
	settings := config.Settings{ProbeOnly: true, ListenAddress: "127.0.0.1", MixedPort: 1, ProxyMode: config.ProxyModeMixed, RouteMode: config.RouteModeAll}
	content, err := config.Build(settings, profile.Profile{Nodes: []profile.Node{node}})
	if err != nil {
		return nil, err
	}
	options, err := singjson.UnmarshalExtendedContext[option.Options](profile.Context(), content)
	if err != nil {
		return nil, err
	}
	if m.probeContext != nil {
		ctx = m.probeContext(ctx)
	} else {
		ctx = serviceContext(ctx, Options{})
	}
	instance, err := box.New(box.Options{Options: options, Context: ctx})
	if err != nil {
		return nil, err
	}
	if err := instance.Start(); err != nil {
		_ = instance.Close()
		return nil, err
	}
	outbound, ok := instance.Outbound().Outbound(node.ID)
	if !ok {
		_ = instance.Close()
		return nil, status.Error(codes.NotFound, "probe outbound missing")
	}
	return &nodeProbeTransport{dial: func(ctx context.Context, network, address string) (net.Conn, error) {
		return outbound.DialContext(ctx, network, M.ParseSocksaddr(address))
	}, close: instance.Close}, nil
}

func (m *Manager) ProbeService(request *api.ProbeServiceRequest, stream grpc.ServerStreamingServer[api.ProbeResult]) error {
	if request.GetServiceId() == "" {
		return status.Error(codes.InvalidArgument, "service ID is required")
	}
	if err := validateProbeHeaders(request.Headers); err != nil {
		return err
	}
	if request.Attempts > 5 || request.MaxConcurrency > 4 || len(request.NodeIds) > 256 {
		return status.Error(codes.InvalidArgument, "probe limits: 5 attempts, 4 workers, 256 nodes")
	}
	p := findProbe(m.smart.read(), request.ServiceId)
	if p == nil {
		return status.Error(codes.NotFound, "service probe not found")
	}
	pool := m.subscriptions.NodePool()
	byID := make(map[string]profile.Node)
	for _, n := range pool.Nodes {
		byID[n.ID] = n
	}
	ids := append([]string(nil), request.NodeIds...)
	if len(ids) == 0 {
		for _, n := range pool.Nodes {
			if n.Outbound != nil && n.Phase != profile.NodeFailed {
				ids = append(ids, n.ID)
			}
		}
	}
	if len(ids) > 256 {
		return status.Error(codes.ResourceExhausted, "select at most 256 nodes per probe request")
	}
	seen := make(map[string]bool)
	for _, id := range ids {
		if seen[id] {
			return status.Error(codes.InvalidArgument, "duplicate node ID")
		}
		seen[id] = true
		if _, ok := byID[id]; !ok {
			return status.Error(codes.NotFound, "probe node not found")
		}
	}
	sort.Strings(ids)
	attempts := request.Attempts
	if attempts == 0 {
		attempts = 1
	}
	concurrency := int(request.MaxConcurrency)
	if concurrency == 0 {
		concurrency = 4
	}
	ctx, cancel := context.WithCancel(stream.Context())
	defer cancel()
	s := m.smart
	s.mu.Lock()
	if s.closed {
		s.mu.Unlock()
		return status.Error(codes.Unavailable, "manager is closed")
	}
	s.workers.Add(1)
	s.mu.Unlock()
	go func() {
		select {
		case <-s.done:
			cancel()
		case <-ctx.Done():
		}
	}()
	jobs := make(chan string, len(ids))
	for _, id := range ids {
		jobs <- id
	}
	close(jobs)
	type outcome struct {
		result *api.ProbeResult
		err    error
	}
	results := make(chan outcome, concurrency)
	var workers sync.WaitGroup
	for i := 0; i < concurrency; i++ {
		workers.Add(1)
		go func() {
			defer workers.Done()
			for id := range jobs {
				select {
				case s.slots <- struct{}{}:
				case <-ctx.Done():
					return
				}
				if ctx.Err() != nil {
					<-s.slots
					return
				}
				m.publishRuntime(&api.RuntimeEvent{Type: api.RuntimeEventType_RUNTIME_EVENT_TYPE_PROBE_STARTED, ServiceId: p.ServiceId, NodeId: id})
				result := m.probeNode(ctx, p, byID[id], pool.Revision, request.Headers, attempts)
				<-s.slots
				if ctx.Err() != nil {
					return
				}
				err := m.saveQuality(ctx, result)
				if err == nil {
					m.publishRuntime(&api.RuntimeEvent{Type: api.RuntimeEventType_RUNTIME_EVENT_TYPE_PROBE_COMPLETED, Probe: result, ServiceId: p.ServiceId, NodeId: id})
				}
				select {
				case results <- outcome{result, err}:
				case <-ctx.Done():
					return
				}
			}
		}()
	}
	finished := make(chan struct{})
	go func() { workers.Wait(); s.workers.Done(); close(results); close(finished) }()
	defer func() { cancel(); <-finished }()
	for {
		select {
		case <-ctx.Done():
			return status.FromContextError(ctx.Err()).Err()
		case item, ok := <-results:
			if !ok {
				return nil
			}
			if item.err != nil {
				return item.err
			}
			if err := stream.Send(item.result); err != nil {
				return err
			}
		}
	}
}

func (m *Manager) probeNode(ctx context.Context, p *api.ServiceProbe, node profile.Node, poolRevision string, headers map[string]string, attempts uint32) *api.ProbeResult {
	result := &api.ProbeResult{Id: uuid.NewString(), ServiceId: p.ServiceId, NodeId: node.ID, NodePoolRevision: poolRevision, ProbeRevision: p.Revision, DeclaredCountry: node.CountryCode, Attempts: attempts}
	// One bounded runtime lifetime includes startup and every service/egress attempt.
	ctx, cancel := context.WithTimeout(ctx, time.Duration(p.TimeoutMilliseconds)*time.Millisecond*time.Duration(attempts)*2+time.Duration(p.PacketCount+1)*time.Duration(p.PacketTimeoutMilliseconds)*time.Millisecond)
	defer cancel()
	transport, err := m.openProbeTransport(ctx, node)
	if err != nil {
		result.Stage = api.ProbeStage_PROBE_STAGE_NODE
		result.ErrorMessage = "cannot initialize node transport"
		if ctx.Err() != nil {
			result.Stage = api.ProbeStage_PROBE_STAGE_TIMEOUT
			result.ErrorMessage = "node initialization timed out"
		}
		result.FailureRatio = 1
	} else {
		defer transport.close()
		var latencies []uint32
		for i := uint32(0); i < attempts; i++ {
			sample := probeHTTP(ctx, p, transport, headers)
			result.Stage, result.ErrorMessage = sample.Stage, sample.ErrorMessage
			result.HttpStatus = sample.HttpStatus
			result.ObservedCountry, result.ServiceCountry, result.EgressIp = sample.ObservedCountry, sample.ServiceCountry, sample.EgressIp
			if sample.Stage == api.ProbeStage_PROBE_STAGE_READY {
				result.Successes++
				latencies = append(latencies, sample.LatencyMilliseconds)
			}
		}
		var sum uint64
		var min, max uint32
		for i, v := range latencies {
			sum += uint64(v)
			if i == 0 || v < min {
				min = v
			}
			if v > max {
				max = v
			}
		}
		if len(latencies) > 0 {
			result.LatencyMilliseconds = uint32(sum / uint64(len(latencies)))
			result.JitterMilliseconds = max - min
		}
		result.FailureRatio = 1 - float64(result.Successes)/float64(attempts)
		probePackets(ctx, p, transport, result)
	}
	result.TestedAtUnixMs = time.Now().UnixMilli()
	result.ExpiresAtUnixMs = result.TestedAtUnixMs + int64(p.ValiditySeconds)*1000
	return result
}

func probeHTTP(ctx context.Context, p *api.ServiceProbe, transport *nodeProbeTransport, headers map[string]string) *api.ProbeResult {
	r := &api.ProbeResult{Stage: api.ProbeStage_PROBE_STAGE_READY}
	ctx, cancel := context.WithTimeout(ctx, time.Duration(p.TimeoutMilliseconds)*time.Millisecond)
	defer cancel()
	var dialMu sync.Mutex
	var dialWorkers sync.WaitGroup
	dialClosed := false
	clientTransport := &http.Transport{DisableKeepAlives: true, TLSHandshakeTimeout: time.Duration(p.TimeoutMilliseconds) * time.Millisecond, ResponseHeaderTimeout: time.Duration(p.TimeoutMilliseconds) * time.Millisecond}
	clientTransport.DialContext = func(dialCtx context.Context, network, address string) (net.Conn, error) {
		dialMu.Lock()
		if dialClosed {
			dialMu.Unlock()
			return nil, context.Canceled
		}
		dialWorkers.Add(1)
		dialMu.Unlock()
		defer dialWorkers.Done()
		// net/http intentionally detaches connection dialing from request
		// cancellation. Probe runtimes must not outlive their concurrency slot.
		dialCtx, dialCancel := context.WithCancel(dialCtx)
		defer dialCancel()
		stop := context.AfterFunc(ctx, dialCancel)
		defer stop()
		if err := ctx.Err(); err != nil {
			return nil, err
		}
		return transport.dial(dialCtx, network, address)
	}
	defer func() {
		cancel()
		clientTransport.CloseIdleConnections()
		dialMu.Lock()
		dialClosed = true
		dialMu.Unlock()
		dialWorkers.Wait()
	}()
	client := &http.Client{Transport: clientTransport, CheckRedirect: func(*http.Request, []*http.Request) error { return http.ErrUseLastResponse }}
	request, err := http.NewRequestWithContext(ctx, http.MethodGet, p.Url, nil)
	if err != nil {
		r.Stage = api.ProbeStage_PROBE_STAGE_HTTP
		r.ErrorMessage = "invalid service request"
		return r
	}
	for k, v := range headers {
		request.Header.Set(k, v)
	}
	var traceMu sync.Mutex
	phase := api.ProbeStage_PROBE_STAGE_TCP
	setPhase := func(value api.ProbeStage) { traceMu.Lock(); phase = value; traceMu.Unlock() }
	trace := &httptrace.ClientTrace{
		DNSStart: func(httptrace.DNSStartInfo) { setPhase(api.ProbeStage_PROBE_STAGE_DNS) },
		DNSDone: func(info httptrace.DNSDoneInfo) {
			if info.Err == nil {
				setPhase(api.ProbeStage_PROBE_STAGE_TCP)
			}
		},
		TLSHandshakeStart: func() { setPhase(api.ProbeStage_PROBE_STAGE_TLS) },
		TLSHandshakeDone: func(_ tls.ConnectionState, err error) {
			if err == nil {
				setPhase(api.ProbeStage_PROBE_STAGE_HTTP)
			}
		},
		WroteRequest: func(info httptrace.WroteRequestInfo) {
			if info.Err == nil {
				setPhase(api.ProbeStage_PROBE_STAGE_HTTP)
			}
		},
	}
	request = request.WithContext(httptrace.WithClientTrace(request.Context(), trace))
	start := time.Now()
	response, err := client.Do(request)
	if err != nil {
		traceMu.Lock()
		r.Stage = phase
		traceMu.Unlock()
		var dnsErr *net.DNSError
		var netErr net.Error
		if errors.As(err, &dnsErr) {
			r.Stage = api.ProbeStage_PROBE_STAGE_DNS
		}
		if errors.Is(err, context.DeadlineExceeded) || errors.As(err, &netErr) && netErr.Timeout() {
			r.Stage = api.ProbeStage_PROBE_STAGE_TIMEOUT
		}
		// Transport errors can contain credential-bearing URLs or proxy details.
		r.ErrorMessage = "service connection failed at " + r.Stage.String()
		return r
	}
	defer response.Body.Close()
	r.HttpStatus = uint32(response.StatusCode)
	r.ServiceCountry = strings.ToUpper(strings.TrimSpace(response.Header.Get(p.ServiceCountryHeader)))
	if !validCountry(r.ServiceCountry) {
		r.ServiceCountry = ""
	}
	if response.StatusCode == 401 || response.StatusCode == 403 || response.StatusCode == 407 {
		r.Stage = api.ProbeStage_PROBE_STAGE_AUTH
		r.ErrorMessage = "service rejected authentication or access"
		return r
	}
	expected := response.StatusCode >= 200 && response.StatusCode < 300
	if len(p.ExpectedStatus) > 0 {
		expected = false
		for _, code := range p.ExpectedStatus {
			if code == r.HttpStatus {
				expected = true
			}
		}
	}
	if !expected {
		r.Stage = api.ProbeStage_PROBE_STAGE_HTTP
		r.ErrorMessage = "unexpected HTTP status"
		return r
	}
	body, err := io.ReadAll(io.LimitReader(response.Body, (1<<20)+1))
	if err != nil {
		r.Stage = api.ProbeStage_PROBE_STAGE_HTTP
		r.ErrorMessage = "cannot read service response"
		if ctx.Err() != nil {
			r.Stage = api.ProbeStage_PROBE_STAGE_TIMEOUT
		}
		return r
	}
	if len(body) > 1<<20 {
		r.Stage = api.ProbeStage_PROBE_STAGE_CONTENT
		r.ErrorMessage = "service response exceeds 1 MiB"
		return r
	}
	if p.BodyContains != "" && !strings.Contains(string(body), p.BodyContains) {
		r.Stage = api.ProbeStage_PROBE_STAGE_CONTENT
		r.ErrorMessage = "service response does not match expected content"
		return r
	}
	r.LatencyMilliseconds = uint32(time.Since(start).Milliseconds())
	if p.EgressUrl != "" {
		country, ip, err := probeEgress(ctx, client, p.EgressUrl)
		if err != nil {
			r.Stage = api.ProbeStage_PROBE_STAGE_EGRESS
			r.ErrorMessage = "cannot verify egress region"
			if ctx.Err() != nil {
				r.Stage = api.ProbeStage_PROBE_STAGE_TIMEOUT
			}
			return r
		}
		r.ObservedCountry, r.EgressIp = country, ip
	}
	country := r.ObservedCountry
	if p.ServiceCountryHeader != "" {
		country = r.ServiceCountry
	}
	if len(p.AllowedCountries) > 0 {
		allowed := false
		for _, c := range p.AllowedCountries {
			if country == c {
				allowed = true
			}
		}
		if !allowed {
			r.Stage = api.ProbeStage_PROBE_STAGE_REGION
			r.ErrorMessage = "observed service region is missing or not allowed"
		}
	}
	return r
}

func probeEgress(ctx context.Context, client *http.Client, endpoint string) (string, string, error) {
	request, err := http.NewRequestWithContext(ctx, http.MethodGet, endpoint, nil)
	if err != nil {
		return "", "", err
	}
	response, err := client.Do(request)
	if err != nil {
		return "", "", err
	}
	defer response.Body.Close()
	if response.StatusCode != http.StatusOK {
		return "", "", errors.New("unexpected egress status")
	}
	body, err := io.ReadAll(io.LimitReader(response.Body, 65537))
	if err != nil {
		return "", "", err
	}
	if len(body) > 65536 {
		return "", "", errors.New("egress response too large")
	}
	var payload struct {
		IP      string `json:"ip"`
		Country string `json:"country"`
	}
	if err := json.Unmarshal(body, &payload); err != nil {
		return "", "", err
	}
	country := strings.ToUpper(strings.TrimSpace(payload.Country))
	if !validCountry(country) {
		return "", "", errors.New("invalid egress country")
	}
	if _, err := netip.ParseAddr(payload.IP); err != nil {
		return "", "", err
	}
	return country, payload.IP, nil
}
