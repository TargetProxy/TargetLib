# 🎯 TargetLib

![License: GPL](https://img.shields.io/badge/License-GPL-blue.svg)
![Platform: Cross-platform](https://img.shields.io/badge/Platform-Win%20%7C%20Mac%20%7C%20Linux%20%7C%20iOS%20%7C%20Android-lightgrey.svg)
![Tech Stack: Go & Flutter](https://img.shields.io/badge/Tech-Go%20%7C%20gRPC%20%7C%20Flutter-00ADD8.svg)

**TargetLib** 是跨平台的 sing-box 管理库。共享 Go 核心负责订阅管理、配置生成和 sing-box 生命周期，gRPC、FFI 与 Flutter 仅作为传输和平台接入层。

---

## ✨ 核心职责

*   📦 **订阅管理**：订阅下载、调度、持久化和节点解析，输出 node-only `profile.Profile`。
*   ⚙️ **配置生成**：`config.Build(settings, profile)` 是唯一入口，流程为 `Plan → Blueprint → Emit`。
*   🚀 **生命周期管理**：sing-box 启动、停止、热加载及失败回滚。
*   🧭 **运行时控制**：运行时设置、节点切换（SelectNode）、规则分流（UpsertRoute）。
*   📱 **平台接入**：TUN、系统密钥、私有存储路径和 socket protect 等平台能力由宿主实现。
*   🌐 **跨平台一致性**：Windows、Linux、macOS、Android 和 iOS 统一 gRPC 接口。

---

## 💡 架构约束

> **订阅只作为解析输入；服务商的入站、DNS、路由、rule set、代理组和运行时选项不得透传。**

*   `subscriptions` 负责订阅下载、调度、持久化和节点解析，输出 node-only `profile.Profile`。
*   原始订阅只作为解析输入；服务商的入站、DNS、路由、rule set、代理组和运行时选项不得透传。
*   `profile` 负责节点中间态及供应商节点规范化，不应包含供应商限定的 ALPN 等已移除字段。
*   `config.Build(settings, profile)` 是生成 sing-box 配置的唯一入口，流程为 `Plan → Blueprint → Emit`。
*   `manager` 负责运行时设置、sing-box 生命周期、热加载及失败回滚。
*   gRPC 只作为传输层，不承担运行时策略；接口能力总览见 [docs/GRPC.md](docs/GRPC.md)。
*   TUN、系统密钥、私有存储路径和 socket protect 等平台能力由宿主实现。
*   Flutter 和产品 UI 只提交意图、审批 proposal 并渲染 snapshot；不得实现选择器构造和完整 RuntimeModel。
*   Android 的长期任务必须由前台 VPN service 所有的 native TargetLib 执行，不得依赖 Activity、Flutter engine 或 Dart isolate 存活。

---

## 🛠️ 构建脚本

本地开发与 CI 使用相同的 PowerShell 入口：

```powershell
# 重新生成 Go 与 Dart protobuf 代码
.\scripts\generate.ps1

# 为当前平台或指定目标构建 gRPC service
.\scripts\service.ps1
.\scripts\service.ps1 -GOOS linux -GOARCH amd64

# 构建并重装 Windows 服务（同时安装 cn.srs）
.\scripts\reinstall-service.ps1

# 构建 Flutter Android 原生库
.\scripts\build-mobile.ps1
.\scripts\build-mobile.ps1 -OutputDir build\mobile\android
```

`service.ps1` 会在可执行文件旁生成配套的 `cn.srs`。Windows 重装脚本会将其复制到 sing-box 工作目录；
未显式指定 `-WorkingPath` 时，该目录就是 `-BasePath`。生成的原生库属于构建产物，不纳入 Git 版本管理。

---

## 📖 文档与设计

详细模块关系和订阅处理流程见：
👉 **[docs/DESIGN.md](docs/DESIGN.md)**

gRPC 接口能力见：
👉 **[docs/GRPC.md](docs/GRPC.md)**

---

## 📄 开源协议

本项目基于 **GPL** (GNU General Public License) 协议开源。
