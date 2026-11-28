package manager

import (
	"context"
	"crypto/x509"
	"io"
	"net"
	"net/http"
	"net/http/httptest"
	"path/filepath"
	"testing"
	"time"

	api "github.com/loafman1120/TargetLib/api/TargetLib"
	"github.com/loafman1120/TargetLib/profile"
	"github.com/loafman1120/TargetLib/subscriptions"
	"github.com/sagernet/sing-box/adapter"
	"github.com/sagernet/sing-box/option"
	"github.com/sagernet/sing/service"
	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/credentials/insecure"
	"google.golang.org/grpc/status"
)

func TestNodeDelayUsesRequestedOutbound(t *testing.T) {
	proxyCalls := make(chan string, 3)
	proxy := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		proxyCalls <- r.Method + " " + r.Host
		w.WriteHeader(http.StatusForbidden)
	}))
	t.Cleanup(proxy.Close)
	addr := proxy.Listener.Addr().(*net.TCPAddr)
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()
	store := &subscriptions.MemoryStore{}
	err := store.Update(ctx, func(tx subscriptions.StoreTx) error {
		return tx.Put(subscriptions.Subscription{ID: "sub", Enabled: true, Profile: profile.Profile{Nodes: []profile.Node{
			{ID: "node", Phase: profile.NodeReady, Outbound: &option.Outbound{Type: "http", Options: &option.HTTPOutboundOptions{
				ServerOptions: option.ServerOptions{Server: addr.IP.String(), ServerPort: uint16(addr.Port)},
			}}},
			{ID: "failed", Phase: profile.NodeFailed},
		}}})
	})
	if err != nil {
		t.Fatal(err)
	}
	basePath := managerTestBasePath(t)
	m, err := New(ctx, Options{BasePath: basePath, SubscriptionStore: store})
	if err != nil {
		t.Fatal(err)
	}
	server, err := listen(m, "127.0.0.1:0", filepath.Join(basePath, CommandSocket))
	if err != nil {
		m.Close()
		t.Fatal(err)
	}
	t.Cleanup(server.Close)
	go func() { _ = server.Serve() }()
	conn, err := grpc.NewClient(server.Endpoint(), grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil {
		t.Fatal(err)
	}
	defer conn.Close()
	client := api.NewTargetLibClient(conn)
	stream, err := client.TestNodeDelay(ctx, &api.TestNodeDelayRequest{NodeIds: []string{"node", "unknown", "node", "failed"}})
	if err != nil {
		t.Fatal(err)
	}
	want := map[string]api.NodeDelayStatus{
		"node": api.NodeDelayStatus_NODE_DELAY_STATUS_FAILED, "unknown": api.NodeDelayStatus_NODE_DELAY_STATUS_NOT_FOUND,
		"failed": api.NodeDelayStatus_NODE_DELAY_STATUS_NOT_READY,
	}
	for {
		result, err := stream.Recv()
		if err == io.EOF {
			break
		}
		if err != nil {
			t.Fatal(err)
		}
		if result.Status != want[result.NodeId] || result.DelayMs != nil {
			t.Fatalf("unexpected node delay result: %v", result)
		}
		delete(want, result.NodeId)
	}
	if len(want) != 0 || len(proxyCalls) != 1 {
		t.Fatalf("missing results: %v, proxy received %d calls", want, len(proxyCalls))
	}
	if got := <-proxyCalls; got != "CONNECT www.gstatic.com:443" {
		t.Fatalf("proxy received %q", got)
	}

	stream, err = client.TestNodeDelay(ctx, &api.TestNodeDelayRequest{NodeIds: []string{"node", " "}})
	if err != nil {
		t.Fatal(err)
	}
	if _, err := stream.Recv(); status.Code(err) != codes.InvalidArgument || len(proxyCalls) != 0 {
		t.Fatalf("blank ID returned %v, proxy received %d calls", err, len(proxyCalls))
	}

	endpoint := httptest.NewTLSServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.Method != http.MethodHead {
			t.Errorf("probe sent %s, want HEAD", r.Method)
		}
		if r.URL.Path == "/redirect" {
			http.Redirect(w, r, "/", http.StatusFound)
			return
		}
		w.WriteHeader(http.StatusNoContent)
	}))
	defer endpoint.Close()
	roots := x509.NewCertPool()
	roots.AddCert(endpoint.Certificate())
	probeCtx := service.ContextWithRegistry(ctx, m.nodeDelayRegistry.Clone())
	instance, err := m.startNodeDelayBox(probeCtx, nil)
	if err != nil {
		t.Fatal(err)
	}
	defer instance.Close()
	direct, ok := instance.Outbound().Outbound("direct")
	if !ok {
		t.Fatal("missing direct outbound")
	}
	probeCtx = service.ContextWith[adapter.CertificateStore](probeCtx, nodeDelayTestCertificateStore{roots: roots})
	if _, err := measureNodeDelay(probeCtx, direct, endpoint.URL); err != nil {
		t.Fatalf("HTTP 204 failed: %v", err)
	}
	if _, err := measureNodeDelay(probeCtx, direct, endpoint.URL+"/redirect"); err == nil {
		t.Fatal("redirect succeeded instead of reporting an error")
	}
}

type nodeDelayTestCertificateStore struct {
	adapter.CertificateStore
	roots *x509.CertPool
}

func (s nodeDelayTestCertificateStore) Pool() *x509.CertPool { return s.roots }
