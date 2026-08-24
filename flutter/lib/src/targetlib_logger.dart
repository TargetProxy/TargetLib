import 'dart:developer' as developer;

typedef TargetLibLogSink = void Function(
  String level,
  String message, {
  Object? error,
  StackTrace? stackTrace,
  String? source,
});

abstract final class TargetLibLog {
  static TargetLibLogSink? sink;

  static void debug(String message, {String? source}) =>
      _write('DEBUG', message, source: source);

  static void info(String message, {String? source}) =>
      _write('INFO', message, source: source);

  static void warning(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? source,
  }) =>
      _write('WARN', message, error: error, stackTrace: stackTrace, source: source);

  static void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? source,
  }) =>
      _write('ERROR', message, error: error, stackTrace: stackTrace, source: source);

  static void _write(
    String level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? source,
  }) {
    final callback = sink;
    if (callback != null) {
      callback(level, message, error: error, stackTrace: stackTrace, source: source);
      return;
    }
    developer.log(message, name: source ?? 'TargetLib', level: level == 'ERROR' ? 1000 : 800, error: error, stackTrace: stackTrace);
  }
}
