import 'package:flutter_test/flutter_test.dart';
import 'package:targetlib/targetlib.dart';
import 'package:targetlib/targetlib_platform_interface.dart';
import 'package:targetlib/targetlib_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockTargetlibPlatform
    with MockPlatformInterfaceMixin
    implements TargetlibPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final TargetlibPlatform initialPlatform = TargetlibPlatform.instance;

  test('$MethodChannelTargetlib is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelTargetlib>());
  });

  test('getPlatformVersion', () async {
    Targetlib targetlibPlugin = Targetlib();
    MockTargetlibPlatform fakePlatform = MockTargetlibPlatform();
    TargetlibPlatform.instance = fakePlatform;

    expect(await targetlibPlugin.getPlatformVersion(), '42');
  });
}
