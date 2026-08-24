# TargetLib

> **全平台统一架构** — TargetLib 为 Windows、Linux、macOS、Android 和 iOS 提供统一的 sing-box 管理能力。所有宿主共享同一份
> TargetLib gRPC 协议；native FFI 仅负责启动和释放本地 gRPC 服务，不维护独立的业务接口。

TargetLib 是基于 `sing-box` 的轻量封装，统一管理 sing-box 的启动、重载、状态、日志和订阅。

## 平台支持

| 平台                    | 接入方式                  | 说明                                      |
|-------------------------|---------------------------|-------------------------------------------|
| Windows                 | daemon / native + gRPC   | 可作为 Windows Service 运行               |
| Linux                   | daemon / native + gRPC   | 使用 Unix socket                          |
| macOS                   | daemon / native + gRPC   | 使用 Unix socket                          |
| Android                 | native + gRPC             | FFI 仅负责启动本地服务                    |
| iOS                     | native + gRPC             | FFI 仅负责启动本地服务                    |

## 功能

- 跨平台 sing-box 管控层，仅暴露 TargetLib 自有能力
- 统一 gRPC 服务：运行时生命周期管理，以及完整的订阅 CRUD、更新、端点查询、日志和事件流
- 轻量 C ABI（`targetlib` native library）仅用于启动、停止和释放 gRPC 服务
- 每个宿主进程维护一个运行时实例，支持并发安全的配置热重载
- 跨平台 Go 订阅服务：加密持久化、条件更新、自动调度、节点中间态及代理端点解析

## 目录结构

```
TargetLib/
├── api/TargetLib/                   # 聚合的 TargetLib gRPC 定义
├── cmd/TargetLib/                   # 独立守护进程 (go build)
├── ffi/native/                      # C ABI 导出 (c-shared / c-archive)
├── manager/                         # 核心管理逻辑 (Setup/New/Server)
├── config/                          # sing-box 配置构建
├── subscriptions/                   # 订阅生命周期、gRPC 适配与代理端点解析
├── scripts/                         # 构建脚本
└── build/                           # 构建产物 (gitignored)
```

## 快速开始

### 依赖

- Go >= 1.26
- protoc >= 3.x (仅改 proto 时需要)
- `protoc-gen-go` / `protoc-gen-go-grpc`

### 构建 daemon

```sh
go build -o build/TargetLib ./cmd/TargetLib
```

```powershell
.\scripts\build.ps1
# 输出 build/TargetLib.exe
# 如果同级 Target 已有 Windows 构建，同时刷新其 Debug/Release/Profile 副本
# 自定义输出
.\scripts\build.ps1 -OutputPath dist/TargetLib.exe -DebugBuild
# CI 或仅构建 TargetLib 时跳过 Target 同步
.\scripts\build.ps1 -SkipTargetSync
```

Windows Service 管理和目标同步脚本仅适用于 Windows：

```powershell
.\scripts\update-installed-service.ps1
```

运行 daemon：

```powershell
.\build\TargetLib.exe --base-path ./run --log-max-lines 300
# 服务控制 (Windows service)
.\build\TargetLib.exe install
.\build\TargetLib.exe start
.\build\TargetLib.exe status
```

### 构建 native FFI

```sh
go build -buildmode=c-shared -o build/targetlib.so ./ffi/native
go build -buildmode=c-archive -o build/targetlib.a ./ffi/native
```

Windows 使用 `.dll`，macOS 使用 `.dylib`；扩展名由 Go 工具链决定。

```powershell
.\scripts\build-native.ps1
# 输出 build/targetlib.dll + build/targetlib.h
.\scripts\build-native.ps1 -BuildMode c-archive -OutputPath dist/targetlib.a
```

C 调用示例：

```c
#include "targetlib.h"
targetlib_init_options opts = { .base_path = "./run", .log_max_lines = 300 };
char *err = NULL;
targetlib_init(&opts, &err);

targetlib_handle h;
targetlib_start("{\"log\":{...}}", &h, &err);
targetlib_stop(h, &err);
targetlib_free_handle(h);
targetlib_free_string(err);
```

所有平台的宿主均使用同一份 `api/TargetLib/targetlib.proto`。native 宿主调用
`targetlib_start` 后，通过 `<base_path>/command.sock` 连接 TargetLib gRPC；重载、状态、日志、订阅和测试等能力全部通过
gRPC 完成，不在 C ABI 中重复实现。

### 重新生成 proto

```powershell
.\scripts\generate.ps1
# 生成 api/TargetLib/*.pb.go
```

## gRPC API

`service TargetLib` (`api/TargetLib/targetlib.proto`) 聚合运行时和订阅管理：

所有平台的 daemon/native library 对外提供完全一致的 `TargetLib` service。sing-box 原始
`daemon.StartedService` 不对外注册。

| RPC                       | 说明                                           |
|---------------------------|------------------------------------------------|
| GetVersion                | 返回 TargetLib / sing-box / Go / protocol 版本 |
| GetCapabilities           | 平台信息                                       |
| CheckConfig               | 校验 JSON 配置                                 |
| Start/Reload/Restart/Stop | 生命周期控制                                   |
| ApplyRuntimeSettings      | 原子构建、校验并启动或重载运行配置             |
| TestOutbound              | 测试单个 outbound 并返回结构化延迟结果          |
| TestOutbounds             | 合并 URLTest group 后并发测试并流式返回结果     |
| GetState / SubscribeState | 查询 / 订阅 `ServiceState`                     |
| SubscribeLogs             | 订阅过滤后的运行日志（仅 INFO 及以上）         |
| SelectOutbound            | 在运行中的选择器中动态切换出站，不重载配置       |
| CloseConnection            | 关闭指定连接                                  |
| CloseAllConnections        | 关闭当前全部连接                              |

`BuildConfigSettings.route_mode` 支持 `DIRECT`（全部直连）、`RULE`（使用配置路由规则）和 `ALL`（全部使用代理主 outbound）；未设置时默认为 `RULE`。通过 `ApplyRuntimeSettings` 可在运行时原子切换。

`ServiceState`: `IDLE` / `STARTING` / `RUNNING` / `STOPPING` / `FAILED`

| RPC                                                       | 说明                                    |
|-----------------------------------------------------------|-----------------------------------------|
| ListSubscriptions / GetSubscription                       | 获取脱敏订阅视图和节点中间态            |
| AddSubscription / RemoveSubscription / RenameSubscription | 订阅 CRUD                               |
| SetSubscriptionEnabled / ConfigureSubscriptionUpdates     | 启用和自动更新配置                      |
| UpdateSubscription                                        | 下载、解析、解析端点并持久化            |
| GetSubscriptionConfig                                     | 显式读取完整 sing-box 配置              |
| GetResolvedEndpoints                                      | 返回供宿主处理的代理节点 IP，不修改 TUN |
| SubscribeSubscriptionEvents                               | 订阅新增、更新、删除和阶段事件          |

列表、单项和事件响应不会包含订阅 URL、请求头、缓存校验器或节点原始配置。

## 配置

`manager.Options`:

```go
type Options struct {
    BasePath    string // 运行时根目录 (含 command.sock)
    WorkingPath string // sing-box 工作目录，默认 BasePath
    TempPath    string // 临时目录，默认 WorkingPath
    Locale      string
    LogMaxLines int    // 默认 300
    Debug       bool
    SubscriptionStore subscriptions.Store // nil 时使用内存存储
}
```

`TargetLib` 默认使用系统凭据库保护的加密 BadgerDB。Android/iOS 宿主可从 Keystore/Keychain 取得 32 字节密钥后注入
`subscriptions.OpenBadgerStore(path, key)`。

## 协议版本

`manager.ProtocolVersion = 5`

## 许可证

GPL
