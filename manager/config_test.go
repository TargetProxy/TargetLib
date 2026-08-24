package manager

import (
	"context"
	"os"
	"testing"

	"github.com/sagernet/sing-box/daemon"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	targetlibapi "github.com/loafman1120/TargetLib/api/TargetLib"
)

func TestApplyRuntimeSettingsRejectsInvalidSettingsBeforeReplacingConfig(t *testing.T) {
	manager := &Manager{config: "last-known-good"}

	_, err := manager.ApplyRuntimeSettings(context.Background(), &targetlibapi.BuildConfigRequest{
		Settings: &targetlibapi.BuildConfigSettings{
			ListenAddress: "127.0.0.1",
			MixedPort:     0,
			ProxyMode:     targetlibapi.ProxyMode_PROXY_MODE_MIXED,
		},
	})

	if status.Code(err) != codes.InvalidArgument {
		t.Fatalf("expected InvalidArgument, got %v", err)
	}
	if manager.config != "last-known-good" {
		t.Fatalf("config changed after validation failure: %q", manager.config)
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
