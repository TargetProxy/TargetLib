import 'dart:ffi';

import 'package:ffi/ffi.dart';

/// Native representation of the `libbox_init_options` C structure.
final class LibboxNativeInitOptions extends Struct {
  external Pointer<Utf8> basePath;
  external Pointer<Utf8> workingPath;
  external Pointer<Utf8> tempPath;
  external Pointer<Utf8> locale;
  external Pointer<Utf8> commandSecret;

  @Int32()
  external int commandPort;

  @Int32()
  external int logMaxLines;

  @Bool()
  external bool debug;

  @Bool()
  external bool oomKillerEnabled;

  @Bool()
  external bool oomKillerDisabled;

  @Int64()
  external int oomMemoryLimit;
}

typedef LibboxHandle = int;

typedef LibboxVersionNative = Pointer<Utf8> Function();
typedef LibboxVersionDart = Pointer<Utf8> Function();
typedef LibboxFreeStringNative = Void Function(Pointer<Utf8>);
typedef LibboxFreeStringDart = void Function(Pointer<Utf8>);
typedef LibboxInitNative = Int32 Function(
    Pointer<LibboxNativeInitOptions>, Pointer<Pointer<Utf8>>);
typedef LibboxInitDart = int Function(
    Pointer<LibboxNativeInitOptions>, Pointer<Pointer<Utf8>>);
typedef LibboxCheckConfigNative = Int32 Function(
    Pointer<Utf8>, Pointer<Pointer<Utf8>>);
typedef LibboxCheckConfigDart = int Function(
  Pointer<Utf8>,
  Pointer<Pointer<Utf8>>,
);
typedef LibboxStartNative = Int32 Function(
    Pointer<Utf8>, Pointer<Uint64>, Pointer<Pointer<Utf8>>);
typedef LibboxStartDart = int Function(
    Pointer<Utf8>, Pointer<Uint64>, Pointer<Pointer<Utf8>>);
typedef LibboxReloadNative = Int32 Function(
    Uint64, Pointer<Utf8>, Pointer<Pointer<Utf8>>);
typedef LibboxReloadDart = int Function(
    int, Pointer<Utf8>, Pointer<Pointer<Utf8>>);
typedef LibboxStopNative = Int32 Function(Uint64, Pointer<Pointer<Utf8>>);
typedef LibboxStopDart = int Function(int, Pointer<Pointer<Utf8>>);
typedef LibboxFreeHandleNative = Int32 Function(Uint64);
typedef LibboxFreeHandleDart = int Function(int);
typedef LibboxJsonResultNative = Int32 Function(
    Pointer<Pointer<Utf8>>, Pointer<Pointer<Utf8>>);
typedef LibboxJsonResultDart = int Function(
    Pointer<Pointer<Utf8>>, Pointer<Pointer<Utf8>>);
typedef LibboxServiceStateNative = Int32 Function(
    Uint64, Pointer<Pointer<Utf8>>, Pointer<Pointer<Utf8>>);
typedef LibboxServiceStateDart = int Function(
    int, Pointer<Pointer<Utf8>>, Pointer<Pointer<Utf8>>);
typedef LibboxSetSystemProxyNative = Int32 Function(
  Pointer<Utf8>,
  Int32,
  Pointer<Utf8>,
  Bool,
  Pointer<Pointer<Utf8>>,
);
typedef LibboxSetSystemProxyDart = int Function(
  Pointer<Utf8>,
  int,
  Pointer<Utf8>,
  bool,
  Pointer<Pointer<Utf8>>,
);

/// Names of the stable symbols exported by the native library.
abstract final class LibboxNativeSymbols {
  static const version = 'libbox_version';
  static const goVersion = 'libbox_go_version';
  static const freeString = 'libbox_free_string';
  static const init = 'libbox_init';
  static const checkConfig = 'libbox_check_config';
  static const start = 'libbox_start';
  static const reload = 'libbox_reload';
  static const stop = 'libbox_stop';
  static const freeHandle = 'libbox_free_handle';
  static const serviceState = 'libbox_service_state';
  static const systemProxyStatus = 'libbox_system_proxy_status';
  static const setSystemProxy = 'libbox_set_system_proxy';
}

/// Typed, ownership-neutral bindings to the native C ABI.
///
/// Prefer [LibboxFfi] for application code. This class is public to support
/// integrations that need direct symbol access.
final class LibboxRawBindings {
  LibboxRawBindings(this.library)
      : libboxVersion =
            library.lookupFunction<LibboxVersionNative, LibboxVersionDart>(
          LibboxNativeSymbols.version,
        ),
        libboxGoVersion =
            library.lookupFunction<LibboxVersionNative, LibboxVersionDart>(
          LibboxNativeSymbols.goVersion,
        ),
        libboxFreeString = library
            .lookupFunction<LibboxFreeStringNative, LibboxFreeStringDart>(
          LibboxNativeSymbols.freeString,
        ),
        libboxInit = library.lookupFunction<LibboxInitNative, LibboxInitDart>(
          LibboxNativeSymbols.init,
        ),
        libboxCheckConfig = library
            .lookupFunction<LibboxCheckConfigNative, LibboxCheckConfigDart>(
          LibboxNativeSymbols.checkConfig,
        ),
        libboxStart =
            library.lookupFunction<LibboxStartNative, LibboxStartDart>(
          LibboxNativeSymbols.start,
        ),
        libboxReload =
            library.lookupFunction<LibboxReloadNative, LibboxReloadDart>(
          LibboxNativeSymbols.reload,
        ),
        libboxStop = library.lookupFunction<LibboxStopNative, LibboxStopDart>(
          LibboxNativeSymbols.stop,
        ),
        libboxFreeHandle = library
            .lookupFunction<LibboxFreeHandleNative, LibboxFreeHandleDart>(
          LibboxNativeSymbols.freeHandle,
        ),
        libboxServiceState = library
            .lookupFunction<LibboxServiceStateNative, LibboxServiceStateDart>(
          LibboxNativeSymbols.serviceState,
        ),
        libboxSystemProxyStatus = library
            .lookupFunction<LibboxJsonResultNative, LibboxJsonResultDart>(
          LibboxNativeSymbols.systemProxyStatus,
        ),
        libboxSetSystemProxy = library.lookupFunction<
            LibboxSetSystemProxyNative, LibboxSetSystemProxyDart>(
          LibboxNativeSymbols.setSystemProxy,
        );

  final DynamicLibrary library;
  final LibboxVersionDart libboxVersion;
  final LibboxVersionDart libboxGoVersion;
  final LibboxFreeStringDart libboxFreeString;
  final LibboxInitDart libboxInit;
  final LibboxCheckConfigDart libboxCheckConfig;
  final LibboxStartDart libboxStart;
  final LibboxReloadDart libboxReload;
  final LibboxStopDart libboxStop;
  final LibboxFreeHandleDart libboxFreeHandle;
  final LibboxServiceStateDart libboxServiceState;
  final LibboxJsonResultDart libboxSystemProxyStatus;
  final LibboxSetSystemProxyDart libboxSetSystemProxy;
}
