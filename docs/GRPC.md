# gRPC 能力总览

TargetLib gRPC 是共享 Go 核心的远程控制与数据传输层，共提供 **29 个 RPC**，其中 **5 个服务端流式 RPC**。协议定义见 [`targetlib.proto`](../api/TargetLib/targetlib.proto)。

| 分类 | RPC | 能力 |
| --- | --- | --- |
| 版本与能力 | `GetVersion`、`GetCapabilities` | 查询 TargetLib、sing-box、Go、协议版本及平台能力。 |
| 生命周期 | `Start`、`Restart`、`Stop`、`GetState`、`SubscribeState`* | 控制 sing-box，查询或订阅 `idle/starting/running/stopping/failed` 状态。 |
| 日志与流量 | `SubscribeLogs`*、`SubscribeTraffic`* | 流式接收分级日志，以及实时速率、累计流量和连接数；流量采样间隔为 250–5000 ms。 |
| 连接控制 | `SelectOutbound`、`CloseConnection`、`CloseAllConnections` | 切换 selector 出站，关闭指定或全部连接。 |
| 订阅管理 | `ListSubscriptions`、`GetSubscription`、`AddSubscription`、`RemoveSubscription`、`RenameSubscription`、`SetSubscriptionEnabled`、`ConfigureSubscriptionUpdates`、`UpdateSubscription` | 管理订阅、自动更新和手动更新；返回状态、节点、流量额度及服务商元数据。显式更新还可返回原始与生成配置用于诊断。 |
| 活动订阅 | `SetActiveSubscription`、`GetActiveSubscription` | 设置或查询活动订阅；空 ID 切换为纯直连配置。 |
| 订阅事件 | `SubscribeSubscriptionEvents`*、`GetResolvedEndpoints` | 订阅添加、更新、删除及阶段事件，查询节点解析后的服务器地址。 |
| 运行时配置 | `GetRuntimeConfig`、`UpdateRuntimeConfig` | 管理监听地址、mixed 端口、Mixed/TUN、IPv6 和路由模式；校验并持久化，运行中热加载，失败时回滚。 |
| 延迟测试 | `TestOutbound`、`TestOutbounds`* | 测试单个或批量节点；区分成功、失败、超时和未找到，超时上限 60 秒，并发度最多 4。 |
| 出口信息 | `GetIpInfo` | 查询后端出口的 IP、国家、城市、ISP、组织和 AS 信息。 |

`*` 表示服务端流式 RPC。

## 传输与边界

- 同时监听本机 TCP `127.0.0.1:19090` 和 `<basePath>/targetlib.sock` Unix socket。
- 当前未配置 gRPC TLS 或认证，安全边界依赖回环地址和 Unix socket 文件权限。
- gRPC 只传递订阅、启停、选择和运行设置等粗粒度命令，不接受或透传完整的服务商 sing-box 配置。
- 订阅解析、节点规范化、配置生成、热加载和失败回滚均由共享 Go 核心负责。
