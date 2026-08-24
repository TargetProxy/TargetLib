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

func TestBuildFromNodesRouteModes(t *testing.T) {
	for _, test := range []struct {
		name string
		mode RouteMode
		want string
	}{
		{"direct", RouteModeDirect, "direct"},
		{"all", RouteModeAll, "direct"}, // no subscription nodes means direct is the only outbound
	} {
		t.Run(test.name, func(t *testing.T) {
			content, err := BuildFromNodes(Settings{ListenAddress: "127.0.0.1", MixedPort: 2080, ProxyMode: ProxyModeMixed, RouteMode: test.mode}, nil)
			if err != nil {
				t.Fatal(err)
			}
			var document struct {
				Route struct {
					Final string `json:"final"`
				} `json:"route"`
			}
			if err := json.Unmarshal(content, &document); err != nil {
				t.Fatal(err)
			}
			if document.Route.Final != test.want {
				t.Fatalf("expected final %q, got %q", test.want, document.Route.Final)
			}
		})
	}
}

func TestApplyRawRouteMode(t *testing.T) {
	config := map[string]any{
		"route":     map[string]any{"final": "proxy", "rules": []any{map[string]any{"domain": []any{"example.com"}, "outbound": "proxy"}}},
		"outbounds": []any{map[string]any{"type": "direct", "tag": "direct"}, map[string]any{"type": "selector", "tag": "proxy"}},
	}
	applyRawRouteMode(config, RouteModeDirect)
	route := config["route"].(map[string]any)
	if route["final"] != "direct" || route["rules"] != nil {
		t.Fatalf("unexpected direct route: %#v", route)
	}
	config["route"] = map[string]any{"rules": []any{map[string]any{}}}
	applyRawRouteMode(config, RouteModeAll)
	route = config["route"].(map[string]any)
	if route["final"] != "proxy" || route["rules"] != nil {
		t.Fatalf("unexpected all route: %#v", route)
	}
}
