// Temporary end-to-end verification of the async FFI path (Isolate.run + cgo).
// Run with: LIBBOX_LIBRARY=<path-to-libbox.dll> dart run tool/async_smoke.dart
import 'dart:io';

import 'package:libbox/libbox.dart';

Future<void> main() async {
  final libraryPath = Platform.environment['LIBBOX_LIBRARY'];
  if (libraryPath == null || libraryPath.isEmpty) {
    stderr.writeln('set LIBBOX_LIBRARY to run');
    exit(1);
  }
  final core = LibboxFfi.open(libraryPath);
  stdout.writeln('version: ${core.version()} (async on background isolate)');

  core.init(
    const LibboxInitOptions(
      basePath: '.',
      workingPath: '.',
      tempPath: '.',
    ),
  );

  const config = '''
{"log":{"level":"error"},"inbounds":[{"type":"mixed","tag":"mixed","listen":"127.0.0.1","listen_port":0}],"outbounds":[{"type":"direct","tag":"direct"}],"route":{"final":"direct"}}
''';
  final startWatch = Stopwatch()..start();
  final service = await core.startAsync(config);
  stdout.writeln(
      'startAsync ok in ${startWatch.elapsedMilliseconds}ms, handle=${service.handle}');

  final state = service.state();
  stdout.writeln('service state: ${state.state}, running=${state.running}');

  await service.closeAsync();
  stdout.writeln(
      'closeAsync ok (stop + freeHandle on background isolate) — ASYNC FFI PATH WORKS');
}
