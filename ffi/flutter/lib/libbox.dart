library;

import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';

import 'package:ffi/ffi.dart';

import 'src/raw_bindings.dart';

export 'src/raw_bindings.dart';

enum LibboxErrorKind {
  config,
  serviceState,
  systemProxy,
  missingLibrary,
  native,
}

final class LibboxException implements Exception {
  const LibboxException(
    this.message, {
    this.kind = LibboxErrorKind.native,
    this.code,
  });

  final String message;
  final LibboxErrorKind kind;
  final String? code;

  @override
  String toString() =>
      'LibboxException(${kind.name}${code == null ? '' : ', $code'}): $message';
}

final class LibboxInitOptions {
  const LibboxInitOptions({
    this.basePath = '.',
    this.workingPath = '.',
    this.tempPath = '.',
    this.locale,
    this.logMaxLines = 300,
    this.debug = false,
    this.oomKillerEnabled = false,
    this.oomKillerDisabled = true,
    this.oomMemoryLimit = 0,
  });

  final String basePath;
  final String workingPath;
  final String tempPath;
  final String? locale;
  final int logMaxLines;
  final bool debug;
  final bool oomKillerEnabled;
  final bool oomKillerDisabled;
  final int oomMemoryLimit;
}

enum LibboxServiceState {
  starting,
  running,
  stopping,
  stopped,
  failed,
  closed,
  unknown;

  static LibboxServiceState fromWire(String? value) => switch (value) {
        'starting' => starting,
        'running' => running,
        'stopping' => stopping,
        'stopped' => stopped,
        'failed' => failed,
        'closed' => closed,
        _ => unknown,
      };
}

final class LibboxServiceSnapshot {
  const LibboxServiceSnapshot({
    required this.state,
    required this.running,
    required this.closed,
    this.lastError,
  });

  factory LibboxServiceSnapshot.fromJson(Map<String, Object?> json) =>
      LibboxServiceSnapshot(
        state: LibboxServiceState.fromWire(json['state'] as String?),
        running: json['running'] == true,
        closed: json['closed'] == true,
        lastError: json['lastError'] as String?,
      );

  final LibboxServiceState state;
  final bool running;
  final bool closed;
  final String? lastError;
}

final class LibboxSystemProxyStatus {
  const LibboxSystemProxyStatus({
    required this.platform,
    required this.supported,
    required this.enabled,
    required this.hasSavedState,
    this.server,
    this.bypass,
  });

  factory LibboxSystemProxyStatus.fromJson(Map<String, Object?> json) =>
      LibboxSystemProxyStatus(
        platform: json['platform'] as String? ?? '',
        supported: json['supported'] == true,
        enabled: json['enabled'] == true,
        hasSavedState: json['hasSavedState'] == true,
        server: json['server'] as String?,
        bypass: json['bypass'] as String?,
      );

  final String platform;
  final bool supported;
  final bool enabled;
  final bool hasSavedState;
  final String? server;
  final String? bypass;
}

final class LibboxSystemProxyOptions {
  const LibboxSystemProxyOptions({
    this.host = '127.0.0.1',
    this.port = 2080,
    this.bypass = '<local>',
  });

  final String host;
  final int port;
  final String bypass;
}

/// High-level API for the current `libbox` C ABI.
///
/// Logs are intentionally not exposed here. Applications can enable libbox's
/// command server over the local Unix socket at `<basePath>/command.sock`.
/// and use its gRPC interface independently.
final class LibboxFfi {
  LibboxFfi._(this.raw, [this._libraryPath, this._useProcess = false]);

  factory LibboxFfi.fromLibrary(DynamicLibrary library) =>
      LibboxFfi._(LibboxRawBindings(library));

  factory LibboxFfi.open([String? path]) =>
      LibboxFfi._(LibboxRawBindings(openDefaultLibrary(path)), path);

  factory LibboxFfi.openBundled([String? path]) {
    if (path != null && path.isNotEmpty) {
      return LibboxFfi._(LibboxRawBindings(DynamicLibrary.open(path)), path);
    }
    if (Platform.isIOS) {
      return LibboxFfi.fromLibrary(DynamicLibrary.process());
    }
    return LibboxFfi.open();
  }

  factory LibboxFfi.process() =>
      LibboxFfi._(LibboxRawBindings(DynamicLibrary.process()), null, true);

  final LibboxRawBindings raw;
  final String? _libraryPath;
  final bool _useProcess;

  static List<String> get defaultLibraryNames {
    if (Platform.isWindows) return const ['libbox.dll'];
    if (Platform.isMacOS || Platform.isIOS) {
      return const ['libbox.dylib'];
    }
    return const ['libbox.so'];
  }

  static DynamicLibrary openDefaultLibrary([String? path]) {
    if (path != null && path.isNotEmpty) return DynamicLibrary.open(path);
    Object? lastError;
    final directories = <String>{
      Directory.current.path,
      File(Platform.executable).parent.path,
      File(Platform.resolvedExecutable).parent.path,
    };
    for (final name in defaultLibraryNames) {
      for (final directory in directories) {
        try {
          return DynamicLibrary.open(
            '$directory${Platform.pathSeparator}$name',
          );
        } catch (error) {
          lastError = error;
        }
      }
      try {
        return DynamicLibrary.open(name);
      } catch (error) {
        lastError = error;
      }
    }
    throw LibboxException(
      'unable to load native library (${defaultLibraryNames.join(', ')}): $lastError',
      kind: LibboxErrorKind.missingLibrary,
      code: 'native.library_not_found',
    );
  }

  String version() => _takeString(raw.libboxVersion());
  String goVersion() => _takeString(raw.libboxGoVersion());

  void init([LibboxInitOptions options = const LibboxInitOptions()]) {
    final nativeOptions = calloc<LibboxNativeInitOptions>();
    final error = calloc<Pointer<Utf8>>();
    final strings = <Pointer<Utf8>>[];
    Pointer<Utf8> allocate(String? value) {
      if (value == null) return nullptr;
      final pointer = value.toNativeUtf8(allocator: calloc);
      strings.add(pointer);
      return pointer;
    }

    try {
      nativeOptions.ref
        ..basePath = allocate(options.basePath)
        ..workingPath = allocate(options.workingPath)
        ..tempPath = allocate(options.tempPath)
        ..locale = allocate(options.locale)
        ..logMaxLines = options.logMaxLines
        ..debug = options.debug
        ..oomKillerEnabled = options.oomKillerEnabled
        ..oomKillerDisabled = options.oomKillerDisabled
        ..oomMemoryLimit = options.oomMemoryLimit;
      _throwOnError(
        raw.libboxInit(nativeOptions, error),
        error,
        code: 'native.init_failed',
      );
    } finally {
      for (final string in strings) {
        calloc.free(string);
      }
      calloc.free(error);
      calloc.free(nativeOptions);
    }
  }

  void checkConfig(String configJson) => _withString(configJson, (config) {
        final error = calloc<Pointer<Utf8>>();
        try {
          _throwOnError(
            raw.libboxCheckConfig(config, error),
            error,
            kind: LibboxErrorKind.config,
            code: 'config.invalid',
          );
        } finally {
          calloc.free(error);
        }
      });

  LibboxService start(String configJson) => _withString(configJson, (config) {
        final handle = calloc<Uint64>();
        final error = calloc<Pointer<Utf8>>();
        try {
          _throwOnError(
            raw.libboxStart(config, handle, error),
            error,
            code: 'service.start_failed',
          );
          return LibboxService._(this, handle.value);
        } finally {
          calloc.free(handle);
          calloc.free(error);
        }
      });

  void reload(LibboxHandle handle, String configJson) =>
      _withString(configJson, (config) {
        final error = calloc<Pointer<Utf8>>();
        try {
          _throwOnError(
            raw.libboxReload(handle, config, error),
            error,
            code: 'service.reload_failed',
          );
        } finally {
          calloc.free(error);
        }
      });

  void stop(LibboxHandle handle) {
    final error = calloc<Pointer<Utf8>>();
    try {
      _throwOnError(
        raw.libboxStop(handle, error),
        error,
        code: 'service.stop_failed',
      );
    } finally {
      calloc.free(error);
    }
  }

  void freeHandle(LibboxHandle handle) {
    if (raw.libboxFreeHandle(handle) != 0) {
      throw const LibboxException(
        'invalid service handle',
        kind: LibboxErrorKind.serviceState,
        code: 'service.invalid_handle',
      );
    }
  }

  /// Runs a blocking native operation on a background isolate so the calling
  /// isolate (typically the UI) is never frozen by long native work such as
  /// service start, reload or rule-set downloads. The native library is
  /// process-global, so reopening it inside the worker is cheap and safe.
  Future<T> _runNative<T>(T Function(LibboxFfi core) operation) {
    final path = _libraryPath;
    final useProcess = _useProcess;
    return Isolate.run(() {
      final core = useProcess ? LibboxFfi.process() : LibboxFfi.open(path);
      return operation(core);
    });
  }

  Future<LibboxService> startAsync(String configJson) async {
    final handle = await _runNative((core) => core.start(configJson).handle);
    return LibboxService._(this, handle);
  }

  Future<void> checkConfigAsync(String configJson) =>
      _runNative((core) => core.checkConfig(configJson));

  Future<void> reloadAsync(LibboxHandle handle, String configJson) =>
      _runNative((core) => core.reload(handle, configJson));

  Future<void> stopAsync(LibboxHandle handle) =>
      _runNative((core) => core.stop(handle));

  Future<void> freeHandleAsync(LibboxHandle handle) =>
      _runNative((core) => core.freeHandle(handle));

  LibboxServiceSnapshot serviceState(LibboxHandle handle) {
    final json = calloc<Pointer<Utf8>>();
    final error = calloc<Pointer<Utf8>>();
    try {
      _throwOnError(
        raw.libboxServiceState(handle, json, error),
        error,
        code: 'service.state_failed',
      );
      return LibboxServiceSnapshot.fromJson(
        _decodeObject(_takeString(json.value)),
      );
    } finally {
      calloc.free(json);
      calloc.free(error);
    }
  }

  LibboxSystemProxyStatus systemProxyStatus() {
    final json = calloc<Pointer<Utf8>>();
    final error = calloc<Pointer<Utf8>>();
    try {
      _throwOnError(
        raw.libboxSystemProxyStatus(json, error),
        error,
        kind: LibboxErrorKind.systemProxy,
        code: 'system_proxy.status_failed',
      );
      return LibboxSystemProxyStatus.fromJson(
        _decodeObject(_takeString(json.value)),
      );
    } finally {
      calloc.free(json);
      calloc.free(error);
    }
  }

  void setSystemProxy(
    bool enabled, {
    LibboxSystemProxyOptions options = const LibboxSystemProxyOptions(),
  }) {
    _withString(
      options.host,
      (host) => _withString(options.bypass, (bypass) {
        final error = calloc<Pointer<Utf8>>();
        try {
          _throwOnError(
            raw.libboxSetSystemProxy(
                host, options.port, bypass, enabled, error),
            error,
            kind: LibboxErrorKind.systemProxy,
            code: enabled
                ? 'system_proxy.enable_failed'
                : 'system_proxy.restore_failed',
          );
        } finally {
          calloc.free(error);
        }
      }),
    );
  }

  T _withString<T>(String value, T Function(Pointer<Utf8>) action) {
    final pointer = value.toNativeUtf8(allocator: calloc);
    try {
      return action(pointer);
    } finally {
      calloc.free(pointer);
    }
  }

  Map<String, Object?> _decodeObject(String source) =>
      Map<String, Object?>.from(jsonDecode(source) as Map);

  void _throwOnError(
    int result,
    Pointer<Pointer<Utf8>> error, {
    LibboxErrorKind kind = LibboxErrorKind.native,
    required String code,
  }) {
    if (result == 0) return;
    final message = error.value == nullptr
        ? 'native call failed'
        : _takeString(error.value);
    throw LibboxException(message, kind: kind, code: code);
  }

  String _takeString(Pointer<Utf8> pointer) {
    if (pointer == nullptr) return '';
    try {
      return pointer.toDartString();
    } finally {
      raw.libboxFreeString(pointer);
    }
  }
}

final class LibboxService {
  LibboxService._(this._core, this.handle);

  final LibboxFfi _core;
  final LibboxHandle handle;
  bool _closed = false;
  bool _systemProxyEnabled = false;

  bool get isClosed => _closed;

  LibboxServiceSnapshot state() => _closed
      ? const LibboxServiceSnapshot(
          state: LibboxServiceState.closed,
          running: false,
          closed: true,
        )
      : _core.serviceState(handle);

  void reload(String configJson) {
    _ensureOpen();
    _core.reload(handle, configJson);
  }

  Future<void> reloadAsync(String configJson) async {
    _ensureOpen();
    await _core.reloadAsync(handle, configJson);
  }

  Future<void> closeAsync() async {
    if (_closed) return;
    _closed = true;
    try {
      if (_systemProxyEnabled) {
        try {
          _core.setSystemProxy(false);
        } catch (_) {
          // The service handle must still be released when proxy restoration fails.
        }
      }
      await _core.stopAsync(handle);
    } finally {
      await _core.freeHandleAsync(handle);
    }
  }

  void enableSystemProxy([
    LibboxSystemProxyOptions options = const LibboxSystemProxyOptions(),
  ]) {
    _ensureOpen();
    _core.setSystemProxy(true, options: options);
    _systemProxyEnabled = true;
  }

  void disableSystemProxy() {
    if (!_systemProxyEnabled) return;
    _core.setSystemProxy(false);
    _systemProxyEnabled = false;
  }

  void close() {
    if (_closed) return;
    _closed = true;
    try {
      if (_systemProxyEnabled) {
        try {
          _core.setSystemProxy(false);
        } catch (_) {
          // The service handle must still be released when proxy restoration fails.
        }
      }
      _core.stop(handle);
    } finally {
      _core.freeHandle(handle);
    }
  }

  void _ensureOpen() {
    if (_closed) {
      throw const LibboxException(
        'service is closed',
        kind: LibboxErrorKind.serviceState,
        code: 'service.closed',
      );
    }
  }
}
