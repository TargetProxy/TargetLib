package manager

import (
	"context"
	"os"
	"testing"

	"github.com/sagernet/sing-box/daemon"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"google.golang.org/protobuf/proto"

	targetlibapi "github.com/loafman1120/TargetLib/api/TargetLib"
	"github.com/loafman1120/TargetLib/subscriptions"
)

func TestUpdateRuntimeConfigRejectsInvalidSettingsBeforeReplacingConfig(t *testing.T) {
	previous := defaultRuntimeConfig()
	sharedStore := &subscriptions.MemoryStore{}
	manager := &Manager{
		config:        "last-known-good",
		runtimeConfig: previous,
		runtimeStore:  runtimeConfigStore{store: sharedStore},
	}

	_, err := manager.UpdateRuntimeConfig(context.Background(), &targetlibapi.UpdateRuntimeConfigRequest{
		Settings: &targetlibapi.RuntimeSettings{
			ListenAddress: "127.0.0.1",
			MixedPort:     0,
			ProxyMode:     targetlibapi.ProxyMode_PROXY_MODE_MIXED,
			RouteMode:     targetlibapi.RouteMode_ROUTE_MODE_RULE,
		},
	})

	if status.Code(err) != codes.InvalidArgument {
		t.Fatalf("expected InvalidArgument, got %v", err)
	}
	if manager.config != "last-known-good" {
		t.Fatalf("config changed after validation failure: %q", manager.config)
	}
	if !proto.Equal(manager.runtimeConfig, previous) {
		t.Fatal("runtime config changed after validation failure")
	}
}

func TestRuntimeSettingsErrorMapsInvalidLifecycleTransition(t *testing.T) {
	err := runtimeSettingsError("apply runtime settings", daemon.ServiceStatus_STOPPING, os.ErrInvalid)

	if status.Code(err) != codes.FailedPrecondition {
		t.Fatalf("expected FailedPrecondition, got %v", err)
	}
	if got := status.Convert(err).Message(); got != "apply runtime settings rejected while service state is STOPPING: invalid argument" {
		t.Fatalf("unexpected error message: %q", got)
	}
}
