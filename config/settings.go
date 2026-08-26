// Package config 把应用设置与订阅中间态合成为可运行的 sing-box 配置。
//
// 所有来源先解析为 profile.Profile；Build 是唯一最终配置生成入口。
// 运行时只消费节点快照，不透传服务商的 rule、DNS 或入站配置。
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
