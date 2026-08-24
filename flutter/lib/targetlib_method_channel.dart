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
}
