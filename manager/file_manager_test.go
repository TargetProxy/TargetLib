package manager

import (
	"context"
	"os"
	"path/filepath"
	"testing"

	"github.com/sagernet/sing-box/daemon"
	"github.com/sagernet/sing/service/filemanager"
)

func TestServiceFileManagerReopensResolvedPath(t *testing.T) {
	workingPath := t.TempDir()
	ruleSetPath := filepath.Join(workingPath, "cn.srs")
	if err := os.WriteFile(ruleSetPath, []byte("rule-set"), 0o600); err != nil {
		t.Fatal(err)
	}

	ctx := serviceContext(context.Background(), Options{
		WorkingPath: workingPath,
		TempPath:    workingPath,
	})
	resolvedPath := filemanager.BasePath(ctx, "cn.srs")
	if resolvedPath != ruleSetPath {
		t.Fatalf("resolved path = %q, want %q", resolvedPath, ruleSetPath)
	}

	file, err := filemanager.Open(ctx, resolvedPath)
	if err != nil {
		t.Fatalf("reopen resolved path %q: %v", resolvedPath, err)
	}
	if err := file.Close(); err != nil {
		t.Fatal(err)
	}
}

func TestStartedServiceLoadsLocalRuleSetFromWorkingPath(t *testing.T) {
	workingPath := t.TempDir()
	sourcePath := filepath.Join("..", "internal", "ruleset", "cn.srs")
	content, err := os.ReadFile(sourcePath)
	if err != nil {
		t.Fatal(err)
	}
	if err := os.WriteFile(filepath.Join(workingPath, "cn.srs"), content, 0o600); err != nil {
		t.Fatal(err)
	}

	service := daemon.NewStartedService(daemon.ServiceOptions{
		Context: serviceContext(context.Background(), Options{
			WorkingPath: workingPath,
			TempPath:    workingPath,
		}),
	})
	t.Cleanup(service.Close)
	config := `{
		"log":{"disabled":true},
		"outbounds":[{"type":"direct","tag":"direct"}],
		"route":{
			"rule_set":[{"type":"local","tag":"geoip-cn","format":"binary","path":"cn.srs"}],
			"final":"direct"
		}
	}`
	if err := service.CheckConfig(context.Background(), config); err != nil {
		t.Fatal(err)
	}
}
