import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'targetlib_method_channel.dart';

abstract class TargetlibPlatform extends PlatformInterface {
  /// Constructs a TargetlibPlatform.
  TargetlibPlatform() : super(token: _token);

  static final Object _token = Object();

  static TargetlibPlatform _instance = MethodChannelTargetlib();

  /// The default instance of [TargetlibPlatform] to use.
  ///
  /// Defaults to [MethodChannelTargetlib].
  static TargetlibPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [TargetlibPlatform] when
  /// they register themselves.
  static set instance(TargetlibPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool> requestVpnPermission() => throw UnimplementedError(
    'requestVpnPermission() has not been implemented.',
  );

  Future<void> startAndroidService({required String basePath}) =>
      throw UnimplementedError(
        'startAndroidService() has not been implemented.',
      );

  Future<void> stopAndroidService() => throw UnimplementedError(
    'stopAndroidService() has not been implemented.',
  );
}
