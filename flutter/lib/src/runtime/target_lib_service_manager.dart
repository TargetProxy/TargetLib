import 'dart:io';

import '../targetlib_logger.dart';

enum TargetLibServiceStatus { running, stopped, unknown, notInstalled }

class TargetLibServiceResult {
  const TargetLibServiceResult(this.status);

  final TargetLibServiceStatus status;
}

/// Queries and starts the TargetLib service installed by the platform package.
final class TargetLibServiceManager {
  static const String _serviceName = 'TargetLib';

  Future<TargetLibServiceResult> status() async {
    if (Platform.isWindows) return _statusWindows();
    if (Platform.isLinux) return _statusLinux();
    if (Platform.isMacOS) return _statusMacOS();
    return const TargetLibServiceResult(TargetLibServiceStatus.notInstalled);
  }

  Future<TargetLibServiceResult> start() async {
    final result = switch (Platform.operatingSystem) {
      'windows' => await Process.run('sc.exe', ['start', _serviceName]),
      'linux' => await Process.run('systemctl', [
        'start',
        '${_serviceName.toLowerCase()}.service',
      ]),
      'macos' => await Process.run('launchctl', [
        'kickstart',
        'system/$_serviceName',
      ]),
      _ => throw UnsupportedError(
        'TargetLib desktop service is not supported on this platform.',
      ),
    };
    _throwOnFailure('start', result);
    return const TargetLibServiceResult(TargetLibServiceStatus.running);
  }

  Future<TargetLibServiceResult> _statusWindows() async {
    final result = await Process.run('sc.exe', ['query', _serviceName]);
    final output = _output(result);
    if (result.exitCode != 0) {
      return TargetLibServiceResult(
        _serviceMissing(output, result.exitCode)
            ? TargetLibServiceStatus.notInstalled
            : TargetLibServiceStatus.unknown,
      );
    }
    final match = RegExp(r'STATE\s+:\s+\d+\s+(\w+)').firstMatch(output);
    return TargetLibServiceResult(switch (match?.group(1)?.toUpperCase()) {
      'RUNNING' => TargetLibServiceStatus.running,
      'STOPPED' || 'PAUSED' => TargetLibServiceStatus.stopped,
      _ => TargetLibServiceStatus.unknown,
    });
  }

  Future<TargetLibServiceResult> _statusLinux() async {
    final result = await Process.run('systemctl', [
      'is-active',
      '${_serviceName.toLowerCase()}.service',
    ]);
    final state = result.stdout.toString().trim().toLowerCase();
    final output = _output(result).toLowerCase();
    if (output.contains('not found') || output.contains('could not be found')) {
      return const TargetLibServiceResult(TargetLibServiceStatus.notInstalled);
    }
    if (result.exitCode == 0 && state == 'active') {
      return const TargetLibServiceResult(TargetLibServiceStatus.running);
    }
    if (state == 'inactive' || state == 'failed' || state == 'activating') {
      return const TargetLibServiceResult(TargetLibServiceStatus.stopped);
    }
    if (state == 'unknown' || state == 'not-found') {
      return const TargetLibServiceResult(TargetLibServiceStatus.notInstalled);
    }
    return const TargetLibServiceResult(TargetLibServiceStatus.unknown);
  }

  Future<TargetLibServiceResult> _statusMacOS() async {
    final result = await Process.run('launchctl', [
      'print',
      'system/$_serviceName',
    ]);
    if (result.exitCode != 0) {
      return const TargetLibServiceResult(TargetLibServiceStatus.notInstalled);
    }
    final output = result.stdout.toString().toLowerCase();
    return TargetLibServiceResult(
      output.contains('state = running')
          ? TargetLibServiceStatus.running
          : TargetLibServiceStatus.stopped,
    );
  }

  void _throwOnFailure(String action, ProcessResult result) {
    if (result.exitCode == 0) return;
    final output = _output(result);
    TargetLibLog.error(
      'Service $action failed with exit code ${result.exitCode}: $output',
      source: 'TargetLib',
    );
    throw ProcessException(
      'TargetLib service',
      [action],
      output,
      result.exitCode,
    );
  }

  String _output(ProcessResult result) => [
    result.stdout.toString().trim(),
    result.stderr.toString().trim(),
  ].where((value) => value.isNotEmpty).join('\n');

  bool _serviceMissing(String output, int exitCode) {
    final value = output.toLowerCase();
    return exitCode == 1060 ||
        value.contains('does not exist') ||
        value.contains('not installed');
  }
}
