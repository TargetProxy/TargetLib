package subscriptions

import (
	"context"
	"net"
	"net/netip"
	"sort"
)

type Resolver interface {
	LookupNetIP(context.Context, string, string) ([]netip.Addr, error)
}

type netResolver struct{ resolver *net.Resolver }

func (r netResolver) LookupNetIP(ctx context.Context, network, host string) ([]netip.Addr, error) {
	return r.resolver.LookupNetIP(ctx, network, host)
}

// ResolveEndpoints 返回具体的代理服务器地址；平台代码可将其转换为路由、VPN 排除项
// 或 socket 保护规则。
func ResolveEndpoints(ctx context.Context, resolver Resolver, nodes []Node) []string {
	set := make(map[string]struct{})
	for _, node := range nodes {
		if node.Phase != NodeReady || node.Server == "" {
			continue
		}
		if address, err := netip.ParseAddr(node.Server); err == nil {
			set[address.Unmap().String()] = struct{}{}
			continue
		}
		addresses, err := resolver.LookupNetIP(ctx, "ip", node.Server)
		if err != nil {
			continue
		}
		for _, address := range addresses {
			set[address.Unmap().String()] = struct{}{}
		}
	}
	out := make([]string, 0, len(set))
	for address := range set {
		out = append(out, address)
	}
	sort.Strings(out)
	return out
}
