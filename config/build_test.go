package config

import (
	"encoding/json"
	"testing"
)

func TestTunModeDoesNotCreateMixedInbound(t *testing.T) {
	content, err := BuildFromNodes(Settings{
		ListenAddress: "127.0.0.1",
		MixedPort:     2080,
		ProxyMode:     ProxyModeTun,
	}, nil)
	if err != nil {
		t.Fatal(err)
	}

	var document struct {
		Inbounds []struct {
			Type string `json:"type"`
		} `json:"inbounds"`
	}
	if err := json.Unmarshal(content, &document); err != nil {
		t.Fatal(err)
	}
	if len(document.Inbounds) != 1 || document.Inbounds[0].Type != "tun" {
		t.Fatalf("unexpected inbounds: %+v", document.Inbounds)
	}
}
