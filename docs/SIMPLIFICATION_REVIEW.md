# SIMPLIFICATION 可行性评审与 box.Box 迁移方案

## 结论

当前方案可以作为性能优化清单，但不能按文档中的代码片段直接实施。建议优先保留配置管线和同步提交语义，只做已能证明不改变行为的优化；`daemon.StartedService` 到 `box.Box` 的迁移应作为独立的运行时替换项目，先建立兼容接口和回归基线，再逐项接管 StartedService 提供的能力。

`box.Box` 迁移本身可行，风险集中在运行时外围能力，而不是创建和启动 Box：

- selector 切换可通过 `Box.Outbound().Outbound(tag)` 取出 `*group.Selector` 后调用 `SelectOutbound`。
- 生命周期可由 `box.New`、`Start`、`Close` 管理，但每个实例仍需自己的 `context.CancelFunc`。
- `Box` 没有暴露 `StartedService` 的状态、日志、流量统计、连接追踪和按 ID 关闭连接接口。
- 文档中的 `router.SetOutbound`、`router.Uplink()`、`router.DownloadTotal()` 等调用在 sing-box v1.14.0 中不存在，不能作为迁移代码。

## 现有实现与文档的差异

### Blueprint 不能直接删除

仓库架构约束规定 `config.Build(settings, profile)` 的流程是 `Plan -> Blueprint -> Emit`。当前 `config/build.go` 也明确保留了 `RoutePlan`、`RuntimePlan`、`Blueprint` 和 `Emit`（`config/build.go:45-92`）。因此“移除 Blueprint”不是单纯的性能优化，而是架构契约变更；除非先修改架构约束和所有调用方，否则不建议实施。

可做的低风险调整是当前工作树已经采用的 `BuildNormalized`：把一次性的规范化从 `planRuntimeModel` 中移出，避免 Manager 已规范化模型时重复处理（`config/build.go:94-124`）。这不会改变 Blueprint 边界，也不应宣称能带来 30% 的收益，收益需要基准测试证明。

### 节点切换已经绕过完整配置校验

`SelectNode` 和 `SelectRouteNode` 都调用 `commitLiveSelector`（`manager/node_selection.go:87-100`、`manager/routes.go:146-161`）。该函数直接调用 live selector，再持久化并在持久化失败时回滚（`manager/runtime_controller.go:287-307`），不会经过 `applySnapshot` 的 `checkConfig`（`manager/runtime_controller.go:234-270`）。因此文档中的“为 SelectNode 增加 validationSkip”在现有路径上已经基本完成，重复改造会扩大风险。

`UpsertRoute` 仍会走完整 `applyDesired` 并 reload，无论是新建还是修改路由（`manager/routes.go:30-59`）。如果要优化它，应先区分“仅改变已有 selector 的选择”和“改变 domains、enabled、selector members”等需要重新生成配置的操作，不能用一个全局跳过校验开关替代。

### 异步持久化会改变当前一致性契约

当前 live select 成功后，只有 `SaveSnapshot` 成功才发布内存状态；失败会恢复 selector（`manager/runtime_controller.go:290-307`）。这与设计文档中的“同步 RPC 失败 = 无副作用”一致。直接改成后台队列会产生已返回成功但重启丢失选择的状态，也需要处理：队列顺序、进程关闭、写入失败重试、旧任务覆盖新任务和错误向 UI 暴露。

文档示例中的 `atomic.Value.Store(error(nil))` 也不可用：`atomic.Value` 不能存储无类型 nil，且第一次存储的动态类型必须稳定。除非产品明确接受“已应用但未持久化”的新语义，否则建议先做持久化基准测试，再保持同步提交。

### 持久化结构简化需要版本迁移

当前运行时快照使用 metadata key `runtime-config-v1`，直接 protobuf 序列化 `RuntimeConfig`（`manager/runtime_config_store.go:10-48`）。引入精简结构时不要修改公开 gRPC proto 作为内部存储协议；应使用独立的内部版本结构和新 key，例如 `runtime-state-v2`，读取顺序为 v2、v1，成功读取 v1 后在同一事务中写入 v2。迁移必须覆盖空 selector、未知 service、节点池变化和旧版本回滚。

## box.Box API 调查（sing-box v1.14.0）

### 可直接复用的能力

`box.Box` 暴露 `Start`、`Close`、`Router`、`Network`、`Outbound`、`Inbound`、`Endpoint` 和 `LogFactory`。selector 的正确调用链是：

```go
outbound, ok := instance.Outbound().Outbound(groupTag)
selector, ok := outbound.(*group.Selector)
if !ok {
    return status.Error(codes.InvalidArgument, "outbound is not a selector")
}
if !selector.SelectOutbound(nodeTag) {
    return status.Error(codes.NotFound, "outbound not found")
}
```

配置解析不能使用标准库 `encoding/json`，需要 sing-box 的扩展 JSON 解码：

```go
options, err := singjson.UnmarshalExtendedContext[option.Options](ctx, content)
```

这与 sing-box `daemon` 内部的 `parseConfig` 保持一致。

### Box 不直接提供的能力

`Box.Router()` 返回的 `adapter.Router` 没有流量累计、连接数量或关闭连接方法；`Box` 也没有公开其内部的 `trafficcontrol.Manager` 和 `route.ConnectionManager`。因此以下功能不能靠简单字段替换保留：

| TargetLib 能力 | StartedService 当前来源 | Box 迁移后的实现 |
| --- | --- | --- |
| 状态订阅 | `SubscribeServiceStatus` | Manager 自己维护状态机和广播 |
| 日志订阅 | `SubscribeLog`、保存日志 | `PlatformLogWriter` 接收日志并维护 ring buffer |
| 流量统计 | 内部 `trafficcontrol.Manager` | 在创建后通过 `Router.AppendTracker` 接入自有 tracker，或保留一个可访问统计管理器的运行时适配层 |
| CloseConnection | `trafficcontrol.Manager.Connection(id)` | 自有 tracker 保存 ID 到可关闭连接的映射，或暂时保留 daemon 后端 |
| CloseAllConnections | connection/traffic manager | 自有 tracker 和连接管理器分别关闭，需验证 UDP/TUN 语义 |
| OOM killer | `StartedService.newInstance` 注入 service | 迁移适配器显式注入同等 service；不能假设 `box.New` 自动注入 |
| reload 回滚 | daemon 先关闭旧实例，再建新实例 | runtime adapter 复刻旧实例关闭、启动失败、恢复旧配置的状态转换 |

日志方面，当前配置通过 `PlatformLogWriter` 接入 StartedService；直接使用 Box 时仍可传入同一类 writer，但必须自己实现错误级别过滤、reset 事件和历史日志上限。仅保存一个 `atomic.Value` 状态不能替代这些流语义。

## 推荐迁移路线

### 阶段 0：建立基线

1. 为 `Start`、`Restart`、`Stop`、`SelectNode`、`SelectRouteNode`、状态流、日志流、流量流、回滚和关闭连接补齐行为测试。
2. 增加基准测试，分别测配置生成、`checkConfig`、Badger/Store 写入和 live select；文档中的 50/100/200ms 目前没有仓库内基准支撑。
3. 固定 sing-box v1.14.0 API 适配点，迁移期间不要同时升级 sing-box。

### 阶段 1：抽象运行时边界，不改变后端

新增内部 `runtimeEngine` 接口，至少包含：

```go
StartOrReload(ctx context.Context, content string) error
CheckConfig(ctx context.Context, content string) error
CloseService() error
Status() (*daemon.ServiceStatus, error)
SelectOutbound(ctx context.Context, group, outbound string) error
SubscribeState(...) error
SubscribeLogs(...) error
SubscribeTraffic(...) error
CloseConnection(ctx context.Context, id string) error
CloseAllConnections(ctx context.Context) error
```

先用现有 `StartedService` 实现该接口，把 Manager 对 `started` 和 `daemonAdapter` 的直接依赖收拢到一个文件。这样可以单独替换运行时，不动 gRPC 合约、配置生成和持久化。

### 阶段 2：实现 Box 后端的最小闭环

实现 `boxRuntime`，先只接管：

1. 解析 `option.Options`、创建实例、`Start`、`Close`。
2. `SelectOutbound` 的正确 selector 路径。
3. 状态机：`idle -> starting -> running`，失败进入 `failed`，停止经过 `stopping`。
4. 旧实例关闭后新实例启动失败时，使用 last-known-good 配置恢复；恢复失败返回 `DATA_LOSS`，与现有行为一致。

这一阶段可以暂时让日志、流量和连接相关接口返回明确的 `Unimplemented`，但不能把能力静默丢掉；Manager 默认仍使用 daemon 后端，Box 后端只在专门测试中启用。

### 阶段 3：逐项接管外围能力

先接日志和状态，再接流量，最后接连接控制。流量 tracker 需要验证 TCP、UDP、TUN 和 reload 后计数器的生命周期；连接控制需要验证 ID 稳定性、关闭竞态和 Box.Close 期间的行为。每项能力都有等价测试后，才把默认后端切换为 Box。

### 阶段 4：删除 daemon 适配

只有在所有 TargetLib RPC 都有 Box 后端实现，并且跨平台 TUN、平台回调、OOM killer、日志、流量、连接和回滚测试通过后，才删除 `daemonAdapter` 和 `StartedService` 依赖。这个阶段不应与配置 Blueprint 重构或持久化协议迁移放在同一个变更中。

## 建议的取舍

- **可以立即做**：保留 Blueprint；继续使用 `BuildNormalized`；测量后缩小配置生成和 `opMu` 临界区；为已有 live selector 路径补并发与持久化失败测试。
- **需要单独设计**：异步持久化、内部持久化 v2、`UpsertRoute` 的增量更新。
- **暂不建议直接做**：删除 Blueprint；用自定义 ticker 伪造 StartedService 的全部流；在没有 tracker/连接方案前切换到 Box 默认后端。

本评审不改变现有代码路径，只记录基于当前工作树和 sing-box v1.14.0 源码核对出的约束与迁移顺序。
