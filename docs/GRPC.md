# gRPC 能力总览

TargetLib gRPC 是共享 Go 核心的远程控制与数据传输层，共提供 **57 个 RPC**，其中 **8 个服务端流式 RPC**。当前协议版本为 **13**，协议定义见 [`targetlib.proto`](../api/TargetLib/targetlib.proto)。

本文是传输契约文档：系统分层和部署见 [DESIGN.md](DESIGN.md)，Smart Connect 领域状态机和不变量见
[SMART_CONNECT_ARCHITECTURE.md](SMART_CONNECT_ARCHITECTURE.md)。RPC handler 不承载策略，只负责认证、基础校验、
wire/领域类型转换以及调用应用服务。

| 分类 | RPC | 能力 |
| --- | --- | --- |
| 版本与能力 | `GetVersion`、`GetCapabilities` | 查询 TargetLib、sing-box、Go、协议版本及平台能力。 |
| 生命周期 | `Start`、`Restart`、`Stop`、`GetState`、`SubscribeState`* | 控制 sing-box，查询或订阅 `idle/starting/running/stopping/failed` 状态。 |
| 日志与流量 | `SubscribeLogs`*、`SubscribeTraffic`* | 流式接收分级日志，以及实时速率、累计流量和连接数；流量采样间隔为 250–5000 ms。 |
| 连接控制 | `SelectOutbound`、`CloseConnection`、`CloseAllConnections` | 切换 selector 出站，关闭指定或全部连接。 |
| 订阅管理 | `ListSubscriptions`、`GetSubscription`、`AddSubscription`、`RemoveSubscription`、`RenameSubscription`、`SetSubscriptionEnabled`、`ConfigureSubscriptionUpdates`、`UpdateSubscription` | 管理订阅、自动更新和手动更新；返回状态、节点、流量额度及服务商元数据。显式更新还可返回原始与生成配置用于诊断。 |
| 节点池 | `GetNodePool` | 返回所有启用订阅的统一节点池、来源和稳定节点 ID。 |
| 订阅事件 | `SubscribeSubscriptionEvents`*、`GetResolvedEndpoints` | 订阅添加、更新、删除及阶段事件，查询节点解析后的服务器地址。 |
| 运行时配置 | `GetRuntimeConfig`、`UpdateRuntimeConfig` | 管理监听地址、mixed 端口、Mixed/TUN、IPv6 和路由模式；校验并持久化，运行中热加载，失败时回滚。 |
| 延迟测试 | `TestOutbound`、`TestOutbounds`* | 测试单个或批量节点；区分成功、失败、超时和未找到，超时上限 60 秒，并发度最多 4。 |
| 出口信息 | `GetIpInfo` | 查询后端出口的 IP、国家、城市、ISP、组织和 AS 信息。 |
| 服务绑定 | `ListServiceBindings`、`ApplyServiceBinding`、`RemoveServiceBinding` | 查询、显式应用或移除独立服务绑定，支持 revision 检查和绑定有效期。 |
| 运行状态 | `GetRuntimeState`、`SubscribeRuntimeEvents`* | 查询实际生效 revision、selector、路由、绑定及待评估原因；订阅配置阶段、节点池、绑定和探测事件。 |
| 服务探测 | `PutServiceProbe`、`RemoveServiceProbe`、`ListServiceProbes`、`ProbeService`* | 管理服务探测定义，通过指定节点验证服务、认证、地区、内容及可选 UDP 丢包；不切换出口。 |
| 选择策略 | `GetServiceSelectionPolicy`、`PutServiceSelectionPolicy` | 管理当前核心候选评估使用的订阅、地区、排除、收藏和 Direct 偏好；目标架构将由完整 `ServicePolicy` 取代。 |
| 质量与诊断 | `GetQualityHistory`、`EvaluateService`、`GetSmartConnectDiagnostics` | 查询持久化质量历史、候选排序、评分趋势和运行诊断报告。 |
| 策略同步 | `ExportSmartConnectPolicy`、`ImportSmartConnectPolicy` | 显式导入/导出服务探测定义，以本地 revision 防止覆盖并发修改；不传输绑定、质量或凭据。 |

`*` 表示服务端流式 RPC。

## Smart Connect v12 兼容调用顺序

以下是当前已实现的低层流程，不是目标产品客户端边界：

1. `GetNodePool` 取得稳定 node ID；`UpdateRuntimeConfig.model` 定义各服务的独立 selector 和域名路由。
2. `PutServiceProbe` 定义服务测试；`ProbeService` 显式探测候选节点，认证头仅随本次调用传入。
3. `EvaluateService` 查询候选质量。兼容客户端明确选定节点后调用 `ApplyServiceBinding`，携带当前 runtime revision。
4. `SubscribeRuntimeEvents` 或 `GetRuntimeState` 确认实际生效 revision、selector 和绑定。
5. 绑定待评估时由客户端重新探测；v12 后端不会因到期、订阅变化或测试失败自动切换节点。

事件消费者落后时服务端返回 `ResourceExhausted`，重连会重新发送状态快照。
服务测试、丢包测量、历史保留与策略同步的限制见 [Smart Connect 目标架构](SMART_CONNECT_ARCHITECTURE.md)。

`UpdateRuntimeConfig.model`、`PutServiceProbe`、`ProbeService`、`EvaluateService` 和 `ApplyServiceBinding`
在迁移期间继续兼容现有调用方及底层测试。Target 产品客户端迁移后不得使用这些 RPC 编排 Smart Connect，
也不得自行计算候选或构造 selector、route 和 binding。

## Smart Connect 意图级 API

协议版本 13 以后台 operation 和权威 snapshot 取代客户端长流程编排。已交付能力如下：

| 分类 | RPC | 语义 |
| --- | --- | --- |
| 总体状态 | `GetSmartConnectSnapshot` | 一次返回 enabled、恢复状态、全部服务、binding、proposal、operation、deadline 和各类 revision。 |
| 开关 | `SetSmartConnectEnabled` | 以 expected revision 和幂等键启停核心编排；关闭时事务化清理自有运行模型。 |
| 服务策略 | `ListServicePolicies`、`UpsertServicePolicy`、`DeleteServicePolicy` | 管理由核心持久化的完整服务、探测和切换策略。 |
| 节点偏好 | `SetNodePreference` | 保存启用、排除、收藏、标签和订阅优先级，自动使相关评估失效。 |
| 评估 | `RequestServiceEvaluation` | 创建持久化 operation，由后台 scheduler/probe/decision engine 执行。 |
| 审批 | `ApproveSwitchProposal`、`RejectSwitchProposal` | 处理 `MANUAL` proposal；审批前重新检查所有 revision。 |
| 强制绑定 | `ForceServiceBinding` | 表达用户意图，仍由核心完成约束校验、切换、验证和回滚。 |
| 操作查询 | `GetOperation`、`ListOperations` | 查询 UI 挂起期间继续执行的任务及最终结果。 |
| 事件 | `SubscribeSmartConnectEvents`* | 订阅带 epoch/cursor 的变化通知；间断时要求重新读取 snapshot。 |

### 命令与查询分离

- Query RPC 无副作用，读取一次一致的 snapshot 或 operation；不得隐式启动探测、刷新订阅或切换节点。
- Command RPC 表达用户意图，完成持久化受理后返回 `Operation`；不得等待整个后台工作流完成。
- Event RPC 只通知状态变化，不能作为唯一事实源，也不能要求订阅者持续在线以保证任务执行。
- 低层诊断 RPC 可以显式启动一次探测，但不能绕过 Orchestrator 修改产品 binding。

领域状态与协议入口的对应关系：

| 领域状态转换 | 接受命令 | 查询方式 |
| --- | --- | --- |
| disabled -> enabled | `SetSmartConnectEnabled` | snapshot enabled/recovery state |
| idle -> evaluating | `RequestServiceEvaluation` | operation + active task |
| evaluating -> proposal ready | 无客户端命令，由核心推进 | snapshot proposal / operation result |
| waiting approval -> applying | `ApproveSwitchProposal` | proposal approval + operation |
| any stable binding -> applying | `ForceServiceBinding` | binding operation |
| applying -> committed/rolled-back | 无客户端命令，由 RuntimeController 推进 | operation + actual/last-known-good binding |
| enabled -> disabled | `SetSmartConnectEnabled` | snapshot + cleanup operation |

所有写命令必须包含：

- `expected_revision`：防止覆盖新策略或绑定；
- `idempotency_key`：重连和超时重试不会创建重复任务；
- 调用方意图和可审计来源；
- 可选 deadline，但 deadline 不能中断已开始的原子提交。

长时间评估、等待审批、运行时切换和验证均返回持久化 `Operation`，不能让 RPC 生命周期成为任务生命周期。
Operation 状态统一为 `QUEUED/RUNNING/WAITING_APPROVAL/SUCCEEDED/FAILED/CANCELLED/ROLLED_BACK`。

### 幂等和并发

- 幂等键的作用域为调用方身份、RPC 类型和目标资源。
- 同一键与相同规范化请求必须返回同一个 operation；同一键对应不同请求返回 `ALREADY_EXISTS`。
- `expected_revision` 必须引用被修改聚合的 revision，而不是任意全局时间戳。
- revision 冲突返回 `ABORTED`，并在结构化 detail 中提供资源类型、资源 ID 和当前 revision。
- 一个服务只能有一个 active evaluation 和一个 active switch；重复等价请求合并，不等价请求排队或返回 `FAILED_PRECONDITION`。
- RPC deadline 只控制调用等待。operation 提交前可取消；进入运行时原子提交后必须完成 commit 或 rollback。

### Operation 最小字段

目标 wire model 至少包含：

```text
id, kind, resource_id, idempotency_key
status, phase, progress_current, progress_total
created_at, started_at, updated_at, completed_at
policy_revision, node_pool_revision, binding_revision, runtime_revision
proposal_id, result_summary, error
```

`error` 使用稳定 machine code、可本地化 message key 和已脱敏 detail；不能只返回服务端拼接字符串。

### 错误语义

| gRPC code | 使用场景 | 客户端处理 |
| --- | --- | --- |
| `INVALID_ARGUMENT` | 字段、域名、地区、探测或策略不合法 | 修正输入，不自动重试 |
| `UNAUTHENTICATED` / `PERMISSION_DENIED` | 本地控制端认证失败或调用方无权执行操作 | 重新建立可信会话或停止 |
| `NOT_FOUND` | policy、proposal、operation、node 不存在 | 刷新 snapshot |
| `ALREADY_EXISTS` | 幂等键复用但 payload 不同 | 生成新键或读取原 operation |
| `FAILED_PRECONDITION` | 生命周期、授权或 active operation 不允许当前命令 | 展示所需前置动作 |
| `ABORTED` | expected revision 过期 | 读取 snapshot 后重新决策 |
| `RESOURCE_EXHAUSTED` | 并发、队列或事件消费者超限 | 按 retry hint 退避；事件流重读 snapshot |
| `UNAVAILABLE` | 核心恢复中、平台网络或运行时暂不可用 | 有上限退避，不改变本地事实状态 |
| `INTERNAL` | 未分类内部失败且运行时已保持或恢复 | 查询 operation/snapshot 确认状态 |
| `DATA_LOSS` | runtime/store 回滚也失败，状态无法保证 | 显示 degraded，禁止自动重试切换 |

错误响应应通过标准 status details 携带 `reason`、`resource`、`current_revision`、`operation_id` 和可选 `retry_after`。

## Snapshot 与事件恢复

- Snapshot 是事实源，事件只是失效通知和增量体验优化。
- 客户端首次连接、进程恢复、sequence 跳变或 `ResourceExhausted` 后必须重新读取 snapshot。
- 近期 operation 和关键事件需持久化；Flutter isolate 挂起不能导致结果丢失。
- 服务重启生成新 event epoch，旧 cursor 不得跨 epoch 继续解释。
- 客户端不根据单个事件推导最终 binding，必须使用 snapshot/operation 确认 committed 或 rolled-back。

事件消息至少包含 `epoch`、单调 `sequence`、`cursor`、事件类型、资源 ID、operation ID 和发生时间。
事件 payload 可以只包含摘要；任何需要展示或决策的完整状态都从 snapshot/query 读取。

## 版本与兼容

- `GetVersion.protocol_version` 继续作为 wire capability 基线；新增领域能力同时通过 `GetCapabilities` 细粒度声明。
- 新 message 字段只追加新编号；删除字段必须 `reserved` 原编号和名称。
- 旧 v12 低层 RPC 在意图 API 稳定、Target 完成迁移并经过至少一个兼容周期前保留。
- deprecated RPC 必须在 proto 注释、生成 SDK 和本文同时标记，并说明替代接口和移除条件。
- 新客户端连接旧核心时依据 capability 隐藏功能，不能在本地模拟核心缺失的策略或切换逻辑。
- 旧客户端连接新核心时仍可使用兼容 RPC，但不能修改由新 Orchestrator 管理的资源；冲突返回 `FAILED_PRECONDITION`。
- Store schema 版本与 protocol version 独立演进；协议兼容不代表旧核心可以安全打开新 Store。

## 传输与边界

- 同时监听本机 TCP `127.0.0.1:19090` 和 `<basePath>/targetlib.sock` Unix socket。
- v13 意图级 RPC 要求 `Authorization: Bearer <token>`；核心首次启动在 `<basePath>/control.token` 生成私有 token，Flutter SDK 自动读取并携带。兼容 v12 的低层 RPC 暂保持原行为。
- Android 优先使用应用私有 Unix socket；桌面 TCP 会话应使用安装时生成、存放于平台安全存储的本地凭据。
- gRPC 只传递订阅、启停、选择和运行设置等粗粒度命令，不接受或透传完整的服务商 sing-box 配置。
- 目标产品路径也不接受客户端构造的完整 Smart Connect RuntimeModel；低层 model RPC 只作兼容和诊断用途。
- 订阅解析、节点规范化、策略、调度、评分、配置生成、live select、热加载、验证和失败回滚均由共享 Go 核心负责。
