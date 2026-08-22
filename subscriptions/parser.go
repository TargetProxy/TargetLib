package subscriptions

import (
	"bytes"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"strings"

	"github.com/tidwall/gjson"
)

type ParsedProfile struct {
	RawConfig json.RawMessage
	RawHash   string
	Nodes     []Node
}

func ParseProfile(body []byte) (ParsedProfile, error) {
	if !gjson.ValidBytes(body) {
		return ParsedProfile{}, errors.New("parse subscription JSON: invalid JSON")
	}
	root := gjson.ParseBytes(body)
	if !root.IsObject() {
		return ParsedProfile{}, errors.New("parse subscription JSON: not a JSON object")
	}
	var normalizedValue any
	if err := decodeJSONNumber(body, &normalizedValue); err != nil {
		return ParsedProfile{}, fmt.Errorf("parse subscription JSON: %w", err)
	}
	outbounds := root.Get("outbounds")
	entries := outbounds.Array()
	if !outbounds.IsArray() || len(entries) == 0 {
		return ParsedProfile{}, errors.New("subscription has no outbounds")
	}
	nodes := make([]Node, 0, len(entries))
	seen := make(map[string]int)
	groups := make(map[string][]string)
	for _, entry := range entries {
		if typ := jsonString(entry, "type"); typ != "selector" && typ != "urltest" {
			continue
		}
		group := jsonString(entry, "tag")
		members := entry.Get("outbounds")
		if !members.IsArray() {
			continue
		}
		for _, member := range members.Array() {
			if member.Type == gjson.String {
				groups[member.Str] = append(groups[member.Str], group)
			}
		}
	}
	for _, entry := range entries {
		if !entry.IsObject() {
			continue
		}
		typ := strings.ToLower(strings.TrimSpace(jsonString(entry, "type")))
		if isControl(typ) {
			continue
		}
		name := strings.TrimSpace(jsonString(entry, "tag"))
		if name == "" {
			name = typ
		}
		server := strings.TrimSpace(jsonString(entry, "server"))
		port := jsonInt(entry, "server_port")
		if port == 0 {
			port = jsonInt(entry, "port")
		}
		id := nodeID(typ + "\x00" + name)
		if count := seen[id]; count > 0 {
			id = fmt.Sprintf("%s-%d", id, count+1)
		}
		seen[nodeID(typ+"\x00"+name)]++
		nodeGroups := append([]string(nil), groups[name]...)
		var config map[string]any
		if err := decodeJSONNumber([]byte(entry.Raw), &config); err != nil {
			return ParsedProfile{}, fmt.Errorf("parse outbound %q: %w", name, err)
		}
		node := Node{ID: id, Name: name, Type: typ, Server: server, Port: port, Groups: nodeGroups, Phase: NodeNormalized, Config: config}
		if len(nodeGroups) > 0 {
			node.Group = nodeGroups[0]
		}
		if typ == "" {
			node.Phase = NodeFailed
			node.Error = "type is missing"
		} else if server == "" || port < 1 || port > 65535 {
			node.Phase = NodeFailed
			node.Error = "server or server_port is invalid"
		} else {
			node.Phase = NodeReady
		}
		nodes = append(nodes, node)
	}
	if len(nodes) == 0 {
		return ParsedProfile{}, errors.New("subscription has no proxy nodes")
	}
	// 规范化为键排序的紧凑 JSON，使语义相同的配置产生稳定的 RawConfig 与 RawHash。
	normalized, err := json.Marshal(normalizedValue)
	if err != nil {
		return ParsedProfile{}, err
	}
	sum := sha256.Sum256(normalized)
	return ParsedProfile{RawConfig: normalized, RawHash: hex.EncodeToString(sum[:]), Nodes: nodes}, nil
}

func decodeJSONNumber(content []byte, target any) error {
	decoder := json.NewDecoder(bytes.NewReader(content))
	decoder.UseNumber()
	if err := decoder.Decode(target); err != nil {
		return err
	}
	if err := decoder.Decode(&struct{}{}); err != io.EOF {
		return errors.New("multiple JSON values")
	}
	return nil
}

// ParseNodes is retained as a small compatibility helper.
func ParseNodes(body []byte) ([]Node, error) {
	profile, err := ParseProfile(body)
	return profile.Nodes, err
}

// jsonString 读取字符串字段；类型不是字符串时视为缺失，与旧的类型断言语义一致。
func jsonString(entry gjson.Result, key string) string {
	value := entry.Get(key)
	if value.Type != gjson.String {
		return ""
	}
	return value.Str
}

// jsonInt 读取整数字段；类型不是数字时视为缺失。
func jsonInt(entry gjson.Result, key string) int {
	value := entry.Get(key)
	if value.Type != gjson.Number {
		return 0
	}
	return int(value.Int())
}

func isControl(typ string) bool {
	switch typ {
	case "direct", "block", "dns", "selector", "urltest":
		return true
	}
	return false
}
func nodeID(value string) string {
	sum := sha256.Sum256([]byte(strings.ToLower(value)))
	return hex.EncodeToString(sum[:8])
}
