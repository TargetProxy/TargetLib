// Package profile 定义 TargetLib 的配置中间表示。
// 来源适配器产出 Profile，只有 config 包负责将其转换为可运行的 sing-box 配置。
package profile

import "github.com/sagernet/sing-box/option"

type NodePhase string

const (
	NodeDiscovered NodePhase = "discovered"
	NodeNormalized NodePhase = "normalized"
	NodeReady      NodePhase = "ready"
	NodeFailed     NodePhase = "failed"
)

// Node 是订阅解析后的类型化节点中间态。
type Node struct {
	ID             string           `json:"id"`
	SubscriptionID string           `json:"subscription_id,omitempty"`
	Name           string           `json:"name"`
	Type           string           `json:"type"`
	CountryCode    string           `json:"country_code,omitempty"`
	Server         string           `json:"server,omitempty"`
	Port           int              `json:"port,omitempty"`
	Phase          NodePhase        `json:"phase"`
	Error          string           `json:"error,omitempty"`
	Outbound       *option.Outbound `json:"-" cbor:"-"`
}

func (n *Node) IsAvailable() bool {
	return n.Outbound != nil && n.Phase != NodeFailed
}

// Profile 是传给 config.Build 的节点快照。
type Profile struct {
	Nodes []Node
}
