import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'target_lib_service_manager.dart';

/// Application-facing service operations. UI code should use this controller
/// instead of constructing CLI arguments or resolving platform directories.
final class TargetLibServiceController {
  TargetLibServiceController({TargetLibServiceManager? manager})
      : _manager = manager ?? TargetLibServiceManager();

  final TargetLibServiceManager _manager;

  Future<String> _basePath(String override) async {
    if (override.trim().isNotEmpty) return override.trim();
    final support = await getApplicationSupportDirectory();
    return '${support.path}${Platform.pathSeparator}core';
  }

  Future<TargetLibServiceResult> status({String basePath = ''}) async =>
      _manager.run(
        'status',
        basePath: await _basePath(basePath),
      );

  Future<TargetLibServiceResult> start({
    String basePath = '',
    String workingPath = '',
    String tempPath = '',
    String locale = '',
  }) async =>
      _manager.run(
        'start',
        basePath: await _basePath(basePath),
        workingPath: workingPath,
        tempPath: tempPath,
        locale: locale,
      );

  Future<TargetLibServiceResult> installAndStart({
    String basePath = '',
    String workingPath = '',
    String tempPath = '',
    String locale = '',
  }) async =>
      _manager.installAndStart(
        basePath: await _basePath(basePath),
        workingPath: workingPath,
        tempPath: tempPath,
        locale: locale,
      );
}
