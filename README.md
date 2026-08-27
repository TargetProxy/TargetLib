# 🎯 TargetLib

![License: GPL](https://img.shields.io/badge/License-GPL-blue.svg)
![Platform: Cross-platform](https://img.shields.io/badge/Platform-Win%20%7C%20Mac%20%7C%20Linux%20%7C%20iOS%20%7C%20Android-lightgrey.svg)
![Tech Stack: Go & Flutter](https://img.shields.io/badge/Tech-Go%20%7C%20gRPC%20%7C%20Flutter-00ADD8.svg)

**TargetLib** 是一个专为 `sing-box` 打造的跨平台核心管理库。它通过统一的 **Go 语言核心**、高效的 **gRPC 控制接口**以及完善的 **Flutter 绑定**，为 Windows、Linux、macOS、Android 和 iOS 提供了一套无缝衔接的解决方案。

---

## ✨ 核心职责

TargetLib 全面接管了底层网络代理的复杂性，为您提供开箱即用的运行时能力：

*   📦 **订阅管理**：负责订阅配置的添加、更新、本地持久化以及节点信息的深度解析。
*   ⚙️ **配置引擎**：根据应用设置与解析出的订阅节点，动态生成安全、受控的 `sing-box` 配置文件。
*   🚀 **生命周期与监控**：全面管理 `sing-box` 的启动、停止与配置热加载（Hot-Reload），并实时接管运行状态、日志输出和流量统计。
*   🌐 **跨平台一致性**：抹平系统差异，确保无论是桌面端还是移动端，都能获得完全一致的 API 体验与运行时能力。

---

## 💡 架构理念：配置隔离

> **核心原则：订阅仅用于提供代理节点。**

为了确保客户端行为的绝对受控与纯净，TargetLib 采用了**“配置隔离”**的设计哲学：
所有的入站（Inbounds）、DNS 解析、路由规则（Routing）、以及 `direct`、`urltest`、`proxy` 等运行时策略，均由 TargetLib **自主接管并生成**。本库**绝不直接透传**服务商下发的原始配置，从而避免未知规则对本地环境的污染。

供应商节点在进入持久化中间态前会统一规范化，包括移除供应商限定的 ALPN；最终配置输出只执行一次序列化和一次 sing-box 配置校验。

---

## 📖 文档与设计

关于详细的系统架构图与完整的订阅处理流程，请参阅设计文档：
👉 **[docs/DESIGN.md](docs/DESIGN.md)**

---

## 📄 开源协议

本项目基于 **GPL** (GNU General Public License) 协议开源。
