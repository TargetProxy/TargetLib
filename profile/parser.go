package profile

import (
	"bytes"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"slices"
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
	var document struct {
		Outbounds []json.RawMessage `json:"outbounds"`
	}
	if err := decodeJSONNumber(raw, &document); err != nil {
		return Parsed{}, fmt.Errorf("parse profile JSON: %w", err)
	}

	nodes := make([]Node, 0, len(document.Outbounds))
	byID := make(map[string]int, len(document.Outbounds))
	ctx := Context()
	for _, rawEntry := range document.Outbounds {
		var fields struct {
			Type       string `json:"type"`
			Tag        any    `json:"tag"`
			Server     any    `json:"server"`
			ServerPort any    `json:"server_port"`
		}
		if err := decodeJSONNumber(rawEntry, &fields); err != nil {
			continue
		}
		outboundType := strings.TrimSpace(fields.Type)
		if !isNodeType(outboundType) {
			continue
		}

		tag, _ := fields.Tag.(string)
		name := strings.TrimSpace(tag)
		if name == "" {
			name = outboundType
		}
		node := Node{
			Name: name, Type: outboundType, CountryCode: inferCountryCode(name),
			Phase: NodeReady,
		}
		node.Server, _ = fields.Server.(string)
		if port, ok := fields.ServerPort.(json.Number); ok {
			number, err := port.Int64()
			if err == nil && int64(int(number)) == number {
				node.Port = int(number)
			}
		}

		outbound, err := singjson.UnmarshalExtendedContext[option.Outbound](ctx, rawEntry)
		if err != nil {
			node.ID = hashBytes(append([]byte("invalid outbound\x00"), rawEntry...))
			node.Phase = NodeFailed
			node.Error = "decode outbound: " + err.Error()
		} else {
			sanitizeOutbound(&outbound)
			outbound.Tag = ""
			data, err := singjson.MarshalContext(ctx, &outbound)
			if err != nil {
				return Parsed{}, fmt.Errorf("identify outbound %q: %w", name, err)
			}
			node.ID = hashBytes(data)
			node.Outbound = &outbound
			if requiresServerEndpoint(outboundType) && (node.Server == "" || node.Port < 1 || node.Port > 65535) {
				node.Phase = NodeFailed
				node.Error = "server or server_port is invalid"
			}
		}
		if index, exists := byID[node.ID]; exists {
			if node.Name < nodes[index].Name {
				nodes[index] = node
			}
			continue
		}
		byID[node.ID] = len(nodes)
		nodes = append(nodes, node)
	}
	if len(nodes) == 0 {
		return Parsed{}, errors.New("profile has no usable outbounds")
	}
	sorted := slices.Clone(nodes)
	slices.SortFunc(sorted, func(a, b Node) int { return strings.Compare(a.ID, b.ID) })
	content, err := json.Marshal(sorted)
	if err != nil {
		return Parsed{}, fmt.Errorf("hash profile: %w", err)
	}
	return Parsed{Profile: Profile{Nodes: nodes}, NodesHash: hashBytes(content)}, nil
}

var nodeTypes = []string{
	C.TypeSOCKS,
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
	C.TypeVLESS,
	C.TypeTUIC,
	C.TypeHysteria2,
}

func isNodeType(value string) bool {
	return slices.Contains(nodeTypes, value)
}

func sanitizeOutbound(outbound *option.Outbound) {
	if outbound.Type == C.TypeTrojan {
		if options, ok := outbound.Options.(*option.TrojanOutboundOptions); ok && options.Transport != nil && options.Network == "" {
			options.Network = "tcp"
		}
	}
	if wrapper, ok := outbound.Options.(option.OutboundTLSOptionsWrapper); ok {
		tls := wrapper.TakeOutboundTLSOptions()
		if tls == nil {
			return
		}
		tls.ALPN = nil
		if tls.ECH != nil {
			tls.ECH.PQSignatureSchemesEnabled = false
			tls.ECH.DynamicRecordSizingDisabled = false
		}
		if tls.UTLS != nil && isRemovedChromeFingerprint(tls.UTLS.Fingerprint) {
			tls.UTLS.Fingerprint = "chrome"
		}
	}
}

func isRemovedChromeFingerprint(value string) bool {
	switch strings.ToLower(strings.TrimSpace(value)) {
	case "chrome_psk", "chrome_psk_shuffle", "chrome_padding_psk_shuffle", "chrome_pq", "chrome_pq_psk":
		return true
	default:
		return false
	}
}

func requiresServerEndpoint(value string) bool {
	return value != C.TypeTor
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

func hashBytes(value []byte) string {
	sum := sha256.Sum256(value)
	return hex.EncodeToString(sum[:])
}
