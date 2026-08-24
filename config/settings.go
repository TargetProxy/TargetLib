// Package config 把应用设置与订阅中间态合成为可运行的 sing-box 配置。
//
// 输入有两种来源：
//   - BuildFromNodes：消费 subscriptions 包的中间态（Node.Config），把每个节点
//     规范化为标准 outbound 后套上 urltest/selector 骨架；
//   - BuildFromRaw：透传订阅原始配置，替换 inbounds（应用拥有入站主权），
//     迁移遗留写法并注入 cache_file。
//
// 规范化刻意发生在构建时而非解析时：中间态（RawHash、已存储节点）保持稳定，
// 骨架则用 sing-box option 包类型安全生成。
package config

import (
	"errors"
	"fmt"
	"strings"
)

var (
	ErrInvalidSettings = errors.New("invalid build settings")
	ErrInvalidSource   = errors.New("invalid config source")
)

type ProxyMode string

const (
	ProxyModeMixed ProxyMode = "mixed"
	ProxyModeTun   ProxyMode = "tun"
)

type RouteMode string

const (
	RouteModeRule   RouteMode = "rule"
	RouteModeDirect RouteMode = "direct"
	RouteModeAll    RouteMode = "all"
)

type Settings struct {
	ListenAddress string
	MixedPort     int
	ProxyMode     ProxyMode
	IPv6          bool
	CacheFilePath string
	RouteMode     RouteMode
}

func (s Settings) Validate() error {
	address := strings.TrimSpace(s.ListenAddress)
	if address == "" || strings.ContainsAny(address, "\r\n") {
		return fmt.Errorf("%w: listen address must be a single non-empty address", ErrInvalidSettings)
	}
	if s.MixedPort <= 0 || s.MixedPort >= 65536 {
		return fmt.Errorf("%w: mixed port must be between 1 and 65535", ErrInvalidSettings)
	}
	switch s.ProxyMode {
	case ProxyModeMixed, ProxyModeTun:
	default:
		return fmt.Errorf("%w: unknown proxy mode %q", ErrInvalidSettings, s.ProxyMode)
	}
	if s.RouteMode == "" {
		s.RouteMode = RouteModeRule
	}
	switch s.RouteMode {
	case RouteModeDirect, RouteModeRule, RouteModeAll:
	default:
		return fmt.Errorf("%w: unknown route mode %q", ErrInvalidSettings, s.RouteMode)
	}
	return nil
}
