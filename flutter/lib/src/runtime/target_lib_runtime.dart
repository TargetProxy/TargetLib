import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../targetlib_logger.dart';
import 'target_lib_connection.dart';
import 'target_lib_service_manager.dart';
import '../../targetlib_platform_interface.dart';
import '../generated/api/TargetLib/targetlib.pb.dart';

/// Cross-platform TargetLib process and local gRPC runtime.
final class TargetLibRuntime {
  TargetLibRuntime({TargetLibServiceManager? serviceManager})
    : _serviceManager = serviceManager ?? TargetLibServiceManager();

  final TargetLibServiceManager _serviceManager;
  TargetLibConnection? _connection;
  Process? _process;
  bool _androidServiceStarted = false;

  TargetLibConnection? get connection => _connection;
  TargetLibServiceManager get serviceManager => _serviceManager;
  static bool get isSupported =>
      Platform.isWindows ||
      Platform.isLinux ||
      Platform.isMacOS ||
      Platform.isAndroid;

  Future<String> resolveBasePath({
    String override = '',
    String? rootOverride,
  }) async {
    if (override.trim().isNotEmpty) return override.trim();
    if (rootOverride != null && rootOverride.trim().isNotEmpty) {
      return '${rootOverride.trim()}${Platform.pathSeparator}core';
    }
    final support = await getApplicationSupportDirectory();
    return '${support.path}${Platform.pathSeparator}core';
  }

  Future<String> resolveTempPath(String override) async {
    if (override.trim().isNotEmpty) return override.trim();
    try {
      final cache = await getApplicationCacheDirectory();
      if (cache.path.trim().isNotEmpty) {
        final target = Directory(
          '${cache.path}${Platform.pathSeparator}Target',
        );
        await target.create(recursive: true);
        return target.path;
      }
    } on Object catch (_) {}
    try {
      final temp = await getTemporaryDirectory();
      if (temp.path.trim().isNotEmpty) {
        final target = Directory('${temp.path}${Platform.pathSeparator}Target');
        await target.create(recursive: true);
        return target.path;
      }
    } on Object catch (_) {}
    return '';
  }

  Future<TargetLibConnection> ensureConnected({
    required String basePath,
    required String workingPath,
    required String tempPath,
    required String locale,
  }) async {
    final current = _connection;
    if (current != null) return current;
    final base = Directory(basePath);
    await base.create(recursive: true);
    final socketPath =
        '${base.path}${Platform.pathSeparator}${TargetLibConnection.socketName}';
    try {
      _connection = await TargetLibConnection.connect(
        socketPath: socketPath,
        timeout: const Duration(milliseconds: 500),
      );
      TargetLibLog.info(
        'Connected via ${_connection!.transport}',
        source: 'TargetLib',
      );
      return _connection!;
    } on Object {
      if (Platform.isAndroid) {
        await TargetlibPlatform.instance.startAndroidService(
          basePath: base.path,
        );
        _androidServiceStarted = true;
      } else {
        _process ??= await _serviceManager.launch(
          basePath: base.path,
          workingPath: workingPath,
          tempPath: tempPath,
          locale: locale,
        );
      }
    }
    try {
      _connection = await TargetLibConnection.connect(socketPath: socketPath);
      TargetLibLog.info(
        'Connected via ${_connection!.transport}',
        source: 'TargetLib',
      );
      return _connection!;
    } on Object {
      final failedProcess = _process;
      _process = null;
      if (failedProcess != null) {
        failedProcess.kill();
        await failedProcess.exitCode.timeout(
          const Duration(seconds: 2),
          onTimeout: () => -1,
        );
      }
      rethrow;
    }
  }

  Future<void> close() async {
    await _connection?.close();
    _connection = null;
    final process = _process;
    _process = null;
    if (process != null) {
      process.kill();
      await process.exitCode.timeout(
        const Duration(seconds: 2),
        onTimeout: () => -1,
      );
    }
    if (Platform.isAndroid && _androidServiceStarted) {
      await TargetlibPlatform.instance.stopAndroidService();
      _androidServiceStarted = false;
    }
  }

  Future<OperationResponse> start() async =>
      (await _requireConnection()).start();

  Future<OperationResponse> restart() async =>
      (await _requireConnection()).restart();

  Future<OperationResponse> stop() async => (await _requireConnection()).stop();

  Future<ServiceState> state() async => (await _requireConnection()).state();

  Future<RuntimeConfig> getRuntimeConfig() async =>
      (await _requireConnection()).getRuntimeConfig();

  Future<RuntimeConfig> updateRuntimeConfig(RuntimeSettings settings) async =>
      (await _requireConnection()).updateRuntimeConfig(settings);

  Future<TargetLibConnection> _requireConnection() async {
    final current = _connection;
    if (current != null) return current;
    throw StateError('TargetLib is not connected');
  }
}
