// Package profile 定义 TargetLib 的配置中间表示。
// 来源适配器产出 Profile，只有 config 包负责将其转换为可运行的 sing-box 配置。
package profile

import (
	"encoding/json"

	"github.com/sagernet/sing-box/option"
)

type NodePhase string

const (
	NodeDiscovered NodePhase = "discovered"
	NodeNormalized NodePhase = "normalized"
	NodeReady      NodePhase = "ready"
	NodeFailed     NodePhase = "failed"
)

type Node struct {
	ID           string          `json:"id"`
	Name         string          `json:"name"`
	Type         string          `json:"type"`
	CountryCode  string          `json:"country_code,omitempty"`
	Server       string          `json:"server,omitempty"`
	Port         int             `json:"port,omitempty"`
	Phase        NodePhase       `json:"phase"`
	Error        string          `json:"error,omitempty"`
	OutboundJSON json.RawMessage `json:"outbound_json,omitempty"`
	// Outbound 保留运行时使用的类型化配置，不直接参与 JSON/CBOR 持久化。
	Outbound *option.Outbound `json:"-" cbor:"-"`
}

// Profile 是传给 config.Build 的节点快照。
type Profile struct {
	Nodes []Node
}
