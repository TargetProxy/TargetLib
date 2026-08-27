# TargetLib 架构

TargetLib 将订阅管理、配置生成和 sing-box 生命周期封装在共享的 Go 核心中。Flutter、FFI 和 gRPC 只负责调用，
不承担订阅下载、解析或运行时配置决策。

## 模块职责

| 模块 | 职责 |
| --- | --- |
| `api/TargetLib` | gRPC 协议与传输模型 |
| `subscriptions` | 订阅更新、调度、存储、事件和端点解析 |
| `profile` | 节点中间态与 sing-box 节点解析 |
| `config` | `Profile + Settings` 到 sing-box 配置的唯一生成路径 |
| `manager` | 配置协调、服务生命周期、状态、日志和流量 |
| `ffi/native`、`flutter` | 平台接入与客户端绑定 |

```mermaid
flowchart LR
    HOST["Flutter / native host"] --> API["gRPC / FFI"]
    API --> MANAGER["manager"]
    MANAGER --> SUB["subscriptions"]
    SUB --> PROFILE["node-only Profile"]
    PROFILE --> CONFIG["config.Plan + config.Emit"]
    MANAGER --> SETTINGS["runtime Settings"]
    SETTINGS --> CONFIG
    CONFIG --> BOX["sing-box runtime"]
    SUB <--> STORE["encrypted subscription store"]
    MANAGER <--> RSTORE["runtime settings store"]
```

## 核心边界

- 前端只发送添加、删除、更新、选择和启停等粗粒度命令。
- 原始订阅配置只作为解析输入，运行时只消费节点中间态 `profile.Profile`。
- `profile` 在持久化前统一规范化供应商节点；供应商 ALPN 和已移除的 TLS 字段不会进入节点中间态。
- 服务商提供的 DNS、路由、rule set、入站、selector/urltest 分组和运行时选项不会透传。
- `config.Build(settings, profile)` 是最终 sing-box 配置的唯一生成入口。
- `config.Emit` 只序列化 Blueprint 并校验结果，不再解析和重写完整 JSON 文档。
- TUN、系统密钥、私有存储路径和 socket protect 等平台能力由宿主实现。

配置生成分为一次规划和一次输出：

```text
Profile + Settings -> config.Plan -> Blueprint -> config.Emit -> sing-box JSON
```

## 订阅到 sing-box

```mermaid
flowchart TB
    A["订阅地址"] --> B{"更新触发"}
    B -->|手动| C["gRPC / 宿主命令"]
    B -->|定时| D["Scheduler"]
    C --> E["subscriptions.Manager"]
    D --> E

    subgraph UPDATE["订阅更新"]
        E --> F["singleflight 合并同一订阅的并发更新"]
        F --> G["HTTPFetcher<br/>HTTPS、重试、ETag、Last-Modified"]
        G --> H{"HTTP 结果"}
        H -->|304 未修改| I["更新流量、过期时间等元数据"]
        H -->|200 新内容| J["ParseProfile + 节点规范化"]
        H -->|下载失败| X["保留上次可用 Profile<br/>记录失败并安排重试"]
        J --> K["节点中间态 Profile<br/>稳定 ID、无供应商 ALPN、<br/>typed outbound、NodesHash"]
        J -.-> DROP["丢弃服务商配置<br/>DNS、规则、rule set、入站、<br/>代理组和运行时选项"]
        K --> L["解析节点服务器地址<br/>生成 ResolvedEndpoints"]
        L --> M["候选订阅快照"]
    end

    I --> N["单写 Coordinator"]
    X --> N
    M --> N
    N --> O{"活动订阅<br/>且 NodesHash 已变化？"}
    O -->|否| P["原子持久化"]
    O -->|是| Q["Runtime changed callback"]

    subgraph BUILD["sing-box 配置生成"]
        Q --> R["活动 Profile + Runtime Settings"]
        R --> S["config.Plan"]
        S --> T["Blueprint"]
        T --> T1["应用入站<br/>Mixed / TUN"]
        T --> T2["节点出站<br/>+ direct + urltest + proxy"]
        T --> T3["应用 DNS 与路由"]
        T --> T4["日志、缓存、Clash API"]
        T1 --> U["config.Emit"]
        T2 --> U
        T3 --> U
        T4 --> U
        U --> V["一次序列化<br/>生成 sing-box JSON"]
        V --> W["校验配置"]
    end

    W -->|校验或加载失败| Y["拒绝候选配置<br/>继续使用旧运行时"]
    W -->|通过| Z["applyConfig 热加载"]
    Z --> AA["运行中的 sing-box"]
    Z --> P
    P -->|成功| AB["发布不可变快照<br/>发送订阅事件"]
    P -->|热加载后持久化失败| AC["回滚旧 sing-box 配置"]
    AB --> AA
```

## 中间态规范化与恢复

`profile.Parse` 在生成 `Node.OutboundJSON` 和类型化 `Node.Outbound` 之前执行节点规范化。供应商指定的 ALPN、
已移除的 ECH 字段和过期的 uTLS 指纹在这一边界被处理，因此持久化表示与运行时表示保持同一不变量。

Badger 中的历史节点在加载时也通过 `profile.RestoreNodeOutbound` 执行相同规范化。若历史内容发生变化，内存中的
`OutboundJSON` 和 `NodesHash` 会同步刷新，避免重启后旧 ALPN 回流。完成上述处理后，`config.Emit` 无需构造
`map[string]any` 遍历整份配置，其固定流程为一次 `MarshalContext` 和一次最终 `validateConfig`。

## 一致性与失败处理

订阅更新由单写协调器串行提交。同一订阅的并发更新会被合并；下载或解析失败时保留上次可用节点并延迟重试。

活动订阅变化时，协调器先生成并加载新运行时配置，再原子持久化订阅状态。运行时加载失败不会提交候选状态；
加载成功后若持久化失败，则恢复旧运行时配置。快照成功提交后才向客户端发布更新事件。
