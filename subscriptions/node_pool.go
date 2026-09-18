package subscriptions

import (
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	targetprofile "github.com/loafman1120/TargetLib/profile"
	"sort"
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
	sort.Slice(pool.Nodes, func(i, j int) bool { return pool.Nodes[i].ID < pool.Nodes[j].ID })
	content, _ := json.Marshal(pool.Nodes)
	sum := sha256.Sum256(content)
	pool.Revision = hex.EncodeToString(sum[:])
	return pool
}
