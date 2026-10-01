package profile

import (
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"slices"
	"strings"
)

// WithSource gives nodes a subscription-scoped identity based on their
// normalized connection settings. Display names and input order are excluded.
func WithSource(source Profile, subscriptionID string) Profile {
	result := Profile{}
	seen := make(map[string]bool)
	for _, node := range source.Nodes {
		var value map[string]json.RawMessage
		if json.Unmarshal(node.OutboundJSON, &value) != nil {
			continue
		}
		delete(value, "tag")
		canonical, _ := json.Marshal(value)
		sum := sha256.Sum256(append([]byte(subscriptionID+"\x00"), canonical...))
		node.ID = hex.EncodeToString(sum[:])
		node.SubscriptionID = subscriptionID
		if seen[node.ID] {
			continue
		}
		seen[node.ID] = true
		result.Nodes = append(result.Nodes, node)
	}
	slices.SortFunc(result.Nodes, func(a, b Node) int { return strings.Compare(a.ID, b.ID) })
	return result
}
