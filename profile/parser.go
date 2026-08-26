package profile

import (
	"bytes"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"strings"

	C "github.com/sagernet/sing-box/constant"
	"github.com/sagernet/sing-box/option"
	singjson "github.com/sagernet/sing/common/json"
)

type Parsed struct {
	Profile   Profile
	NodesHash string
}

func Parse(raw []byte) (Parsed, error) {
	if len(bytes.TrimSpace(raw)) == 0 {
		return Parsed{}, errors.New("parse profile JSON: empty input")
	}
	var document map[string]any
	if err := decodeJSONNumber(raw, &document); err != nil {
		return Parsed{}, fmt.Errorf("parse profile JSON: %w", err)
	}
	if document == nil {
		return Parsed{}, errors.New("parse profile JSON: not a JSON object")
	}

	typedContent, err := json.Marshal(map[string]any{
		"outbounds": document["outbounds"],
	})
	if err != nil {
		return Parsed{}, fmt.Errorf("normalize profile JSON: %w", err)
	}
	options, err := singjson.UnmarshalExtendedContext[option.Options](Context(), typedContent)
	if err != nil {
		return Parsed{}, fmt.Errorf("decode sing-box profile: %w", err)
	}

	result := Profile{}
	rawOutbounds, _ := document["outbounds"].([]any)
	nodes := make([]Node, 0, len(options.Outbounds))
	seen := make(map[string]int)
	for index := range options.Outbounds {
		outbound := options.Outbounds[index]
		if outbound.Type == "selector" || outbound.Type == "urltest" || !isNodeType(outbound.Type) {
			continue
		}
		rawOutbound, _ := rawOutbounds[index].(map[string]any)
		name := strings.TrimSpace(outbound.Tag)
		if name == "" {
			name = outbound.Type
		}
		server := valueToString(valueFrom(rawOutbound, "server", "address"))
		port, _ := toInt(valueFrom(rawOutbound, "server_port", "port"))
		baseID := nodeID(outbound.Type + "\x00" + name)
		id := baseID
		if seen[baseID] > 0 {
			id = fmt.Sprintf("%s-%d", baseID, seen[baseID]+1)
		}
		seen[baseID]++
		typedOutbound := outbound
		outboundJSON, _ := json.Marshal(rawOutbound)
		if len(outboundJSON) == 0 || string(outboundJSON) == "null" {
			outboundJSON, _ = json.Marshal(outbound)
		}
		node := Node{
			ID:           id,
			Name:         name,
			Type:         outbound.Type,
			Server:       server,
			Port:         port,
			Phase:        NodeNormalized,
			OutboundJSON: outboundJSON,
			Outbound:     &typedOutbound,
		}
		if requiresServerEndpoint(outbound.Type) && (server == "" || port < 1 || port > 65535) {
			node.Phase = NodeFailed
			node.Error = "server or server_port is invalid"
		} else {
			node.Phase = NodeReady
		}
		nodes = append(nodes, node)
	}
	if len(nodes) == 0 {
		return Parsed{}, errors.New("profile has no usable outbounds")
	}
	result.Nodes = nodes
	sum := sha256.Sum256(canonicalNodeBytes(nodes))
	return Parsed{Profile: result, NodesHash: hex.EncodeToString(sum[:])}, nil
}

func isNodeType(value string) bool {
	switch value {
	case C.TypeSOCKS,
		C.TypeHTTP,
		C.TypeShadowsocks,
		C.TypeVMess,
		C.TypeTrojan,
		C.TypeNaive,
		C.TypeHysteria,
		C.TypeTor,
		C.TypeSSH,
		C.TypeShadowTLS,
		C.TypeAnyTLS,
		C.TypeShadowsocksR,
		C.TypeVLESS,
		C.TypeTUIC,
		C.TypeHysteria2:
		return true
	default:
		return false
	}
}

func requiresServerEndpoint(value string) bool {
	return value != C.TypeTor
}

func canonicalNodeBytes(nodes []Node) []byte {
	content, _ := json.Marshal(nodes)
	return content
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

func valueFrom(config map[string]any, keys ...string) any {
	for _, key := range keys {
		if value, ok := config[key]; ok && value != nil {
			return value
		}
	}
	return nil
}

func valueToString(value any) string {
	if value == nil {
		return ""
	}
	if text, ok := value.(string); ok {
		return text
	}
	return fmt.Sprint(value)
}

func toInt(value any) (int, bool) {
	switch typed := value.(type) {
	case json.Number:
		value, err := typed.Int64()
		return int(value), err == nil && int64(int(value)) == value
	case float64:
		value := int(typed)
		return value, float64(value) == typed
	case int:
		return typed, true
	case string:
		var value int
		_, err := fmt.Sscan(typed, &value)
		return value, err == nil
	default:
		return 0, false
	}
}

func nodeID(value string) string {
	sum := sha256.Sum256([]byte(strings.ToLower(value)))
	return hex.EncodeToString(sum[:8])
}
