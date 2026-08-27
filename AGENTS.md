# TargetLib

TargetLib 是跨平台的 sing-box 管理库。共享 Go 核心负责订阅管理、配置生成和 sing-box 生命周期，gRPC、FFI 与 Flutter 仅作为传输和平台接入层。

## 架构约束

- `subscriptions` 负责订阅下载、调度、持久化和节点解析，输出 node-only `profile.Profile`。
- 原始订阅只作为解析输入；服务商的入站、DNS、路由、rule set、代理组和运行时选项不得透传。
- `profile` 负责节点中间态及供应商节点规范化，不应包含供应商限定的 ALPN 等已移除字段。
- `config.Build(settings, profile)` 是生成 sing-box 配置的唯一入口，流程为 `Plan -> Blueprint -> Emit`。
- `manager` 负责运行时设置、sing-box 生命周期、热加载及失败回滚。
- gRPC 只作为传输层，不承担运行时策略；接口能力总览见 [docs/GRPC.md](docs/GRPC.md)。
- TUN、系统密钥、私有存储路径和 socket protect 等平台能力由宿主实现。

详细模块关系和订阅处理流程见 [docs/DESIGN.md](docs/DESIGN.md)，gRPC 接口能力见 [docs/GRPC.md](docs/GRPC.md)。
