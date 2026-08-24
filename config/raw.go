package config

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"strings"

	singjson "github.com/sagernet/sing/common/json"
)

// BuildFromRaw 透传订阅原始配置：替换 inbounds（应用拥有入站主权）、
// 迁移 sing-box 遗留写法、注入 cache_file，然后重新序列化。
func BuildFromRaw(settings Settings, raw []byte) ([]byte, error) {
	if err := settings.Validate(); err != nil {
		return nil, err
	}
	if len(strings.TrimSpace(string(raw))) == 0 {
		return nil, fmt.Errorf("%w: raw config is empty", ErrInvalidSource)
	}
	var config map[string]any
	if err := decodeJSONNumber(raw, &config); err != nil {
		return nil, fmt.Errorf("%w: raw config is not valid JSON: %v", ErrInvalidSource, err)
	}
	if config == nil {
		return nil, fmt.Errorf("%w: raw config is not a JSON object", ErrInvalidSource)
	}
	inbounds, err := buildInbounds(settings)
	if err != nil {
		return nil, err
	}
	encodedInbounds, err := singjson.MarshalContext(context.Background(), inbounds)
	if err != nil {
		return nil, fmt.Errorf("marshal inbounds: %w", err)
	}
	var inboundList []any
	if err := json.Unmarshal(encodedInbounds, &inboundList); err != nil {
		return nil, fmt.Errorf("decode inbounds: %w", err)
	}
	config["inbounds"] = inboundList

	migrateLegacyTransports(config)
	migrateLegacyDnsOutbound(config)
	normalizeAnyTlsAlpn(config)
	mergeCacheFile(config, settings.CacheFilePath)
	applyRawRouteMode(config, settings.RouteMode)
	content, err := json.Marshal(config)
	if err != nil {
		return nil, err
	}
	if err := validateConfig(content); err != nil {
		return nil, fmt.Errorf("%w: validate config: %v", ErrInvalidSource, err)
	}
	return content, nil
}

func applyRawRouteMode(config map[string]any, mode RouteMode) {
	if mode == "" || mode == RouteModeRule {
		return
	}
	route, _ := config["route"].(map[string]any)
	if route == nil {
		route = map[string]any{}
		config["route"] = route
	}
	delete(route, "rules")
	if mode == RouteModeDirect {
		route["final"] = "direct"
		return
	}
	if mode == RouteModeAll {
		if proxy := primaryProxyOutbound(config); proxy != "" {
			route["final"] = proxy
		}
	}
}

func primaryProxyOutbound(config map[string]any) string {
	outbounds, _ := config["outbounds"].([]any)
	for _, raw := range outbounds {
		outbound, ok := raw.(map[string]any)
		if !ok {
			continue
		}
		tag, _ := outbound["tag"].(string)
		if tag == "proxy" {
			return tag
		}
	}
	for _, raw := range outbounds {
		outbound, ok := raw.(map[string]any)
		if !ok {
			continue
		}
		typ, _ := outbound["type"].(string)
		tag, _ := outbound["tag"].(string)
		if tag != "" && typ != "direct" && typ != "block" {
			return tag
		}
	}
	return ""
}

func decodeJSONNumber(content []byte, target any) error {
	decoder := json.NewDecoder(bytes.NewReader(content))
	decoder.UseNumber()
	if err := decoder.Decode(target); err != nil {
		return err
	}
	if err := decoder.Decode(&struct{}{}); err != io.EOF {
		return fmt.Errorf("multiple JSON values")
	}
	return nil
}

// migrateLegacyTransports 把 transport.host 迁移到 transport.headers.Host
// （sing-box 移除了 transport.host 字段）。
func migrateLegacyTransports(config map[string]any) {
	outbounds, ok := config["outbounds"].([]any)
	if !ok {
		return
	}
	for _, rawOutbound := range outbounds {
		outbound, ok := rawOutbound.(map[string]any)
		if !ok {
			continue
		}
		transport, ok := outbound["transport"].(map[string]any)
		if !ok {
			continue
		}
		host, exists := transport["host"]
		if !exists {
			continue
		}
		delete(transport, "host")
		if host == nil {
			continue
		}
		headers, _ := transport["headers"].(map[string]any)
		if headers == nil {
			headers = map[string]any{}
		}
		hasHost := false
		for key := range headers {
			if strings.EqualFold(key, "host") {
				hasHost = true
				break
			}
		}
		if !hasHost {
			headers["Host"] = host
		}
		transport["headers"] = headers
	}
}

// migrateLegacyDnsOutbound 移除 1.13 起删除的 dns outbound，
// 并把引用它的规则改写为 hijack-dns action。
func migrateLegacyDnsOutbound(config map[string]any) {
	outbounds, ok := config["outbounds"].([]any)
	if !ok {
		return
	}
	dnsTags := map[string]bool{}
	filtered := outbounds[:0]
	for _, rawOutbound := range outbounds {
		outbound, isMap := rawOutbound.(map[string]any)
		if isMap {
			if typ, _ := outbound["type"].(string); typ == "dns" {
				if tag, _ := outbound["tag"].(string); tag != "" {
					dnsTags[tag] = true
				}
				continue
			}
		}
		filtered = append(filtered, rawOutbound)
	}
	if len(dnsTags) == 0 {
		return
	}
	config["outbounds"] = filtered
	route, ok := config["route"].(map[string]any)
	if !ok {
		return
	}
	rules, ok := route["rules"].([]any)
	if !ok {
		return
	}
	for _, rawRule := range rules {
		rule, ok := rawRule.(map[string]any)
		if !ok {
			continue
		}
		outbound, _ := rule["outbound"].(string)
		if !dnsTags[outbound] {
			continue
		}
		delete(rule, "outbound")
		rule["action"] = "hijack-dns"
	}
}

// normalizeAnyTlsAlpn 剥离 anytls outbound 的 alpn：anytls 不协商 ALPN，
// 机场下发的 alpn:["h3"] 会导致 no_application_protocol TLS 告警。
func normalizeAnyTlsAlpn(config map[string]any) {
	outbounds, ok := config["outbounds"].([]any)
	if !ok {
		return
	}
	for _, rawOutbound := range outbounds {
		outbound, ok := rawOutbound.(map[string]any)
		if !ok {
			continue
		}
		if typ, _ := outbound["type"].(string); typ != "anytls" {
			continue
		}
		if tls, ok := outbound["tls"].(map[string]any); ok {
			delete(tls, "alpn")
		}
	}
}

func mergeCacheFile(config map[string]any, cacheFilePath string) {
	path := strings.TrimSpace(cacheFilePath)
	if path == "" {
		return
	}
	experimental, _ := config["experimental"].(map[string]any)
	if experimental == nil {
		experimental = map[string]any{}
		config["experimental"] = experimental
	}
	cacheFile, _ := experimental["cache_file"].(map[string]any)
	if cacheFile == nil {
		cacheFile = map[string]any{}
	}
	cacheFile["enabled"] = true
	cacheFile["path"] = singBoxPath(path)
	experimental["cache_file"] = cacheFile
}
