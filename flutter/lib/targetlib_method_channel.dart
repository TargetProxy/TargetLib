import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'targetlib_platform_interface.dart';

/// An implementation of [TargetlibPlatform] that uses method channels.
class MethodChannelTargetlib extends TargetlibPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('targetlib');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }

  @override
  Future<bool> requestVpnPermission() async =>
      await methodChannel.invokeMethod<bool>('requestVpnPermission') ?? false;

  @override
  Future<void> startAndroidService({required String basePath}) => methodChannel
      .invokeMethod<void>('startAndroidService', {'basePath': basePath});

  @override
  Future<void> stopAndroidService() =>
      methodChannel.invokeMethod<void>('stopAndroidService');
}
