package manager

import (
	"context"
	"crypto/tls"
	"errors"
	"net"
	"net/http"
	"strings"
	"sync"
	"time"

	api "github.com/loafman1120/TargetLib/api/TargetLib"
	"github.com/loafman1120/TargetLib/config"
	"github.com/loafman1120/TargetLib/profile"
	box "github.com/sagernet/sing-box"
	"github.com/sagernet/sing-box/adapter"
	"github.com/sagernet/sing-box/option"
	singjson "github.com/sagernet/sing/common/json"
	M "github.com/sagernet/sing/common/metadata"
	N "github.com/sagernet/sing/common/network"
	"github.com/sagernet/sing/service"
	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

const (
	nodeDelayConcurrency = 8
	nodeDelayTimeout     = 5 * time.Second
)

func (m *Manager) TestNodeDelay(request *api.TestNodeDelayRequest, stream grpc.ServerStreamingServer[api.NodeDelayResult]) error {
	ids := request.GetNodeIds()
	if len(ids) == 0 {
		return status.Error(codes.InvalidArgument, "at least one node ID is required")
	}
	for _, id := range ids {
		if strings.TrimSpace(id) == "" {
			return status.Error(codes.InvalidArgument, "node ID must not be blank")
		}
	}

	ctx, cancel := context.WithCancel(stream.Context())
	defer cancel()
	nodes := make(map[string]profile.Node)
	for _, node := range m.subscriptions.NodePool().Nodes {
		nodes[node.ID] = node
	}
	seen := make(map[string]bool, len(ids))
	var targets []profile.Node
	for _, id := range ids {
		if seen[id] {
			continue
		}
		seen[id] = true
		node, found := nodes[id]
		if found && node.IsAvailable() {
			targets = append(targets, node)
			continue
		}
		result := &api.NodeDelayResult{NodeId: id, Status: api.NodeDelayStatus_NODE_DELAY_STATUS_NOT_FOUND}
		if found {
			result.Status = api.NodeDelayStatus_NODE_DELAY_STATUS_NOT_READY
		}
		if err := stream.Send(result); err != nil {
			return err
		}
	}
	if len(targets) == 0 {
		return nil
	}
	if err := ctx.Err(); err != nil {
		return status.FromContextError(err).Err()
	}

	probeCtx := service.ContextWithRegistry(ctx, m.nodeDelayRegistry.Clone())
	instance, err := m.startNodeDelayBox(probeCtx, targets)
	if err != nil {
		if ctx.Err() != nil {
			return status.FromContextError(ctx.Err()).Err()
		}
		return status.Error(codes.Unavailable, "could not start node delay probe")
	}
	defer instance.Close()

	results := make(chan *api.NodeDelayResult)
	go m.runNodeDelayBatch(probeCtx, instance.Outbound(), targets, results)
	defer func() {
		// Stop and join the probes before closing their shared runtime.
		cancel()
		for range results {
		}
	}()
	for result := range results {
		if err := stream.Send(result); err != nil {
			return err
		}
	}
	return status.FromContextError(ctx.Err()).Err()
}

func (m *Manager) startNodeDelayBox(ctx context.Context, nodes []profile.Node) (*box.Box, error) {
	m.configMu.RLock()
	settings := m.intent.settings
	m.configMu.RUnlock()
	settings.ProbeOnly = true
	settings.RouteMode = config.RouteModeDirect
	built, err := config.Build(settings, profile.Profile{Nodes: nodes})
	if err != nil {
		return nil, err
	}
	options, err := singjson.UnmarshalExtendedContext[option.Options](ctx, built.Content)
	if err != nil {
		return nil, err
	}
	instance, err := box.New(box.Options{Context: ctx, Options: options})
	if err != nil {
		return nil, err
	}
	if err := instance.Start(); err != nil {
		return nil, err
	}
	return instance, nil
}

func (m *Manager) runNodeDelayBatch(ctx context.Context, outbounds adapter.OutboundManager, nodes []profile.Node, results chan<- *api.NodeDelayResult) {
	var workers sync.WaitGroup
	defer close(results)
	defer workers.Wait()
	for _, node := range nodes {
		select {
		case m.nodeDelaySlots <- struct{}{}:
		case <-ctx.Done():
			return
		}
		workers.Go(func() {
			defer func() { <-m.nodeDelaySlots }()
			if ctx.Err() != nil {
				return
			}
			result := &api.NodeDelayResult{NodeId: node.ID, Status: api.NodeDelayStatus_NODE_DELAY_STATUS_FAILED}
			if outbound, ok := outbounds.Outbound(node.ID); ok {
				probeCtx, cancel := context.WithTimeout(ctx, nodeDelayTimeout)
				delay, err := measureNodeDelay(probeCtx, outbound, config.DefaultURLTestURL)
				switch {
				case err == nil:
					result.Status = api.NodeDelayStatus_NODE_DELAY_STATUS_OK
					result.DelayMs = &delay
				case errors.Is(err, context.DeadlineExceeded) || errors.Is(probeCtx.Err(), context.DeadlineExceeded):
					result.Status = api.NodeDelayStatus_NODE_DELAY_STATUS_TIMEOUT
				}
				cancel()
			}
			select {
			case results <- result:
			case <-ctx.Done():
			}
		})
	}
}

func measureNodeDelay(ctx context.Context, outbound N.Dialer, endpoint string) (uint32, error) {
	request, err := http.NewRequestWithContext(ctx, http.MethodHead, endpoint, nil)
	if err != nil {
		return 0, err
	}
	port := request.URL.Port()
	if port == "" {
		port = "443"
	}
	destination := M.ParseSocksaddrHostPortStr(request.URL.Hostname(), port)
	start := time.Now()
	conn, err := outbound.DialContext(ctx, N.NetworkTCP, destination)
	if err != nil {
		return 0, err
	}
	defer conn.Close()
	transport := &http.Transport{
		DialContext:       func(context.Context, string, string) (net.Conn, error) { return conn, nil },
		TLSClientConfig:   &tls.Config{RootCAs: adapter.RootPoolFromContext(ctx)},
		DisableKeepAlives: true,
	}
	defer transport.CloseIdleConnections()
	client := http.Client{
		Transport: transport,
		CheckRedirect: func(*http.Request, []*http.Request) error {
			return http.ErrUseLastResponse
		},
	}
	response, err := client.Do(request)
	if err != nil {
		return 0, err
	}
	delay := uint32(time.Since(start).Milliseconds())
	_ = response.Body.Close()
	if response.StatusCode != http.StatusNoContent {
		return 0, errors.New(response.Status)
	}
	return delay, nil
}
