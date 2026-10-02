package manager

import (
	"context"
	"os"
	"path/filepath"
	"testing"

	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/metadata"
	"google.golang.org/grpc/status"
)

func TestAuthenticationUsesPersistentControlToken(t *testing.T) {
	base := t.TempDir()
	first, err := loadControlToken(base, "")
	if err != nil {
		t.Fatal(err)
	}
	second, err := loadControlToken(base, "")
	if err != nil {
		t.Fatal(err)
	}
	if first != second || len(first) < 32 {
		t.Fatal("control token was not persisted")
	}
	if _, err := os.Stat(filepath.Join(base, controlTokenFile)); err != nil {
		t.Fatal(err)
	}

	m := &Manager{controlToken: first}
	for _, name := range []string{"UpdateRuntimeConfig", "UpsertRoute", "DeleteRoute", "SelectRouteNode"} {
		t.Run(name, func(t *testing.T) {
			method := "/targetlib.TargetLib/" + name
			if code := status.Code(m.authenticate(context.Background(), method)); code != codes.Unauthenticated {
				t.Fatalf("missing token code=%v", code)
			}
			bad := metadata.NewIncomingContext(context.Background(), metadata.Pairs("authorization", "Bearer wrong"))
			if code := status.Code(m.authenticate(bad, method)); code != codes.Unauthenticated {
				t.Fatalf("bad token code=%v", code)
			}
			good := metadata.NewIncomingContext(context.Background(), metadata.Pairs("authorization", "Bearer "+first))
			if err := m.authenticate(good, method); err != nil {
				t.Fatal(err)
			}
		})
	}
	for _, name := range []string{"GetState", "SelectNode", "ListRoutes"} {
		t.Run(name+" does not require token", func(t *testing.T) {
			if err := m.authenticate(context.Background(), "/targetlib.TargetLib/"+name); err != nil {
				t.Fatal(err)
			}
		})
	}
}
