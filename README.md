# TargetLib

基于 `sing-box` 的轻量封装，提供 gRPC 守护进程 `targetlibd` 与 C ABI (`targetlib.dll` / `targetlib.h`)，统一管理 sing-box 的启动、重载与状态查询。

## 功能

- 封装 `sing-box` 核心，仅暴露必要能力
- gRPC 服务：`GetVersion` / `CheckConfig` / `Start` / `Reload` / `Restart` / `Stop` / `GetState` / `SubscribeState`
- C ABI 供桌面端/移动端通过 FFI 调用
- 单例 `StartedService`，支持并发安全的配置热重载

## 目录结构

```
TargetLib/
├── api/TargetLib/v1/manager.proto   # gRPC 定义
├── cmd/targetlibd/                  # 独立守护进程 (go build)
├── ffi/native/                      # C ABI 导出 (c-shared / c-archive)
├── manager/                         # 核心管理逻辑 (Setup/New/Server)
├── scripts/                         # 构建脚本
└── build/                           # 构建产物 (gitignored)
```

## 快速开始

### 依赖

- Go >= 1.26
- protoc >= 3.x (仅改 proto 时需要)
- `protoc-gen-go` / `protoc-gen-go-grpc`

### 构建守护进程

```powershell
.\scripts\build.ps1
# 输出 build/targetlibd.exe
# 自定义输出
.\scripts\build.ps1 -OutputPath dist/targetlibd.exe -DebugBuild
```

运行：

```powershell
.\build\targetlibd.exe --base-path ./run --log-max-lines 300
# 服务控制 (Windows service)
.\build\targetlibd.exe install
.\build\targetlibd.exe start
.\build\targetlibd.exe status
```

### 构建 C ABI

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
targetlib_service_state(h, &json, &err);
targetlib_stop(h, &err);
targetlib_free_handle(h);
targetlib_free_string(err);
```

### 重新生成 proto

```powershell
.\scripts\generate.ps1
# 生成 api/TargetLib/v1/*.pb.go
```

## gRPC API

`service TargetLibManager` ( `api/TargetLib/v1/manager.proto` )：

| RPC | 说明 |
|---|---|
| GetVersion | 返回 TargetLib / sing-box / Go / protocol 版本 |
| GetCapabilities | 平台信息 |
| CheckConfig | 校验 JSON 配置 |
| Start/Reload/Restart/Stop | 生命周期控制 |
| GetState / SubscribeState | 查询 / 订阅 `ServiceState` |

`ServiceState`: `IDLE` / `STARTING` / `RUNNING` / `STOPPING` / `FAILED`

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
}
```

## 协议版本

`manager.ProtocolVersion = 1`

## 许可证

见 `LICENSE`。
