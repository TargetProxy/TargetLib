// This is a generated file - do not edit.
//
// Generated from api/TargetLib/targetlib.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;
import 'package:protobuf/well_known_types/google/protobuf/empty.pb.dart' as $0;

import 'targetlib.pb.dart' as $1;

export 'targetlib.pb.dart';

@$pb.GrpcServiceName('targetlib.TargetLib')
class TargetLibClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  TargetLibClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$1.VersionResponse> getVersion(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getVersion, request, options: options);
  }

  $grpc.ResponseFuture<$1.CapabilitiesResponse> getCapabilities(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getCapabilities, request, options: options);
  }

  $grpc.ResponseFuture<$1.OperationResponse> start(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$start, request, options: options);
  }

  $grpc.ResponseFuture<$1.OperationResponse> restart(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$restart, request, options: options);
  }

  $grpc.ResponseFuture<$1.OperationResponse> stop(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$stop, request, options: options);
  }

  $grpc.ResponseFuture<$1.ServiceState> getState(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getState, request, options: options);
  }

  $grpc.ResponseStream<$1.ServiceState> subscribeState(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$subscribeState, $async.Stream.fromIterable([request]),
        options: options);
  }

  $grpc.ResponseStream<$1.LogBatch> subscribeLogs(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$subscribeLogs, $async.Stream.fromIterable([request]),
        options: options);
  }

  $grpc.ResponseStream<$1.TrafficStatus> subscribeTraffic(
    $1.TrafficRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$subscribeTraffic, $async.Stream.fromIterable([request]),
        options: options);
  }

  $grpc.ResponseFuture<$0.Empty> selectOutbound(
    $1.SelectOutboundRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$selectOutbound, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> closeConnection(
    $1.CloseConnectionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$closeConnection, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> closeAllConnections(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$closeAllConnections, request, options: options);
  }

  $grpc.ResponseFuture<$1.SubscriptionList> listSubscriptions(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listSubscriptions, request, options: options);
  }

  $grpc.ResponseFuture<$1.SubscriptionView> getSubscription(
    $1.SubscriptionId request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getSubscription, request, options: options);
  }

  $grpc.ResponseFuture<$1.SubscriptionView> addSubscription(
    $1.AddSubscriptionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$addSubscription, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> removeSubscription(
    $1.SubscriptionId request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$removeSubscription, request, options: options);
  }

  $grpc.ResponseFuture<$1.SubscriptionView> renameSubscription(
    $1.RenameSubscriptionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$renameSubscription, request, options: options);
  }

  $grpc.ResponseFuture<$1.SubscriptionView> setSubscriptionEnabled(
    $1.SetSubscriptionEnabledRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$setSubscriptionEnabled, request,
        options: options);
  }

  $grpc.ResponseFuture<$1.SubscriptionView> configureSubscriptionUpdates(
    $1.ConfigureSubscriptionUpdatesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$configureSubscriptionUpdates, request,
        options: options);
  }

  $grpc.ResponseFuture<$1.SubscriptionUpdateResult> updateSubscription(
    $1.SubscriptionId request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateSubscription, request, options: options);
  }

  /// Returns the backend-owned desired runtime configuration.
  $grpc.ResponseFuture<$1.RuntimeConfig> getRuntimeConfig(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getRuntimeConfig, request, options: options);
  }

  /// Validates and persists the desired configuration. If the core is running,
  /// it is reloaded immediately; otherwise it is used on the next start.
  $grpc.ResponseFuture<$1.RuntimeConfig> updateRuntimeConfig(
    $1.UpdateRuntimeConfigRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateRuntimeConfig, request, options: options);
  }

  $grpc.ResponseFuture<$1.LatencyTestResult> testOutbound(
    $1.TestOutboundRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$testOutbound, request, options: options);
  }

  $grpc.ResponseStream<$1.LatencyTestResult> testOutbounds(
    $1.TestOutboundsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$testOutbounds, $async.Stream.fromIterable([request]),
        options: options);
  }

  $grpc.ResponseFuture<$1.ResolvedEndpoints> getResolvedEndpoints(
    $1.ResolvedEndpointsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getResolvedEndpoints, request, options: options);
  }

  $grpc.ResponseStream<$1.SubscriptionEvent> subscribeSubscriptionEvents(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$subscribeSubscriptionEvents, $async.Stream.fromIterable([request]),
        options: options);
  }

  /// IP geolocation query (egress from the backend).
  $grpc.ResponseFuture<$1.IpInfoResponse> getIpInfo(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getIpInfo, request, options: options);
  }

  $grpc.ResponseFuture<$1.NodePool> getNodePool(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getNodePool, request, options: options);
  }

  $grpc.ResponseFuture<$1.RuntimeState> getRuntimeState(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getRuntimeState, request, options: options);
  }

  $grpc.ResponseFuture<$1.ServiceBindingList> listServiceBindings(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listServiceBindings, request, options: options);
  }

  $grpc.ResponseFuture<$1.RuntimeConfig> applyServiceBinding(
    $1.ApplyServiceBindingRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$applyServiceBinding, request, options: options);
  }

  $grpc.ResponseFuture<$1.RuntimeConfig> removeServiceBinding(
    $1.RemoveServiceBindingRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$removeServiceBinding, request, options: options);
  }

  $grpc.ResponseFuture<$1.ServiceProbe> putServiceProbe(
    $1.ServiceProbe request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$putServiceProbe, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> removeServiceProbe(
    $1.RemoveServiceProbeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$removeServiceProbe, request, options: options);
  }

  $grpc.ResponseFuture<$1.ServiceProbeList> listServiceProbes(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listServiceProbes, request, options: options);
  }

  $grpc.ResponseStream<$1.ProbeResult> probeService(
    $1.ProbeServiceRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$probeService, $async.Stream.fromIterable([request]),
        options: options);
  }

  $grpc.ResponseFuture<$1.QualityHistory> getQualityHistory(
    $1.QualityHistoryRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getQualityHistory, request, options: options);
  }

  $grpc.ResponseFuture<$1.ServiceEvaluation> evaluateService(
    $1.EvaluateServiceRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$evaluateService, request, options: options);
  }

  $grpc.ResponseFuture<$1.ServiceSelectionPolicy> getServiceSelectionPolicy(
    $1.ServiceSelectionPolicyRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getServiceSelectionPolicy, request,
        options: options);
  }

  $grpc.ResponseFuture<$1.ServiceSelectionPolicy> putServiceSelectionPolicy(
    $1.ServiceSelectionPolicy request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$putServiceSelectionPolicy, request,
        options: options);
  }

  $grpc.ResponseFuture<$1.SmartConnectDiagnostics> getSmartConnectDiagnostics(
    $1.EvaluateServiceRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getSmartConnectDiagnostics, request,
        options: options);
  }

  $grpc.ResponseStream<$1.RuntimeEvent> subscribeRuntimeEvents(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$subscribeRuntimeEvents, $async.Stream.fromIterable([request]),
        options: options);
  }

  $grpc.ResponseFuture<$1.SmartConnectPolicy> exportSmartConnectPolicy(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$exportSmartConnectPolicy, request,
        options: options);
  }

  $grpc.ResponseFuture<$1.SmartConnectPolicy> importSmartConnectPolicy(
    $1.ImportSmartConnectPolicyRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$importSmartConnectPolicy, request,
        options: options);
  }

  /// Intent-level Smart Connect API. Commands return a durable operation.
  $grpc.ResponseFuture<$1.SmartConnectSnapshot> getSmartConnectSnapshot(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getSmartConnectSnapshot, request,
        options: options);
  }

  $grpc.ResponseFuture<$1.Operation> setSmartConnectEnabled(
    $1.SetSmartConnectEnabledRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$setSmartConnectEnabled, request,
        options: options);
  }

  $grpc.ResponseFuture<$1.ServicePolicyList> listServicePolicies(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listServicePolicies, request, options: options);
  }

  $grpc.ResponseFuture<$1.Operation> upsertServicePolicy(
    $1.UpsertServicePolicyRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$upsertServicePolicy, request, options: options);
  }

  $grpc.ResponseFuture<$1.Operation> deleteServicePolicy(
    $1.DeleteServicePolicyRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteServicePolicy, request, options: options);
  }

  $grpc.ResponseFuture<$1.Operation> setNodePreference(
    $1.SetNodePreferenceRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$setNodePreference, request, options: options);
  }

  $grpc.ResponseFuture<$1.Operation> requestServiceEvaluation(
    $1.RequestServiceEvaluationRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$requestServiceEvaluation, request,
        options: options);
  }

  $grpc.ResponseFuture<$1.Operation> approveSwitchProposal(
    $1.ProposalCommandRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$approveSwitchProposal, request, options: options);
  }

  $grpc.ResponseFuture<$1.Operation> rejectSwitchProposal(
    $1.ProposalCommandRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$rejectSwitchProposal, request, options: options);
  }

  $grpc.ResponseFuture<$1.Operation> forceServiceBinding(
    $1.ForceServiceBindingRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$forceServiceBinding, request, options: options);
  }

  $grpc.ResponseFuture<$1.Operation> getOperation(
    $1.GetOperationRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getOperation, request, options: options);
  }

  $grpc.ResponseFuture<$1.OperationList> listOperations(
    $1.ListOperationsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listOperations, request, options: options);
  }

  $grpc.ResponseStream<$1.SmartConnectEvent> subscribeSmartConnectEvents(
    $1.SmartConnectEventsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$subscribeSmartConnectEvents, $async.Stream.fromIterable([request]),
        options: options);
  }

  // method descriptors

  static final _$getVersion = $grpc.ClientMethod<$0.Empty, $1.VersionResponse>(
      '/targetlib.TargetLib/GetVersion',
      ($0.Empty value) => value.writeToBuffer(),
      $1.VersionResponse.fromBuffer);
  static final _$getCapabilities =
      $grpc.ClientMethod<$0.Empty, $1.CapabilitiesResponse>(
          '/targetlib.TargetLib/GetCapabilities',
          ($0.Empty value) => value.writeToBuffer(),
          $1.CapabilitiesResponse.fromBuffer);
  static final _$start = $grpc.ClientMethod<$0.Empty, $1.OperationResponse>(
      '/targetlib.TargetLib/Start',
      ($0.Empty value) => value.writeToBuffer(),
      $1.OperationResponse.fromBuffer);
  static final _$restart = $grpc.ClientMethod<$0.Empty, $1.OperationResponse>(
      '/targetlib.TargetLib/Restart',
      ($0.Empty value) => value.writeToBuffer(),
      $1.OperationResponse.fromBuffer);
  static final _$stop = $grpc.ClientMethod<$0.Empty, $1.OperationResponse>(
      '/targetlib.TargetLib/Stop',
      ($0.Empty value) => value.writeToBuffer(),
      $1.OperationResponse.fromBuffer);
  static final _$getState = $grpc.ClientMethod<$0.Empty, $1.ServiceState>(
      '/targetlib.TargetLib/GetState',
      ($0.Empty value) => value.writeToBuffer(),
      $1.ServiceState.fromBuffer);
  static final _$subscribeState = $grpc.ClientMethod<$0.Empty, $1.ServiceState>(
      '/targetlib.TargetLib/SubscribeState',
      ($0.Empty value) => value.writeToBuffer(),
      $1.ServiceState.fromBuffer);
  static final _$subscribeLogs = $grpc.ClientMethod<$0.Empty, $1.LogBatch>(
      '/targetlib.TargetLib/SubscribeLogs',
      ($0.Empty value) => value.writeToBuffer(),
      $1.LogBatch.fromBuffer);
  static final _$subscribeTraffic =
      $grpc.ClientMethod<$1.TrafficRequest, $1.TrafficStatus>(
          '/targetlib.TargetLib/SubscribeTraffic',
          ($1.TrafficRequest value) => value.writeToBuffer(),
          $1.TrafficStatus.fromBuffer);
  static final _$selectOutbound =
      $grpc.ClientMethod<$1.SelectOutboundRequest, $0.Empty>(
          '/targetlib.TargetLib/SelectOutbound',
          ($1.SelectOutboundRequest value) => value.writeToBuffer(),
          $0.Empty.fromBuffer);
  static final _$closeConnection =
      $grpc.ClientMethod<$1.CloseConnectionRequest, $0.Empty>(
          '/targetlib.TargetLib/CloseConnection',
          ($1.CloseConnectionRequest value) => value.writeToBuffer(),
          $0.Empty.fromBuffer);
  static final _$closeAllConnections = $grpc.ClientMethod<$0.Empty, $0.Empty>(
      '/targetlib.TargetLib/CloseAllConnections',
      ($0.Empty value) => value.writeToBuffer(),
      $0.Empty.fromBuffer);
  static final _$listSubscriptions =
      $grpc.ClientMethod<$0.Empty, $1.SubscriptionList>(
          '/targetlib.TargetLib/ListSubscriptions',
          ($0.Empty value) => value.writeToBuffer(),
          $1.SubscriptionList.fromBuffer);
  static final _$getSubscription =
      $grpc.ClientMethod<$1.SubscriptionId, $1.SubscriptionView>(
          '/targetlib.TargetLib/GetSubscription',
          ($1.SubscriptionId value) => value.writeToBuffer(),
          $1.SubscriptionView.fromBuffer);
  static final _$addSubscription =
      $grpc.ClientMethod<$1.AddSubscriptionRequest, $1.SubscriptionView>(
          '/targetlib.TargetLib/AddSubscription',
          ($1.AddSubscriptionRequest value) => value.writeToBuffer(),
          $1.SubscriptionView.fromBuffer);
  static final _$removeSubscription =
      $grpc.ClientMethod<$1.SubscriptionId, $0.Empty>(
          '/targetlib.TargetLib/RemoveSubscription',
          ($1.SubscriptionId value) => value.writeToBuffer(),
          $0.Empty.fromBuffer);
  static final _$renameSubscription =
      $grpc.ClientMethod<$1.RenameSubscriptionRequest, $1.SubscriptionView>(
          '/targetlib.TargetLib/RenameSubscription',
          ($1.RenameSubscriptionRequest value) => value.writeToBuffer(),
          $1.SubscriptionView.fromBuffer);
  static final _$setSubscriptionEnabled =
      $grpc.ClientMethod<$1.SetSubscriptionEnabledRequest, $1.SubscriptionView>(
          '/targetlib.TargetLib/SetSubscriptionEnabled',
          ($1.SetSubscriptionEnabledRequest value) => value.writeToBuffer(),
          $1.SubscriptionView.fromBuffer);
  static final _$configureSubscriptionUpdates = $grpc.ClientMethod<
          $1.ConfigureSubscriptionUpdatesRequest, $1.SubscriptionView>(
      '/targetlib.TargetLib/ConfigureSubscriptionUpdates',
      ($1.ConfigureSubscriptionUpdatesRequest value) => value.writeToBuffer(),
      $1.SubscriptionView.fromBuffer);
  static final _$updateSubscription =
      $grpc.ClientMethod<$1.SubscriptionId, $1.SubscriptionUpdateResult>(
          '/targetlib.TargetLib/UpdateSubscription',
          ($1.SubscriptionId value) => value.writeToBuffer(),
          $1.SubscriptionUpdateResult.fromBuffer);
  static final _$getRuntimeConfig =
      $grpc.ClientMethod<$0.Empty, $1.RuntimeConfig>(
          '/targetlib.TargetLib/GetRuntimeConfig',
          ($0.Empty value) => value.writeToBuffer(),
          $1.RuntimeConfig.fromBuffer);
  static final _$updateRuntimeConfig =
      $grpc.ClientMethod<$1.UpdateRuntimeConfigRequest, $1.RuntimeConfig>(
          '/targetlib.TargetLib/UpdateRuntimeConfig',
          ($1.UpdateRuntimeConfigRequest value) => value.writeToBuffer(),
          $1.RuntimeConfig.fromBuffer);
  static final _$testOutbound =
      $grpc.ClientMethod<$1.TestOutboundRequest, $1.LatencyTestResult>(
          '/targetlib.TargetLib/TestOutbound',
          ($1.TestOutboundRequest value) => value.writeToBuffer(),
          $1.LatencyTestResult.fromBuffer);
  static final _$testOutbounds =
      $grpc.ClientMethod<$1.TestOutboundsRequest, $1.LatencyTestResult>(
          '/targetlib.TargetLib/TestOutbounds',
          ($1.TestOutboundsRequest value) => value.writeToBuffer(),
          $1.LatencyTestResult.fromBuffer);
  static final _$getResolvedEndpoints =
      $grpc.ClientMethod<$1.ResolvedEndpointsRequest, $1.ResolvedEndpoints>(
          '/targetlib.TargetLib/GetResolvedEndpoints',
          ($1.ResolvedEndpointsRequest value) => value.writeToBuffer(),
          $1.ResolvedEndpoints.fromBuffer);
  static final _$subscribeSubscriptionEvents =
      $grpc.ClientMethod<$0.Empty, $1.SubscriptionEvent>(
          '/targetlib.TargetLib/SubscribeSubscriptionEvents',
          ($0.Empty value) => value.writeToBuffer(),
          $1.SubscriptionEvent.fromBuffer);
  static final _$getIpInfo = $grpc.ClientMethod<$0.Empty, $1.IpInfoResponse>(
      '/targetlib.TargetLib/GetIpInfo',
      ($0.Empty value) => value.writeToBuffer(),
      $1.IpInfoResponse.fromBuffer);
  static final _$getNodePool = $grpc.ClientMethod<$0.Empty, $1.NodePool>(
      '/targetlib.TargetLib/GetNodePool',
      ($0.Empty value) => value.writeToBuffer(),
      $1.NodePool.fromBuffer);
  static final _$getRuntimeState =
      $grpc.ClientMethod<$0.Empty, $1.RuntimeState>(
          '/targetlib.TargetLib/GetRuntimeState',
          ($0.Empty value) => value.writeToBuffer(),
          $1.RuntimeState.fromBuffer);
  static final _$listServiceBindings =
      $grpc.ClientMethod<$0.Empty, $1.ServiceBindingList>(
          '/targetlib.TargetLib/ListServiceBindings',
          ($0.Empty value) => value.writeToBuffer(),
          $1.ServiceBindingList.fromBuffer);
  static final _$applyServiceBinding =
      $grpc.ClientMethod<$1.ApplyServiceBindingRequest, $1.RuntimeConfig>(
          '/targetlib.TargetLib/ApplyServiceBinding',
          ($1.ApplyServiceBindingRequest value) => value.writeToBuffer(),
          $1.RuntimeConfig.fromBuffer);
  static final _$removeServiceBinding =
      $grpc.ClientMethod<$1.RemoveServiceBindingRequest, $1.RuntimeConfig>(
          '/targetlib.TargetLib/RemoveServiceBinding',
          ($1.RemoveServiceBindingRequest value) => value.writeToBuffer(),
          $1.RuntimeConfig.fromBuffer);
  static final _$putServiceProbe =
      $grpc.ClientMethod<$1.ServiceProbe, $1.ServiceProbe>(
          '/targetlib.TargetLib/PutServiceProbe',
          ($1.ServiceProbe value) => value.writeToBuffer(),
          $1.ServiceProbe.fromBuffer);
  static final _$removeServiceProbe =
      $grpc.ClientMethod<$1.RemoveServiceProbeRequest, $0.Empty>(
          '/targetlib.TargetLib/RemoveServiceProbe',
          ($1.RemoveServiceProbeRequest value) => value.writeToBuffer(),
          $0.Empty.fromBuffer);
  static final _$listServiceProbes =
      $grpc.ClientMethod<$0.Empty, $1.ServiceProbeList>(
          '/targetlib.TargetLib/ListServiceProbes',
          ($0.Empty value) => value.writeToBuffer(),
          $1.ServiceProbeList.fromBuffer);
  static final _$probeService =
      $grpc.ClientMethod<$1.ProbeServiceRequest, $1.ProbeResult>(
          '/targetlib.TargetLib/ProbeService',
          ($1.ProbeServiceRequest value) => value.writeToBuffer(),
          $1.ProbeResult.fromBuffer);
  static final _$getQualityHistory =
      $grpc.ClientMethod<$1.QualityHistoryRequest, $1.QualityHistory>(
          '/targetlib.TargetLib/GetQualityHistory',
          ($1.QualityHistoryRequest value) => value.writeToBuffer(),
          $1.QualityHistory.fromBuffer);
  static final _$evaluateService =
      $grpc.ClientMethod<$1.EvaluateServiceRequest, $1.ServiceEvaluation>(
          '/targetlib.TargetLib/EvaluateService',
          ($1.EvaluateServiceRequest value) => value.writeToBuffer(),
          $1.ServiceEvaluation.fromBuffer);
  static final _$getServiceSelectionPolicy = $grpc.ClientMethod<
          $1.ServiceSelectionPolicyRequest, $1.ServiceSelectionPolicy>(
      '/targetlib.TargetLib/GetServiceSelectionPolicy',
      ($1.ServiceSelectionPolicyRequest value) => value.writeToBuffer(),
      $1.ServiceSelectionPolicy.fromBuffer);
  static final _$putServiceSelectionPolicy =
      $grpc.ClientMethod<$1.ServiceSelectionPolicy, $1.ServiceSelectionPolicy>(
          '/targetlib.TargetLib/PutServiceSelectionPolicy',
          ($1.ServiceSelectionPolicy value) => value.writeToBuffer(),
          $1.ServiceSelectionPolicy.fromBuffer);
  static final _$getSmartConnectDiagnostics =
      $grpc.ClientMethod<$1.EvaluateServiceRequest, $1.SmartConnectDiagnostics>(
          '/targetlib.TargetLib/GetSmartConnectDiagnostics',
          ($1.EvaluateServiceRequest value) => value.writeToBuffer(),
          $1.SmartConnectDiagnostics.fromBuffer);
  static final _$subscribeRuntimeEvents =
      $grpc.ClientMethod<$0.Empty, $1.RuntimeEvent>(
          '/targetlib.TargetLib/SubscribeRuntimeEvents',
          ($0.Empty value) => value.writeToBuffer(),
          $1.RuntimeEvent.fromBuffer);
  static final _$exportSmartConnectPolicy =
      $grpc.ClientMethod<$0.Empty, $1.SmartConnectPolicy>(
          '/targetlib.TargetLib/ExportSmartConnectPolicy',
          ($0.Empty value) => value.writeToBuffer(),
          $1.SmartConnectPolicy.fromBuffer);
  static final _$importSmartConnectPolicy = $grpc.ClientMethod<
          $1.ImportSmartConnectPolicyRequest, $1.SmartConnectPolicy>(
      '/targetlib.TargetLib/ImportSmartConnectPolicy',
      ($1.ImportSmartConnectPolicyRequest value) => value.writeToBuffer(),
      $1.SmartConnectPolicy.fromBuffer);
  static final _$getSmartConnectSnapshot =
      $grpc.ClientMethod<$0.Empty, $1.SmartConnectSnapshot>(
          '/targetlib.TargetLib/GetSmartConnectSnapshot',
          ($0.Empty value) => value.writeToBuffer(),
          $1.SmartConnectSnapshot.fromBuffer);
  static final _$setSmartConnectEnabled =
      $grpc.ClientMethod<$1.SetSmartConnectEnabledRequest, $1.Operation>(
          '/targetlib.TargetLib/SetSmartConnectEnabled',
          ($1.SetSmartConnectEnabledRequest value) => value.writeToBuffer(),
          $1.Operation.fromBuffer);
  static final _$listServicePolicies =
      $grpc.ClientMethod<$0.Empty, $1.ServicePolicyList>(
          '/targetlib.TargetLib/ListServicePolicies',
          ($0.Empty value) => value.writeToBuffer(),
          $1.ServicePolicyList.fromBuffer);
  static final _$upsertServicePolicy =
      $grpc.ClientMethod<$1.UpsertServicePolicyRequest, $1.Operation>(
          '/targetlib.TargetLib/UpsertServicePolicy',
          ($1.UpsertServicePolicyRequest value) => value.writeToBuffer(),
          $1.Operation.fromBuffer);
  static final _$deleteServicePolicy =
      $grpc.ClientMethod<$1.DeleteServicePolicyRequest, $1.Operation>(
          '/targetlib.TargetLib/DeleteServicePolicy',
          ($1.DeleteServicePolicyRequest value) => value.writeToBuffer(),
          $1.Operation.fromBuffer);
  static final _$setNodePreference =
      $grpc.ClientMethod<$1.SetNodePreferenceRequest, $1.Operation>(
          '/targetlib.TargetLib/SetNodePreference',
          ($1.SetNodePreferenceRequest value) => value.writeToBuffer(),
          $1.Operation.fromBuffer);
  static final _$requestServiceEvaluation =
      $grpc.ClientMethod<$1.RequestServiceEvaluationRequest, $1.Operation>(
          '/targetlib.TargetLib/RequestServiceEvaluation',
          ($1.RequestServiceEvaluationRequest value) => value.writeToBuffer(),
          $1.Operation.fromBuffer);
  static final _$approveSwitchProposal =
      $grpc.ClientMethod<$1.ProposalCommandRequest, $1.Operation>(
          '/targetlib.TargetLib/ApproveSwitchProposal',
          ($1.ProposalCommandRequest value) => value.writeToBuffer(),
          $1.Operation.fromBuffer);
  static final _$rejectSwitchProposal =
      $grpc.ClientMethod<$1.ProposalCommandRequest, $1.Operation>(
          '/targetlib.TargetLib/RejectSwitchProposal',
          ($1.ProposalCommandRequest value) => value.writeToBuffer(),
          $1.Operation.fromBuffer);
  static final _$forceServiceBinding =
      $grpc.ClientMethod<$1.ForceServiceBindingRequest, $1.Operation>(
          '/targetlib.TargetLib/ForceServiceBinding',
          ($1.ForceServiceBindingRequest value) => value.writeToBuffer(),
          $1.Operation.fromBuffer);
  static final _$getOperation =
      $grpc.ClientMethod<$1.GetOperationRequest, $1.Operation>(
          '/targetlib.TargetLib/GetOperation',
          ($1.GetOperationRequest value) => value.writeToBuffer(),
          $1.Operation.fromBuffer);
  static final _$listOperations =
      $grpc.ClientMethod<$1.ListOperationsRequest, $1.OperationList>(
          '/targetlib.TargetLib/ListOperations',
          ($1.ListOperationsRequest value) => value.writeToBuffer(),
          $1.OperationList.fromBuffer);
  static final _$subscribeSmartConnectEvents =
      $grpc.ClientMethod<$1.SmartConnectEventsRequest, $1.SmartConnectEvent>(
          '/targetlib.TargetLib/SubscribeSmartConnectEvents',
          ($1.SmartConnectEventsRequest value) => value.writeToBuffer(),
          $1.SmartConnectEvent.fromBuffer);
}

@$pb.GrpcServiceName('targetlib.TargetLib')
abstract class TargetLibServiceBase extends $grpc.Service {
  $core.String get $name => 'targetlib.TargetLib';

  TargetLibServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Empty, $1.VersionResponse>(
        'GetVersion',
        getVersion_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($1.VersionResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $1.CapabilitiesResponse>(
        'GetCapabilities',
        getCapabilities_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($1.CapabilitiesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $1.OperationResponse>(
        'Start',
        start_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($1.OperationResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $1.OperationResponse>(
        'Restart',
        restart_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($1.OperationResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $1.OperationResponse>(
        'Stop',
        stop_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($1.OperationResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $1.ServiceState>(
        'GetState',
        getState_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($1.ServiceState value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $1.ServiceState>(
        'SubscribeState',
        subscribeState_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($1.ServiceState value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $1.LogBatch>(
        'SubscribeLogs',
        subscribeLogs_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($1.LogBatch value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.TrafficRequest, $1.TrafficStatus>(
        'SubscribeTraffic',
        subscribeTraffic_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $1.TrafficRequest.fromBuffer(value),
        ($1.TrafficStatus value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.SelectOutboundRequest, $0.Empty>(
        'SelectOutbound',
        selectOutbound_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $1.SelectOutboundRequest.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.CloseConnectionRequest, $0.Empty>(
        'CloseConnection',
        closeConnection_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $1.CloseConnectionRequest.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.Empty>(
        'CloseAllConnections',
        closeAllConnections_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $1.SubscriptionList>(
        'ListSubscriptions',
        listSubscriptions_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($1.SubscriptionList value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.SubscriptionId, $1.SubscriptionView>(
        'GetSubscription',
        getSubscription_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.SubscriptionId.fromBuffer(value),
        ($1.SubscriptionView value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$1.AddSubscriptionRequest, $1.SubscriptionView>(
            'AddSubscription',
            addSubscription_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $1.AddSubscriptionRequest.fromBuffer(value),
            ($1.SubscriptionView value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.SubscriptionId, $0.Empty>(
        'RemoveSubscription',
        removeSubscription_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.SubscriptionId.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$1.RenameSubscriptionRequest, $1.SubscriptionView>(
            'RenameSubscription',
            renameSubscription_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $1.RenameSubscriptionRequest.fromBuffer(value),
            ($1.SubscriptionView value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.SetSubscriptionEnabledRequest,
            $1.SubscriptionView>(
        'SetSubscriptionEnabled',
        setSubscriptionEnabled_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $1.SetSubscriptionEnabledRequest.fromBuffer(value),
        ($1.SubscriptionView value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.ConfigureSubscriptionUpdatesRequest,
            $1.SubscriptionView>(
        'ConfigureSubscriptionUpdates',
        configureSubscriptionUpdates_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $1.ConfigureSubscriptionUpdatesRequest.fromBuffer(value),
        ($1.SubscriptionView value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$1.SubscriptionId, $1.SubscriptionUpdateResult>(
            'UpdateSubscription',
            updateSubscription_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $1.SubscriptionId.fromBuffer(value),
            ($1.SubscriptionUpdateResult value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $1.RuntimeConfig>(
        'GetRuntimeConfig',
        getRuntimeConfig_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($1.RuntimeConfig value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$1.UpdateRuntimeConfigRequest, $1.RuntimeConfig>(
            'UpdateRuntimeConfig',
            updateRuntimeConfig_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $1.UpdateRuntimeConfigRequest.fromBuffer(value),
            ($1.RuntimeConfig value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$1.TestOutboundRequest, $1.LatencyTestResult>(
            'TestOutbound',
            testOutbound_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $1.TestOutboundRequest.fromBuffer(value),
            ($1.LatencyTestResult value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$1.TestOutboundsRequest, $1.LatencyTestResult>(
            'TestOutbounds',
            testOutbounds_Pre,
            false,
            true,
            ($core.List<$core.int> value) =>
                $1.TestOutboundsRequest.fromBuffer(value),
            ($1.LatencyTestResult value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$1.ResolvedEndpointsRequest, $1.ResolvedEndpoints>(
            'GetResolvedEndpoints',
            getResolvedEndpoints_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $1.ResolvedEndpointsRequest.fromBuffer(value),
            ($1.ResolvedEndpoints value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $1.SubscriptionEvent>(
        'SubscribeSubscriptionEvents',
        subscribeSubscriptionEvents_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($1.SubscriptionEvent value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $1.IpInfoResponse>(
        'GetIpInfo',
        getIpInfo_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($1.IpInfoResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $1.NodePool>(
        'GetNodePool',
        getNodePool_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($1.NodePool value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $1.RuntimeState>(
        'GetRuntimeState',
        getRuntimeState_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($1.RuntimeState value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $1.ServiceBindingList>(
        'ListServiceBindings',
        listServiceBindings_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($1.ServiceBindingList value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$1.ApplyServiceBindingRequest, $1.RuntimeConfig>(
            'ApplyServiceBinding',
            applyServiceBinding_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $1.ApplyServiceBindingRequest.fromBuffer(value),
            ($1.RuntimeConfig value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$1.RemoveServiceBindingRequest, $1.RuntimeConfig>(
            'RemoveServiceBinding',
            removeServiceBinding_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $1.RemoveServiceBindingRequest.fromBuffer(value),
            ($1.RuntimeConfig value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.ServiceProbe, $1.ServiceProbe>(
        'PutServiceProbe',
        putServiceProbe_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.ServiceProbe.fromBuffer(value),
        ($1.ServiceProbe value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.RemoveServiceProbeRequest, $0.Empty>(
        'RemoveServiceProbe',
        removeServiceProbe_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $1.RemoveServiceProbeRequest.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $1.ServiceProbeList>(
        'ListServiceProbes',
        listServiceProbes_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($1.ServiceProbeList value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.ProbeServiceRequest, $1.ProbeResult>(
        'ProbeService',
        probeService_Pre,
        false,
        true,
        ($core.List<$core.int> value) =>
            $1.ProbeServiceRequest.fromBuffer(value),
        ($1.ProbeResult value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.QualityHistoryRequest, $1.QualityHistory>(
        'GetQualityHistory',
        getQualityHistory_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $1.QualityHistoryRequest.fromBuffer(value),
        ($1.QualityHistory value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$1.EvaluateServiceRequest, $1.ServiceEvaluation>(
            'EvaluateService',
            evaluateService_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $1.EvaluateServiceRequest.fromBuffer(value),
            ($1.ServiceEvaluation value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.ServiceSelectionPolicyRequest,
            $1.ServiceSelectionPolicy>(
        'GetServiceSelectionPolicy',
        getServiceSelectionPolicy_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $1.ServiceSelectionPolicyRequest.fromBuffer(value),
        ($1.ServiceSelectionPolicy value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.ServiceSelectionPolicy,
            $1.ServiceSelectionPolicy>(
        'PutServiceSelectionPolicy',
        putServiceSelectionPolicy_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $1.ServiceSelectionPolicy.fromBuffer(value),
        ($1.ServiceSelectionPolicy value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.EvaluateServiceRequest,
            $1.SmartConnectDiagnostics>(
        'GetSmartConnectDiagnostics',
        getSmartConnectDiagnostics_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $1.EvaluateServiceRequest.fromBuffer(value),
        ($1.SmartConnectDiagnostics value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $1.RuntimeEvent>(
        'SubscribeRuntimeEvents',
        subscribeRuntimeEvents_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($1.RuntimeEvent value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $1.SmartConnectPolicy>(
        'ExportSmartConnectPolicy',
        exportSmartConnectPolicy_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($1.SmartConnectPolicy value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.ImportSmartConnectPolicyRequest,
            $1.SmartConnectPolicy>(
        'ImportSmartConnectPolicy',
        importSmartConnectPolicy_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $1.ImportSmartConnectPolicyRequest.fromBuffer(value),
        ($1.SmartConnectPolicy value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $1.SmartConnectSnapshot>(
        'GetSmartConnectSnapshot',
        getSmartConnectSnapshot_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($1.SmartConnectSnapshot value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$1.SetSmartConnectEnabledRequest, $1.Operation>(
            'SetSmartConnectEnabled',
            setSmartConnectEnabled_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $1.SetSmartConnectEnabledRequest.fromBuffer(value),
            ($1.Operation value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $1.ServicePolicyList>(
        'ListServicePolicies',
        listServicePolicies_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($1.ServicePolicyList value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.UpsertServicePolicyRequest, $1.Operation>(
        'UpsertServicePolicy',
        upsertServicePolicy_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $1.UpsertServicePolicyRequest.fromBuffer(value),
        ($1.Operation value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.DeleteServicePolicyRequest, $1.Operation>(
        'DeleteServicePolicy',
        deleteServicePolicy_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $1.DeleteServicePolicyRequest.fromBuffer(value),
        ($1.Operation value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.SetNodePreferenceRequest, $1.Operation>(
        'SetNodePreference',
        setNodePreference_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $1.SetNodePreferenceRequest.fromBuffer(value),
        ($1.Operation value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$1.RequestServiceEvaluationRequest, $1.Operation>(
            'RequestServiceEvaluation',
            requestServiceEvaluation_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $1.RequestServiceEvaluationRequest.fromBuffer(value),
            ($1.Operation value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.ProposalCommandRequest, $1.Operation>(
        'ApproveSwitchProposal',
        approveSwitchProposal_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $1.ProposalCommandRequest.fromBuffer(value),
        ($1.Operation value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.ProposalCommandRequest, $1.Operation>(
        'RejectSwitchProposal',
        rejectSwitchProposal_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $1.ProposalCommandRequest.fromBuffer(value),
        ($1.Operation value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.ForceServiceBindingRequest, $1.Operation>(
        'ForceServiceBinding',
        forceServiceBinding_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $1.ForceServiceBindingRequest.fromBuffer(value),
        ($1.Operation value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.GetOperationRequest, $1.Operation>(
        'GetOperation',
        getOperation_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $1.GetOperationRequest.fromBuffer(value),
        ($1.Operation value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.ListOperationsRequest, $1.OperationList>(
        'ListOperations',
        listOperations_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $1.ListOperationsRequest.fromBuffer(value),
        ($1.OperationList value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$1.SmartConnectEventsRequest, $1.SmartConnectEvent>(
            'SubscribeSmartConnectEvents',
            subscribeSmartConnectEvents_Pre,
            false,
            true,
            ($core.List<$core.int> value) =>
                $1.SmartConnectEventsRequest.fromBuffer(value),
            ($1.SmartConnectEvent value) => value.writeToBuffer()));
  }

  $async.Future<$1.VersionResponse> getVersion_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return getVersion($call, await $request);
  }

  $async.Future<$1.VersionResponse> getVersion(
      $grpc.ServiceCall call, $0.Empty request);

  $async.Future<$1.CapabilitiesResponse> getCapabilities_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return getCapabilities($call, await $request);
  }

  $async.Future<$1.CapabilitiesResponse> getCapabilities(
      $grpc.ServiceCall call, $0.Empty request);

  $async.Future<$1.OperationResponse> start_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return start($call, await $request);
  }

  $async.Future<$1.OperationResponse> start(
      $grpc.ServiceCall call, $0.Empty request);

  $async.Future<$1.OperationResponse> restart_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return restart($call, await $request);
  }

  $async.Future<$1.OperationResponse> restart(
      $grpc.ServiceCall call, $0.Empty request);

  $async.Future<$1.OperationResponse> stop_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return stop($call, await $request);
  }

  $async.Future<$1.OperationResponse> stop(
      $grpc.ServiceCall call, $0.Empty request);

  $async.Future<$1.ServiceState> getState_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return getState($call, await $request);
  }

  $async.Future<$1.ServiceState> getState(
      $grpc.ServiceCall call, $0.Empty request);

  $async.Stream<$1.ServiceState> subscribeState_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async* {
    yield* subscribeState($call, await $request);
  }

  $async.Stream<$1.ServiceState> subscribeState(
      $grpc.ServiceCall call, $0.Empty request);

  $async.Stream<$1.LogBatch> subscribeLogs_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async* {
    yield* subscribeLogs($call, await $request);
  }

  $async.Stream<$1.LogBatch> subscribeLogs(
      $grpc.ServiceCall call, $0.Empty request);

  $async.Stream<$1.TrafficStatus> subscribeTraffic_Pre($grpc.ServiceCall $call,
      $async.Future<$1.TrafficRequest> $request) async* {
    yield* subscribeTraffic($call, await $request);
  }

  $async.Stream<$1.TrafficStatus> subscribeTraffic(
      $grpc.ServiceCall call, $1.TrafficRequest request);

  $async.Future<$0.Empty> selectOutbound_Pre($grpc.ServiceCall $call,
      $async.Future<$1.SelectOutboundRequest> $request) async {
    return selectOutbound($call, await $request);
  }

  $async.Future<$0.Empty> selectOutbound(
      $grpc.ServiceCall call, $1.SelectOutboundRequest request);

  $async.Future<$0.Empty> closeConnection_Pre($grpc.ServiceCall $call,
      $async.Future<$1.CloseConnectionRequest> $request) async {
    return closeConnection($call, await $request);
  }

  $async.Future<$0.Empty> closeConnection(
      $grpc.ServiceCall call, $1.CloseConnectionRequest request);

  $async.Future<$0.Empty> closeAllConnections_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return closeAllConnections($call, await $request);
  }

  $async.Future<$0.Empty> closeAllConnections(
      $grpc.ServiceCall call, $0.Empty request);

  $async.Future<$1.SubscriptionList> listSubscriptions_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return listSubscriptions($call, await $request);
  }

  $async.Future<$1.SubscriptionList> listSubscriptions(
      $grpc.ServiceCall call, $0.Empty request);

  $async.Future<$1.SubscriptionView> getSubscription_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$1.SubscriptionId> $request) async {
    return getSubscription($call, await $request);
  }

  $async.Future<$1.SubscriptionView> getSubscription(
      $grpc.ServiceCall call, $1.SubscriptionId request);

  $async.Future<$1.SubscriptionView> addSubscription_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$1.AddSubscriptionRequest> $request) async {
    return addSubscription($call, await $request);
  }

  $async.Future<$1.SubscriptionView> addSubscription(
      $grpc.ServiceCall call, $1.AddSubscriptionRequest request);

  $async.Future<$0.Empty> removeSubscription_Pre($grpc.ServiceCall $call,
      $async.Future<$1.SubscriptionId> $request) async {
    return removeSubscription($call, await $request);
  }

  $async.Future<$0.Empty> removeSubscription(
      $grpc.ServiceCall call, $1.SubscriptionId request);

  $async.Future<$1.SubscriptionView> renameSubscription_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$1.RenameSubscriptionRequest> $request) async {
    return renameSubscription($call, await $request);
  }

  $async.Future<$1.SubscriptionView> renameSubscription(
      $grpc.ServiceCall call, $1.RenameSubscriptionRequest request);

  $async.Future<$1.SubscriptionView> setSubscriptionEnabled_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$1.SetSubscriptionEnabledRequest> $request) async {
    return setSubscriptionEnabled($call, await $request);
  }

  $async.Future<$1.SubscriptionView> setSubscriptionEnabled(
      $grpc.ServiceCall call, $1.SetSubscriptionEnabledRequest request);

  $async.Future<$1.SubscriptionView> configureSubscriptionUpdates_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$1.ConfigureSubscriptionUpdatesRequest> $request) async {
    return configureSubscriptionUpdates($call, await $request);
  }

  $async.Future<$1.SubscriptionView> configureSubscriptionUpdates(
      $grpc.ServiceCall call, $1.ConfigureSubscriptionUpdatesRequest request);

  $async.Future<$1.SubscriptionUpdateResult> updateSubscription_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$1.SubscriptionId> $request) async {
    return updateSubscription($call, await $request);
  }

  $async.Future<$1.SubscriptionUpdateResult> updateSubscription(
      $grpc.ServiceCall call, $1.SubscriptionId request);

  $async.Future<$1.RuntimeConfig> getRuntimeConfig_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return getRuntimeConfig($call, await $request);
  }

  $async.Future<$1.RuntimeConfig> getRuntimeConfig(
      $grpc.ServiceCall call, $0.Empty request);

  $async.Future<$1.RuntimeConfig> updateRuntimeConfig_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$1.UpdateRuntimeConfigRequest> $request) async {
    return updateRuntimeConfig($call, await $request);
  }

  $async.Future<$1.RuntimeConfig> updateRuntimeConfig(
      $grpc.ServiceCall call, $1.UpdateRuntimeConfigRequest request);

  $async.Future<$1.LatencyTestResult> testOutbound_Pre($grpc.ServiceCall $call,
      $async.Future<$1.TestOutboundRequest> $request) async {
    return testOutbound($call, await $request);
  }

  $async.Future<$1.LatencyTestResult> testOutbound(
      $grpc.ServiceCall call, $1.TestOutboundRequest request);

  $async.Stream<$1.LatencyTestResult> testOutbounds_Pre($grpc.ServiceCall $call,
      $async.Future<$1.TestOutboundsRequest> $request) async* {
    yield* testOutbounds($call, await $request);
  }

  $async.Stream<$1.LatencyTestResult> testOutbounds(
      $grpc.ServiceCall call, $1.TestOutboundsRequest request);

  $async.Future<$1.ResolvedEndpoints> getResolvedEndpoints_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$1.ResolvedEndpointsRequest> $request) async {
    return getResolvedEndpoints($call, await $request);
  }

  $async.Future<$1.ResolvedEndpoints> getResolvedEndpoints(
      $grpc.ServiceCall call, $1.ResolvedEndpointsRequest request);

  $async.Stream<$1.SubscriptionEvent> subscribeSubscriptionEvents_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async* {
    yield* subscribeSubscriptionEvents($call, await $request);
  }

  $async.Stream<$1.SubscriptionEvent> subscribeSubscriptionEvents(
      $grpc.ServiceCall call, $0.Empty request);

  $async.Future<$1.IpInfoResponse> getIpInfo_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return getIpInfo($call, await $request);
  }

  $async.Future<$1.IpInfoResponse> getIpInfo(
      $grpc.ServiceCall call, $0.Empty request);

  $async.Future<$1.NodePool> getNodePool_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return getNodePool($call, await $request);
  }

  $async.Future<$1.NodePool> getNodePool(
      $grpc.ServiceCall call, $0.Empty request);

  $async.Future<$1.RuntimeState> getRuntimeState_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return getRuntimeState($call, await $request);
  }

  $async.Future<$1.RuntimeState> getRuntimeState(
      $grpc.ServiceCall call, $0.Empty request);

  $async.Future<$1.ServiceBindingList> listServiceBindings_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return listServiceBindings($call, await $request);
  }

  $async.Future<$1.ServiceBindingList> listServiceBindings(
      $grpc.ServiceCall call, $0.Empty request);

  $async.Future<$1.RuntimeConfig> applyServiceBinding_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$1.ApplyServiceBindingRequest> $request) async {
    return applyServiceBinding($call, await $request);
  }

  $async.Future<$1.RuntimeConfig> applyServiceBinding(
      $grpc.ServiceCall call, $1.ApplyServiceBindingRequest request);

  $async.Future<$1.RuntimeConfig> removeServiceBinding_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$1.RemoveServiceBindingRequest> $request) async {
    return removeServiceBinding($call, await $request);
  }

  $async.Future<$1.RuntimeConfig> removeServiceBinding(
      $grpc.ServiceCall call, $1.RemoveServiceBindingRequest request);

  $async.Future<$1.ServiceProbe> putServiceProbe_Pre(
      $grpc.ServiceCall $call, $async.Future<$1.ServiceProbe> $request) async {
    return putServiceProbe($call, await $request);
  }

  $async.Future<$1.ServiceProbe> putServiceProbe(
      $grpc.ServiceCall call, $1.ServiceProbe request);

  $async.Future<$0.Empty> removeServiceProbe_Pre($grpc.ServiceCall $call,
      $async.Future<$1.RemoveServiceProbeRequest> $request) async {
    return removeServiceProbe($call, await $request);
  }

  $async.Future<$0.Empty> removeServiceProbe(
      $grpc.ServiceCall call, $1.RemoveServiceProbeRequest request);

  $async.Future<$1.ServiceProbeList> listServiceProbes_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return listServiceProbes($call, await $request);
  }

  $async.Future<$1.ServiceProbeList> listServiceProbes(
      $grpc.ServiceCall call, $0.Empty request);

  $async.Stream<$1.ProbeResult> probeService_Pre($grpc.ServiceCall $call,
      $async.Future<$1.ProbeServiceRequest> $request) async* {
    yield* probeService($call, await $request);
  }

  $async.Stream<$1.ProbeResult> probeService(
      $grpc.ServiceCall call, $1.ProbeServiceRequest request);

  $async.Future<$1.QualityHistory> getQualityHistory_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$1.QualityHistoryRequest> $request) async {
    return getQualityHistory($call, await $request);
  }

  $async.Future<$1.QualityHistory> getQualityHistory(
      $grpc.ServiceCall call, $1.QualityHistoryRequest request);

  $async.Future<$1.ServiceEvaluation> evaluateService_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$1.EvaluateServiceRequest> $request) async {
    return evaluateService($call, await $request);
  }

  $async.Future<$1.ServiceEvaluation> evaluateService(
      $grpc.ServiceCall call, $1.EvaluateServiceRequest request);

  $async.Future<$1.ServiceSelectionPolicy> getServiceSelectionPolicy_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$1.ServiceSelectionPolicyRequest> $request) async {
    return getServiceSelectionPolicy($call, await $request);
  }

  $async.Future<$1.ServiceSelectionPolicy> getServiceSelectionPolicy(
      $grpc.ServiceCall call, $1.ServiceSelectionPolicyRequest request);

  $async.Future<$1.ServiceSelectionPolicy> putServiceSelectionPolicy_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$1.ServiceSelectionPolicy> $request) async {
    return putServiceSelectionPolicy($call, await $request);
  }

  $async.Future<$1.ServiceSelectionPolicy> putServiceSelectionPolicy(
      $grpc.ServiceCall call, $1.ServiceSelectionPolicy request);

  $async.Future<$1.SmartConnectDiagnostics> getSmartConnectDiagnostics_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$1.EvaluateServiceRequest> $request) async {
    return getSmartConnectDiagnostics($call, await $request);
  }

  $async.Future<$1.SmartConnectDiagnostics> getSmartConnectDiagnostics(
      $grpc.ServiceCall call, $1.EvaluateServiceRequest request);

  $async.Stream<$1.RuntimeEvent> subscribeRuntimeEvents_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async* {
    yield* subscribeRuntimeEvents($call, await $request);
  }

  $async.Stream<$1.RuntimeEvent> subscribeRuntimeEvents(
      $grpc.ServiceCall call, $0.Empty request);

  $async.Future<$1.SmartConnectPolicy> exportSmartConnectPolicy_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return exportSmartConnectPolicy($call, await $request);
  }

  $async.Future<$1.SmartConnectPolicy> exportSmartConnectPolicy(
      $grpc.ServiceCall call, $0.Empty request);

  $async.Future<$1.SmartConnectPolicy> importSmartConnectPolicy_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$1.ImportSmartConnectPolicyRequest> $request) async {
    return importSmartConnectPolicy($call, await $request);
  }

  $async.Future<$1.SmartConnectPolicy> importSmartConnectPolicy(
      $grpc.ServiceCall call, $1.ImportSmartConnectPolicyRequest request);

  $async.Future<$1.SmartConnectSnapshot> getSmartConnectSnapshot_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return getSmartConnectSnapshot($call, await $request);
  }

  $async.Future<$1.SmartConnectSnapshot> getSmartConnectSnapshot(
      $grpc.ServiceCall call, $0.Empty request);

  $async.Future<$1.Operation> setSmartConnectEnabled_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$1.SetSmartConnectEnabledRequest> $request) async {
    return setSmartConnectEnabled($call, await $request);
  }

  $async.Future<$1.Operation> setSmartConnectEnabled(
      $grpc.ServiceCall call, $1.SetSmartConnectEnabledRequest request);

  $async.Future<$1.ServicePolicyList> listServicePolicies_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return listServicePolicies($call, await $request);
  }

  $async.Future<$1.ServicePolicyList> listServicePolicies(
      $grpc.ServiceCall call, $0.Empty request);

  $async.Future<$1.Operation> upsertServicePolicy_Pre($grpc.ServiceCall $call,
      $async.Future<$1.UpsertServicePolicyRequest> $request) async {
    return upsertServicePolicy($call, await $request);
  }

  $async.Future<$1.Operation> upsertServicePolicy(
      $grpc.ServiceCall call, $1.UpsertServicePolicyRequest request);

  $async.Future<$1.Operation> deleteServicePolicy_Pre($grpc.ServiceCall $call,
      $async.Future<$1.DeleteServicePolicyRequest> $request) async {
    return deleteServicePolicy($call, await $request);
  }

  $async.Future<$1.Operation> deleteServicePolicy(
      $grpc.ServiceCall call, $1.DeleteServicePolicyRequest request);

  $async.Future<$1.Operation> setNodePreference_Pre($grpc.ServiceCall $call,
      $async.Future<$1.SetNodePreferenceRequest> $request) async {
    return setNodePreference($call, await $request);
  }

  $async.Future<$1.Operation> setNodePreference(
      $grpc.ServiceCall call, $1.SetNodePreferenceRequest request);

  $async.Future<$1.Operation> requestServiceEvaluation_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$1.RequestServiceEvaluationRequest> $request) async {
    return requestServiceEvaluation($call, await $request);
  }

  $async.Future<$1.Operation> requestServiceEvaluation(
      $grpc.ServiceCall call, $1.RequestServiceEvaluationRequest request);

  $async.Future<$1.Operation> approveSwitchProposal_Pre($grpc.ServiceCall $call,
      $async.Future<$1.ProposalCommandRequest> $request) async {
    return approveSwitchProposal($call, await $request);
  }

  $async.Future<$1.Operation> approveSwitchProposal(
      $grpc.ServiceCall call, $1.ProposalCommandRequest request);

  $async.Future<$1.Operation> rejectSwitchProposal_Pre($grpc.ServiceCall $call,
      $async.Future<$1.ProposalCommandRequest> $request) async {
    return rejectSwitchProposal($call, await $request);
  }

  $async.Future<$1.Operation> rejectSwitchProposal(
      $grpc.ServiceCall call, $1.ProposalCommandRequest request);

  $async.Future<$1.Operation> forceServiceBinding_Pre($grpc.ServiceCall $call,
      $async.Future<$1.ForceServiceBindingRequest> $request) async {
    return forceServiceBinding($call, await $request);
  }

  $async.Future<$1.Operation> forceServiceBinding(
      $grpc.ServiceCall call, $1.ForceServiceBindingRequest request);

  $async.Future<$1.Operation> getOperation_Pre($grpc.ServiceCall $call,
      $async.Future<$1.GetOperationRequest> $request) async {
    return getOperation($call, await $request);
  }

  $async.Future<$1.Operation> getOperation(
      $grpc.ServiceCall call, $1.GetOperationRequest request);

  $async.Future<$1.OperationList> listOperations_Pre($grpc.ServiceCall $call,
      $async.Future<$1.ListOperationsRequest> $request) async {
    return listOperations($call, await $request);
  }

  $async.Future<$1.OperationList> listOperations(
      $grpc.ServiceCall call, $1.ListOperationsRequest request);

  $async.Stream<$1.SmartConnectEvent> subscribeSmartConnectEvents_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$1.SmartConnectEventsRequest> $request) async* {
    yield* subscribeSmartConnectEvents($call, await $request);
  }

  $async.Stream<$1.SmartConnectEvent> subscribeSmartConnectEvents(
      $grpc.ServiceCall call, $1.SmartConnectEventsRequest request);
}
