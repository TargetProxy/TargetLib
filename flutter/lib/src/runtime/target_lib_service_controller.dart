import 'target_lib_service_manager.dart';

/// Application-facing access to an installer-managed desktop service.
final class TargetLibServiceController {
  TargetLibServiceController({TargetLibServiceManager? manager})
    : _manager = manager ?? TargetLibServiceManager();

  final TargetLibServiceManager _manager;

  Future<TargetLibServiceResult> status() => _manager.status();

  Future<TargetLibServiceResult> start() => _manager.start();
}
