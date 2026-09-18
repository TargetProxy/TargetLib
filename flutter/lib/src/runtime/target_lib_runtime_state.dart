import '../generated/api/TargetLib/targetlib.pb.dart';

/// Immutable client-side aggregate rebuilt from the runtime snapshot and events.
class TargetLibRuntimeState {
  const TargetLibRuntimeState({
    this.capabilities,
    this.runtime,
    this.lastEvent,
  });
  final CapabilitiesResponse? capabilities;
  final RuntimeState? runtime;
  final RuntimeEvent? lastEvent;

  TargetLibRuntimeState copyWith({
    CapabilitiesResponse? capabilities,
    RuntimeState? runtime,
    RuntimeEvent? lastEvent,
  }) => TargetLibRuntimeState(
    capabilities: capabilities ?? this.capabilities,
    runtime: runtime ?? this.runtime,
    lastEvent: lastEvent ?? this.lastEvent,
  );
}
