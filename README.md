# TargetLib

TargetLib 是跨平台的 sing-box 管理库。Windows、Linux、macOS、Android 和 iOS 共享同一份 Go 核心与 gRPC 协议；native FFI
只负责启动本地服务。

控制面只监听本机，通过 `<basePath>/targetlib.sock` 提供 gRPC，TCP 回退地址为 `127.0.0.1:19090`。不启用 TLS 或鉴权，也不监听局域网接口。

## 目录

```text
api/TargetLib/   gRPC 协议
cmd/TargetLib/   桌面 daemon
ffi/native/      C ABI
manager/         生命周期与运行时状态
profile/         订阅配置中间态（IR）
config/          Profile + Settings -> sing-box 配置
subscriptions/   订阅存储、更新与节点解析
flutter/         Flutter 插件与示例
scripts/         桌面构建和 Windows 服务重装脚本
```

配置生成采用一次规划、一次输出的流程：

```text
Profile + Settings -> config.Plan -> Blueprint -> config.Emit -> sing-box JSON
```

订阅运行配置只提供节点数据。DNS、路由规则、rule-set、入站和运行时选项均由 TargetLib 从零生成；`direct`、`urltest`、`proxy` 由 TargetLib 统一生成。

## 开发

依赖 Go 1.26 或更高版本。修改 proto 时还需要 protoc、protoc-gen-go 和 protoc-gen-go-grpc。

sing-box 的 HTTP/2 transport 需要测试标签 `http2legacy with_clash_api`，不要直接运行不带标签的 `go test ./...`。

构建桌面 daemon：

```powershell
.\scripts\build.ps1
```

默认输出 `build/TargetLib.exe`。也可以指定路径或跳过 Windows Target 同步：

```powershell
.\scripts\build.ps1 -OutputPath dist/TargetLib.exe -DebugBuild
.\scripts\build.ps1 -SkipTargetSync
```

Windows 开发时可用一条命令构建并重装服务。脚本会迁移现有服务参数、自动请求一次 UAC，
并在安装失败时尝试恢复旧二进制和服务：

```powershell
.\scripts\reinstall-service.ps1
```

常用选项：

```powershell
.\scripts\reinstall-service.ps1 -WhatIf             # 只查看重装计划
.\scripts\reinstall-service.ps1 -SkipBuild          # 使用 build/TargetLib.exe
.\scripts\reinstall-service.ps1 -NoStart -KeepBackup
```

## 运行

```powershell
.\build\TargetLib.exe --base-path ./run --log-max-lines 300
```

宿主调用 `targetlib_start` 后连接 gRPC；运行配置、生命周期、日志、订阅和端点查询均通过 `api/TargetLib/targetlib.proto` 定义的
`TargetLib` service 完成。

## 许可证

GPL
