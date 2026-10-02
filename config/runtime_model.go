package config

import targetprofile "github.com/loafman1120/TargetLib/profile"

// DefaultServiceID is the built-in service owning the "proxy" selector.
// It takes no domains and no route; SelectNode switches its node.
const DefaultServiceID = "default"

// NodePool is the runtime view of all subscription profiles.
type NodePool struct {
	Nodes []targetprofile.Node
}

type Selector struct {
	Tag              string
	NodeIDs          []string
	Selected         string
	SelectedAtUnixMs int64
}

type ServiceRoute struct {
	ServiceID   string
	DisplayName string
	Domains     []string
	Selector    string
	Enabled     bool
}

type RuntimeModel struct {
	NodePool      NodePool
	Selectors     []Selector
	ServiceRoutes []ServiceRoute
}

func RuntimeModelFromProfile(source targetprofile.Profile) RuntimeModel {
	return RuntimeModel{NodePool: NodePool{Nodes: source.Nodes}}
}
