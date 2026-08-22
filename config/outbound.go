package config

import (
	"encoding/json"
	"fmt"
	"math"
	"strconv"
	"strings"

	"github.com/sagernet/sing-box/option"
	singjson "github.com/sagernet/sing/common/json"
)

// outboundTypeAliases 把订阅里可能出现的旧式类型名映射到 sing-box 规范名。
var outboundTypeAliases = map[string]string{
	"ss":          "shadowsocks",
	"shadowsocks": "shadowsocks",
	"socks5":      "socks",
	"hy2":         "hysteria2",
	"tuic-v5":     "tuic",
	"naiveproxy":  "naive",
	"shadow-tls":  "shadowtls",
	"any-tls":     "anytls",
}

var supportedOutboundTypes = map[string]bool{
	"shadowsocks": true,
	"vmess":       true,
	"vless":       true,
	"trojan":      true,
	"hysteria2":   true,
	"tuic":        true,
	"naive":       true,
	"shadowtls":   true,
	"anytls":      true,
	"socks":       true,
	"http":        true,
}

var outboundRequiredFields = map[string][]string{
	"shadowsocks": {"method", "password"},
	"vmess":       {"uuid"},
	"vless":       {"uuid"},
	"trojan":      {"password"},
	"hysteria2":   {"password"},
	"anytls":      {"password"},
	"shadowtls":   {"password"},
	"tuic":        {"uuid", "password"},
	"naive":       {"username", "password"},
}

// NormalizeOutbound 把中间态节点配置（订阅原始 outbound map）规范化为标准
// sing-box outbound：类型别名归一、凭据字段提取、TLS 合成、传输层修正。
// 失败时返回错误，调用方应跳过该节点（与 Dart 端 _outbound 返回 null 一致）。
func NormalizeOutbound(tag, nodeType string, config map[string]any) (map[string]any, error) {
	server := valueToString(valueFrom(config, "server", "address"))
	serverPort, portOK := toInt(valueFrom(config, "port", "server_port"))
	if server == "" || !portOK {
		return nil, fmt.Errorf("outbound %q: server or port is missing", tag)
	}

	typ := strings.ToLower(strings.TrimSpace(nodeType))
	if canonical, ok := outboundTypeAliases[typ]; ok {
		typ = canonical
	}
	if !supportedOutboundTypes[typ] {
		return nil, fmt.Errorf("outbound %q: unsupported type %q", tag, nodeType)
	}

	outbound := map[string]any{
		"type":        typ,
		"tag":         tag,
		"server":      server,
		"server_port": serverPort,
	}
	copyField := func(target string, sources ...string) {
		if len(sources) == 0 {
			sources = []string{target}
		}
		if value := valueFrom(config, sources...); value != nil {
			outbound[target] = value
		}
	}

	switch typ {
	case "shadowsocks":
		copyField("method", "cipher", "method")
		copyField("password")
	case "vmess":
		copyField("uuid")
		copyField("security", "cipher", "security")
		if _, ok := outbound["security"]; !ok {
			outbound["security"] = "auto"
		}
		if alterID, ok := toInt(valueFrom(config, "alterId", "alter_id")); ok {
			outbound["alter_id"] = alterID
		} else {
			outbound["alter_id"] = 0
		}
	case "vless":
		copyField("uuid")
		copyField("flow")
	case "trojan", "hysteria2", "anytls":
		copyField("password", "password", "auth", "auth-str")
	case "tuic":
		copyField("uuid")
		copyField("password")
		copyField("congestion_control")
	case "naive":
		copyField("username", "username", "user")
		copyField("password")
	case "shadowtls":
		if version, ok := toInt(valueFrom(config, "version")); ok {
			outbound["version"] = version
		} else {
			outbound["version"] = 3
		}
		copyField("password")
	case "socks", "http":
		copyField("username")
		copyField("password")
	}

	if requiresTLS(typ, config) {
		sourceTLS, _ := config["tls"].(map[string]any)
		if sourceTLS == nil {
			sourceTLS = map[string]any{}
		}
		serverName := valueFrom(sourceTLS, "server_name")
		if serverName == nil {
			serverName = valueFrom(config, "sni")
		}
		if serverName == nil {
			serverName = server
		}
		tlsConfig := map[string]any{"enabled": true, "server_name": serverName}
		if insecure := valueFrom(sourceTLS, "insecure"); insecure != nil {
			tlsConfig["insecure"] = insecure
		} else {
			tlsConfig["insecure"] = config["skip-cert-verify"] == true
		}
		if reality, ok := config["reality"].(map[string]any); ok && reality["public_key"] != nil {
			realityConfig := map[string]any{"enabled": true, "public_key": reality["public_key"]}
			if shortID := valueFrom(reality, "short_id"); shortID != nil {
				realityConfig["short_id"] = shortID
			} else {
				realityConfig["short_id"] = ""
			}
			tlsConfig["reality"] = realityConfig
		}
		outbound["tls"] = tlsConfig
	}

	if transport, ok := config["transport"].(map[string]any); ok {
		if transportType, _ := transport["type"].(string); transportType != "" {
			normalized := make(map[string]any, len(transport))
			for key, value := range transport {
				normalized[key] = value
			}
			if transportType == "web-socket" {
				normalized["type"] = "ws"
			}
			outbound["transport"] = normalized
		}
	}

	for _, field := range outboundRequiredFields[typ] {
		if _, ok := outbound[field]; !ok {
			return nil, fmt.Errorf("outbound %q: missing required field %q", tag, field)
		}
	}
	encoded, err := json.Marshal(outbound)
	if err != nil {
		return nil, fmt.Errorf("outbound %q: marshal for validation: %w", tag, err)
	}
	var validated option.Outbound
	if err := singjson.UnmarshalContext(validationContext(), encoded, &validated); err != nil {
		return nil, fmt.Errorf("outbound %q: validate: %w", tag, err)
	}
	return outbound, nil
}

func requiresTLS(typ string, config map[string]any) bool {
	switch typ {
	case "trojan", "hysteria2", "tuic", "naive", "anytls":
		return true
	}
	switch tls := config["tls"].(type) {
	case bool:
		return tls
	case string:
		return tls == "tls"
	case map[string]any:
		return true
	}
	_, hasReality := config["reality"].(map[string]any)
	return hasReality
}

// valueFrom 取第一个存在且非 nil 的键值，对应 Dart 的 `a ?? b` 取值语义。
func valueFrom(config map[string]any, keys ...string) any {
	for _, key := range keys {
		if value, ok := config[key]; ok && value != nil {
			return value
		}
	}
	return nil
}

func valueToString(value any) string {
	switch v := value.(type) {
	case nil:
		return ""
	case string:
		return v
	default:
		return fmt.Sprint(v)
	}
}

func toInt(value any) (int, bool) {
	switch v := value.(type) {
	case float64:
		if v == math.Trunc(v) && v >= math.MinInt && v <= math.MaxInt {
			return int(v), true
		}
		return 0, false
	case int:
		return v, true
	case int64:
		return int(v), true
	case json.Number:
		n, err := strconv.ParseInt(string(v), 10, 64)
		if err != nil || n < math.MinInt || n > math.MaxInt {
			return 0, false
		}
		return int(n), true
	case string:
		if n, err := strconv.Atoi(v); err == nil {
			return n, true
		}
		return 0, false
	default:
		return 0, false
	}
}
