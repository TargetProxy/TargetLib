package subscriptions

import (
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
	state := m.snapshot.Load()
	pool := NodePool{Revision: state.revision}
	for _, item := range state.items {
		if item.Enabled {
			pool.Nodes = append(pool.Nodes, cloneNodes(item.Profile.Nodes)...)
		}
	}
	slices.SortFunc(pool.Nodes, func(a, b targetprofile.Node) int { return strings.Compare(a.ID, b.ID) })
	return pool
}
