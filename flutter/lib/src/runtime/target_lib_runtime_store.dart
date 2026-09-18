import 'dart:async';

import 'target_lib_runtime.dart';
import 'target_lib_runtime_state.dart';

/// Keeps the last capability and runtime snapshot for UI consumers.
final class TargetLibRuntimeStore {
  TargetLibRuntimeStore(this.runtime);
  final TargetLibRuntime runtime;
  final _changes = StreamController<TargetLibRuntimeState>.broadcast();
  TargetLibRuntimeState _state = const TargetLibRuntimeState();
  TargetLibRuntimeState get state => _state;
  Stream<TargetLibRuntimeState> get changes => _changes.stream;

  Future<TargetLibRuntimeState> refresh() async {
    final capabilities = await runtime.capabilities();
    final snapshot = await runtime.getRuntimeState();
    _state = _state.copyWith(capabilities: capabilities, runtime: snapshot);
    _changes.add(_state);
    return _state;
  }

  Future<void> watch() async {
    await for (final event in runtime.subscribeRuntimeEvents()) {
      _state = _state.copyWith(lastEvent: event);
      _changes.add(_state);
    }
  }

  Future<void> dispose() => _changes.close();
}
