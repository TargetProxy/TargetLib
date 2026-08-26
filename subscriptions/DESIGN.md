# Subscription Service Design

The `subscriptions` package owns subscription behavior end to end and has no dependency on gRPC, FFI, Flutter, or
sing-box runtime types.

## Responsibilities

```text
gRPC adapter or host bridge
        |
        v
subscriptions.Manager
  |-- HTTPFetcher (Resty / net/http)
  |-- ParseProfile -> profile.Profile (nodes-only snapshot with typed node outbounds)
  |-- Resolver (neutral proxy endpoint IPs)
  |-- Store (atomic encrypted snapshots)
  `-- event stream + scheduler
        |
        v
host transport / storage / network integration
```

The frontend issues only coarse commands: add, remove, rename, enable, update, select, list, and subscribe to events. It
must not download profiles, parse headers, schedule updates, or resolve endpoints.

## Update transaction

1. Coalesce concurrent updates for the same subscription with `singleflight` and mark it `updating/fetching`.
2. Fetch over HTTPS with a bounded response, retry policy, ETag, and Last-Modified validators.
3. Parse the source into the TargetLib `profile.Profile` node snapshot.
4. Retain only node data and typed node outbounds for persistence/reparse, including failed nodes.
5. Resolve ready proxy endpoints into platform-neutral IP address strings.
6. Submit the candidate state to the single-writer coordinator.
7. Apply an affected active runtime, atomically persist all related keys, and publish the immutable read snapshot.
8. If persistence fails after a runtime reload, restore the previous runtime before returning the error.
9. On download or parse failure, retain the last good profile and schedule a bounded retry.

The subscription package does not construct TUN routes or call socket-protect APIs. Android VPNService, Apple Network
Extension, and desktop TUN adapters can consume `ResolvedEndpoints` according to their own lifecycle.

## HTTP library decision

`github.com/go-resty/resty/v2` is used on top of `net/http`.

| Library       | Decision     | Reason                                                                                          |
|---------------|--------------|-------------------------------------------------------------------------------------------------|
| Resty v2      | Selected     | Context support, retries, hooks, standard transports, small integration surface                 |
| retryablehttp | Not selected | Good retry layer, but most request/response behavior still needs wrapping                       |
| req/v3        | Not selected | Strong feature set, but heavier than required for periodic JSON downloads                       |
| fasthttp      | Not selected | Optimized for high request volume and incompatible with normal `net/http` middleware/transports |

Retries are limited to transport failures, HTTP 429, and HTTP 5xx. Permanent 4xx responses are returned directly.
Redirects are capped and HTTPS downgrade redirects are rejected.

## Persistence and secrets

`OpenBadgerStore(path, key)` is the only persistent-store entry point. Each subscription is a separate versioned CBOR
value in BadgerDB. `Store.Update` groups subscription records, the active ID, and runtime metadata into one Badger
transaction when an operation changes more than one key. Badger encrypts keys and values with AES-256; the host
injects exactly 32 bytes of key material:

- Android: key material supplied by the host's Keystore integration
- iOS/macOS: key material supplied by the host's Keychain integration
- Desktop: the optional `subscriptions/keyringstore` adapter can use Windows Credential Manager, macOS Keychain, or
  Linux Secret Service

The core package imports no mobile or desktop credential API. A host may also inject another `Store` without changing
the manager. Badger is tuned for this small mobile workload: 4MB block cache, 4MB index cache, a 16MB memtable, two
compactors, an 8MB value-log limit, disabled metrics/logging, and synchronous writes. HTTP responses are capped at 2MB
so every profile fits in one simple transaction. Call `Close` during an orderly host shutdown and never open the same
database directory from two processes.

## Configuration boundary

Raw JSON is a parser input, never a runtime build input. Every source adapter produces a node-only `profile.Profile`,
and `config.Build(settings, profile)` is the only final configuration-generation path. The builder owns application
inbounds, node normalization, the default selector/urltest layer, route-mode overrides, cache injection, and final
sing-box validation. A complete sing-box subscription therefore cannot bypass TargetLib's orchestration logic.

## Mobile boundary

Android and Apple builds use the same HTTP, parser, scheduler, model, and event code. The host owns filesystem paths,
secure-key retrieval, background-task lifecycle, VPN/TUN handling, and FFI bindings. `Manager.Run` takes a context so
mobile lifecycle code can stop background work without platform hooks here. Badger's directory must live in
application-private storage and must not be an iCloud/backup-coordinated directory while it is open.

## Transport boundary

The gRPC adapter in the `subscriptions` package maps protobuf messages to the public manager methods and exposes `Event`
as a server stream. `View` is the transport-safe read model: it keeps node intermediate states and quota data while
excluding URLs, headers, cache validators, raw configs, and node credentials. The nested `ProfileView` is node-only:
it carries just the fields needed for front-end selection and keeps provider sections out of the payload.

The adapter contains no subscription behavior. FFI and platform TUN handling remain host-owned.
