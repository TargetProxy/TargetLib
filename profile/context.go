package profile

import (
	"context"
	"sync"

	box "github.com/sagernet/sing-box"
	"github.com/sagernet/sing-box/include"
)

var (
	contextOnce  sync.Once
	contextValue context.Context
)

// Context 返回解析 sing-box 联合类型所需的注册表上下文，联合类型包括 inbound、
// outbound、endpoint 和 service。
func Context() context.Context {
	contextOnce.Do(func() {
		contextValue = box.Context(
			context.Background(),
			include.InboundRegistry(),
			include.OutboundRegistry(),
			include.EndpointRegistry(),
			include.DNSTransportRegistry(),
			include.ServiceRegistry(),
		)
	})
	return contextValue
}
