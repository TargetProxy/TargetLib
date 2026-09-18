import 'dart:io';

import 'android_targetlib_host_bridge.dart';
import 'target_lib_service_manager.dart';

enum TargetLibHostStatus {
  running,
  stopped,
  unknown,
  notInstalled,
  unsupported,
}

abstract interface class TargetLibHost {
  Future<TargetLibHostStatus> status();
  Future<void> start({required String basePath});
  Future<void> stop();
}

/// Shared implementation for installer-managed desktop services.
///
/// The concrete classes below make the platform mapping explicit while
/// keeping service command details in [TargetLibServiceManager].
class DesktopTargetLibHost implements TargetLibHost {
  DesktopTargetLibHost({TargetLibServiceManager? manager})
    : _manager = manager ?? TargetLibServiceManager();
  final TargetLibServiceManager _manager;

  @override
  Future<TargetLibHostStatus> status() async =>
      _manager.status().then((result) => result.status.toHostStatus());

  @override
  Future<void> start({required String basePath}) async {
    await _manager.start();
  }

  @override
  Future<void> stop() async {
    await _manager.stop();
  }
}

final class WindowsTargetLibHost extends DesktopTargetLibHost {}

final class LinuxTargetLibHost extends DesktopTargetLibHost {}

final class MacOSTargetLibHost extends DesktopTargetLibHost {}

/// iOS has no installer-managed TargetLib host in this package yet.
/// Network Extension/Packet Tunnel integration must provide this host before
/// runtime connections can be established on iOS.
final class IOSTargetLibHost extends UnsupportedTargetLibHost {
  const IOSTargetLibHost();
}

final class AndroidTargetLibHost implements TargetLibHost {
  AndroidTargetLibHost({AndroidTargetLibHostBridge? bridge})
    : _bridge = bridge ?? const AndroidTargetLibHostBridge();
  final AndroidTargetLibHostBridge _bridge;

  @override
  Future<TargetLibHostStatus> status() async => TargetLibHostStatus.unknown;

  @override
  Future<void> start({required String basePath}) =>
      _bridge.start(basePath: basePath);

  @override
  Future<void> stop() => _bridge.stop();
}

class UnsupportedTargetLibHost implements TargetLibHost {
  const UnsupportedTargetLibHost();
  @override
  Future<TargetLibHostStatus> status() async => TargetLibHostStatus.unsupported;
  @override
  Future<void> start({required String basePath}) => Future.error(
    UnsupportedError('TargetLib host is not supported on this platform.'),
  );
  @override
  Future<void> stop() => Future.error(
    UnsupportedError('TargetLib host is not supported on this platform.'),
  );
}

TargetLibHost defaultTargetLibHost() {
  if (Platform.isAndroid) return AndroidTargetLibHost();
  if (Platform.isWindows) return WindowsTargetLibHost();
  if (Platform.isLinux) return LinuxTargetLibHost();
  if (Platform.isMacOS) return MacOSTargetLibHost();
  if (Platform.isIOS) return const IOSTargetLibHost();
  return const UnsupportedTargetLibHost();
}

extension on TargetLibServiceStatus {
  TargetLibHostStatus toHostStatus() => switch (this) {
    TargetLibServiceStatus.running => TargetLibHostStatus.running,
    TargetLibServiceStatus.stopped => TargetLibHostStatus.stopped,
    TargetLibServiceStatus.unknown => TargetLibHostStatus.unknown,
    TargetLibServiceStatus.notInstalled => TargetLibHostStatus.notInstalled,
  };
}
