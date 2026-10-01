import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../targetlib_logger.dart';
import 'target_lib_connection.dart';
import 'target_lib_api.dart';
import 'target_lib_host.dart';

/// Cross-platform connection to the installer-managed TargetLib service.
final class TargetLibRuntime {
  TargetLibRuntime({TargetLibHost? host})
    : _host = host ?? defaultTargetLibHost();

  final TargetLibHost _host;
  TargetLibConnection? _connection;
  bool _hostStarted = false;

  TargetLibConnection? get connection => _connection;
  TargetLibConfig get config => TargetLibConfig(_requireConnection);
  TargetLibProxy get proxy => TargetLibProxy(_requireConnection);
  TargetLibSubscriptions get subscriptions =>
      TargetLibSubscriptions(_requireConnection);
  TargetLibRoutes get routes => TargetLibRoutes(_requireConnection);
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

  Future<TargetLibConnection> ensureConnected({
    required String basePath,
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
      final service = await _host.status();
      if (service == TargetLibHostStatus.notInstalled) {
        throw StateError('TargetLib service is not installed.');
      }
      if (service != TargetLibHostStatus.running) {
        await _host.start(basePath: base.path);
        _hostStarted = true;
      }
    }
    try {
      _connection = await TargetLibConnection.connect(socketPath: socketPath);
    } on Object {
      if (_hostStarted) {
        await _host.stop();
        _hostStarted = false;
      }
      rethrow;
    }
    TargetLibLog.info(
      'Connected via ${_connection!.transport}',
      source: 'TargetLib',
    );
    return _connection!;
  }

  Future<void> close() async {
    await _connection?.close();
    _connection = null;
    if (_hostStarted) {
      await _host.stop();
      _hostStarted = false;
    }
  }

  Future<TargetLibConnection> _requireConnection() async {
    final current = _connection;
    if (current != null) return current;
    throw StateError('TargetLib is not connected');
  }
}
