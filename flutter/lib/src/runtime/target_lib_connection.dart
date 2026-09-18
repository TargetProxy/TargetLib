import 'dart:async';
import 'dart:io';

import 'package:grpc/grpc.dart';
import 'package:fixnum/fixnum.dart' show Int64;
import 'package:protobuf/well_known_types/google/protobuf/empty.pb.dart';

import '../generated/api/TargetLib/targetlib.pbgrpc.dart';

/// Owns the local TargetLib command connection.
///
/// Socket-first transport selection and the readiness handshake live in the
/// plugin so applications do not duplicate gRPC setup or fallback behavior.
final class TargetLibConnection {
  TargetLibConnection._(
    this.channel,
    this.client,
    this.options,
    this.transport,
  );

  final ClientChannel channel;
  final TargetLibClient client;
  final CallOptions options;
  final String transport;

  static const String host = '127.0.0.1';
  static const int port = 19090;
  static const String socketName = 'targetlib.sock';
  static const String controlTokenName = 'control.token';

  static Future<TargetLibConnection> connect({
    required String socketPath,
    Duration timeout = const Duration(seconds: 5),
  }) async {
    final channels = <({String transport, ClientChannel channel})>[];
    Object? lastError;
    try {
      channels.add((
        transport: 'unix',
        channel: ClientChannel(
          InternetAddress(socketPath, type: InternetAddressType.unix),
          port: 0,
          options: const ChannelOptions(
            credentials: ChannelCredentials.insecure(),
          ),
        ),
      ));
    } on Object catch (error) {
      lastError = error;
    }
    channels.add((
      transport: 'tcp',
      channel: ClientChannel(
        host,
        port: port,
        options: const ChannelOptions(
          credentials: ChannelCredentials.insecure(),
        ),
      ),
    ));
    final tokenFile = File(
      '${File(socketPath).parent.path}${Platform.pathSeparator}$controlTokenName',
    );
    String? controlToken;
    try {
      controlToken = (await tokenFile.readAsString()).trim();
    } on FileSystemException {
      // Older cores do not create a token and remain usable for v12 APIs.
    }
    final options = CallOptions(
      metadata: controlToken == null || controlToken.isEmpty
          ? null
          : <String, String>{'authorization': 'Bearer $controlToken'},
    );
    final deadline = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(deadline)) {
      for (final candidate in channels) {
        final client = TargetLibClient(candidate.channel);
        try {
          await client
              .getVersion(Empty(), options: options)
              .timeout(const Duration(milliseconds: 250));
          for (final unused in channels) {
            if (!identical(unused.channel, candidate.channel)) {
              await unused.channel.shutdown();
            }
          }
          return TargetLibConnection._(
            candidate.channel,
            client,
            options,
            candidate.transport,
          );
        } on Object catch (error) {
          lastError = error;
        }
      }
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
    for (final candidate in channels) {
      await candidate.channel.shutdown();
    }
    throw StateError(
      'TargetLib command server did not become ready: $lastError',
    );
  }

  Future<void> close() => channel.shutdown();

  Future<OperationResponse> start() => client.start(Empty(), options: options);
  Future<CapabilitiesResponse> capabilities() =>
      client.getCapabilities(Empty(), options: options);

  Future<OperationResponse> restart() =>
      client.restart(Empty(), options: options);

  Future<OperationResponse> stop() => client.stop(Empty(), options: options);

  Future<ServiceState> state() => client.getState(Empty(), options: options);

  ResponseStream<TrafficStatus> subscribeTraffic({
    Duration interval = const Duration(seconds: 1),
  }) => client.subscribeTraffic(
    TrafficRequest(intervalMilliseconds: interval.inMilliseconds),
    options: options,
  );

  Future<RuntimeConfig> getRuntimeConfig() =>
      client.getRuntimeConfig(Empty(), options: options);

  Future<RuntimeConfig> updateRuntimeConfig(
    RuntimeSettings settings, {
    RuntimeModel? model,
    String? expectedRevision,
  }) => client.updateRuntimeConfig(
    UpdateRuntimeConfigRequest(
      settings: settings,
      model: model,
      expectedRevision: expectedRevision,
    ),
    options: options,
  );

  Future<NodePool> getNodePool() =>
      client.getNodePool(Empty(), options: options);
  Future<ServiceProbe> putServiceProbe(ServiceProbe probe) =>
      client.putServiceProbe(probe, options: options);
  Future<ServiceProbeList> listServiceProbes() =>
      client.listServiceProbes(Empty(), options: options);
  Future<void> removeServiceProbe(RemoveServiceProbeRequest request) async {
    await client.removeServiceProbe(request, options: options);
  }

  Future<SmartConnectDiagnostics> getSmartConnectDiagnostics({
    String? serviceId,
  }) => client.getSmartConnectDiagnostics(
    EvaluateServiceRequest(serviceId: serviceId),
    options: options,
  );
  Future<ServiceSelectionPolicy> getServiceSelectionPolicy(String serviceId) =>
      client.getServiceSelectionPolicy(
        ServiceSelectionPolicyRequest(serviceId: serviceId),
        options: options,
      );
  Future<ServiceSelectionPolicy> putServiceSelectionPolicy(
    ServiceSelectionPolicy policy,
  ) => client.putServiceSelectionPolicy(policy, options: options);
  ResponseStream<ProbeResult> probeService(ProbeServiceRequest request) =>
      client.probeService(request, options: options);
  Future<QualityHistory> getQualityHistory(QualityHistoryRequest request) =>
      client.getQualityHistory(request, options: options);
  Future<ServiceEvaluation> evaluateService(String serviceId) =>
      client.evaluateService(
        EvaluateServiceRequest(serviceId: serviceId),
        options: options,
      );
  ResponseStream<RuntimeEvent> subscribeRuntimeEvents() =>
      client.subscribeRuntimeEvents(Empty(), options: options);
  Future<SmartConnectPolicy> exportSmartConnectPolicy() =>
      client.exportSmartConnectPolicy(Empty(), options: options);
  Future<SmartConnectPolicy> importSmartConnectPolicy(
    ImportSmartConnectPolicyRequest request,
  ) => client.importSmartConnectPolicy(request, options: options);
  Future<RuntimeState> getRuntimeState() =>
      client.getRuntimeState(Empty(), options: options);
  Future<ServiceBindingList> listServiceBindings() =>
      client.listServiceBindings(Empty(), options: options);
  Future<RuntimeConfig> applyServiceBinding(
    ServiceBinding binding, {
    String? expectedRevision,
  }) => client.applyServiceBinding(
    ApplyServiceBindingRequest(
      binding: binding,
      expectedRevision: expectedRevision,
    ),
    options: options,
  );
  Future<RuntimeConfig> removeServiceBinding(
    String serviceId, {
    String? expectedRevision,
  }) => client.removeServiceBinding(
    RemoveServiceBindingRequest(
      serviceId: serviceId,
      expectedRevision: expectedRevision,
    ),
    options: options,
  );

  Future<SmartConnectSnapshot> getSmartConnectSnapshot() =>
      client.getSmartConnectSnapshot(Empty(), options: options);
  Future<Operation> setSmartConnectEnabled(
    SetSmartConnectEnabledRequest request,
  ) => client.setSmartConnectEnabled(request, options: options);
  Future<ServicePolicyList> listServicePolicies() =>
      client.listServicePolicies(Empty(), options: options);
  Future<Operation> upsertServicePolicy(UpsertServicePolicyRequest request) =>
      client.upsertServicePolicy(request, options: options);
  Future<Operation> deleteServicePolicy(DeleteServicePolicyRequest request) =>
      client.deleteServicePolicy(request, options: options);
  Future<Operation> setNodePreference(SetNodePreferenceRequest request) =>
      client.setNodePreference(request, options: options);
  Future<Operation> requestServiceEvaluation(
    RequestServiceEvaluationRequest request,
  ) => client.requestServiceEvaluation(request, options: options);
  Future<Operation> approveSwitchProposal(ProposalCommandRequest request) =>
      client.approveSwitchProposal(request, options: options);
  Future<Operation> rejectSwitchProposal(ProposalCommandRequest request) =>
      client.rejectSwitchProposal(request, options: options);
  Future<Operation> forceServiceBinding(ForceServiceBindingRequest request) =>
      client.forceServiceBinding(request, options: options);
  Future<Operation> getOperation(String operationId) => client.getOperation(
    GetOperationRequest(operationId: operationId),
    options: options,
  );
  Future<OperationList> listOperations(ListOperationsRequest request) =>
      client.listOperations(request, options: options);
  ResponseStream<SmartConnectEvent> subscribeSmartConnectEvents({
    int afterSequence = 0,
  }) => client.subscribeSmartConnectEvents(
    SmartConnectEventsRequest(afterSequence: Int64(afterSequence)),
    options: options,
  );
}
