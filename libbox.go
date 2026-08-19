package main

import (
	"context"
	"net"
	"os"
	"path/filepath"
	"runtime"
	"strconv"

	box "github.com/sagernet/sing-box"
	"github.com/sagernet/sing-box/daemon"
	"github.com/sagernet/sing-box/experimental/libbox"
	"github.com/sagernet/sing-box/include"
	"github.com/sagernet/sing/service/filemanager"
	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/metadata"
	"google.golang.org/grpc/status"

	"github.com/loafman1120/libbox/platform"
)

// newDesktopStartedService builds the daemon-based service. Unlike the
// libbox.NewCommandServer path it does not register a PlatformInterface, so
// sing-box uses its native desktop network stack (tun network monitor +
// default interface finder) instead of the platform interface list.
func newDesktopStartedService() (serviceAdapter, *serviceController) {
	controller := new(serviceController)
	options := getCurrentInitOptions()
	started := daemon.NewStartedService(daemon.ServiceOptions{
		Context:     desktopServiceContext(options),
		Handler:     &desktopCommandHandler{controller: controller},
		Debug:       options.debug,
		LogMaxLines: int(options.logMaxLines),
		OOMKiller:   false,
	})
	server, err := startCommandServer(started, options)
	if err != nil {
		started.Close()
		return &failedService{err: err}, nil
	}
	return &daemonService{service: started, server: server}, controller
}

// desktopServiceContext builds the sing-box context with the standard
// registries and no platform interface.
func desktopServiceContext(options initOptions) context.Context {
	ctx := context.Background()
	ctx = filemanager.WithDefault(ctx, options.workingPath, options.tempPath, os.Getuid(), os.Getgid())
	return box.Context(ctx,
		include.InboundRegistry(),
		include.OutboundRegistry(),
		include.EndpointRegistry(),
		include.DNSTransportRegistry(),
		include.ServiceRegistry(),
	)
}

func libboxVersion() string   { return libbox.Version() }
func libboxGoVersion() string { return runtime.Version() }

func setupLibbox(options initOptions) error {
	if options.locale != "" {
		libbox.SetLocale(options.locale)
	}
	return libbox.Setup(&libbox.SetupOptions{
		BasePath:                options.basePath,
		WorkingPath:             options.workingPath,
		TempPath:                options.tempPath,
		CommandServerListenPort: options.commandPort,
		CommandServerSecret:     options.commandSecret,
		LogMaxLines:             int(options.logMaxLines),
		Debug:                   options.debug,
	})
}

func checkLibboxConfig(config string) error { return libbox.CheckConfig(config) }

func systemProxyStatus() (platform.SystemProxyStatus, error) {
	return platform.GetSystemProxyStatus()
}

func setSystemProxy(enabled bool, host string, port int32, bypass string) error {
	return platform.SetSystemProxy(enabled, host, port, bypass)
}

// daemonService adapts daemon.StartedService to serviceAdapter.
type daemonService struct {
	service *daemon.StartedService
	server  *commandServer
}

func (s *daemonService) StartOrReloadService(config string) error {
	return s.service.StartOrReloadService(config, &daemon.OverrideOptions{})
}
func (s *daemonService) CloseService() error { return s.service.CloseService() }
func (s *daemonService) Close() {
	if s.server != nil {
		s.server.grpc.Stop()
		s.server.listener.Close()
	}
	s.service.Close()
}

type failedService struct{ err error }

func (s *failedService) StartOrReloadService(string) error { return s.err }
func (s *failedService) CloseService() error               { return s.err }
func (s *failedService) Close()                            {}

// commandServer serves the daemon StartedService gRPC protocol, the same
// protocol libbox.CommandServer exposed.
type commandServer struct {
	listener net.Listener
	grpc     *grpc.Server
}

func startCommandServer(started *daemon.StartedService, options initOptions) (*commandServer, error) {
	var (
		listener net.Listener
		err      error
	)
	if options.commandPort == 0 {
		sockPath := filepath.Join(options.basePath, "command.sock")
		os.Remove(sockPath)
		listener, err = net.ListenUnix("unix", &net.UnixAddr{Name: sockPath, Net: "unix"})
	} else {
		listener, err = net.Listen("tcp", net.JoinHostPort("127.0.0.1", strconv.Itoa(int(options.commandPort))))
	}
	if err != nil {
		return nil, err
	}
	grpcServer := grpc.NewServer(
		grpc.UnaryInterceptor(commandAuthInterceptor(options.commandSecret)),
		grpc.StreamInterceptor(commandStreamAuthInterceptor(options.commandSecret)),
	)
	daemon.RegisterStartedServiceServer(grpcServer, started)
	go grpcServer.Serve(listener)
	return &commandServer{listener: listener, grpc: grpcServer}, nil
}

func commandAuthInterceptor(secret string) grpc.UnaryServerInterceptor {
	return func(ctx context.Context, req any, info *grpc.UnaryServerInfo, handler grpc.UnaryHandler) (any, error) {
		if secret != "" && !validCommandSecret(ctx, secret) {
			return nil, status.Error(codes.Unauthenticated, "invalid authentication secret")
		}
		return handler(ctx, req)
	}
}

func commandStreamAuthInterceptor(secret string) grpc.StreamServerInterceptor {
	return func(srv any, stream grpc.ServerStream, info *grpc.StreamServerInfo, handler grpc.StreamHandler) error {
		if secret != "" && !validCommandSecret(stream.Context(), secret) {
			return status.Error(codes.Unauthenticated, "invalid authentication secret")
		}
		return handler(srv, stream)
	}
}

func validCommandSecret(ctx context.Context, secret string) bool {
	md, ok := metadata.FromIncomingContext(ctx)
	if !ok {
		return false
	}
	values := md.Get("x-command-secret")
	return len(values) > 0 && values[0] == secret
}

// desktopCommandHandler is the small command surface exposed by the daemon
// service. Lifecycle operations delegate to the shared controller.
type desktopCommandHandler struct {
	controller *serviceController
}

func (h *desktopCommandHandler) ServiceStop() error {
	return h.controller.ServiceStop()
}
func (h *desktopCommandHandler) ServiceReload() error {
	return h.controller.ServiceReload()
}
func (*desktopCommandHandler) SystemProxyStatus() (*daemon.SystemProxyStatus, error) {
	status, err := platform.GetSystemProxyStatus()
	if err != nil {
		return nil, err
	}
	return &daemon.SystemProxyStatus{Available: status.Supported, Enabled: status.Enabled}, nil
}
func (*desktopCommandHandler) SetSystemProxyEnabled(enabled bool) error {
	return platform.SetSystemProxy(enabled, "127.0.0.1", 2080, "<local>")
}
func (*desktopCommandHandler) WriteDebugMessage(string) {}
