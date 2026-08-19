# libbox

Flutter and Dart bindings for the `libbox` C ABI.

## Add the package from Git

Add the package to the application's `pubspec.yaml`. The Dart package lives
under `ffi/flutter` in the repository, so the `path` entry is required:

```yaml
dependencies:
  libbox:
    git:
      url: https://github.com/TargetProxy/libbox.git
      path: ffi/flutter
      ref: 1.13.19
```

Then fetch the dependency:

```shell
flutter pub get
```

The native library is not downloaded by Pub. Build or obtain the library for
each target and package it using that platform's normal native-library layout.
For Windows, place `libbox.dll` beside the application's executable. The
repository build script generates this file at `build/libbox.dll` and its C
header at `build/libbox.h`.

The package exposes version information, libbox initialization, configuration
validation, service lifecycle, service state, and desktop system proxy control.
It does not expose a log-draining API. Enable the libbox command server with
`LibboxInitOptions(commandPort: ..., commandSecret: ...)` and use its gRPC
surface when an application needs logs or other command-server features.

`LibboxFfi.openBundled()` uses process symbols on iOS and searches for the
dynamic library on other platforms. Its default names are `libbox.dll` on
Windows, `libbox.dylib` on macOS, and `libbox.so` on Linux/Android.

All strings returned by the native library are released automatically by the
high-level API. Direct users of `LibboxRawBindings` must release returned
strings with `libboxFreeString`.
