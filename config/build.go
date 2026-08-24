package config

import (
	"context"
	"encoding/json"
	"fmt"
	"net/netip"
	"path/filepath"
	"runtime"
	"strings"
	"sync"
	"time"

	box "github.com/sagernet/sing-box"
	"github.com/sagernet/sing-box/include"
	"github.com/sagernet/sing-box/option"
	singjson "github.com/sagernet/sing/common/json"
	"github.com/sagernet/sing/common/json/badoption"

	"github.com/loafman1120/TargetLib/subscriptions"
)

const (
	urlTestURL       = "https://www.gstatic.com/generate_204"
	urlTestInterval  = 5 * time.Minute
	urlTestTolerance = 50
	tunInterfaceName = "target0"
	tunMTU           = 1500
)

// builtConfig 的骨架字段用 sing-box option 包类型安全生成；outbounds 由
// 规范化后的节点 map 与 option 类型的分组混合组成，经 json.RawMessage 拼装。
type builtConfig struct {
	Inbounds     []*option.Inbound           `json:"inbounds"`
	Outbounds    []json.RawMessage           `json:"outbounds"`
	Route        option.RouteOptions         `json:"route"`
	Experimental *option.ExperimentalOptions `json:"experimental,omitempty"`
}

// BuildFromNodes 消费订阅中间态（含 Node.Config 的节点列表），合成完整配置。
// 规范化失败的节点按 Dart 端行为直接跳过。
func BuildFromNodes(settings Settings, nodes []subscriptions.Node) ([]byte, error) {
	if err := settings.Validate(); err != nil {
		return nil, err
	}
	inbounds, err := buildInbounds(settings)
	if err != nil {
		return nil, err
	}
	outbounds := []json.RawMessage{mustMarshalOutbound(&option.Outbound{
		Type: "direct", Tag: "direct", Options: option.DirectOutboundOptions{},
	})}
	tags := make([]string, 0, len(nodes))
	for i := range nodes {
		node := &nodes[i]
		if node.Config == nil {
			continue
		}
		outbound, err := NormalizeOutbound(node.ID, node.Type, node.Config)
		if err != nil {
			continue
		}
		encoded, err := json.Marshal(outbound)
		if err != nil {
			return nil, fmt.Errorf("marshal outbound %q: %w", node.ID, err)
		}
		outbounds = append(outbounds, encoded)
		tags = append(tags, node.ID)
	}
	finalOutbound := "direct"
	if len(tags) > 0 {
		outbounds = append(outbounds,
			mustMarshalOutbound(&option.Outbound{
				Type: "urltest", Tag: "urltest",
				Options: option.URLTestOutboundOptions{
					Outbounds: tags,
					URL:       urlTestURL,
					Interval:  badoption.Duration(urlTestInterval),
					Tolerance: urlTestTolerance,
				},
			}),
			mustMarshalOutbound(&option.Outbound{
				Type: "selector", Tag: "proxy",
				Options: option.SelectorOutboundOptions{
					Outbounds: append(append([]string{"urltest"}, tags...), "direct"),
					Default:   "urltest",
				},
			}),
		)
		finalOutbound = "proxy"
	}
	finalOutbound = applyGeneratedRouteMode(finalOutbound, settings.RouteMode)
	config := builtConfig{
		Inbounds:  inbounds,
		Outbounds: outbounds,
		Route:     option.RouteOptions{AutoDetectInterface: true, Final: finalOutbound},
		// StartedService connection telemetry depends on the internal Clash API
		// traffic manager. No external controller is configured or exposed.
		Experimental: &option.ExperimentalOptions{ClashAPI: &option.ClashAPIOptions{}},
	}
	if path := strings.TrimSpace(settings.CacheFilePath); path != "" {
		config.Experimental.CacheFile = &option.CacheFileOptions{Enabled: true, Path: singBoxPath(path)}
	}
	content, err := singjson.MarshalContext(context.Background(), config)
	if err != nil {
		return nil, err
	}
	if err := validateConfig(content); err != nil {
		return nil, fmt.Errorf("validate generated config: %w", err)
	}
	return content, nil
}

func applyGeneratedRouteMode(finalOutbound string, mode RouteMode) string {
	switch mode {
	case RouteModeDirect:
		return "direct"
	case RouteModeAll, RouteModeRule:
		return finalOutbound
	default:
		return finalOutbound
	}
}

func validateConfig(content []byte) error {
	_, err := singjson.UnmarshalExtendedContext[option.Options](validationContext(), content)
	return err
}

var (
	validationContextOnce  sync.Once
	validationContextValue context.Context
)

func validationContext() context.Context {
	validationContextOnce.Do(func() {
		validationContextValue = box.Context(
			context.Background(),
			include.InboundRegistry(),
			include.OutboundRegistry(),
			include.EndpointRegistry(),
			include.DNSTransportRegistry(),
			include.ServiceRegistry(),
		)
	})
	return validationContextValue
}

// buildInbounds 生成应用拥有的入站面。订阅透传配置不得自带 inbounds
// （机场常带需管理员权限的 tun），入站主权始终在应用侧。
func buildInbounds(settings Settings) ([]*option.Inbound, error) {
	var inbounds []*option.Inbound
	if settings.ProxyMode == ProxyModeMixed {
		address, err := netip.ParseAddr(strings.TrimSpace(settings.ListenAddress))
		if err != nil {
			return nil, fmt.Errorf("%w: listen address %q is not a valid IP address", ErrInvalidSettings, settings.ListenAddress)
		}
		listen := badoption.Addr(address)
		inbounds = append(inbounds, &option.Inbound{
			Type: "mixed", Tag: "mixed",
			Options: option.HTTPMixedInboundOptions{
				ListenOptions: option.ListenOptions{Listen: &listen, ListenPort: uint16(settings.MixedPort)},
			},
		})
	}
	if settings.ProxyMode == ProxyModeTun {
		addresses := []netip.Prefix{netip.MustParsePrefix("172.18.0.1/30")}
		if settings.IPv6 {
			addresses = append(addresses, netip.MustParsePrefix("fd00:1:fd00:1::1/126"))
		}
		inbounds = append(inbounds, &option.Inbound{
			Type: "tun", Tag: "tun",
			Options: option.TunInboundOptions{
				InterfaceName:       tunInterfaceName,
				Address:             addresses,
				MTU:                 tunMTU,
				AutoRoute:           true,
				StrictRoute:         false,
				RouteExcludeAddress: []netip.Prefix{netip.MustParsePrefix("127.0.0.0/8")},
			},
		})
	}
	return inbounds, nil
}

func mustMarshalOutbound(outbound *option.Outbound) json.RawMessage {
	encoded, err := outbound.MarshalJSONContext(context.Background())
	if err != nil {
		// 仅由静态字面量构成，序列化不可能失败。
		panic(fmt.Sprintf("config: marshal outbound: %v", err))
	}
	return encoded
}

// singBoxPath 为 Windows 长路径添加 \\?\ 前缀（正斜杠形式），其余平台原样返回。
func singBoxPath(path string) string {
	if runtime.GOOS != "windows" {
		return path
	}
	absolute, err := filepath.Abs(path)
	if err != nil {
		absolute = path
	}
	absolute = strings.ReplaceAll(absolute, `\`, "/")
	if len(absolute) >= 2 && absolute[1] == ':' && isDriveLetter(absolute[0]) {
		return "//?/" + absolute
	}
	return absolute
}

func isDriveLetter(char byte) bool {
	return char >= 'A' && char <= 'Z' || char >= 'a' && char <= 'z'
}
