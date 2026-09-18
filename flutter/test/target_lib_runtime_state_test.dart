import 'package:flutter_test/flutter_test.dart';
import 'package:fixnum/fixnum.dart';
import 'package:targetlib/targetlib.dart';

void main() {
  test('runtime state copyWith preserves existing values', () {
    final caps = CapabilitiesResponse()..smartConnect = true;
    final runtime = RuntimeState();
    final event = RuntimeEvent()..sequence = Int64(3);
    final state = TargetLibRuntimeState(capabilities: caps, runtime: runtime);
    final next = state.copyWith(lastEvent: event);
    expect(next.capabilities, same(caps));
    expect(next.runtime, same(runtime));
    expect(next.lastEvent, same(event));
  });
}
