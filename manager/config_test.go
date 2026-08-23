package manager

import (
	"context"
	"testing"

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
