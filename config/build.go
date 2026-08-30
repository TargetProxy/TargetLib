package config

import (
	"fmt"
	"net/netip"
	"path/filepath"
	"runtime"
	"strings"
	"time"

	C "github.com/sagernet/sing-box/constant"
	"github.com/sagernet/sing-box/option"
	singjson "github.com/sagernet/sing/common/json"
	"github.com/sagernet/sing/common/json/badoption"

	targetprofile "github.com/loafman1120/TargetLib/profile"
)

const (
	urlTestURL         = "https://www.gstatic.com/generate_204"
	urlTestInterval    = 5 * time.Minute
	urlTestTolerance   = 50
	geoIPCNRuleSetTag  = "geoip-cn"
	geoIPCNRuleSetPath = "cn.srs"
	tunInterfaceName   = "target0"
	tunMTU             = 1500
	tunDNSPublicTag    = "public-dns"
	tunDNSPublicAddr   = "119.29.29.29"
)

// TUN 前缀是全平台唯一的地址来源。Android 的 VpnService 在 establish()
// 之前经 JNI 读取同一常量来配置内核接口，因此两侧永远不可能漂移。
const (
	tunIPv4Address    = "172.18.0.1"
	tunIPv4PrefixBits = 30
)

// TunIPv4Address 返回 TUN 入站使用的 IPv4 地址。
func TunIPv4Address() string { return tunIPv4Address }

// TunIPv4PrefixBits 返回 TUN IPv4 地址的前缀长度。
func TunIPv4PrefixBits() int32 { return tunIPv4PrefixBits }

// RoutePlan 保存路由决策；Base 仅承载未被 TargetLib 接管的上游字段。
type RoutePlan struct {
	Base                option.RouteOptions
	Rules               []option.Rule
	RuleSets            []option.RuleSet
	Final               string
	AutoDetectInterface bool
}

// RuntimePlan 保存日志、缓存和上游运行时元数据。
type RuntimePlan struct {
	Schema       string
	Log          option.LogOptions
	NTP          *option.NTPOptions
	Certificate  *option.CertificateOptions
	Endpoints    []option.Endpoint
	Services     []option.Service
	Experimental option.ExperimentalOptions
}

// Blueprint 是按配置 section 划分的最终计划。Emit 不再推断或修补配置。
type Blueprint struct {
	Inbounds  []option.Inbound
	Outbounds []option.Outbound
	DNS       *option.DNSOptions
	Route     RoutePlan
	Runtime   RuntimePlan
}

// Plan 将应用设置和订阅中间态解析为结构化的、应用拥有的运行配置计划。
// 订阅只贡献可用节点；其 DNS、路由、运行时和出站组合配置均不透传。
func Plan(settings Settings, source targetprofile.Profile) (Blueprint, error) {
	if err := settings.Validate(); err != nil {
		return Blueprint{}, err
	}
	inbounds, err := buildInbounds(settings)
	if err != nil {
		return Blueprint{}, err
	}
	outbounds, finalOutbound, err := planOutbounds(source.Nodes)
	if err != nil {
		return Blueprint{}, err
	}
	route := planRoute(finalOutbound, settings)
	dns, err := planDNS(settings.ProxyMode == ProxyModeTun)
	if err != nil {
		return Blueprint{}, err
	}
	return Blueprint{Inbounds: inbounds, Outbounds: outbounds, DNS: dns, Route: route,
		Runtime: planRuntime(settings)}, nil
}

// Emit 将 Blueprint 序列化并校验，不包含配置决策。
func Emit(plan Blueprint) ([]byte, error) {
	experimental := plan.Runtime.Experimental
	config := option.Options{
		Schema: plan.Runtime.Schema, Log: &plan.Runtime.Log, DNS: plan.DNS, NTP: plan.Runtime.NTP,
		Certificate: plan.Runtime.Certificate, Endpoints: plan.Runtime.Endpoints,
		Inbounds: plan.Inbounds, Outbounds: plan.Outbounds,
		Route:    emitRoute(plan.Route),
		Services: plan.Runtime.Services, Experimental: &experimental,
	}
	content, err := singjson.MarshalContext(targetprofile.Context(), &config)
	if err != nil {
		return nil, err
	}
	if err := validateConfig(content); err != nil {
		return nil, fmt.Errorf("validate generated config: %w", err)
	}
	return content, nil
}

// Build 保留稳定的公开入口。
func Build(settings Settings, source targetprofile.Profile) ([]byte, error) {
	plan, err := Plan(settings, source)
	if err != nil {
		return nil, err
	}
	return Emit(plan)
}

func planOutbounds(nodes []targetprofile.Node) ([]option.Outbound, string, error) {
	outbounds := make([]option.Outbound, 0, len(nodes)+3)
	nodeTags := make([]string, 0, len(nodes))
	used := map[string]bool{"direct": true, "urltest": true, "proxy": true}
	for _, node := range nodes {
		if node.Phase == targetprofile.NodeFailed || node.Outbound == nil {
			continue
		}
		tag := strings.TrimSpace(node.ID)
		if tag == "" {
			continue
		}
		if used[tag] {
			return nil, "", fmt.Errorf("%w: outbound tag %q is reserved or duplicated", ErrInvalidSource, tag)
		}
		outbound := *node.Outbound
		outbound.Tag = tag
		outbounds = append(outbounds, outbound)
		nodeTags = append(nodeTags, tag)
		used[tag] = true
	}
	outbounds = append(outbounds, option.Outbound{Type: "direct", Tag: "direct", Options: option.DirectOutboundOptions{}})
	if len(nodeTags) == 0 {
		return outbounds, "direct", nil
	}
	outbounds = append(outbounds, option.Outbound{Type: "urltest", Tag: "urltest", Options: option.URLTestOutboundOptions{
		Outbounds: append([]string(nil), nodeTags...), URL: urlTestURL, Interval: badoption.Duration(urlTestInterval), Tolerance: urlTestTolerance,
	}})
	members := append([]string{"urltest"}, nodeTags...)
	members = append(members, "direct")
	outbounds = append(outbounds, option.Outbound{Type: "selector", Tag: "proxy", Options: option.SelectorOutboundOptions{Outbounds: members, Default: "urltest"}})
	return outbounds, "proxy", nil
}

// planDNS 只生成应用侧需要的 DNS；订阅提供的 DNS 永不透传。
func planDNS(tunMode bool) (*option.DNSOptions, error) {
	if tunMode {
		return defaultTunDNS(), nil
	}
	return nil, nil
}

func defaultTunDNS() *option.DNSOptions {
	return &option.DNSOptions{RawDNSOptions: option.RawDNSOptions{
		Servers: []option.DNSServerOptions{{
			Type: C.DNSTypeUDP,
			Tag:  tunDNSPublicTag,
			Options: &option.RemoteDNSServerOptions{DNSServerAddressOptions: option.DNSServerAddressOptions{
				Server: tunDNSPublicAddr,
			}},
		}},
		Final: tunDNSPublicTag,
	}}
}

func tunDNSHijackRule() option.Rule {
	return option.Rule{
		Type: C.RuleTypeDefault,
		DefaultOptions: option.DefaultRule{
			RawDefaultRule: option.RawDefaultRule{Port: badoption.Listable[uint16]{53}},
			RuleAction:     option.RuleAction{Action: C.RuleActionTypeHijackDNS},
		},
	}
}

func sniffRule() option.Rule {
	return option.Rule{
		Type: C.RuleTypeDefault,
		DefaultOptions: option.DefaultRule{
			RuleAction: option.RuleAction{Action: C.RuleActionTypeSniff},
		},
	}
}

func geoIPCNRule() option.Rule {
	return option.Rule{
		Type: C.RuleTypeDefault,
		DefaultOptions: option.DefaultRule{
			RawDefaultRule: option.RawDefaultRule{RuleSet: badoption.Listable[string]{geoIPCNRuleSetTag}},
			RuleAction: option.RuleAction{
				Action:       C.RuleActionTypeRoute,
				RouteOptions: option.RouteActionOptions{Outbound: "direct"},
			},
		},
	}
}

func geoIPCNRuleSet() option.RuleSet {
	return option.RuleSet{
		Type:         C.RuleSetTypeLocal,
		Tag:          geoIPCNRuleSetTag,
		Format:       C.RuleSetFormatBinary,
		LocalOptions: option.LocalRuleSet{Path: geoIPCNRuleSetPath},
	}
}

func planRoute(finalOutbound string, settings Settings) RoutePlan {
	// Route starts empty. In particular, never retain provider rule_set entries
	// or rules that refer to provider-owned outbound tags.
	base := option.RouteOptions{}
	rules := []option.Rule{sniffRule()}
	if settings.ProxyMode == ProxyModeTun {
		rules = append(rules, tunDNSHijackRule())
	}
	var ruleSets []option.RuleSet
	final := finalOutbound
	switch settings.RouteMode {
	case RouteModeDirect:
		final = "direct"
	case RouteModeAll:
		final = finalOutbound
	case RouteModeRule:
		// Provider rules remain isolated. Rule mode only applies TargetLib's
		// runtime-directory-local China GeoIP rule set.
		ruleSets = append(ruleSets, geoIPCNRuleSet())
		rules = append(rules, geoIPCNRule())
	}
	return RoutePlan{Base: base, Rules: rules, RuleSets: ruleSets, Final: final, AutoDetectInterface: true}
}

// emitRoute 将已完成决策的路由计划映射为 sing-box 对象。
func emitRoute(plan RoutePlan) *option.RouteOptions {
	route := plan.Base
	route.Rules = plan.Rules
	route.RuleSet = plan.RuleSets
	route.Final = plan.Final
	route.AutoDetectInterface = plan.AutoDetectInterface
	return &route
}

func planRuntime(settings Settings) RuntimePlan {
	experimental := option.ExperimentalOptions{}
	// TargetLib owns telemetry and cache storage regardless of upstream metadata.
	experimental.ClashAPI = &option.ClashAPIOptions{}
	if path := strings.TrimSpace(settings.CacheFilePath); path != "" {
		experimental.CacheFile = &option.CacheFileOptions{Enabled: true, Path: singBoxPath(path)}
	}
	return RuntimePlan{
		Log: option.LogOptions{Level: "error", Output: "target.log", Timestamp: true}, Experimental: experimental,
	}
}

func validateConfig(content []byte) error {
	_, err := singjson.UnmarshalExtendedContext[option.Options](targetprofile.Context(), content)
	return err
}

// buildInbounds 生成应用拥有的入站面。订阅透传配置不得自带 inbounds
// （机场常带需管理员权限的 tun），入站主权始终在应用侧。
func buildInbounds(settings Settings) ([]option.Inbound, error) {
	var inbounds []option.Inbound
	if settings.ProxyMode == ProxyModeMixed {
		address, err := netip.ParseAddr(strings.TrimSpace(settings.ListenAddress))
		if err != nil {
			return nil, fmt.Errorf("%w: listen address %q is not a valid IP address", ErrInvalidSettings, settings.ListenAddress)
		}
		listen := badoption.Addr(address)
		inbounds = append(inbounds, option.Inbound{
			Type: "mixed", Tag: "mixed",
			Options: option.HTTPMixedInboundOptions{
				ListenOptions: option.ListenOptions{Listen: &listen, ListenPort: uint16(settings.MixedPort)},
			},
		})
	}
	if settings.ProxyMode == ProxyModeTun {
		// Android VpnService 用 TunIPv4Address/PrefixBits 配置同一前缀。
		addresses := []netip.Prefix{
			netip.PrefixFrom(netip.MustParseAddr(tunIPv4Address), tunIPv4PrefixBits),
		}
		if settings.IPv6 {
			addresses = append(addresses, netip.MustParsePrefix("fd00:1:fd00:1::1/126"))
		}
		inbounds = append(inbounds, option.Inbound{
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
