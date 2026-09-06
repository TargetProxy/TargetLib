# sing-box 1.14.0 适配调研

调研基线：sing-box `v1.14.0`（2026-08-31 发布），TargetLib 当前依赖 `github.com/sagernet/sing-box v1.13.19`。

官方发布说明：<https://github.com/SagerNet/sing-box/releases/tag/v1.14.0>

## 主要新增能力

- 新增 OpenVPN client/server、OpenConnect client、Snell、cloudflared inbound。
- L3 forwarding 与 `bridge` outbound；TUN、WireGuard、Tailscale 可直接转发 L3 流量。
- Linux network namespace（含 rootless `unshare`）和 USB/IP client/server。
- sing-box API service、`sing-box api` CLI、Dashboard 远程控制。
- Hysteria Realm/NAT 穿透；Hysteria2 默认 Chrome QUIC fingerprint、BBR profile、`gecko` obfs 等。
- DNS `evaluate`/response matching/race、optimistic cache、查询超时、mDNS、neighbor/MAC/hostname 匹配。
- TUN `dns_mode`/`dns_address`、UDP NAT 参数、pre-match UDP sniff。
- 顶层可复用 `http_clients`，共享 HTTP/2/QUIC 参数，证书 provider（ACME、Cloudflare Origin CA、Tailscale）。
- TLS spoof、Windows Schannel/Apple Network.framework TLS engine、Apple NSURLSession HTTP engine。
- Tailscale SSH/Taildrop、JSON Schema、rule-set 多 tag 和 `initial_path`。

## 对 TargetLib 的直接影响

### 必须在升级前处理

1. **构建链**：1.14.0 的 `go.mod` 为 `go 1.25.5`，官方说明要求至少 Go 1.25；CI、Windows 服务构建和移动端交叉编译镜像都要升级并锁定版本。当前 TargetLib `go.mod` 声明 Go 1.26，因此主版本声明满足要求，但实际 runner 仍需确认。
2. **TUN DNS 语义**：1.14 默认 `tun.dns_mode=hijack`，会设置系统接口 DNS，并在 Linux/Windows/Apple 安装平台级 DNS 劫持。TargetLib 当前 TUN 没有设置 `DNSMode`，但又生成 `hijack_dns` 路由规则（见 `config/build.go`）；升级后可能出现额外系统防火墙/权限副作用。应明确设置 `DNSMode`（建议按产品策略选择 `disabled` 或 `native`，保留显式路由劫持时不要依赖默认值），并增加各平台回归测试。
3. **DNS 规则兼容性**：`ip_version`/`query_type` 现在也作用于内部 DNS 查询；与旧地址过滤字段混用会在启动时拒绝。`independent_cache`、`store_rdrc`、旧 `strategy` 等进入弃用周期，将在 1.16 移除。TargetLib 当前只使用基础 UDP DNS，但应避免未来把这些旧字段加入生成配置。
4. **缓存配置**：持久化 DNS 缓存使用 `experimental.cache_file.store_dns`；`store_rdrc` 已被替代。现有 `CacheFileOptions` 初始化仍可编译，但若开启 DNS 持久化必须迁移字段。
5. **HTTP/ACME 配置模型**：远程 rule-set、ACME、Cloudflare Origin CA、DERP 请求改用顶层 `http_clients` 或引用 tag；旧的 inline dial/TLS 与 `download_detour` 仅保留兼容并计划在 1.16 删除。TargetLib 当前不透传供应商运行时配置，因此暂不需要行为改动，但后续扩展配置 API 时应采用新模型。

### 可选能力（不应透传订阅配置）

OpenVPN/OpenConnect/Snell、API service、USB/IP、network namespace、Hysteria Realm、TLS spoof、Tailscale SSH/Taildrop 等均属于运行时或平台能力。根据 TargetLib 架构约束，它们应通过受控的 `RuntimeSettings`/平台接口建模，不能把订阅原始 JSON 直接合并进 `config.Build`。

## API 与代码检查

- 1.14 的 `option.TunInboundOptions` 仍保留 `Address`、`RouteExcludeAddress`、`AutoRoute`、`StrictRoute` 等 TargetLib 当前使用字段，并新增 `NetNs`、`DNSMode`、`DNSAddress`、UDP NAT 和 MAC 过滤字段。
- `option.Options` 仍包含 `$schema`、`HTTPClients`、`NetworkNamespaces`、`CertificateProviders`；现有 `Blueprint` 可向前兼容，但新增 section 需要在 `RuntimePlan` 中显式建模。
- `daemon`/`experimental/libbox` 的 TargetLib 使用面未发现发布说明中的直接删除项；仍需在升级后的依赖完整可下载时运行 `go vet ./...` 和带 `http2legacy`/`-checklinkname=0` 的全量测试。

## 建议升级顺序

1. 先升级 Go/CI 和 `go.mod` 到 `sing-box v1.14.0`，运行全量编译测试。
2. 在 `config` 增加明确的 TUN `DNSMode` 策略及 Linux/Windows/macOS/Android 回归测试。
3. 检查生成 JSON 与 1.14 schema，确认没有旧 DNS/cache/HTTP 字段。
4. 再按需求评估新协议和 API service；为每项能力增加 TargetLib 自有 API，而不是放开供应商配置透传。

## 参考

- [1.14.0 Release Notes](https://github.com/SagerNet/sing-box/releases/tag/v1.14.0)
- [TUN inbound](https://sing-box.sagernet.org/configuration/inbound/tun/)
- [DNS migration](https://sing-box.sagernet.org/migration/)
- [HTTP client](https://sing-box.sagernet.org/configuration/shared/http-client/)
- [Certificate provider](https://sing-box.sagernet.org/configuration/shared/certificate-provider/)
