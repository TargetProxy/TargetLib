package profile

import (
	"slices"
	"strings"
)

// WithSource gives nodes a subscription-scoped identity based on their
// parsed identity.
func WithSource(source Profile, subscriptionID string) Profile {
	result := Profile{}
	seen := make(map[string]bool)
	for _, node := range source.Nodes {
		if node.ID == "" || (node.SubscriptionID != "" && node.SubscriptionID != subscriptionID) {
			continue
		}
		if node.SubscriptionID != subscriptionID {
			node.ID = hashBytes([]byte(subscriptionID + "\x00" + node.ID))
			node.SubscriptionID = subscriptionID
		}
		if seen[node.ID] {
			continue
		}
		seen[node.ID] = true
		result.Nodes = append(result.Nodes, node)
	}
	slices.SortFunc(result.Nodes, func(a, b Node) int { return strings.Compare(a.ID, b.ID) })
	return result
}
