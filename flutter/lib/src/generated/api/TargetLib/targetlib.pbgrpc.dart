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

  /// Active subscription state is persisted by the backend; clients do not track it.
  $grpc.ResponseFuture<$0.Empty> setActiveSubscription(
    $1.SetActiveSubscriptionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$setActiveSubscription, request, options: options);
  }

  $grpc.ResponseFuture<$1.ActiveSubscriptionResponse> getActiveSubscription(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getActiveSubscription, request, options: options);
  }

  /// IP geolocation query (egress from the backend).
  $grpc.ResponseFuture<$1.IpInfoResponse> getIpInfo(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getIpInfo, request, options: options);
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
  static final _$setActiveSubscription =
      $grpc.ClientMethod<$1.SetActiveSubscriptionRequest, $0.Empty>(
          '/targetlib.TargetLib/SetActiveSubscription',
          ($1.SetActiveSubscriptionRequest value) => value.writeToBuffer(),
          $0.Empty.fromBuffer);
  static final _$getActiveSubscription =
      $grpc.ClientMethod<$0.Empty, $1.ActiveSubscriptionResponse>(
          '/targetlib.TargetLib/GetActiveSubscription',
          ($0.Empty value) => value.writeToBuffer(),
          $1.ActiveSubscriptionResponse.fromBuffer);
  static final _$getIpInfo = $grpc.ClientMethod<$0.Empty, $1.IpInfoResponse>(
      '/targetlib.TargetLib/GetIpInfo',
      ($0.Empty value) => value.writeToBuffer(),
      $1.IpInfoResponse.fromBuffer);
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
    $addMethod($grpc.ServiceMethod<$1.SetActiveSubscriptionRequest, $0.Empty>(
        'SetActiveSubscription',
        setActiveSubscription_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $1.SetActiveSubscriptionRequest.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $1.ActiveSubscriptionResponse>(
        'GetActiveSubscription',
        getActiveSubscription_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($1.ActiveSubscriptionResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $1.IpInfoResponse>(
        'GetIpInfo',
        getIpInfo_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($1.IpInfoResponse value) => value.writeToBuffer()));
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

  $async.Future<$0.Empty> setActiveSubscription_Pre($grpc.ServiceCall $call,
      $async.Future<$1.SetActiveSubscriptionRequest> $request) async {
    return setActiveSubscription($call, await $request);
  }

  $async.Future<$0.Empty> setActiveSubscription(
      $grpc.ServiceCall call, $1.SetActiveSubscriptionRequest request);

  $async.Future<$1.ActiveSubscriptionResponse> getActiveSubscription_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return getActiveSubscription($call, await $request);
  }

  $async.Future<$1.ActiveSubscriptionResponse> getActiveSubscription(
      $grpc.ServiceCall call, $0.Empty request);

  $async.Future<$1.IpInfoResponse> getIpInfo_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return getIpInfo($call, await $request);
  }

  $async.Future<$1.IpInfoResponse> getIpInfo(
      $grpc.ServiceCall call, $0.Empty request);
}
