# gRPC 接口

TargetLib 的 gRPC 服务是本地控制面。协议定义以 [targetlib.proto](../api/TargetLib/targetlib.proto) 为准；本文记录当前 Go 实现的行为和约束，不包含 sing-box 服务商配置的透传接口。

TargetLib 核心负责订阅、节点池、运行时配置、节点选择和 sing-box 生命周期。客户端提交设置或选择意图，核心生成并校验最终配置；Flutter、FFI 和其他宿主只负责传输和平台接入。

## 连接与认证

manager.NewLocal 同时监听：

| 传输 | 端点 | 权限 |
| --- | --- | --- |
| TCP | 127.0.0.1:19090 | 本机回环地址 |
| Unix socket | <BasePath>/targetlib.sock | socket 权限 0600 |

控制 token 位于 <BasePath>/control.token。未通过 Options.ControlToken 提供 token 时，核心首次启动生成随机 token 并以 0600 保存；已有文件会被复用。需要认证的 RPC 必须带 gRPC metadata：

    authorization: Bearer <control-token>

只有下列四个修改运行时意图的 RPC 经过 token 校验：

- UpdateRuntimeConfig
- UpsertRoute
- DeleteRoute
- SelectRouteNode

其余 RPC（包括 SelectNode、订阅管理和查询）不要求 token。token 缺失、格式错误或不匹配时返回 UNAUTHENTICATED。

## RPC 总览

服务当前共有 30 个 RPC：Layer 1 有 26 个，Layer 2 有 4 个。

| 分组 | RPC |
| --- | --- |
| 生命周期与观测（10） | Start, Restart, Stop, GetState, SubscribeState, SubscribeLogs, SubscribeTraffic, SubscribeConnections, CloseConnection, CloseAllConnections |
| 订阅（10） | ListSubscriptions, GetSubscription, AddSubscription, RemoveSubscription, RenameSubscription, SetSubscriptionEnabled, ConfigureSubscriptionUpdates, UpdateSubscription, GetResolvedEndpoints, SubscribeSubscriptionEvents |
| 节点选择（3） | GetNodePool, SelectNode, GetProxyStatus |
| 运行时与网络信息（3） | GetRuntimeConfig, UpdateRuntimeConfig, GetIpInfo |
| 规则分流（4） | UpsertRoute, DeleteRoute, ListRoutes, SelectRouteNode |

所有时间戳字段均为 Unix 毫秒。节点 ProfileNode.tag 是稳定的 node_id，显示名称不能代替它作为选择键。

## 生命周期与观测

### 生命周期

| RPC | 请求 / 返回 | 当前行为 |
| --- | --- | --- |
| Start | Empty -> OperationResponse | 根据已保存的运行时配置构建、校验并启动 sing-box；服务处于 STARTING 或 RUNNING 时返回 FAILED_PRECONDITION。 |
| Restart | Empty -> OperationResponse | 使用当前订阅节点池和运行时配置重新构建并加载；服务未运行时也会启动。 |
| Stop | Empty -> OperationResponse | 停止服务；已经处于 IDLE 或 FAILED 时幂等返回当前状态。 |
| GetState | Empty -> ServiceState | 返回当前状态、错误文本和状态变更时间。 |
| SubscribeState | Empty -> stream ServiceState | 转发 sing-box 服务状态流；客户端取消 context 即结束流。 |
| SubscribeLogs | Empty -> stream LogBatch | 转发核心日志批次。运行时生成配置固定使用 error 日志级别，LogBatch.reset 表示日志窗口被重置。 |

ServiceState.state 的取值为 IDLE、STARTING、RUNNING、STOPPING 或 FAILED。Start、Restart 和 Stop 返回的 OperationResponse.state 是调用完成时读回的状态，而不是异步 operation ID。

### 流量和连接

SubscribeTraffic 的 interval_milliseconds 为 0 时使用 1000 ms；非零值必须在 250–5000 ms（含边界）之间，否则返回 INVALID_ARGUMENT。TrafficStatus 中的速率字段已按采样间隔换算为 bytes/s；available=false 表示 sing-box 当前没有可用流量统计。

SubscribeConnections 的间隔为 0 时使用 1000 ms，代码不额外限制非零间隔。服务未运行时，底层连接订阅返回 FAILED_PRECONDITION。流中每个 ConnectionEvents 批次包含：

- reset=true：客户端应将批次视为新的基线；
- NEW、UPDATE、CLOSED：分别表示连接建立、统计更新和关闭；
- ConnectionEvent.connection：连接快照；uplink_delta 和 downlink_delta：本批次增量。

CloseConnection 要求非空连接 id；CloseAllConnections 关闭当前全部连接。

## 订阅管理

订阅只接受 HTTPS URL。新增订阅时：

- id 为空时由核心生成 UUID；name 为空时使用 id；
- enabled 和 auto_update 未设置时默认为 true；
- update_interval_seconds 为 0 或负值时使用默认 12 小时；启用自动更新时最小间隔为 5 分钟；
- headers 仅用于拉取订阅；原始订阅的入站、DNS、路由和规则不会进入运行时配置；
- update_now=true 会在新增后立即拉取。拉取失败时核心删除刚创建的订阅并返回错误。

| RPC | 请求 / 返回 | 说明 |
| --- | --- | --- |
| ListSubscriptions | Empty -> SubscriptionList | 返回按名称排序的订阅视图。 |
| GetSubscription | SubscriptionId -> SubscriptionView | 不存在返回 NOT_FOUND。 |
| AddSubscription | AddSubscriptionRequest -> SubscriptionView | 见上面的默认值和 update_now 回滚行为；重复 ID 返回 ALREADY_EXISTS。 |
| RemoveSubscription | SubscriptionId -> Empty | 删除订阅及其节点。 |
| RenameSubscription | RenameSubscriptionRequest -> SubscriptionView | 名称去除首尾空白，空名称返回 INVALID_ARGUMENT。 |
| SetSubscriptionEnabled | SetSubscriptionEnabledRequest -> SubscriptionView | 禁用订阅后，其节点不再进入 NodePool。 |
| ConfigureSubscriptionUpdates | ConfigureSubscriptionUpdatesRequest -> SubscriptionView | 修改自动更新开关和间隔；启用时仍需满足 5 分钟下限。 |
| UpdateSubscription | SubscriptionId -> SubscriptionUpdateResult | 手动拉取、解析、解析节点地址并持久化。并发更新同一订阅会合并。 |
| GetResolvedEndpoints | ResolvedEndpointsRequest -> ResolvedEndpoints | 返回订阅节点解析出的地址；enabled_only=true 只包含启用订阅。 |
| SubscribeSubscriptionEvents | Empty -> stream SubscriptionEvent | 推送 ADDED、UPDATED、REMOVED、STAGE 事件。 |

SubscriptionView.status 为 IDLE、UPDATING、READY 或 FAILED；stage 为 FETCHING、PARSING、RESOLVING、PERSISTING、COMPLETE 或 FAILED。失败信息在 error_code 和 error_message 中返回。

UpdateSubscription 的结果字段含义：

| 字段 | 含义 |
| --- | --- |
| changed | 拉取成功且节点内容发生变化。 |
| not_modified | 服务商返回未修改（例如条件请求命中）。 |
| original_config | 本次实际拉取的原始响应体；未产生新内容时为空。 |
| generated_config | 本次更新对应的核心生成配置；仅在有新的 original_config 时生成。 |
| duration_milliseconds | 本次更新耗时。 |

更新失败但已有订阅记录时，RPC 仍返回包含 FAILED 状态和错误信息的 SubscriptionUpdateResult；订阅不存在或无法取得结果时返回 gRPC 错误。

## 节点池与默认节点

GetNodePool 汇总所有启用订阅中的节点，并返回 revision。节点的 tag 是 SelectNode 使用的 node_id；phase 对外主要为 READY 或 FAILED。

    rpc SelectNode(SelectNodeRequest) returns (SelectNodeResponse);

    message SelectNodeRequest {
      string node_id = 1;
    }

SelectNode 要求节点存在且可用，否则返回 NOT_FOUND。核心先等待服务离开 STARTING / STOPPING：

- 服务运行中：通过 sing-box selector 即时切换并持久化；applied_immediately=true；
- 服务未运行：只保存选择，下次 Start 或 Restart 生效；applied_immediately=false。

持久化失败时，运行中的 selector 会尝试恢复原选择。

GetProxyStatus 返回默认 proxy selector 的选择、服务状态、节点可用性和 effective。actual_node_id 只有服务运行时才填充；节点不在当前池中时 unavailable_reason=node_not_in_pool，节点处于失败或未就绪状态时分别为 node_failed 或 node_not_ready。

## 运行时配置

GetRuntimeConfig 返回持久化的 RuntimeConfig：

- settings：监听地址、mixed 端口、代理模式、IPv6 和路由模式；
- selectors：proxy 及每个规则服务的 selector、成员和当前选择；
- service_routes：规则服务及其域名；
- node_pool_revision：配置生成时使用的节点池版本。

UpdateRuntimeConfig 要求 settings 非空，并替换 settings，同时保留已有 selector 和 service route。配置会先经过 config.Build 的 Plan -> Blueprint -> Emit 流程和 sing-box 校验：

- 服务运行中：尝试热加载；校验、加载或持久化失败会恢复上一个运行配置；
- 服务未运行：保存配置，下一次启动使用；
- 监听地址必须为单行非空字符串，mixed 端口为 1–65535；
- route_mode 必须为 DIRECT、RULE 或 ALL；桌面端 proxy_mode 必须为 MIXED 或 TUN；Android/iOS 会强制使用 TUN。

订阅供应商的入站、DNS、路由、rule set 和代理组不会透传。TUN 配置使用核心固定的 TUN/DNS 规划；规则模式使用随程序提供的 cn.srs 中国规则集。

GetIpInfo 从核心运行环境访问 ip-api.com 查询出口 IP 地理信息，返回 IpInfoResponse。请求超时或上游不可用时返回 UNAVAILABLE；该 RPC 不要求 control token。

## 规则分流

规则分流由 ServiceRoute 和同名 selector 组成。每个服务拥有独立 selector，selector tag 由核心生成（通常为 route-<service_id>），客户端只保存和传递 service_id。

| RPC | 请求 / 返回 | 说明 |
| --- | --- | --- |
| UpsertRoute | UpsertRouteRequest -> RouteInfo | 新建或更新服务规则；要求 service_id、至少一个域名和可用 node_id。 |
| DeleteRoute | DeleteRouteRequest -> Empty | 删除服务规则及其 selector；不存在返回 NOT_FOUND。 |
| ListRoutes | Empty -> RouteList | 返回所有服务规则，并在 default_route 返回默认 proxy selector 的当前节点。 |
| SelectRouteNode | SelectRouteNodeRequest -> SelectNodeResponse | 切换指定服务的节点；运行中即时切换，未运行时保存到下次启动。 |

UpsertRoute 会规范化域名（小写、去掉末尾点并排序），启用规则之间不允许重复域名。域名格式、服务 ID、节点和 selector 引用无效时返回 INVALID_ARGUMENT 或 NOT_FOUND。RouteInfo.effective 只有在规则启用、路由模式不是 DIRECT 且服务处于 RUNNING 时才为 true。

路由模式的实际含义：

| route_mode | 默认流量 | 服务规则 |
| --- | --- | --- |
| DIRECT | 全部直连 | 不生效，RouteInfo.effective=false |
| ALL | 默认走 proxy selector | 启用的服务规则仍可覆盖到独立 selector |
| RULE | 中国规则集命中时直连，其余走 proxy selector | 启用的服务规则优先匹配并走指定 selector |

无论模式如何，SelectNode 选择的是默认 proxy selector；SelectRouteNode 只影响指定服务的 selector。

## 错误码

| gRPC code | 典型场景 |
| --- | --- |
| INVALID_ARGUMENT | 缺少必填字段、非 HTTPS 订阅 URL、间隔或运行时设置越界、域名无效。 |
| NOT_FOUND | 订阅、节点或规则不存在，或节点当前不可用。 |
| ALREADY_EXISTS | 新增订阅使用了已有 ID。 |
| FAILED_PRECONDITION | 重复启动、连接流要求服务运行、服务长时间停留在过渡状态。 |
| UNAUTHENTICATED | 四个受保护 RPC 缺少或提供了错误 token。 |
| UNAVAILABLE | 出口 IP 查询的上游不可用。 |
| INTERNAL | sing-box 加载、持久化或其他核心操作失败。 |
| DATA_LOSS | 新配置应用失败且回滚也失败。 |
| CANCELED / DEADLINE_EXCEEDED | 客户端取消或 context 超时。 |

服务端会记录未被客户端取消导致的 gRPC 错误；流式 RPC 应使用 context 管理生命周期，并在重连后重新建立所需的订阅流。
