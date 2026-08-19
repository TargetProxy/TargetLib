import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:libbox/libbox.dart';

void main() {
  final libraryPath = Platform.environment['LIBBOX_LIBRARY'];

  test(
    'loads the native library and reads its version',
    () {
      final core = LibboxFfi.open(libraryPath);
      expect(core.version(), isNotEmpty);
      expect(core.goVersion(), startsWith('go'));
    },
    skip: libraryPath == null || libraryPath.isEmpty
        ? 'set LIBBOX_LIBRARY to run the native smoke test'
        : false,
  );
}
