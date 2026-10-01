package subscriptions

import (
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"slices"
	"strings"

	targetprofile "github.com/loafman1120/TargetLib/profile"
)

type NodePool struct {
	Revision string
	Nodes    []targetprofile.Node
}

// NodePool reads one immutable coordinator snapshot.
func (m *Manager) NodePool() NodePool {
	pool := NodePool{}
	for _, item := range m.snapshot.Load().items {
		if item.Enabled {
			pool.Nodes = append(pool.Nodes, cloneNodes(item.Profile.Nodes)...)
		}
	}
	slices.SortFunc(pool.Nodes, func(a, b targetprofile.Node) int { return strings.Compare(a.ID, b.ID) })
	content, _ := json.Marshal(pool.Nodes)
	sum := sha256.Sum256(content)
	pool.Revision = hex.EncodeToString(sum[:])
	return pool
}
