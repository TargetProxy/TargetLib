package manager

import (
	"context"
	"net"
	"os"
	"path/filepath"

	targetlibapi "github.com/loafman1120/TargetLib/api/TargetLib"
	"google.golang.org/grpc"
)

type Server struct {
	manager  *Manager
	listener net.Listener
	grpc     *grpc.Server
	cleanup  func()
}

func NewLocal(ctx context.Context, options Options, socketPath string) (*Manager, *Server, error) {
	m, err := New(ctx, options)
	if err != nil {
		return nil, nil, err
	}
	s, err := Listen(m, socketPath)
	if err != nil {
		m.Close()
		return nil, nil, err
	}
	return m, s, nil
}

func Listen(manager *Manager, socketPath string) (*Server, error) {
	if socketPath == "" {
		return nil, os.ErrInvalid
	}
	if err := os.MkdirAll(filepath.Dir(socketPath), 0o700); err != nil {
		return nil, err
	}
	if err := os.Remove(socketPath); err != nil && !os.IsNotExist(err) {
		return nil, err
	}
	listener, err := net.Listen("unix", socketPath)
	if err != nil {
		return nil, err
	}
	// Keep the endpoint private to the current user on POSIX systems.
	// Windows ignores this mode for AF_UNIX sockets.
	_ = os.Chmod(socketPath, 0o600)
	server := grpc.NewServer()
	targetlibapi.RegisterTargetLibServer(server, manager)
	return &Server{
		manager:  manager,
		listener: listener,
		grpc:     server,
		cleanup:  func() { _ = os.Remove(socketPath) },
	}, nil
}

func (s *Server) Serve() error {
	return s.grpc.Serve(s.listener)
}

func (s *Server) Endpoint() string {
	return s.listener.Addr().String()
}

func (s *Server) Network() string {
	return s.listener.Addr().Network()
}

func (s *Server) Close() {
	s.grpc.Stop()
	_ = s.listener.Close()
	s.cleanup()
	s.manager.Close()
}
