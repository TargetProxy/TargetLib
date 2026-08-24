import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'target_lib_connection.dart';
import 'target_lib_service_manager.dart';

/// Cross-platform TargetLib process and command-socket runtime.
final class TargetLibRuntime {
  TargetLibRuntime({TargetLibServiceManager? serviceManager})
      : _serviceManager = serviceManager ?? TargetLibServiceManager();

  final TargetLibServiceManager _serviceManager;
  TargetLibConnection? _connection;
  Process? _process;
  String? _socketPath;

  TargetLibConnection? get connection => _connection;
  String? get socketPath => _socketPath;
  TargetLibServiceManager get serviceManager => _serviceManager;
  static bool get isSupported =>
      Platform.isWindows || Platform.isLinux || Platform.isMacOS;

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
        final target = Directory('${cache.path}${Platform.pathSeparator}Target');
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
    _socketPath = '${base.path}${Platform.pathSeparator}command.sock';
    if (_process == null && !await File(_socketPath!).exists()) {
      _process = await _serviceManager.launch(
        basePath: base.path,
        workingPath: workingPath,
        tempPath: tempPath,
        locale: locale,
      );
    }
    try {
      _connection = await TargetLibConnection.connect(_socketPath!);
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
      final socket = File(_socketPath!);
      if (await socket.exists()) await socket.delete();
      _process = await _serviceManager.launch(
        basePath: base.path,
        workingPath: workingPath,
        tempPath: tempPath,
        locale: locale,
      );
      _connection = await TargetLibConnection.connect(_socketPath!);
      return _connection!;
    }
  }

  Future<void> close() async {
    await _connection?.close();
    _connection = null;
    final process = _process;
    _process = null;
    if (process != null) {
      process.kill();
      await process.exitCode.timeout(const Duration(seconds: 2), onTimeout: () => -1);
    }
  }
}
