package manager

import (
	"bufio"
	"context"
	"fmt"
	"io"
	"net"
	"net/http"
	"net/http/httptest"
	"net/url"
	"strconv"
	"strings"
	"testing"
	"time"

	"github.com/loafman1120/TargetLib/config"
	"github.com/loafman1120/TargetLib/profile"
	box "github.com/sagernet/sing-box"
	"github.com/sagernet/sing-box/option"
	singjson "github.com/sagernet/sing/common/json"
)

// All listeners and proxy nodes are local. This exercises real sing-box routing
// through the generated mixed inbound, not a mocked selector or JSON assertion.
func TestSmartServiceTrafficIsolationAndDisable(t *testing.T) {
	makeNode := func(id string) (*httptest.Server, profile.Node) {
		server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			if r.Method != http.MethodConnect {
				http.Error(w, "CONNECT required", 400)
				return
			}
			conn, rw, err := w.(http.Hijacker).Hijack()
			if err != nil {
				return
			}
			defer conn.Close()
			_ = conn.SetDeadline(time.Now().Add(3 * time.Second))
			fmt.Fprint(rw, "HTTP/1.1 200 Connection Established\r\n\r\n")
			rw.Flush()
			if _, err := http.ReadRequest(rw.Reader); err != nil {
				return
			}
			fmt.Fprintf(rw, "HTTP/1.1 200 OK\r\nContent-Length: %d\r\nConnection: close\r\n\r\n%s", len(id), id)
			rw.Flush()
		}))
		host, rawPort, _ := net.SplitHostPort(strings.TrimPrefix(server.URL, "http://"))
		port, _ := strconv.Atoi(rawPort)
		return server, profile.Node{ID: id, Phase: profile.NodeReady, Outbound: &option.Outbound{Type: "http", Options: &option.HTTPOutboundOptions{ServerOptions: option.ServerOptions{Server: host, ServerPort: uint16(port)}}}}
	}
	a, nodeA := makeNode("node-a")
	defer a.Close()
	b, nodeB := makeNode("node-b")
	defer b.Close()
	model := config.RuntimeModel{NodePool: config.NodePool{Nodes: []profile.Node{nodeA, nodeB}},
		Selectors: []config.Selector{{Tag: "proxy", NodeIDs: []string{"node-a", "node-b"}, Selected: "node-b"},
			{Tag: "one", NodeIDs: []string{"node-a"}, Selected: "node-a"}, {Tag: "two", NodeIDs: []string{"node-b"}, Selected: "node-b"}},
		ServiceRoutes: []config.ServiceRoute{{ServiceID: "one", Domains: []string{"one.invalid"}, Selector: "one", Enabled: true},
			{ServiceID: "two", Domains: []string{"two.invalid"}, Selector: "two", Enabled: true}}}
	run := func(model config.RuntimeModel, check func(*http.Client)) {
		t.Helper()
		listener, err := net.Listen("tcp", "127.0.0.1:0")
		if err != nil {
			t.Fatal(err)
		}
		port := listener.Addr().(*net.TCPAddr).Port
		listener.Close()
		content, err := config.Build(config.Settings{ListenAddress: "127.0.0.1", MixedPort: port, ProxyMode: config.ProxyModeMixed, RouteMode: config.RouteModeAll}, model)
		if err != nil {
			t.Fatal(err)
		}
		options, err := singjson.UnmarshalExtendedContext[option.Options](profile.Context(), content)
		if err != nil {
			t.Fatal(err)
		}
		instance, err := box.New(box.Options{Options: options, Context: serviceContext(context.Background(), Options{})})
		if err != nil {
			t.Fatal(err)
		}
		if err := instance.Start(); err != nil {
			instance.Close()
			t.Fatal(err)
		}
		defer instance.Close()
		proxy, _ := url.Parse(fmt.Sprintf("http://127.0.0.1:%d", port))
		transport := &http.Transport{Proxy: http.ProxyURL(proxy), DisableKeepAlives: true}
		defer transport.CloseIdleConnections()
		check(&http.Client{Transport: transport, Timeout: 3 * time.Second})
	}
	request := func(client *http.Client, host, want string) {
		t.Helper()
		response, err := client.Get("http://" + host + "/")
		if err != nil {
			t.Fatal(err)
		}
		defer response.Body.Close()
		body, err := io.ReadAll(bufio.NewReader(response.Body))
		if err != nil || string(body) != want {
			t.Fatalf("%s returned %q, expected %q: %v", host, body, want, err)
		}
	}
	for i := 0; i < 2; i++ { // Identical restored config preserves per-service selections.
		run(model, func(client *http.Client) {
			request(client, "one.invalid", "node-a")
			request(client, "two.invalid", "node-b")
			request(client, "unmatched.invalid", "node-b")
		})
	}
	a.Close()
	run(model, func(client *http.Client) {
		response, err := client.Get("http://one.invalid/")
		if err == nil {
			defer response.Body.Close()
			body, _ := io.ReadAll(response.Body)
			if string(body) == "node-b" || response.StatusCode == 200 {
				t.Fatal("failed service silently fell back")
			}
		}
		request(client, "two.invalid", "node-b")
	})
	for i := range model.ServiceRoutes {
		model.ServiceRoutes[i].Enabled = false
	}
	run(model, func(client *http.Client) {
		request(client, "one.invalid", "node-b")
		request(client, "two.invalid", "node-b")
	})
}
