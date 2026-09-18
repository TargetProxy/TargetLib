# TargetLib

TargetLib 是跨平台的 sing-box 管理库。共享 Go 核心负责订阅管理、配置生成和 sing-box 生命周期，gRPC、FFI 与 Flutter 仅作为传输和平台接入层。

## 架构约束

- `subscriptions` 负责订阅下载、调度、持久化和节点解析，输出 node-only `profile.Profile`。
- 原始订阅只作为解析输入；服务商的入站、DNS、路由、rule set、代理组和运行时选项不得透传。
- `profile` 负责节点中间态及供应商节点规范化，不应包含供应商限定的 ALPN 等已移除字段。
- `config.Build(settings, profile)` 是生成 sing-box 配置的唯一入口，流程为 `Plan -> Blueprint -> Emit`。
- `manager` 负责运行时设置、sing-box 生命周期、热加载及失败回滚；Smart Connect 的策略、调度、决策、绑定状态机和审计也必须位于共享 Go 核心。
- gRPC 只作为传输层，不承担运行时策略；接口能力总览见 [docs/GRPC.md](docs/GRPC.md)。
- TUN、系统密钥、私有存储路径和 socket protect 等平台能力由宿主实现。
- Flutter 和产品 UI 只提交意图、审批 proposal 并渲染 snapshot；不得实现 Smart Connect 评分、探测调度或构造 selector、route、binding 和完整 RuntimeModel。
- Android 的长期任务必须由前台 VPN service 所有的 native TargetLib 执行，不得依赖 Activity、Flutter engine 或 Dart isolate 存活。

详细模块关系和订阅处理流程见 [docs/DESIGN.md](docs/DESIGN.md)，gRPC 接口能力见 [docs/GRPC.md](docs/GRPC.md)。


# AGENTS.md — Development & Coding Guidelines

## 1. Core Philosophy
* **KISS & YAGNI First**: Implement only what is directly requested. Never anticipate hypothetical future requirements.
* **Reject Over-Engineering**: Prefer a single clean function over a hierarchy of interfaces, factories, and builders.
* **Standard Library Priority**: Maximize use of standard library features and modern language idioms before introducing custom helpers or external packages.

## 2. Code Generation & Style
* **Zero Defensive Bloat**: Do not introduce unnecessary `try-catch` wrappers, redundant null/nil/type assertions, or trivial data transformation layers unless required by boundary contracts.
* **High Information Density**: Write idiomatic, compact code. Avoid boilerplate getters/setters, repetitive log statements, and useless boilerplate types.
* **Meaningful Comments Only**: Do NOT comment on self-evident code, function names, or boilerplate. Reserve comments exclusively for non-obvious algorithms, race condition mitigations, or hardware/OS-level quirks.

## 3. Editing & Refactoring Constraints
* **Surgical Edits**: Touch only the functions or lines directly related to the task. Keep diffs as small as possible.
* **No Full-File Dumps**: When updating existing code, provide only the modified functions or targeted replacements. Never regenerate an entire unchanged file.
* **Dead Code Pruning**: If a refactor renders previous functions, variables, or imports obsolete, eliminate them immediately rather than commenting them out.

## 4. Communication Rules
* **No Conversational Fluff**: Skip pleasantries, restating the prompt, and generic concluding remarks.
* **Brief Context**: If an implementation detail requires explanation, keep it to 1–2 bullet points directly below the code block.
