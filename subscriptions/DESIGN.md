# Subscription Service Design

The `subscriptions` package owns subscription behavior end to end and has no
dependency on gRPC, FFI, Flutter, or sing-box runtime types.

## Responsibilities

```text
gRPC adapter or host bridge
        |
        v
subscriptions.Manager
  |-- HTTPFetcher (Resty / net/http)
  |-- ParseProfile (complete sing-box JSON + neutral nodes)
  |-- Resolver (neutral proxy endpoint IPs)
  |-- Store (atomic encrypted snapshots)
  `-- event stream + scheduler
        |
        v
host transport / storage / network integration
```

The frontend issues only coarse commands: add, remove,
rename, enable, update, select, list, and subscribe to events. It must not
download profiles, parse headers, schedule updates, or resolve endpoints.

## Update transaction

1. Mark the subscription `updating/fetching` and reject a concurrent update.
2. Fetch over HTTPS with a bounded response, retry policy, ETag, and
   Last-Modified validators.
3. Parse and retain the complete sing-box JSON document.
4. Produce neutral nodes, including failed intermediate nodes instead of
   silently dropping them.
5. Resolve ready proxy endpoints into platform-neutral IP address strings.
6. Atomically persist the new snapshot and publish an event.
7. On failure, retain the last good profile and schedule a bounded retry.

The subscription package does not construct TUN routes or call socket-protect
APIs. Android VPNService, Apple Network Extension, and desktop TUN adapters can
consume `ResolvedEndpoints` according to their own lifecycle.

## HTTP library decision

`github.com/go-resty/resty/v2` is used on top of `net/http`.

| Library | Decision | Reason |
|---|---|---|
| Resty v2 | Selected | Context support, retries, hooks, standard transports, small integration surface |
| retryablehttp | Not selected | Good retry layer, but most request/response behavior still needs wrapping |
| req/v3 | Not selected | Strong feature set, but heavier than required for periodic JSON downloads |
| fasthttp | Not selected | Optimized for high request volume and incompatible with normal `net/http` middleware/transports |

Retries are limited to transport failures, HTTP 429, and HTTP 5xx. Permanent
4xx responses are returned directly. Redirects are capped and HTTPS downgrade
redirects are rejected.

## Persistence and secrets

`OpenBadgerStore(path, key)` is the only persistent-store entry point. Each
subscription is a separate versioned CBOR value in BadgerDB and changes use
single-record transactions. Badger encrypts keys and values with AES-256; the
host injects exactly 32 bytes of key material:

- Android: key material supplied by the host's Keystore integration
- iOS/macOS: key material supplied by the host's Keychain integration
- Desktop: the optional `subscriptions/keyringstore` adapter can use Windows
  Credential Manager, macOS Keychain, or Linux Secret Service

The core package imports no mobile or desktop credential API. A host may also
inject another `Store` without changing the manager. Badger is tuned for this
small mobile workload: 4MB block cache, 4MB index cache, a 16MB memtable, two
compactors, an 8MB value-log limit, disabled metrics/logging, and synchronous
writes. HTTP responses are capped at 2MB so every profile fits in one simple
transaction. Call `Close` during an orderly host shutdown and never open the same
database directory from two processes.

## Mobile boundary

Android and Apple builds use the same HTTP, parser, scheduler, model, and event
code. The host owns filesystem paths, secure-key retrieval, background-task
lifecycle, VPN/TUN handling, and FFI bindings. `Manager.Run` takes a context so
mobile lifecycle code can stop background work without platform hooks here.
Badger's directory must live in application-private storage and must not be an
iCloud/backup-coordinated directory while it is open.

## Transport boundary

The gRPC adapter in the `subscriptions` package maps protobuf messages to the
public manager methods and exposes `Event` as a server stream. `View` is the transport-safe
read model: it keeps node intermediate states and quota data while excluding
URLs, headers, cache validators, raw configs, and node credentials. Raw config
is available only through the explicit `GetSubscriptionConfig` RPC.

The adapter contains no subscription behavior. FFI and platform TUN handling
remain host-owned.
