package manager

import (
	"context"
	"net"
	"os"
	"path/filepath"
	"testing"
	"time"

	targetlibapi "github.com/loafman1120/TargetLib/api/TargetLib"
	"github.com/loafman1120/TargetLib/subscriptions"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
	"google.golang.org/protobuf/types/known/emptypb"
)

func TestListenUsesUnixSocketAndLoopbackTCP(t *testing.T) {
	basePath := t.TempDir()
	manager, err := New(context.Background(), Options{
		BasePath:          basePath,
		SubscriptionStore: &subscriptions.MemoryStore{},
	})
	if err != nil {
		t.Fatal(err)
	}
	socketPath := filepath.Join(basePath, CommandSocket)
	server, err := listen(manager, "127.0.0.1:0", socketPath)
	if err != nil {
		manager.Close()
		t.Fatal(err)
	}
	t.Cleanup(server.Close)

	if got := server.Network(); got != "tcp" {
		t.Fatalf("network = %q, want tcp", got)
	}
	if host := server.tcpListener.Addr().(*net.TCPAddr).IP.String(); host != CommandHost {
		t.Fatalf("host = %q, want %q", host, CommandHost)
	}
	if got := server.socketListener.Addr().Network(); got != "unix" {
		t.Fatalf("socket network = %q, want unix", got)
	}
	if got := server.SocketEndpoint(); got != socketPath {
		t.Fatalf("socket endpoint = %q, want %q", got, socketPath)
	}
}

func TestServeAcceptsUnixSocketAndTCP(t *testing.T) {
	basePath := t.TempDir()
	manager, err := New(context.Background(), Options{
		BasePath:          basePath,
		SubscriptionStore: &subscriptions.MemoryStore{},
	})
	if err != nil {
		t.Fatal(err)
	}
	socketPath := filepath.Join(basePath, CommandSocket)
	server, err := listen(manager, "127.0.0.1:0", socketPath)
	if err != nil {
		manager.Close()
		t.Fatal(err)
	}
	go func() { _ = server.Serve() }()
	t.Cleanup(server.Close)

	tcpConnection, err := grpc.NewClient(
		server.Endpoint(),
		grpc.WithTransportCredentials(insecure.NewCredentials()),
	)
	if err != nil {
		t.Fatal(err)
	}
	defer tcpConnection.Close()
	assertVersionHandshake(t, targetlibapi.NewTargetLibClient(tcpConnection))

	socketConnection, err := grpc.NewClient(
		"passthrough:///targetlib",
		grpc.WithTransportCredentials(insecure.NewCredentials()),
		grpc.WithContextDialer(func(ctx context.Context, _ string) (net.Conn, error) {
			return (&net.Dialer{}).DialContext(ctx, "unix", socketPath)
		}),
	)
	if err != nil {
		t.Fatal(err)
	}
	defer socketConnection.Close()
	assertVersionHandshake(t, targetlibapi.NewTargetLibClient(socketConnection))

	server.Close()
	if _, err := os.Stat(socketPath); !os.IsNotExist(err) {
		t.Fatalf("socket was not removed after close: %v", err)
	}
}

func TestSecondServerDoesNotRemoveActiveSocket(t *testing.T) {
	basePath := t.TempDir()
	firstManager, err := New(context.Background(), Options{
		BasePath:          basePath,
		SubscriptionStore: &subscriptions.MemoryStore{},
	})
	if err != nil {
		t.Fatal(err)
	}
	socketPath := filepath.Join(basePath, CommandSocket)
	first, err := listen(firstManager, "127.0.0.1:0", socketPath)
	if err != nil {
		firstManager.Close()
		t.Fatal(err)
	}
	t.Cleanup(first.Close)

	secondManager, err := New(context.Background(), Options{
		BasePath:          t.TempDir(),
		SubscriptionStore: &subscriptions.MemoryStore{},
	})
	if err != nil {
		t.Fatal(err)
	}
	defer secondManager.Close()
	if _, err := listen(secondManager, first.Endpoint(), socketPath); err == nil {
		t.Fatal("second server unexpectedly acquired the active TCP endpoint")
	}
	if _, err := os.Stat(socketPath); err != nil {
		t.Fatalf("active socket was removed by second server: %v", err)
	}
}

func assertVersionHandshake(t *testing.T, client targetlibapi.TargetLibClient) {
	t.Helper()
	ctx, cancel := context.WithTimeout(context.Background(), 3*time.Second)
	defer cancel()
	version, err := client.GetVersion(ctx, &emptypb.Empty{})
	if err != nil {
		t.Fatal(err)
	}
	if version.GetProtocolVersion() != ProtocolVersion {
		t.Fatalf("protocol version = %d, want %d", version.GetProtocolVersion(), ProtocolVersion)
	}
}
