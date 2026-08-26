package subscriptions

import targetprofile "github.com/loafman1120/TargetLib/profile"

type ParsedProfile struct {
	targetprofile.Profile
	NodesHash string
}

// ParseProfile 将 sing-box JSON 来源转换为 TargetLib 的节点中间表示。
// 运行配置生成只依赖 Nodes。
func ParseProfile(body []byte) (ParsedProfile, error) {
	parsed, err := targetprofile.Parse(body)
	if err != nil {
		return ParsedProfile{}, err
	}
	return ParsedProfile{
		Profile:   parsed.Profile,
		NodesHash: parsed.NodesHash,
	}, nil
}
