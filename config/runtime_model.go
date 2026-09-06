package config

import targetprofile "github.com/loafman1120/TargetLib/profile"

// NodePool is the runtime view of all subscription profiles.
type NodePool struct {
	Nodes []targetprofile.Node
}

type Selector struct {
	Tag      string
	NodeIDs  []string
	Selected string
}

type ServiceRoute struct {
	ServiceID string
	Domains   []string
	Selector  string
	Enabled   bool
}

type ServiceBinding struct {
	ServiceID string
	Selector  string
	Outbound  string
	Revision  string
}

type RuntimeModel struct {
	NodePool        NodePool
	Selectors       []Selector
	ServiceRoutes   []ServiceRoute
	ServiceBindings []ServiceBinding
}

func RuntimeModelFromProfile(source targetprofile.Profile) RuntimeModel {
	return RuntimeModel{NodePool: NodePool{Nodes: source.Nodes}}
}
