import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../targetlib_logger.dart';
import 'target_lib_connection.dart';
import 'target_lib_host.dart';
import '../generated/api/TargetLib/targetlib.pb.dart';

/// Cross-platform connection to the installer-managed TargetLib service.
final class TargetLibRuntime {
  TargetLibRuntime({TargetLibHost? host})
    : _host = host ?? defaultTargetLibHost();

  final TargetLibHost _host;
  TargetLibConnection? _connection;
  bool _hostStarted = false;

  TargetLibConnection? get connection => _connection;
  static bool get isSupported =>
      Platform.isWindows ||
      Platform.isLinux ||
      Platform.isMacOS ||
      Platform.isAndroid;

  Future<String> resolveBasePath({
    String override = '',
    String? rootOverride,
  }) async {
    if (override.trim().isNotEmpty) return override.trim();
    if (rootOverride != null && rootOverride.trim().isNotEmpty) {
      return '${rootOverride.trim()}${Platform.pathSeparator}core';
    }
    final support = await getApplicationSupportDirectory();
    return '${support.path}${Platform.pathSeparator}core';
  }

  Future<TargetLibConnection> ensureConnected({
    required String basePath,
  }) async {
    final current = _connection;
    if (current != null) return current;
    final base = Directory(basePath);
    await base.create(recursive: true);
    final socketPath =
        '${base.path}${Platform.pathSeparator}${TargetLibConnection.socketName}';
    try {
      _connection = await TargetLibConnection.connect(
        socketPath: socketPath,
        timeout: const Duration(milliseconds: 500),
      );
      TargetLibLog.info(
        'Connected via ${_connection!.transport}',
        source: 'TargetLib',
      );
      return _connection!;
    } on Object {
      final service = await _host.status();
      if (service == TargetLibHostStatus.notInstalled) {
        throw StateError('TargetLib service is not installed.');
      }
      if (service != TargetLibHostStatus.running) {
        await _host.start(basePath: base.path);
        _hostStarted = true;
      }
    }
    try {
      _connection = await TargetLibConnection.connect(socketPath: socketPath);
    } on Object {
      if (_hostStarted) {
        await _host.stop();
        _hostStarted = false;
      }
      rethrow;
    }
    TargetLibLog.info(
      'Connected via ${_connection!.transport}',
      source: 'TargetLib',
    );
    return _connection!;
  }

  Future<void> close() async {
    await _connection?.close();
    _connection = null;
    if (_hostStarted) {
      await _host.stop();
      _hostStarted = false;
    }
  }

  Future<OperationResponse> start() async =>
      (await _requireConnection()).start();
  Future<CapabilitiesResponse> capabilities() async =>
      (await _requireConnection()).capabilities();

  Future<OperationResponse> restart() async =>
      (await _requireConnection()).restart();

  Future<OperationResponse> stop() async => (await _requireConnection()).stop();

  Future<ServiceState> state() async => (await _requireConnection()).state();

  Future<RuntimeConfig> getRuntimeConfig() async =>
      (await _requireConnection()).getRuntimeConfig();

  Future<NodePool> getNodePool() async =>
      (await _requireConnection()).getNodePool();
  Future<RuntimeState> getRuntimeState() async =>
      (await _requireConnection()).getRuntimeState();

  Future<SmartConnectSnapshot> getSmartConnectSnapshot() async =>
      (await _requireConnection()).getSmartConnectSnapshot();
  Future<Operation> setSmartConnectEnabled(
    SetSmartConnectEnabledRequest request,
  ) async => (await _requireConnection()).setSmartConnectEnabled(request);
  Future<ServicePolicyList> listServicePolicies() async =>
      (await _requireConnection()).listServicePolicies();
  Future<Operation> upsertServicePolicy(
    UpsertServicePolicyRequest request,
  ) async => (await _requireConnection()).upsertServicePolicy(request);
  Future<Operation> deleteServicePolicy(
    DeleteServicePolicyRequest request,
  ) async => (await _requireConnection()).deleteServicePolicy(request);
  Future<Operation> setNodePreference(SetNodePreferenceRequest request) async =>
      (await _requireConnection()).setNodePreference(request);
  Future<Operation> requestServiceEvaluation(
    RequestServiceEvaluationRequest request,
  ) async => (await _requireConnection()).requestServiceEvaluation(request);
  Future<Operation> approveSwitchProposal(
    ProposalCommandRequest request,
  ) async => (await _requireConnection()).approveSwitchProposal(request);
  Future<Operation> rejectSwitchProposal(
    ProposalCommandRequest request,
  ) async => (await _requireConnection()).rejectSwitchProposal(request);
  Future<Operation> forceServiceBinding(
    ForceServiceBindingRequest request,
  ) async => (await _requireConnection()).forceServiceBinding(request);
  Future<Operation> getOperation(String operationId) async =>
      (await _requireConnection()).getOperation(operationId);
  Future<OperationList> listOperations(ListOperationsRequest request) async =>
      (await _requireConnection()).listOperations(request);
  Stream<SmartConnectEvent> subscribeSmartConnectEvents({
    int afterSequence = 0,
  }) async* {
    yield* (await _requireConnection()).subscribeSmartConnectEvents(
      afterSequence: afterSequence,
    );
  }

  Future<TargetLibConnection> _requireConnection() async {
    final current = _connection;
    if (current != null) return current;
    throw StateError('TargetLib is not connected');
  }
}
