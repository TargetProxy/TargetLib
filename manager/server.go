package manager

import (
	"context"
	"net"
	"os"
	"path/filepath"
	"sync"

	targetlibapi "github.com/loafman1120/TargetLib/api/TargetLib"
	"google.golang.org/grpc"
)

const (
	CommandHost    = "127.0.0.1"
	CommandAddress = "127.0.0.1:19090"
	CommandSocket  = "targetlib.sock"
)

type Server struct {
	manager        *Manager
	tcpListener    net.Listener
	socketListener net.Listener
	grpc           *grpc.Server
	socketPath     string
	close          sync.Once
}

func NewLocal(ctx context.Context, options Options) (*Manager, *Server, error) {
	m, err := New(ctx, options)
	if err != nil {
		return nil, nil, err
	}
	s, err := Listen(m, filepath.Join(options.BasePath, CommandSocket))
	if err != nil {
		m.Close()
		return nil, nil, err
	}
	return m, s, nil
}

func Listen(manager *Manager, socketPath string) (*Server, error) {
	return listen(manager, CommandAddress, socketPath)
}

func listen(manager *Manager, address, socketPath string) (*Server, error) {
	if socketPath == "" {
		return nil, os.ErrInvalid
	}
	tcpListener, err := net.Listen("tcp", address)
	if err != nil {
		return nil, err
	}
	if err := os.MkdirAll(filepath.Dir(socketPath), 0o700); err != nil {
		_ = tcpListener.Close()
		return nil, err
	}
	if err := os.Remove(socketPath); err != nil && !os.IsNotExist(err) {
		_ = tcpListener.Close()
		return nil, err
	}
	socketListener, err := net.Listen("unix", socketPath)
	if err != nil {
		_ = tcpListener.Close()
		return nil, err
	}
	_ = os.Chmod(socketPath, 0o600)
	server := grpc.NewServer()
	targetlibapi.RegisterTargetLibServer(server, manager)
	return &Server{
		manager: manager, tcpListener: tcpListener, socketListener: socketListener,
		grpc: server, socketPath: socketPath,
	}, nil
}

func (s *Server) Serve() error {
	errors := make(chan error, 2)
	go func() { errors <- s.grpc.Serve(s.socketListener) }()
	go func() { errors <- s.grpc.Serve(s.tcpListener) }()
	err := <-errors
	s.stopListeners()
	return err
}

func (s *Server) Endpoint() string {
	return s.tcpListener.Addr().String()
}

func (s *Server) Network() string {
	return s.tcpListener.Addr().Network()
}

func (s *Server) SocketEndpoint() string {
	return s.socketListener.Addr().String()
}

func (s *Server) Close() {
	s.close.Do(func() {
		s.stopListeners()
		s.manager.Close()
	})
}

func (s *Server) stopListeners() {
	s.grpc.Stop()
	_ = s.socketListener.Close()
	_ = s.tcpListener.Close()
	_ = os.Remove(s.socketPath)
}
