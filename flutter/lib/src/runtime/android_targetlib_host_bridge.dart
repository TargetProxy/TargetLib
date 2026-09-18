import 'package:flutter/services.dart';

/// Android-only bridge for VPN permission and foreground service lifecycle.
/// It is intentionally separate from the cross-platform plugin interface.
final class AndroidTargetLibHostBridge {
  const AndroidTargetLibHostBridge();

  static const MethodChannel _channel = MethodChannel('targetlib');

  Future<bool> requestPermission() async =>
      await _channel.invokeMethod<bool>('requestVpnPermission') ?? false;

  Future<void> start({required String basePath}) => _channel.invokeMethod<void>(
    'startAndroidService',
    {'basePath': basePath},
  );

  Future<void> stop() => _channel.invokeMethod<void>('stopAndroidService');
}
