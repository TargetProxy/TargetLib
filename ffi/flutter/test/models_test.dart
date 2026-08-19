import 'package:flutter_test/flutter_test.dart';
import 'package:libbox/libbox.dart';

void main() {
  test('parses native service snapshots', () {
    final snapshot = LibboxServiceSnapshot.fromJson({
      'state': 'stopped',
      'running': false,
      'closed': false,
      'lastError': 'example',
    });

    expect(snapshot.state, LibboxServiceState.stopped);
    expect(snapshot.running, isFalse);
    expect(snapshot.closed, isFalse);
    expect(snapshot.lastError, 'example');
  });

  test('parses system proxy status', () {
    final status = LibboxSystemProxyStatus.fromJson({
      'platform': 'windows',
      'supported': true,
      'enabled': true,
      'server': '127.0.0.1:2080',
      'bypass': '<local>',
      'hasSavedState': true,
    });

    expect(status.platform, 'windows');
    expect(status.enabled, isTrue);
    expect(status.hasSavedState, isTrue);
  });
}
