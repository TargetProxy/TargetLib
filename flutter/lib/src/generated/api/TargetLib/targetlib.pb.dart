// This is a generated file - do not edit.
//
// Generated from api/TargetLib/targetlib.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'targetlib.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'targetlib.pbenum.dart';

class LogMessage extends $pb.GeneratedMessage {
  factory LogMessage({
    LogLevel? level,
    $core.String? message,
  }) {
    final result = create();
    if (level != null) result.level = level;
    if (message != null) result.message = message;
    return result;
  }

  LogMessage._();

  factory LogMessage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LogMessage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LogMessage',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aE<LogLevel>(1, _omitFieldNames ? '' : 'level',
        enumValues: LogLevel.values)
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LogMessage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LogMessage copyWith(void Function(LogMessage) updates) =>
      super.copyWith((message) => updates(message as LogMessage)) as LogMessage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LogMessage create() => LogMessage._();
  @$core.override
  LogMessage createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LogMessage getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LogMessage>(create);
  static LogMessage? _defaultInstance;

  @$pb.TagNumber(1)
  LogLevel get level => $_getN(0);
  @$pb.TagNumber(1)
  set level(LogLevel value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLevel() => $_has(0);
  @$pb.TagNumber(1)
  void clearLevel() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);
}

class LogBatch extends $pb.GeneratedMessage {
  factory LogBatch({
    $core.Iterable<LogMessage>? messages,
    $core.bool? reset,
  }) {
    final result = create();
    if (messages != null) result.messages.addAll(messages);
    if (reset != null) result.reset = reset;
    return result;
  }

  LogBatch._();

  factory LogBatch.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LogBatch.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LogBatch',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..pPM<LogMessage>(1, _omitFieldNames ? '' : 'messages',
        subBuilder: LogMessage.create)
    ..aOB(2, _omitFieldNames ? '' : 'reset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LogBatch clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LogBatch copyWith(void Function(LogBatch) updates) =>
      super.copyWith((message) => updates(message as LogBatch)) as LogBatch;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LogBatch create() => LogBatch._();
  @$core.override
  LogBatch createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LogBatch getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LogBatch>(create);
  static LogBatch? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<LogMessage> get messages => $_getList(0);

  @$pb.TagNumber(2)
  $core.bool get reset => $_getBF(1);
  @$pb.TagNumber(2)
  set reset($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReset() => $_has(1);
  @$pb.TagNumber(2)
  void clearReset() => $_clearField(2);
}

class SelectOutboundRequest extends $pb.GeneratedMessage {
  factory SelectOutboundRequest({
    $core.String? groupTag,
    $core.String? outboundTag,
  }) {
    final result = create();
    if (groupTag != null) result.groupTag = groupTag;
    if (outboundTag != null) result.outboundTag = outboundTag;
    return result;
  }

  SelectOutboundRequest._();

  factory SelectOutboundRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SelectOutboundRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SelectOutboundRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'groupTag')
    ..aOS(2, _omitFieldNames ? '' : 'outboundTag')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SelectOutboundRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SelectOutboundRequest copyWith(
          void Function(SelectOutboundRequest) updates) =>
      super.copyWith((message) => updates(message as SelectOutboundRequest))
          as SelectOutboundRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SelectOutboundRequest create() => SelectOutboundRequest._();
  @$core.override
  SelectOutboundRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SelectOutboundRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SelectOutboundRequest>(create);
  static SelectOutboundRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get groupTag => $_getSZ(0);
  @$pb.TagNumber(1)
  set groupTag($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGroupTag() => $_has(0);
  @$pb.TagNumber(1)
  void clearGroupTag() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get outboundTag => $_getSZ(1);
  @$pb.TagNumber(2)
  set outboundTag($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOutboundTag() => $_has(1);
  @$pb.TagNumber(2)
  void clearOutboundTag() => $_clearField(2);
}

class CloseConnectionRequest extends $pb.GeneratedMessage {
  factory CloseConnectionRequest({
    $core.String? id,
  }) {
    final result = create();
    if (id != null) result.id = id;
    return result;
  }

  CloseConnectionRequest._();

  factory CloseConnectionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloseConnectionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CloseConnectionRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseConnectionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseConnectionRequest copyWith(
          void Function(CloseConnectionRequest) updates) =>
      super.copyWith((message) => updates(message as CloseConnectionRequest))
          as CloseConnectionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloseConnectionRequest create() => CloseConnectionRequest._();
  @$core.override
  CloseConnectionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloseConnectionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CloseConnectionRequest>(create);
  static CloseConnectionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class VersionResponse extends $pb.GeneratedMessage {
  factory VersionResponse({
    $core.String? targetlibVersion,
    $core.String? singBoxVersion,
    $core.String? goVersion,
    $core.int? protocolVersion,
  }) {
    final result = create();
    if (targetlibVersion != null) result.targetlibVersion = targetlibVersion;
    if (singBoxVersion != null) result.singBoxVersion = singBoxVersion;
    if (goVersion != null) result.goVersion = goVersion;
    if (protocolVersion != null) result.protocolVersion = protocolVersion;
    return result;
  }

  VersionResponse._();

  factory VersionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VersionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VersionResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'targetlibVersion')
    ..aOS(2, _omitFieldNames ? '' : 'singBoxVersion')
    ..aOS(3, _omitFieldNames ? '' : 'goVersion')
    ..aI(4, _omitFieldNames ? '' : 'protocolVersion',
        fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VersionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VersionResponse copyWith(void Function(VersionResponse) updates) =>
      super.copyWith((message) => updates(message as VersionResponse))
          as VersionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VersionResponse create() => VersionResponse._();
  @$core.override
  VersionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VersionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VersionResponse>(create);
  static VersionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get targetlibVersion => $_getSZ(0);
  @$pb.TagNumber(1)
  set targetlibVersion($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTargetlibVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearTargetlibVersion() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get singBoxVersion => $_getSZ(1);
  @$pb.TagNumber(2)
  set singBoxVersion($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSingBoxVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearSingBoxVersion() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get goVersion => $_getSZ(2);
  @$pb.TagNumber(3)
  set goVersion($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasGoVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearGoVersion() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get protocolVersion => $_getIZ(3);
  @$pb.TagNumber(4)
  set protocolVersion($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasProtocolVersion() => $_has(3);
  @$pb.TagNumber(4)
  void clearProtocolVersion() => $_clearField(4);
}

class CapabilitiesResponse extends $pb.GeneratedMessage {
  factory CapabilitiesResponse({
    $core.String? platform,
    $core.bool? platformVpn,
    $core.bool? subscriptionManagement,
    $core.bool? realTimeTraffic,
    $core.bool? smartConnect,
    $core.bool? serviceProbes,
    $core.bool? runtimeEvents,
    $core.bool? smartConnectIntentApi,
  }) {
    final result = create();
    if (platform != null) result.platform = platform;
    if (platformVpn != null) result.platformVpn = platformVpn;
    if (subscriptionManagement != null)
      result.subscriptionManagement = subscriptionManagement;
    if (realTimeTraffic != null) result.realTimeTraffic = realTimeTraffic;
    if (smartConnect != null) result.smartConnect = smartConnect;
    if (serviceProbes != null) result.serviceProbes = serviceProbes;
    if (runtimeEvents != null) result.runtimeEvents = runtimeEvents;
    if (smartConnectIntentApi != null)
      result.smartConnectIntentApi = smartConnectIntentApi;
    return result;
  }

  CapabilitiesResponse._();

  factory CapabilitiesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CapabilitiesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CapabilitiesResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'platform')
    ..aOB(3, _omitFieldNames ? '' : 'platformVpn')
    ..aOB(5, _omitFieldNames ? '' : 'subscriptionManagement')
    ..aOB(6, _omitFieldNames ? '' : 'realTimeTraffic')
    ..aOB(7, _omitFieldNames ? '' : 'smartConnect')
    ..aOB(8, _omitFieldNames ? '' : 'serviceProbes')
    ..aOB(9, _omitFieldNames ? '' : 'runtimeEvents')
    ..aOB(10, _omitFieldNames ? '' : 'smartConnectIntentApi')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CapabilitiesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CapabilitiesResponse copyWith(void Function(CapabilitiesResponse) updates) =>
      super.copyWith((message) => updates(message as CapabilitiesResponse))
          as CapabilitiesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CapabilitiesResponse create() => CapabilitiesResponse._();
  @$core.override
  CapabilitiesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CapabilitiesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CapabilitiesResponse>(create);
  static CapabilitiesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get platform => $_getSZ(0);
  @$pb.TagNumber(1)
  set platform($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPlatform() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlatform() => $_clearField(1);

  @$pb.TagNumber(3)
  $core.bool get platformVpn => $_getBF(1);
  @$pb.TagNumber(3)
  set platformVpn($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(3)
  $core.bool hasPlatformVpn() => $_has(1);
  @$pb.TagNumber(3)
  void clearPlatformVpn() => $_clearField(3);

  @$pb.TagNumber(5)
  $core.bool get subscriptionManagement => $_getBF(2);
  @$pb.TagNumber(5)
  set subscriptionManagement($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(5)
  $core.bool hasSubscriptionManagement() => $_has(2);
  @$pb.TagNumber(5)
  void clearSubscriptionManagement() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get realTimeTraffic => $_getBF(3);
  @$pb.TagNumber(6)
  set realTimeTraffic($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(6)
  $core.bool hasRealTimeTraffic() => $_has(3);
  @$pb.TagNumber(6)
  void clearRealTimeTraffic() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get smartConnect => $_getBF(4);
  @$pb.TagNumber(7)
  set smartConnect($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(7)
  $core.bool hasSmartConnect() => $_has(4);
  @$pb.TagNumber(7)
  void clearSmartConnect() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get serviceProbes => $_getBF(5);
  @$pb.TagNumber(8)
  set serviceProbes($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(8)
  $core.bool hasServiceProbes() => $_has(5);
  @$pb.TagNumber(8)
  void clearServiceProbes() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get runtimeEvents => $_getBF(6);
  @$pb.TagNumber(9)
  set runtimeEvents($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(9)
  $core.bool hasRuntimeEvents() => $_has(6);
  @$pb.TagNumber(9)
  void clearRuntimeEvents() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get smartConnectIntentApi => $_getBF(7);
  @$pb.TagNumber(10)
  set smartConnectIntentApi($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(10)
  $core.bool hasSmartConnectIntentApi() => $_has(7);
  @$pb.TagNumber(10)
  void clearSmartConnectIntentApi() => $_clearField(10);
}

class OperationResponse extends $pb.GeneratedMessage {
  factory OperationResponse({
    ServiceState? state,
  }) {
    final result = create();
    if (state != null) result.state = state;
    return result;
  }

  OperationResponse._();

  factory OperationResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OperationResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OperationResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOM<ServiceState>(1, _omitFieldNames ? '' : 'state',
        subBuilder: ServiceState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OperationResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OperationResponse copyWith(void Function(OperationResponse) updates) =>
      super.copyWith((message) => updates(message as OperationResponse))
          as OperationResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OperationResponse create() => OperationResponse._();
  @$core.override
  OperationResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OperationResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OperationResponse>(create);
  static OperationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ServiceState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state(ServiceState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);
  @$pb.TagNumber(1)
  ServiceState ensureState() => $_ensure(0);
}

class ServiceState extends $pb.GeneratedMessage {
  factory ServiceState({
    ServiceStateType? state,
    $core.String? errorMessage,
    $fixnum.Int64? changedAtUnixMs,
  }) {
    final result = create();
    if (state != null) result.state = state;
    if (errorMessage != null) result.errorMessage = errorMessage;
    if (changedAtUnixMs != null) result.changedAtUnixMs = changedAtUnixMs;
    return result;
  }

  ServiceState._();

  factory ServiceState.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServiceState.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServiceState',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aE<ServiceStateType>(1, _omitFieldNames ? '' : 'state',
        enumValues: ServiceStateType.values)
    ..aOS(2, _omitFieldNames ? '' : 'errorMessage')
    ..aInt64(3, _omitFieldNames ? '' : 'changedAtUnixMs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceState clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceState copyWith(void Function(ServiceState) updates) =>
      super.copyWith((message) => updates(message as ServiceState))
          as ServiceState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceState create() => ServiceState._();
  @$core.override
  ServiceState createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ServiceState getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServiceState>(create);
  static ServiceState? _defaultInstance;

  @$pb.TagNumber(1)
  ServiceStateType get state => $_getN(0);
  @$pb.TagNumber(1)
  set state(ServiceStateType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get errorMessage => $_getSZ(1);
  @$pb.TagNumber(2)
  set errorMessage($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasErrorMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearErrorMessage() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get changedAtUnixMs => $_getI64(2);
  @$pb.TagNumber(3)
  set changedAtUnixMs($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasChangedAtUnixMs() => $_has(2);
  @$pb.TagNumber(3)
  void clearChangedAtUnixMs() => $_clearField(3);
}

class TrafficRequest extends $pb.GeneratedMessage {
  factory TrafficRequest({
    $core.int? intervalMilliseconds,
  }) {
    final result = create();
    if (intervalMilliseconds != null)
      result.intervalMilliseconds = intervalMilliseconds;
    return result;
  }

  TrafficRequest._();

  factory TrafficRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TrafficRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TrafficRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'intervalMilliseconds',
        fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrafficRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrafficRequest copyWith(void Function(TrafficRequest) updates) =>
      super.copyWith((message) => updates(message as TrafficRequest))
          as TrafficRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TrafficRequest create() => TrafficRequest._();
  @$core.override
  TrafficRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TrafficRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TrafficRequest>(create);
  static TrafficRequest? _defaultInstance;

  /// Zero uses one second. The accepted range is 250-5000 milliseconds.
  @$pb.TagNumber(1)
  $core.int get intervalMilliseconds => $_getIZ(0);
  @$pb.TagNumber(1)
  set intervalMilliseconds($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIntervalMilliseconds() => $_has(0);
  @$pb.TagNumber(1)
  void clearIntervalMilliseconds() => $_clearField(1);
}

class TrafficStatus extends $pb.GeneratedMessage {
  factory TrafficStatus({
    $core.bool? available,
    $fixnum.Int64? uploadBytesPerSecond,
    $fixnum.Int64? downloadBytesPerSecond,
    $fixnum.Int64? uploadTotalBytes,
    $fixnum.Int64? downloadTotalBytes,
    $core.int? inboundConnections,
    $core.int? outboundConnections,
    $fixnum.Int64? sampledAtUnixMs,
    $core.int? intervalMilliseconds,
  }) {
    final result = create();
    if (available != null) result.available = available;
    if (uploadBytesPerSecond != null)
      result.uploadBytesPerSecond = uploadBytesPerSecond;
    if (downloadBytesPerSecond != null)
      result.downloadBytesPerSecond = downloadBytesPerSecond;
    if (uploadTotalBytes != null) result.uploadTotalBytes = uploadTotalBytes;
    if (downloadTotalBytes != null)
      result.downloadTotalBytes = downloadTotalBytes;
    if (inboundConnections != null)
      result.inboundConnections = inboundConnections;
    if (outboundConnections != null)
      result.outboundConnections = outboundConnections;
    if (sampledAtUnixMs != null) result.sampledAtUnixMs = sampledAtUnixMs;
    if (intervalMilliseconds != null)
      result.intervalMilliseconds = intervalMilliseconds;
    return result;
  }

  TrafficStatus._();

  factory TrafficStatus.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TrafficStatus.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TrafficStatus',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'available')
    ..aInt64(2, _omitFieldNames ? '' : 'uploadBytesPerSecond')
    ..aInt64(3, _omitFieldNames ? '' : 'downloadBytesPerSecond')
    ..aInt64(4, _omitFieldNames ? '' : 'uploadTotalBytes')
    ..aInt64(5, _omitFieldNames ? '' : 'downloadTotalBytes')
    ..aI(6, _omitFieldNames ? '' : 'inboundConnections')
    ..aI(7, _omitFieldNames ? '' : 'outboundConnections')
    ..aInt64(8, _omitFieldNames ? '' : 'sampledAtUnixMs')
    ..aI(9, _omitFieldNames ? '' : 'intervalMilliseconds',
        fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrafficStatus clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrafficStatus copyWith(void Function(TrafficStatus) updates) =>
      super.copyWith((message) => updates(message as TrafficStatus))
          as TrafficStatus;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TrafficStatus create() => TrafficStatus._();
  @$core.override
  TrafficStatus createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TrafficStatus getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TrafficStatus>(create);
  static TrafficStatus? _defaultInstance;

  /// False when the runtime is stopped or its traffic manager is unavailable.
  @$pb.TagNumber(1)
  $core.bool get available => $_getBF(0);
  @$pb.TagNumber(1)
  set available($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAvailable() => $_has(0);
  @$pb.TagNumber(1)
  void clearAvailable() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get uploadBytesPerSecond => $_getI64(1);
  @$pb.TagNumber(2)
  set uploadBytesPerSecond($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUploadBytesPerSecond() => $_has(1);
  @$pb.TagNumber(2)
  void clearUploadBytesPerSecond() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get downloadBytesPerSecond => $_getI64(2);
  @$pb.TagNumber(3)
  set downloadBytesPerSecond($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDownloadBytesPerSecond() => $_has(2);
  @$pb.TagNumber(3)
  void clearDownloadBytesPerSecond() => $_clearField(3);

  /// Totals belong to the current sing-box runtime and reset when it restarts.
  @$pb.TagNumber(4)
  $fixnum.Int64 get uploadTotalBytes => $_getI64(3);
  @$pb.TagNumber(4)
  set uploadTotalBytes($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUploadTotalBytes() => $_has(3);
  @$pb.TagNumber(4)
  void clearUploadTotalBytes() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get downloadTotalBytes => $_getI64(4);
  @$pb.TagNumber(5)
  set downloadTotalBytes($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDownloadTotalBytes() => $_has(4);
  @$pb.TagNumber(5)
  void clearDownloadTotalBytes() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get inboundConnections => $_getIZ(5);
  @$pb.TagNumber(6)
  set inboundConnections($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasInboundConnections() => $_has(5);
  @$pb.TagNumber(6)
  void clearInboundConnections() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get outboundConnections => $_getIZ(6);
  @$pb.TagNumber(7)
  set outboundConnections($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasOutboundConnections() => $_has(6);
  @$pb.TagNumber(7)
  void clearOutboundConnections() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get sampledAtUnixMs => $_getI64(7);
  @$pb.TagNumber(8)
  set sampledAtUnixMs($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasSampledAtUnixMs() => $_has(7);
  @$pb.TagNumber(8)
  void clearSampledAtUnixMs() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get intervalMilliseconds => $_getIZ(8);
  @$pb.TagNumber(9)
  set intervalMilliseconds($core.int value) => $_setUnsignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasIntervalMilliseconds() => $_has(8);
  @$pb.TagNumber(9)
  void clearIntervalMilliseconds() => $_clearField(9);
}

class SubscriptionId extends $pb.GeneratedMessage {
  factory SubscriptionId({
    $core.String? id,
  }) {
    final result = create();
    if (id != null) result.id = id;
    return result;
  }

  SubscriptionId._();

  factory SubscriptionId.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SubscriptionId.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubscriptionId',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubscriptionId clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubscriptionId copyWith(void Function(SubscriptionId) updates) =>
      super.copyWith((message) => updates(message as SubscriptionId))
          as SubscriptionId;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubscriptionId create() => SubscriptionId._();
  @$core.override
  SubscriptionId createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SubscriptionId getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubscriptionId>(create);
  static SubscriptionId? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class AddSubscriptionRequest extends $pb.GeneratedMessage {
  factory AddSubscriptionRequest({
    $core.String? id,
    $core.String? name,
    $core.String? url,
    $core.bool? enabled,
    $core.bool? autoUpdate,
    $fixnum.Int64? updateIntervalSeconds,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? headers,
    $core.bool? updateNow,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (url != null) result.url = url;
    if (enabled != null) result.enabled = enabled;
    if (autoUpdate != null) result.autoUpdate = autoUpdate;
    if (updateIntervalSeconds != null)
      result.updateIntervalSeconds = updateIntervalSeconds;
    if (headers != null) result.headers.addEntries(headers);
    if (updateNow != null) result.updateNow = updateNow;
    return result;
  }

  AddSubscriptionRequest._();

  factory AddSubscriptionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddSubscriptionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddSubscriptionRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'url')
    ..aOB(4, _omitFieldNames ? '' : 'enabled')
    ..aOB(5, _omitFieldNames ? '' : 'autoUpdate')
    ..aInt64(6, _omitFieldNames ? '' : 'updateIntervalSeconds')
    ..m<$core.String, $core.String>(7, _omitFieldNames ? '' : 'headers',
        entryClassName: 'AddSubscriptionRequest.HeadersEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('targetlib'))
    ..aOB(9, _omitFieldNames ? '' : 'updateNow')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddSubscriptionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddSubscriptionRequest copyWith(
          void Function(AddSubscriptionRequest) updates) =>
      super.copyWith((message) => updates(message as AddSubscriptionRequest))
          as AddSubscriptionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddSubscriptionRequest create() => AddSubscriptionRequest._();
  @$core.override
  AddSubscriptionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddSubscriptionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddSubscriptionRequest>(create);
  static AddSubscriptionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get url => $_getSZ(2);
  @$pb.TagNumber(3)
  set url($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearUrl() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get enabled => $_getBF(3);
  @$pb.TagNumber(4)
  set enabled($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEnabled() => $_has(3);
  @$pb.TagNumber(4)
  void clearEnabled() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get autoUpdate => $_getBF(4);
  @$pb.TagNumber(5)
  set autoUpdate($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAutoUpdate() => $_has(4);
  @$pb.TagNumber(5)
  void clearAutoUpdate() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get updateIntervalSeconds => $_getI64(5);
  @$pb.TagNumber(6)
  set updateIntervalSeconds($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasUpdateIntervalSeconds() => $_has(5);
  @$pb.TagNumber(6)
  void clearUpdateIntervalSeconds() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbMap<$core.String, $core.String> get headers => $_getMap(6);

  @$pb.TagNumber(9)
  $core.bool get updateNow => $_getBF(7);
  @$pb.TagNumber(9)
  set updateNow($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(9)
  $core.bool hasUpdateNow() => $_has(7);
  @$pb.TagNumber(9)
  void clearUpdateNow() => $_clearField(9);
}

class RenameSubscriptionRequest extends $pb.GeneratedMessage {
  factory RenameSubscriptionRequest({
    $core.String? id,
    $core.String? name,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    return result;
  }

  RenameSubscriptionRequest._();

  factory RenameSubscriptionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RenameSubscriptionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RenameSubscriptionRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RenameSubscriptionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RenameSubscriptionRequest copyWith(
          void Function(RenameSubscriptionRequest) updates) =>
      super.copyWith((message) => updates(message as RenameSubscriptionRequest))
          as RenameSubscriptionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RenameSubscriptionRequest create() => RenameSubscriptionRequest._();
  @$core.override
  RenameSubscriptionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RenameSubscriptionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RenameSubscriptionRequest>(create);
  static RenameSubscriptionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);
}

class SetSubscriptionEnabledRequest extends $pb.GeneratedMessage {
  factory SetSubscriptionEnabledRequest({
    $core.String? id,
    $core.bool? enabled,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (enabled != null) result.enabled = enabled;
    return result;
  }

  SetSubscriptionEnabledRequest._();

  factory SetSubscriptionEnabledRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetSubscriptionEnabledRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetSubscriptionEnabledRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOB(2, _omitFieldNames ? '' : 'enabled')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetSubscriptionEnabledRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetSubscriptionEnabledRequest copyWith(
          void Function(SetSubscriptionEnabledRequest) updates) =>
      super.copyWith(
              (message) => updates(message as SetSubscriptionEnabledRequest))
          as SetSubscriptionEnabledRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetSubscriptionEnabledRequest create() =>
      SetSubscriptionEnabledRequest._();
  @$core.override
  SetSubscriptionEnabledRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetSubscriptionEnabledRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetSubscriptionEnabledRequest>(create);
  static SetSubscriptionEnabledRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get enabled => $_getBF(1);
  @$pb.TagNumber(2)
  set enabled($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEnabled() => $_has(1);
  @$pb.TagNumber(2)
  void clearEnabled() => $_clearField(2);
}

class ConfigureSubscriptionUpdatesRequest extends $pb.GeneratedMessage {
  factory ConfigureSubscriptionUpdatesRequest({
    $core.String? id,
    $core.bool? enabled,
    $fixnum.Int64? updateIntervalSeconds,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (enabled != null) result.enabled = enabled;
    if (updateIntervalSeconds != null)
      result.updateIntervalSeconds = updateIntervalSeconds;
    return result;
  }

  ConfigureSubscriptionUpdatesRequest._();

  factory ConfigureSubscriptionUpdatesRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ConfigureSubscriptionUpdatesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConfigureSubscriptionUpdatesRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOB(2, _omitFieldNames ? '' : 'enabled')
    ..aInt64(3, _omitFieldNames ? '' : 'updateIntervalSeconds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfigureSubscriptionUpdatesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfigureSubscriptionUpdatesRequest copyWith(
          void Function(ConfigureSubscriptionUpdatesRequest) updates) =>
      super.copyWith((message) =>
              updates(message as ConfigureSubscriptionUpdatesRequest))
          as ConfigureSubscriptionUpdatesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConfigureSubscriptionUpdatesRequest create() =>
      ConfigureSubscriptionUpdatesRequest._();
  @$core.override
  ConfigureSubscriptionUpdatesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ConfigureSubscriptionUpdatesRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          ConfigureSubscriptionUpdatesRequest>(create);
  static ConfigureSubscriptionUpdatesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get enabled => $_getBF(1);
  @$pb.TagNumber(2)
  set enabled($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEnabled() => $_has(1);
  @$pb.TagNumber(2)
  void clearEnabled() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get updateIntervalSeconds => $_getI64(2);
  @$pb.TagNumber(3)
  set updateIntervalSeconds($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUpdateIntervalSeconds() => $_has(2);
  @$pb.TagNumber(3)
  void clearUpdateIntervalSeconds() => $_clearField(3);
}

class ResolvedEndpointsRequest extends $pb.GeneratedMessage {
  factory ResolvedEndpointsRequest({
    $core.bool? enabledOnly,
  }) {
    final result = create();
    if (enabledOnly != null) result.enabledOnly = enabledOnly;
    return result;
  }

  ResolvedEndpointsRequest._();

  factory ResolvedEndpointsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResolvedEndpointsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResolvedEndpointsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'enabledOnly')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolvedEndpointsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolvedEndpointsRequest copyWith(
          void Function(ResolvedEndpointsRequest) updates) =>
      super.copyWith((message) => updates(message as ResolvedEndpointsRequest))
          as ResolvedEndpointsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResolvedEndpointsRequest create() => ResolvedEndpointsRequest._();
  @$core.override
  ResolvedEndpointsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResolvedEndpointsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResolvedEndpointsRequest>(create);
  static ResolvedEndpointsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get enabledOnly => $_getBF(0);
  @$pb.TagNumber(1)
  set enabledOnly($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEnabledOnly() => $_has(0);
  @$pb.TagNumber(1)
  void clearEnabledOnly() => $_clearField(1);
}

class SubscriptionList extends $pb.GeneratedMessage {
  factory SubscriptionList({
    $core.Iterable<SubscriptionView>? subscriptions,
  }) {
    final result = create();
    if (subscriptions != null) result.subscriptions.addAll(subscriptions);
    return result;
  }

  SubscriptionList._();

  factory SubscriptionList.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SubscriptionList.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubscriptionList',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..pPM<SubscriptionView>(1, _omitFieldNames ? '' : 'subscriptions',
        subBuilder: SubscriptionView.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubscriptionList clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubscriptionList copyWith(void Function(SubscriptionList) updates) =>
      super.copyWith((message) => updates(message as SubscriptionList))
          as SubscriptionList;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubscriptionList create() => SubscriptionList._();
  @$core.override
  SubscriptionList createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SubscriptionList getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubscriptionList>(create);
  static SubscriptionList? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<SubscriptionView> get subscriptions => $_getList(0);
}

class SubscriptionView extends $pb.GeneratedMessage {
  factory SubscriptionView({
    $core.String? id,
    $core.String? name,
    $core.String? source,
    $core.bool? enabled,
    $core.bool? autoUpdate,
    $fixnum.Int64? updateIntervalSeconds,
    SubscriptionStatus? status,
    SubscriptionUpdateStage? stage,
    ProfileView? profile,
    $core.String? errorCode,
    $core.String? errorMessage,
    $fixnum.Int64? updatedAtUnixMs,
    $fixnum.Int64? nextUpdateAtUnixMs,
    $fixnum.Int64? uploadBytes,
    $fixnum.Int64? downloadBytes,
    $fixnum.Int64? totalBytes,
    $fixnum.Int64? expiresAtUnixMs,
    $core.String? title,
    $core.String? webPageUrl,
    $core.String? supportUrl,
    $core.String? movedPermanentlyTo,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (source != null) result.source = source;
    if (enabled != null) result.enabled = enabled;
    if (autoUpdate != null) result.autoUpdate = autoUpdate;
    if (updateIntervalSeconds != null)
      result.updateIntervalSeconds = updateIntervalSeconds;
    if (status != null) result.status = status;
    if (stage != null) result.stage = stage;
    if (profile != null) result.profile = profile;
    if (errorCode != null) result.errorCode = errorCode;
    if (errorMessage != null) result.errorMessage = errorMessage;
    if (updatedAtUnixMs != null) result.updatedAtUnixMs = updatedAtUnixMs;
    if (nextUpdateAtUnixMs != null)
      result.nextUpdateAtUnixMs = nextUpdateAtUnixMs;
    if (uploadBytes != null) result.uploadBytes = uploadBytes;
    if (downloadBytes != null) result.downloadBytes = downloadBytes;
    if (totalBytes != null) result.totalBytes = totalBytes;
    if (expiresAtUnixMs != null) result.expiresAtUnixMs = expiresAtUnixMs;
    if (title != null) result.title = title;
    if (webPageUrl != null) result.webPageUrl = webPageUrl;
    if (supportUrl != null) result.supportUrl = supportUrl;
    if (movedPermanentlyTo != null)
      result.movedPermanentlyTo = movedPermanentlyTo;
    return result;
  }

  SubscriptionView._();

  factory SubscriptionView.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SubscriptionView.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubscriptionView',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'source')
    ..aOB(4, _omitFieldNames ? '' : 'enabled')
    ..aOB(5, _omitFieldNames ? '' : 'autoUpdate')
    ..aInt64(6, _omitFieldNames ? '' : 'updateIntervalSeconds')
    ..aE<SubscriptionStatus>(7, _omitFieldNames ? '' : 'status',
        enumValues: SubscriptionStatus.values)
    ..aE<SubscriptionUpdateStage>(8, _omitFieldNames ? '' : 'stage',
        enumValues: SubscriptionUpdateStage.values)
    ..aOM<ProfileView>(9, _omitFieldNames ? '' : 'profile',
        subBuilder: ProfileView.create)
    ..aOS(10, _omitFieldNames ? '' : 'errorCode')
    ..aOS(11, _omitFieldNames ? '' : 'errorMessage')
    ..aInt64(12, _omitFieldNames ? '' : 'updatedAtUnixMs')
    ..aInt64(13, _omitFieldNames ? '' : 'nextUpdateAtUnixMs')
    ..aInt64(14, _omitFieldNames ? '' : 'uploadBytes')
    ..aInt64(15, _omitFieldNames ? '' : 'downloadBytes')
    ..aInt64(16, _omitFieldNames ? '' : 'totalBytes')
    ..aInt64(17, _omitFieldNames ? '' : 'expiresAtUnixMs')
    ..aOS(18, _omitFieldNames ? '' : 'title')
    ..aOS(19, _omitFieldNames ? '' : 'webPageUrl')
    ..aOS(20, _omitFieldNames ? '' : 'supportUrl')
    ..aOS(21, _omitFieldNames ? '' : 'movedPermanentlyTo')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubscriptionView clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubscriptionView copyWith(void Function(SubscriptionView) updates) =>
      super.copyWith((message) => updates(message as SubscriptionView))
          as SubscriptionView;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubscriptionView create() => SubscriptionView._();
  @$core.override
  SubscriptionView createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SubscriptionView getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubscriptionView>(create);
  static SubscriptionView? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get source => $_getSZ(2);
  @$pb.TagNumber(3)
  set source($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSource() => $_has(2);
  @$pb.TagNumber(3)
  void clearSource() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get enabled => $_getBF(3);
  @$pb.TagNumber(4)
  set enabled($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEnabled() => $_has(3);
  @$pb.TagNumber(4)
  void clearEnabled() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get autoUpdate => $_getBF(4);
  @$pb.TagNumber(5)
  set autoUpdate($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAutoUpdate() => $_has(4);
  @$pb.TagNumber(5)
  void clearAutoUpdate() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get updateIntervalSeconds => $_getI64(5);
  @$pb.TagNumber(6)
  set updateIntervalSeconds($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasUpdateIntervalSeconds() => $_has(5);
  @$pb.TagNumber(6)
  void clearUpdateIntervalSeconds() => $_clearField(6);

  @$pb.TagNumber(7)
  SubscriptionStatus get status => $_getN(6);
  @$pb.TagNumber(7)
  set status(SubscriptionStatus value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasStatus() => $_has(6);
  @$pb.TagNumber(7)
  void clearStatus() => $_clearField(7);

  @$pb.TagNumber(8)
  SubscriptionUpdateStage get stage => $_getN(7);
  @$pb.TagNumber(8)
  set stage(SubscriptionUpdateStage value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasStage() => $_has(7);
  @$pb.TagNumber(8)
  void clearStage() => $_clearField(8);

  @$pb.TagNumber(9)
  ProfileView get profile => $_getN(8);
  @$pb.TagNumber(9)
  set profile(ProfileView value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasProfile() => $_has(8);
  @$pb.TagNumber(9)
  void clearProfile() => $_clearField(9);
  @$pb.TagNumber(9)
  ProfileView ensureProfile() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.String get errorCode => $_getSZ(9);
  @$pb.TagNumber(10)
  set errorCode($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasErrorCode() => $_has(9);
  @$pb.TagNumber(10)
  void clearErrorCode() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get errorMessage => $_getSZ(10);
  @$pb.TagNumber(11)
  set errorMessage($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasErrorMessage() => $_has(10);
  @$pb.TagNumber(11)
  void clearErrorMessage() => $_clearField(11);

  @$pb.TagNumber(12)
  $fixnum.Int64 get updatedAtUnixMs => $_getI64(11);
  @$pb.TagNumber(12)
  set updatedAtUnixMs($fixnum.Int64 value) => $_setInt64(11, value);
  @$pb.TagNumber(12)
  $core.bool hasUpdatedAtUnixMs() => $_has(11);
  @$pb.TagNumber(12)
  void clearUpdatedAtUnixMs() => $_clearField(12);

  @$pb.TagNumber(13)
  $fixnum.Int64 get nextUpdateAtUnixMs => $_getI64(12);
  @$pb.TagNumber(13)
  set nextUpdateAtUnixMs($fixnum.Int64 value) => $_setInt64(12, value);
  @$pb.TagNumber(13)
  $core.bool hasNextUpdateAtUnixMs() => $_has(12);
  @$pb.TagNumber(13)
  void clearNextUpdateAtUnixMs() => $_clearField(13);

  @$pb.TagNumber(14)
  $fixnum.Int64 get uploadBytes => $_getI64(13);
  @$pb.TagNumber(14)
  set uploadBytes($fixnum.Int64 value) => $_setInt64(13, value);
  @$pb.TagNumber(14)
  $core.bool hasUploadBytes() => $_has(13);
  @$pb.TagNumber(14)
  void clearUploadBytes() => $_clearField(14);

  @$pb.TagNumber(15)
  $fixnum.Int64 get downloadBytes => $_getI64(14);
  @$pb.TagNumber(15)
  set downloadBytes($fixnum.Int64 value) => $_setInt64(14, value);
  @$pb.TagNumber(15)
  $core.bool hasDownloadBytes() => $_has(14);
  @$pb.TagNumber(15)
  void clearDownloadBytes() => $_clearField(15);

  @$pb.TagNumber(16)
  $fixnum.Int64 get totalBytes => $_getI64(15);
  @$pb.TagNumber(16)
  set totalBytes($fixnum.Int64 value) => $_setInt64(15, value);
  @$pb.TagNumber(16)
  $core.bool hasTotalBytes() => $_has(15);
  @$pb.TagNumber(16)
  void clearTotalBytes() => $_clearField(16);

  /// 订阅协议响应头元数据，服务器未提供时为零值。
  @$pb.TagNumber(17)
  $fixnum.Int64 get expiresAtUnixMs => $_getI64(16);
  @$pb.TagNumber(17)
  set expiresAtUnixMs($fixnum.Int64 value) => $_setInt64(16, value);
  @$pb.TagNumber(17)
  $core.bool hasExpiresAtUnixMs() => $_has(16);
  @$pb.TagNumber(17)
  void clearExpiresAtUnixMs() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.String get title => $_getSZ(17);
  @$pb.TagNumber(18)
  set title($core.String value) => $_setString(17, value);
  @$pb.TagNumber(18)
  $core.bool hasTitle() => $_has(17);
  @$pb.TagNumber(18)
  void clearTitle() => $_clearField(18);

  @$pb.TagNumber(19)
  $core.String get webPageUrl => $_getSZ(18);
  @$pb.TagNumber(19)
  set webPageUrl($core.String value) => $_setString(18, value);
  @$pb.TagNumber(19)
  $core.bool hasWebPageUrl() => $_has(18);
  @$pb.TagNumber(19)
  void clearWebPageUrl() => $_clearField(19);

  @$pb.TagNumber(20)
  $core.String get supportUrl => $_getSZ(19);
  @$pb.TagNumber(20)
  set supportUrl($core.String value) => $_setString(19, value);
  @$pb.TagNumber(20)
  $core.bool hasSupportUrl() => $_has(19);
  @$pb.TagNumber(20)
  void clearSupportUrl() => $_clearField(20);

  @$pb.TagNumber(21)
  $core.String get movedPermanentlyTo => $_getSZ(20);
  @$pb.TagNumber(21)
  set movedPermanentlyTo($core.String value) => $_setString(20, value);
  @$pb.TagNumber(21)
  $core.bool hasMovedPermanentlyTo() => $_has(20);
  @$pb.TagNumber(21)
  void clearMovedPermanentlyTo() => $_clearField(21);
}

class ProfileView extends $pb.GeneratedMessage {
  factory ProfileView({
    $core.Iterable<ProfileNode>? nodes,
  }) {
    final result = create();
    if (nodes != null) result.nodes.addAll(nodes);
    return result;
  }

  ProfileView._();

  factory ProfileView.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ProfileView.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProfileView',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..pPM<ProfileNode>(1, _omitFieldNames ? '' : 'nodes',
        subBuilder: ProfileNode.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProfileView clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProfileView copyWith(void Function(ProfileView) updates) =>
      super.copyWith((message) => updates(message as ProfileView))
          as ProfileView;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProfileView create() => ProfileView._();
  @$core.override
  ProfileView createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ProfileView getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProfileView>(create);
  static ProfileView? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ProfileNode> get nodes => $_getList(0);
}

class ProfileNode extends $pb.GeneratedMessage {
  factory ProfileNode({
    $core.String? tag,
    $core.String? name,
    $core.String? type,
    $core.String? server,
    $core.int? port,
    ProfileNodePhase? phase,
    $core.String? errorMessage,
    $core.String? countryCode,
    $core.String? subscriptionId,
  }) {
    final result = create();
    if (tag != null) result.tag = tag;
    if (name != null) result.name = name;
    if (type != null) result.type = type;
    if (server != null) result.server = server;
    if (port != null) result.port = port;
    if (phase != null) result.phase = phase;
    if (errorMessage != null) result.errorMessage = errorMessage;
    if (countryCode != null) result.countryCode = countryCode;
    if (subscriptionId != null) result.subscriptionId = subscriptionId;
    return result;
  }

  ProfileNode._();

  factory ProfileNode.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ProfileNode.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProfileNode',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'tag')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'type')
    ..aOS(4, _omitFieldNames ? '' : 'server')
    ..aI(5, _omitFieldNames ? '' : 'port')
    ..aE<ProfileNodePhase>(7, _omitFieldNames ? '' : 'phase',
        enumValues: ProfileNodePhase.values)
    ..aOS(8, _omitFieldNames ? '' : 'errorMessage')
    ..aOS(9, _omitFieldNames ? '' : 'countryCode')
    ..aOS(10, _omitFieldNames ? '' : 'subscriptionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProfileNode clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProfileNode copyWith(void Function(ProfileNode) updates) =>
      super.copyWith((message) => updates(message as ProfileNode))
          as ProfileNode;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProfileNode create() => ProfileNode._();
  @$core.override
  ProfileNode createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ProfileNode getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProfileNode>(create);
  static ProfileNode? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get tag => $_getSZ(0);
  @$pb.TagNumber(1)
  set tag($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTag() => $_has(0);
  @$pb.TagNumber(1)
  void clearTag() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get type => $_getSZ(2);
  @$pb.TagNumber(3)
  set type($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasType() => $_has(2);
  @$pb.TagNumber(3)
  void clearType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get server => $_getSZ(3);
  @$pb.TagNumber(4)
  set server($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasServer() => $_has(3);
  @$pb.TagNumber(4)
  void clearServer() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get port => $_getIZ(4);
  @$pb.TagNumber(5)
  set port($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPort() => $_has(4);
  @$pb.TagNumber(5)
  void clearPort() => $_clearField(5);

  @$pb.TagNumber(7)
  ProfileNodePhase get phase => $_getN(5);
  @$pb.TagNumber(7)
  set phase(ProfileNodePhase value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasPhase() => $_has(5);
  @$pb.TagNumber(7)
  void clearPhase() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get errorMessage => $_getSZ(6);
  @$pb.TagNumber(8)
  set errorMessage($core.String value) => $_setString(6, value);
  @$pb.TagNumber(8)
  $core.bool hasErrorMessage() => $_has(6);
  @$pb.TagNumber(8)
  void clearErrorMessage() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get countryCode => $_getSZ(7);
  @$pb.TagNumber(9)
  set countryCode($core.String value) => $_setString(7, value);
  @$pb.TagNumber(9)
  $core.bool hasCountryCode() => $_has(7);
  @$pb.TagNumber(9)
  void clearCountryCode() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get subscriptionId => $_getSZ(8);
  @$pb.TagNumber(10)
  set subscriptionId($core.String value) => $_setString(8, value);
  @$pb.TagNumber(10)
  $core.bool hasSubscriptionId() => $_has(8);
  @$pb.TagNumber(10)
  void clearSubscriptionId() => $_clearField(10);
}

class SubscriptionUpdateResult extends $pb.GeneratedMessage {
  factory SubscriptionUpdateResult({
    SubscriptionView? subscription,
    $core.bool? changed,
    $core.bool? notModified,
    $fixnum.Int64? durationMilliseconds,
    $core.List<$core.int>? originalConfig,
    $core.List<$core.int>? generatedConfig,
  }) {
    final result = create();
    if (subscription != null) result.subscription = subscription;
    if (changed != null) result.changed = changed;
    if (notModified != null) result.notModified = notModified;
    if (durationMilliseconds != null)
      result.durationMilliseconds = durationMilliseconds;
    if (originalConfig != null) result.originalConfig = originalConfig;
    if (generatedConfig != null) result.generatedConfig = generatedConfig;
    return result;
  }

  SubscriptionUpdateResult._();

  factory SubscriptionUpdateResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SubscriptionUpdateResult.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubscriptionUpdateResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOM<SubscriptionView>(1, _omitFieldNames ? '' : 'subscription',
        subBuilder: SubscriptionView.create)
    ..aOB(2, _omitFieldNames ? '' : 'changed')
    ..aOB(3, _omitFieldNames ? '' : 'notModified')
    ..aInt64(4, _omitFieldNames ? '' : 'durationMilliseconds')
    ..a<$core.List<$core.int>>(
        5, _omitFieldNames ? '' : 'originalConfig', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(
        6, _omitFieldNames ? '' : 'generatedConfig', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubscriptionUpdateResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubscriptionUpdateResult copyWith(
          void Function(SubscriptionUpdateResult) updates) =>
      super.copyWith((message) => updates(message as SubscriptionUpdateResult))
          as SubscriptionUpdateResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubscriptionUpdateResult create() => SubscriptionUpdateResult._();
  @$core.override
  SubscriptionUpdateResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SubscriptionUpdateResult getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubscriptionUpdateResult>(create);
  static SubscriptionUpdateResult? _defaultInstance;

  @$pb.TagNumber(1)
  SubscriptionView get subscription => $_getN(0);
  @$pb.TagNumber(1)
  set subscription(SubscriptionView value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSubscription() => $_has(0);
  @$pb.TagNumber(1)
  void clearSubscription() => $_clearField(1);
  @$pb.TagNumber(1)
  SubscriptionView ensureSubscription() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get changed => $_getBF(1);
  @$pb.TagNumber(2)
  set changed($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasChanged() => $_has(1);
  @$pb.TagNumber(2)
  void clearChanged() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get notModified => $_getBF(2);
  @$pb.TagNumber(3)
  set notModified($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNotModified() => $_has(2);
  @$pb.TagNumber(3)
  void clearNotModified() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get durationMilliseconds => $_getI64(3);
  @$pb.TagNumber(4)
  set durationMilliseconds($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDurationMilliseconds() => $_has(3);
  @$pb.TagNumber(4)
  void clearDurationMilliseconds() => $_clearField(4);

  /// One-shot diagnostics for an explicit update. These bytes are not persisted.
  @$pb.TagNumber(5)
  $core.List<$core.int> get originalConfig => $_getN(4);
  @$pb.TagNumber(5)
  set originalConfig($core.List<$core.int> value) => $_setBytes(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOriginalConfig() => $_has(4);
  @$pb.TagNumber(5)
  void clearOriginalConfig() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.List<$core.int> get generatedConfig => $_getN(5);
  @$pb.TagNumber(6)
  set generatedConfig($core.List<$core.int> value) => $_setBytes(5, value);
  @$pb.TagNumber(6)
  $core.bool hasGeneratedConfig() => $_has(5);
  @$pb.TagNumber(6)
  void clearGeneratedConfig() => $_clearField(6);
}

class RuntimeSettings extends $pb.GeneratedMessage {
  factory RuntimeSettings({
    $core.String? listenAddress,
    $core.int? mixedPort,
    ProxyMode? proxyMode,
    $core.bool? ipv6,
    RouteMode? routeMode,
  }) {
    final result = create();
    if (listenAddress != null) result.listenAddress = listenAddress;
    if (mixedPort != null) result.mixedPort = mixedPort;
    if (proxyMode != null) result.proxyMode = proxyMode;
    if (ipv6 != null) result.ipv6 = ipv6;
    if (routeMode != null) result.routeMode = routeMode;
    return result;
  }

  RuntimeSettings._();

  factory RuntimeSettings.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RuntimeSettings.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RuntimeSettings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'listenAddress')
    ..aI(2, _omitFieldNames ? '' : 'mixedPort', fieldType: $pb.PbFieldType.OU3)
    ..aE<ProxyMode>(3, _omitFieldNames ? '' : 'proxyMode',
        enumValues: ProxyMode.values)
    ..aOB(4, _omitFieldNames ? '' : 'ipv6')
    ..aE<RouteMode>(5, _omitFieldNames ? '' : 'routeMode',
        enumValues: RouteMode.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RuntimeSettings clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RuntimeSettings copyWith(void Function(RuntimeSettings) updates) =>
      super.copyWith((message) => updates(message as RuntimeSettings))
          as RuntimeSettings;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RuntimeSettings create() => RuntimeSettings._();
  @$core.override
  RuntimeSettings createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RuntimeSettings getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RuntimeSettings>(create);
  static RuntimeSettings? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get listenAddress => $_getSZ(0);
  @$pb.TagNumber(1)
  set listenAddress($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasListenAddress() => $_has(0);
  @$pb.TagNumber(1)
  void clearListenAddress() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get mixedPort => $_getIZ(1);
  @$pb.TagNumber(2)
  set mixedPort($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMixedPort() => $_has(1);
  @$pb.TagNumber(2)
  void clearMixedPort() => $_clearField(2);

  @$pb.TagNumber(3)
  ProxyMode get proxyMode => $_getN(2);
  @$pb.TagNumber(3)
  set proxyMode(ProxyMode value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasProxyMode() => $_has(2);
  @$pb.TagNumber(3)
  void clearProxyMode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get ipv6 => $_getBF(3);
  @$pb.TagNumber(4)
  set ipv6($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIpv6() => $_has(3);
  @$pb.TagNumber(4)
  void clearIpv6() => $_clearField(4);

  @$pb.TagNumber(5)
  RouteMode get routeMode => $_getN(4);
  @$pb.TagNumber(5)
  set routeMode(RouteMode value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasRouteMode() => $_has(4);
  @$pb.TagNumber(5)
  void clearRouteMode() => $_clearField(5);
}

class RuntimeConfig extends $pb.GeneratedMessage {
  factory RuntimeConfig({
    RuntimeSettings? settings,
    $core.Iterable<SelectorConfig>? selectors,
    $core.Iterable<ServiceRoute>? serviceRoutes,
    $core.Iterable<ServiceBinding>? serviceBindings,
    $core.String? revision,
    $core.String? nodePoolRevision,
  }) {
    final result = create();
    if (settings != null) result.settings = settings;
    if (selectors != null) result.selectors.addAll(selectors);
    if (serviceRoutes != null) result.serviceRoutes.addAll(serviceRoutes);
    if (serviceBindings != null) result.serviceBindings.addAll(serviceBindings);
    if (revision != null) result.revision = revision;
    if (nodePoolRevision != null) result.nodePoolRevision = nodePoolRevision;
    return result;
  }

  RuntimeConfig._();

  factory RuntimeConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RuntimeConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RuntimeConfig',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOM<RuntimeSettings>(1, _omitFieldNames ? '' : 'settings',
        subBuilder: RuntimeSettings.create)
    ..pPM<SelectorConfig>(2, _omitFieldNames ? '' : 'selectors',
        subBuilder: SelectorConfig.create)
    ..pPM<ServiceRoute>(3, _omitFieldNames ? '' : 'serviceRoutes',
        subBuilder: ServiceRoute.create)
    ..pPM<ServiceBinding>(4, _omitFieldNames ? '' : 'serviceBindings',
        subBuilder: ServiceBinding.create)
    ..aOS(5, _omitFieldNames ? '' : 'revision')
    ..aOS(6, _omitFieldNames ? '' : 'nodePoolRevision')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RuntimeConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RuntimeConfig copyWith(void Function(RuntimeConfig) updates) =>
      super.copyWith((message) => updates(message as RuntimeConfig))
          as RuntimeConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RuntimeConfig create() => RuntimeConfig._();
  @$core.override
  RuntimeConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RuntimeConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RuntimeConfig>(create);
  static RuntimeConfig? _defaultInstance;

  @$pb.TagNumber(1)
  RuntimeSettings get settings => $_getN(0);
  @$pb.TagNumber(1)
  set settings(RuntimeSettings value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSettings() => $_has(0);
  @$pb.TagNumber(1)
  void clearSettings() => $_clearField(1);
  @$pb.TagNumber(1)
  RuntimeSettings ensureSettings() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<SelectorConfig> get selectors => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<ServiceRoute> get serviceRoutes => $_getList(2);

  @$pb.TagNumber(4)
  $pb.PbList<ServiceBinding> get serviceBindings => $_getList(3);

  @$pb.TagNumber(5)
  $core.String get revision => $_getSZ(4);
  @$pb.TagNumber(5)
  set revision($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRevision() => $_has(4);
  @$pb.TagNumber(5)
  void clearRevision() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get nodePoolRevision => $_getSZ(5);
  @$pb.TagNumber(6)
  set nodePoolRevision($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasNodePoolRevision() => $_has(5);
  @$pb.TagNumber(6)
  void clearNodePoolRevision() => $_clearField(6);
}

class UpdateRuntimeConfigRequest extends $pb.GeneratedMessage {
  factory UpdateRuntimeConfigRequest({
    RuntimeSettings? settings,
    RuntimeModel? model,
    $core.String? expectedRevision,
  }) {
    final result = create();
    if (settings != null) result.settings = settings;
    if (model != null) result.model = model;
    if (expectedRevision != null) result.expectedRevision = expectedRevision;
    return result;
  }

  UpdateRuntimeConfigRequest._();

  factory UpdateRuntimeConfigRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateRuntimeConfigRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateRuntimeConfigRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOM<RuntimeSettings>(1, _omitFieldNames ? '' : 'settings',
        subBuilder: RuntimeSettings.create)
    ..aOM<RuntimeModel>(2, _omitFieldNames ? '' : 'model',
        subBuilder: RuntimeModel.create)
    ..aOS(3, _omitFieldNames ? '' : 'expectedRevision')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateRuntimeConfigRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateRuntimeConfigRequest copyWith(
          void Function(UpdateRuntimeConfigRequest) updates) =>
      super.copyWith(
              (message) => updates(message as UpdateRuntimeConfigRequest))
          as UpdateRuntimeConfigRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateRuntimeConfigRequest create() => UpdateRuntimeConfigRequest._();
  @$core.override
  UpdateRuntimeConfigRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateRuntimeConfigRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateRuntimeConfigRequest>(create);
  static UpdateRuntimeConfigRequest? _defaultInstance;

  @$pb.TagNumber(1)
  RuntimeSettings get settings => $_getN(0);
  @$pb.TagNumber(1)
  set settings(RuntimeSettings value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSettings() => $_has(0);
  @$pb.TagNumber(1)
  void clearSettings() => $_clearField(1);
  @$pb.TagNumber(1)
  RuntimeSettings ensureSettings() => $_ensure(0);

  /// When present, replaces the complete selector/route/binding model.
  /// When absent, preserves it (legacy settings-only updates).
  @$pb.TagNumber(2)
  RuntimeModel get model => $_getN(1);
  @$pb.TagNumber(2)
  set model(RuntimeModel value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasModel() => $_has(1);
  @$pb.TagNumber(2)
  void clearModel() => $_clearField(2);
  @$pb.TagNumber(2)
  RuntimeModel ensureModel() => $_ensure(1);

  /// Empty disables optimistic concurrency checking.
  @$pb.TagNumber(3)
  $core.String get expectedRevision => $_getSZ(2);
  @$pb.TagNumber(3)
  set expectedRevision($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExpectedRevision() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpectedRevision() => $_clearField(3);
}

class SelectorConfig extends $pb.GeneratedMessage {
  factory SelectorConfig({
    $core.String? tag,
    $core.Iterable<$core.String>? nodeIds,
    $core.String? selectedNodeId,
  }) {
    final result = create();
    if (tag != null) result.tag = tag;
    if (nodeIds != null) result.nodeIds.addAll(nodeIds);
    if (selectedNodeId != null) result.selectedNodeId = selectedNodeId;
    return result;
  }

  SelectorConfig._();

  factory SelectorConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SelectorConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SelectorConfig',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'tag')
    ..pPS(2, _omitFieldNames ? '' : 'nodeIds')
    ..aOS(3, _omitFieldNames ? '' : 'selectedNodeId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SelectorConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SelectorConfig copyWith(void Function(SelectorConfig) updates) =>
      super.copyWith((message) => updates(message as SelectorConfig))
          as SelectorConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SelectorConfig create() => SelectorConfig._();
  @$core.override
  SelectorConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SelectorConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SelectorConfig>(create);
  static SelectorConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get tag => $_getSZ(0);
  @$pb.TagNumber(1)
  set tag($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTag() => $_has(0);
  @$pb.TagNumber(1)
  void clearTag() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get nodeIds => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get selectedNodeId => $_getSZ(2);
  @$pb.TagNumber(3)
  set selectedNodeId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSelectedNodeId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSelectedNodeId() => $_clearField(3);
}

class ServiceRoute extends $pb.GeneratedMessage {
  factory ServiceRoute({
    $core.String? serviceId,
    $core.Iterable<$core.String>? domains,
    $core.String? selectorTag,
    $core.bool? enabled,
  }) {
    final result = create();
    if (serviceId != null) result.serviceId = serviceId;
    if (domains != null) result.domains.addAll(domains);
    if (selectorTag != null) result.selectorTag = selectorTag;
    if (enabled != null) result.enabled = enabled;
    return result;
  }

  ServiceRoute._();

  factory ServiceRoute.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServiceRoute.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServiceRoute',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serviceId')
    ..pPS(2, _omitFieldNames ? '' : 'domains')
    ..aOS(3, _omitFieldNames ? '' : 'selectorTag')
    ..aOB(4, _omitFieldNames ? '' : 'enabled')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceRoute clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceRoute copyWith(void Function(ServiceRoute) updates) =>
      super.copyWith((message) => updates(message as ServiceRoute))
          as ServiceRoute;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceRoute create() => ServiceRoute._();
  @$core.override
  ServiceRoute createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ServiceRoute getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServiceRoute>(create);
  static ServiceRoute? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServiceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServiceId() => $_clearField(1);

  /// DNS suffixes, including the apex. More-specific domains take precedence.
  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get domains => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get selectorTag => $_getSZ(2);
  @$pb.TagNumber(3)
  set selectorTag($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSelectorTag() => $_has(2);
  @$pb.TagNumber(3)
  void clearSelectorTag() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get enabled => $_getBF(3);
  @$pb.TagNumber(4)
  set enabled($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEnabled() => $_has(3);
  @$pb.TagNumber(4)
  void clearEnabled() => $_clearField(4);
}

class ServiceBinding extends $pb.GeneratedMessage {
  factory ServiceBinding({
    $core.String? serviceId,
    $core.String? selectorTag,
    $core.String? nodeId,
    $core.String? revision,
    $fixnum.Int64? expiresAtUnixMs,
    $fixnum.Int64? selectedAtUnixMs,
    $core.double? selectedScore,
    $core.String? selectionReason,
    $core.String? selectionPolicyRevision,
  }) {
    final result = create();
    if (serviceId != null) result.serviceId = serviceId;
    if (selectorTag != null) result.selectorTag = selectorTag;
    if (nodeId != null) result.nodeId = nodeId;
    if (revision != null) result.revision = revision;
    if (expiresAtUnixMs != null) result.expiresAtUnixMs = expiresAtUnixMs;
    if (selectedAtUnixMs != null) result.selectedAtUnixMs = selectedAtUnixMs;
    if (selectedScore != null) result.selectedScore = selectedScore;
    if (selectionReason != null) result.selectionReason = selectionReason;
    if (selectionPolicyRevision != null)
      result.selectionPolicyRevision = selectionPolicyRevision;
    return result;
  }

  ServiceBinding._();

  factory ServiceBinding.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServiceBinding.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServiceBinding',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serviceId')
    ..aOS(2, _omitFieldNames ? '' : 'selectorTag')
    ..aOS(3, _omitFieldNames ? '' : 'nodeId')
    ..aOS(4, _omitFieldNames ? '' : 'revision')
    ..aInt64(5, _omitFieldNames ? '' : 'expiresAtUnixMs')
    ..aInt64(6, _omitFieldNames ? '' : 'selectedAtUnixMs')
    ..aD(7, _omitFieldNames ? '' : 'selectedScore')
    ..aOS(8, _omitFieldNames ? '' : 'selectionReason')
    ..aOS(9, _omitFieldNames ? '' : 'selectionPolicyRevision')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceBinding clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceBinding copyWith(void Function(ServiceBinding) updates) =>
      super.copyWith((message) => updates(message as ServiceBinding))
          as ServiceBinding;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceBinding create() => ServiceBinding._();
  @$core.override
  ServiceBinding createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ServiceBinding getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServiceBinding>(create);
  static ServiceBinding? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServiceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServiceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get selectorTag => $_getSZ(1);
  @$pb.TagNumber(2)
  set selectorTag($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSelectorTag() => $_has(1);
  @$pb.TagNumber(2)
  void clearSelectorTag() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get nodeId => $_getSZ(2);
  @$pb.TagNumber(3)
  set nodeId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNodeId() => $_has(2);
  @$pb.TagNumber(3)
  void clearNodeId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get revision => $_getSZ(3);
  @$pb.TagNumber(4)
  set revision($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRevision() => $_has(3);
  @$pb.TagNumber(4)
  void clearRevision() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get expiresAtUnixMs => $_getI64(4);
  @$pb.TagNumber(5)
  set expiresAtUnixMs($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasExpiresAtUnixMs() => $_has(4);
  @$pb.TagNumber(5)
  void clearExpiresAtUnixMs() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get selectedAtUnixMs => $_getI64(5);
  @$pb.TagNumber(6)
  set selectedAtUnixMs($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSelectedAtUnixMs() => $_has(5);
  @$pb.TagNumber(6)
  void clearSelectedAtUnixMs() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get selectedScore => $_getN(6);
  @$pb.TagNumber(7)
  set selectedScore($core.double value) => $_setDouble(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSelectedScore() => $_has(6);
  @$pb.TagNumber(7)
  void clearSelectedScore() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get selectionReason => $_getSZ(7);
  @$pb.TagNumber(8)
  set selectionReason($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasSelectionReason() => $_has(7);
  @$pb.TagNumber(8)
  void clearSelectionReason() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get selectionPolicyRevision => $_getSZ(8);
  @$pb.TagNumber(9)
  set selectionPolicyRevision($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasSelectionPolicyRevision() => $_has(8);
  @$pb.TagNumber(9)
  void clearSelectionPolicyRevision() => $_clearField(9);
}

class RuntimeModel extends $pb.GeneratedMessage {
  factory RuntimeModel({
    $core.Iterable<SelectorConfig>? selectors,
    $core.Iterable<ServiceRoute>? serviceRoutes,
    $core.Iterable<ServiceBinding>? serviceBindings,
  }) {
    final result = create();
    if (selectors != null) result.selectors.addAll(selectors);
    if (serviceRoutes != null) result.serviceRoutes.addAll(serviceRoutes);
    if (serviceBindings != null) result.serviceBindings.addAll(serviceBindings);
    return result;
  }

  RuntimeModel._();

  factory RuntimeModel.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RuntimeModel.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RuntimeModel',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..pPM<SelectorConfig>(1, _omitFieldNames ? '' : 'selectors',
        subBuilder: SelectorConfig.create)
    ..pPM<ServiceRoute>(2, _omitFieldNames ? '' : 'serviceRoutes',
        subBuilder: ServiceRoute.create)
    ..pPM<ServiceBinding>(3, _omitFieldNames ? '' : 'serviceBindings',
        subBuilder: ServiceBinding.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RuntimeModel clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RuntimeModel copyWith(void Function(RuntimeModel) updates) =>
      super.copyWith((message) => updates(message as RuntimeModel))
          as RuntimeModel;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RuntimeModel create() => RuntimeModel._();
  @$core.override
  RuntimeModel createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RuntimeModel getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RuntimeModel>(create);
  static RuntimeModel? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<SelectorConfig> get selectors => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<ServiceRoute> get serviceRoutes => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<ServiceBinding> get serviceBindings => $_getList(2);
}

class NodePool extends $pb.GeneratedMessage {
  factory NodePool({
    $core.String? revision,
    $core.Iterable<ProfileNode>? nodes,
  }) {
    final result = create();
    if (revision != null) result.revision = revision;
    if (nodes != null) result.nodes.addAll(nodes);
    return result;
  }

  NodePool._();

  factory NodePool.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NodePool.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NodePool',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'revision')
    ..pPM<ProfileNode>(2, _omitFieldNames ? '' : 'nodes',
        subBuilder: ProfileNode.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NodePool clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NodePool copyWith(void Function(NodePool) updates) =>
      super.copyWith((message) => updates(message as NodePool)) as NodePool;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NodePool create() => NodePool._();
  @$core.override
  NodePool createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static NodePool getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NodePool>(create);
  static NodePool? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get revision => $_getSZ(0);
  @$pb.TagNumber(1)
  set revision($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRevision() => $_has(0);
  @$pb.TagNumber(1)
  void clearRevision() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<ProfileNode> get nodes => $_getList(1);
}

class ApplyServiceBindingRequest extends $pb.GeneratedMessage {
  factory ApplyServiceBindingRequest({
    ServiceBinding? binding,
    $core.String? expectedRevision,
  }) {
    final result = create();
    if (binding != null) result.binding = binding;
    if (expectedRevision != null) result.expectedRevision = expectedRevision;
    return result;
  }

  ApplyServiceBindingRequest._();

  factory ApplyServiceBindingRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ApplyServiceBindingRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApplyServiceBindingRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOM<ServiceBinding>(1, _omitFieldNames ? '' : 'binding',
        subBuilder: ServiceBinding.create)
    ..aOS(2, _omitFieldNames ? '' : 'expectedRevision')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApplyServiceBindingRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApplyServiceBindingRequest copyWith(
          void Function(ApplyServiceBindingRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ApplyServiceBindingRequest))
          as ApplyServiceBindingRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApplyServiceBindingRequest create() => ApplyServiceBindingRequest._();
  @$core.override
  ApplyServiceBindingRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ApplyServiceBindingRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApplyServiceBindingRequest>(create);
  static ApplyServiceBindingRequest? _defaultInstance;

  @$pb.TagNumber(1)
  ServiceBinding get binding => $_getN(0);
  @$pb.TagNumber(1)
  set binding(ServiceBinding value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBinding() => $_has(0);
  @$pb.TagNumber(1)
  void clearBinding() => $_clearField(1);
  @$pb.TagNumber(1)
  ServiceBinding ensureBinding() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get expectedRevision => $_getSZ(1);
  @$pb.TagNumber(2)
  set expectedRevision($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasExpectedRevision() => $_has(1);
  @$pb.TagNumber(2)
  void clearExpectedRevision() => $_clearField(2);
}

class RemoveServiceBindingRequest extends $pb.GeneratedMessage {
  factory RemoveServiceBindingRequest({
    $core.String? serviceId,
    $core.String? expectedRevision,
  }) {
    final result = create();
    if (serviceId != null) result.serviceId = serviceId;
    if (expectedRevision != null) result.expectedRevision = expectedRevision;
    return result;
  }

  RemoveServiceBindingRequest._();

  factory RemoveServiceBindingRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RemoveServiceBindingRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RemoveServiceBindingRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serviceId')
    ..aOS(2, _omitFieldNames ? '' : 'expectedRevision')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveServiceBindingRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveServiceBindingRequest copyWith(
          void Function(RemoveServiceBindingRequest) updates) =>
      super.copyWith(
              (message) => updates(message as RemoveServiceBindingRequest))
          as RemoveServiceBindingRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RemoveServiceBindingRequest create() =>
      RemoveServiceBindingRequest._();
  @$core.override
  RemoveServiceBindingRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RemoveServiceBindingRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RemoveServiceBindingRequest>(create);
  static RemoveServiceBindingRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServiceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServiceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get expectedRevision => $_getSZ(1);
  @$pb.TagNumber(2)
  set expectedRevision($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasExpectedRevision() => $_has(1);
  @$pb.TagNumber(2)
  void clearExpectedRevision() => $_clearField(2);
}

class ServiceBindingList extends $pb.GeneratedMessage {
  factory ServiceBindingList({
    $core.Iterable<ServiceBinding>? bindings,
  }) {
    final result = create();
    if (bindings != null) result.bindings.addAll(bindings);
    return result;
  }

  ServiceBindingList._();

  factory ServiceBindingList.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServiceBindingList.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServiceBindingList',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..pPM<ServiceBinding>(1, _omitFieldNames ? '' : 'bindings',
        subBuilder: ServiceBinding.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceBindingList clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceBindingList copyWith(void Function(ServiceBindingList) updates) =>
      super.copyWith((message) => updates(message as ServiceBindingList))
          as ServiceBindingList;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceBindingList create() => ServiceBindingList._();
  @$core.override
  ServiceBindingList createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ServiceBindingList getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServiceBindingList>(create);
  static ServiceBindingList? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ServiceBinding> get bindings => $_getList(0);
}

class SelectorState extends $pb.GeneratedMessage {
  factory SelectorState({
    SelectorConfig? desired,
    $core.String? actualNodeId,
    $core.bool? effective,
  }) {
    final result = create();
    if (desired != null) result.desired = desired;
    if (actualNodeId != null) result.actualNodeId = actualNodeId;
    if (effective != null) result.effective = effective;
    return result;
  }

  SelectorState._();

  factory SelectorState.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SelectorState.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SelectorState',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOM<SelectorConfig>(1, _omitFieldNames ? '' : 'desired',
        subBuilder: SelectorConfig.create)
    ..aOS(2, _omitFieldNames ? '' : 'actualNodeId')
    ..aOB(3, _omitFieldNames ? '' : 'effective')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SelectorState clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SelectorState copyWith(void Function(SelectorState) updates) =>
      super.copyWith((message) => updates(message as SelectorState))
          as SelectorState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SelectorState create() => SelectorState._();
  @$core.override
  SelectorState createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SelectorState getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SelectorState>(create);
  static SelectorState? _defaultInstance;

  @$pb.TagNumber(1)
  SelectorConfig get desired => $_getN(0);
  @$pb.TagNumber(1)
  set desired(SelectorConfig value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDesired() => $_has(0);
  @$pb.TagNumber(1)
  void clearDesired() => $_clearField(1);
  @$pb.TagNumber(1)
  SelectorConfig ensureDesired() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get actualNodeId => $_getSZ(1);
  @$pb.TagNumber(2)
  set actualNodeId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasActualNodeId() => $_has(1);
  @$pb.TagNumber(2)
  void clearActualNodeId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get effective => $_getBF(2);
  @$pb.TagNumber(3)
  set effective($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEffective() => $_has(2);
  @$pb.TagNumber(3)
  void clearEffective() => $_clearField(3);
}

class ServiceRouteState extends $pb.GeneratedMessage {
  factory ServiceRouteState({
    ServiceRoute? desired,
    $core.bool? effective,
  }) {
    final result = create();
    if (desired != null) result.desired = desired;
    if (effective != null) result.effective = effective;
    return result;
  }

  ServiceRouteState._();

  factory ServiceRouteState.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServiceRouteState.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServiceRouteState',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOM<ServiceRoute>(1, _omitFieldNames ? '' : 'desired',
        subBuilder: ServiceRoute.create)
    ..aOB(2, _omitFieldNames ? '' : 'effective')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceRouteState clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceRouteState copyWith(void Function(ServiceRouteState) updates) =>
      super.copyWith((message) => updates(message as ServiceRouteState))
          as ServiceRouteState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceRouteState create() => ServiceRouteState._();
  @$core.override
  ServiceRouteState createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ServiceRouteState getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServiceRouteState>(create);
  static ServiceRouteState? _defaultInstance;

  @$pb.TagNumber(1)
  ServiceRoute get desired => $_getN(0);
  @$pb.TagNumber(1)
  set desired(ServiceRoute value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDesired() => $_has(0);
  @$pb.TagNumber(1)
  void clearDesired() => $_clearField(1);
  @$pb.TagNumber(1)
  ServiceRoute ensureDesired() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get effective => $_getBF(1);
  @$pb.TagNumber(2)
  set effective($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEffective() => $_has(1);
  @$pb.TagNumber(2)
  void clearEffective() => $_clearField(2);
}

class ServiceBindingState extends $pb.GeneratedMessage {
  factory ServiceBindingState({
    ServiceBinding? desired,
    $core.bool? effective,
    $core.bool? nodeAvailable,
    $core.bool? needsEvaluation,
    $core.String? evaluationReason,
  }) {
    final result = create();
    if (desired != null) result.desired = desired;
    if (effective != null) result.effective = effective;
    if (nodeAvailable != null) result.nodeAvailable = nodeAvailable;
    if (needsEvaluation != null) result.needsEvaluation = needsEvaluation;
    if (evaluationReason != null) result.evaluationReason = evaluationReason;
    return result;
  }

  ServiceBindingState._();

  factory ServiceBindingState.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServiceBindingState.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServiceBindingState',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOM<ServiceBinding>(1, _omitFieldNames ? '' : 'desired',
        subBuilder: ServiceBinding.create)
    ..aOB(2, _omitFieldNames ? '' : 'effective')
    ..aOB(3, _omitFieldNames ? '' : 'nodeAvailable')
    ..aOB(4, _omitFieldNames ? '' : 'needsEvaluation')
    ..aOS(5, _omitFieldNames ? '' : 'evaluationReason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceBindingState clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceBindingState copyWith(void Function(ServiceBindingState) updates) =>
      super.copyWith((message) => updates(message as ServiceBindingState))
          as ServiceBindingState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceBindingState create() => ServiceBindingState._();
  @$core.override
  ServiceBindingState createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ServiceBindingState getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServiceBindingState>(create);
  static ServiceBindingState? _defaultInstance;

  @$pb.TagNumber(1)
  ServiceBinding get desired => $_getN(0);
  @$pb.TagNumber(1)
  set desired(ServiceBinding value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDesired() => $_has(0);
  @$pb.TagNumber(1)
  void clearDesired() => $_clearField(1);
  @$pb.TagNumber(1)
  ServiceBinding ensureDesired() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get effective => $_getBF(1);
  @$pb.TagNumber(2)
  set effective($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEffective() => $_has(1);
  @$pb.TagNumber(2)
  void clearEffective() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get nodeAvailable => $_getBF(2);
  @$pb.TagNumber(3)
  set nodeAvailable($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNodeAvailable() => $_has(2);
  @$pb.TagNumber(3)
  void clearNodeAvailable() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get needsEvaluation => $_getBF(3);
  @$pb.TagNumber(4)
  set needsEvaluation($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNeedsEvaluation() => $_has(3);
  @$pb.TagNumber(4)
  void clearNeedsEvaluation() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get evaluationReason => $_getSZ(4);
  @$pb.TagNumber(5)
  set evaluationReason($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasEvaluationReason() => $_has(4);
  @$pb.TagNumber(5)
  void clearEvaluationReason() => $_clearField(5);
}

/// Probe definitions contain no credentials. Request headers are transient.
class ServiceProbe extends $pb.GeneratedMessage {
  factory ServiceProbe({
    $core.String? serviceId,
    $core.String? url,
    $core.Iterable<$core.int>? expectedStatus,
    $core.String? bodyContains,
    $core.Iterable<$core.String>? allowedCountries,
    $core.String? egressUrl,
    $core.String? serviceCountryHeader,
    $core.int? timeoutMilliseconds,
    $core.int? validitySeconds,
    $core.String? revision,
    $core.String? udpEchoAddress,
    $core.int? packetCount,
    $core.int? packetTimeoutMilliseconds,
    $core.double? maximumPacketLoss,
  }) {
    final result = create();
    if (serviceId != null) result.serviceId = serviceId;
    if (url != null) result.url = url;
    if (expectedStatus != null) result.expectedStatus.addAll(expectedStatus);
    if (bodyContains != null) result.bodyContains = bodyContains;
    if (allowedCountries != null)
      result.allowedCountries.addAll(allowedCountries);
    if (egressUrl != null) result.egressUrl = egressUrl;
    if (serviceCountryHeader != null)
      result.serviceCountryHeader = serviceCountryHeader;
    if (timeoutMilliseconds != null)
      result.timeoutMilliseconds = timeoutMilliseconds;
    if (validitySeconds != null) result.validitySeconds = validitySeconds;
    if (revision != null) result.revision = revision;
    if (udpEchoAddress != null) result.udpEchoAddress = udpEchoAddress;
    if (packetCount != null) result.packetCount = packetCount;
    if (packetTimeoutMilliseconds != null)
      result.packetTimeoutMilliseconds = packetTimeoutMilliseconds;
    if (maximumPacketLoss != null) result.maximumPacketLoss = maximumPacketLoss;
    return result;
  }

  ServiceProbe._();

  factory ServiceProbe.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServiceProbe.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServiceProbe',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serviceId')
    ..aOS(2, _omitFieldNames ? '' : 'url')
    ..p<$core.int>(
        3, _omitFieldNames ? '' : 'expectedStatus', $pb.PbFieldType.KU3)
    ..aOS(4, _omitFieldNames ? '' : 'bodyContains')
    ..pPS(5, _omitFieldNames ? '' : 'allowedCountries')
    ..aOS(6, _omitFieldNames ? '' : 'egressUrl')
    ..aOS(7, _omitFieldNames ? '' : 'serviceCountryHeader')
    ..aI(8, _omitFieldNames ? '' : 'timeoutMilliseconds',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(9, _omitFieldNames ? '' : 'validitySeconds',
        fieldType: $pb.PbFieldType.OU3)
    ..aOS(10, _omitFieldNames ? '' : 'revision')
    ..aOS(11, _omitFieldNames ? '' : 'udpEchoAddress')
    ..aI(12, _omitFieldNames ? '' : 'packetCount',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(13, _omitFieldNames ? '' : 'packetTimeoutMilliseconds',
        fieldType: $pb.PbFieldType.OU3)
    ..aD(14, _omitFieldNames ? '' : 'maximumPacketLoss')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceProbe clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceProbe copyWith(void Function(ServiceProbe) updates) =>
      super.copyWith((message) => updates(message as ServiceProbe))
          as ServiceProbe;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceProbe create() => ServiceProbe._();
  @$core.override
  ServiceProbe createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ServiceProbe getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServiceProbe>(create);
  static ServiceProbe? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServiceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServiceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get url => $_getSZ(1);
  @$pb.TagNumber(2)
  set url($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearUrl() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.int> get expectedStatus => $_getList(2);

  @$pb.TagNumber(4)
  $core.String get bodyContains => $_getSZ(3);
  @$pb.TagNumber(4)
  set bodyContains($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBodyContains() => $_has(3);
  @$pb.TagNumber(4)
  void clearBodyContains() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get allowedCountries => $_getList(4);

  /// Optional JSON endpoint returning {"ip":"...","country":"US"}.
  @$pb.TagNumber(6)
  $core.String get egressUrl => $_getSZ(5);
  @$pb.TagNumber(6)
  set egressUrl($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasEgressUrl() => $_has(5);
  @$pb.TagNumber(6)
  void clearEgressUrl() => $_clearField(6);

  /// Optional service response header containing an ISO country code.
  @$pb.TagNumber(7)
  $core.String get serviceCountryHeader => $_getSZ(6);
  @$pb.TagNumber(7)
  set serviceCountryHeader($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasServiceCountryHeader() => $_has(6);
  @$pb.TagNumber(7)
  void clearServiceCountryHeader() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get timeoutMilliseconds => $_getIZ(7);
  @$pb.TagNumber(8)
  set timeoutMilliseconds($core.int value) => $_setUnsignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasTimeoutMilliseconds() => $_has(7);
  @$pb.TagNumber(8)
  void clearTimeoutMilliseconds() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get validitySeconds => $_getIZ(8);
  @$pb.TagNumber(9)
  set validitySeconds($core.int value) => $_setUnsignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasValiditySeconds() => $_has(8);
  @$pb.TagNumber(9)
  void clearValiditySeconds() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get revision => $_getSZ(9);
  @$pb.TagNumber(10)
  set revision($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasRevision() => $_has(9);
  @$pb.TagNumber(10)
  void clearRevision() => $_clearField(10);

  /// Optional RFC 862 UDP echo endpoint controlled by the host/operator.
  @$pb.TagNumber(11)
  $core.String get udpEchoAddress => $_getSZ(10);
  @$pb.TagNumber(11)
  set udpEchoAddress($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasUdpEchoAddress() => $_has(10);
  @$pb.TagNumber(11)
  void clearUdpEchoAddress() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.int get packetCount => $_getIZ(11);
  @$pb.TagNumber(12)
  set packetCount($core.int value) => $_setUnsignedInt32(11, value);
  @$pb.TagNumber(12)
  $core.bool hasPacketCount() => $_has(11);
  @$pb.TagNumber(12)
  void clearPacketCount() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.int get packetTimeoutMilliseconds => $_getIZ(12);
  @$pb.TagNumber(13)
  set packetTimeoutMilliseconds($core.int value) =>
      $_setUnsignedInt32(12, value);
  @$pb.TagNumber(13)
  $core.bool hasPacketTimeoutMilliseconds() => $_has(12);
  @$pb.TagNumber(13)
  void clearPacketTimeoutMilliseconds() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.double get maximumPacketLoss => $_getN(13);
  @$pb.TagNumber(14)
  set maximumPacketLoss($core.double value) => $_setDouble(13, value);
  @$pb.TagNumber(14)
  $core.bool hasMaximumPacketLoss() => $_has(13);
  @$pb.TagNumber(14)
  void clearMaximumPacketLoss() => $_clearField(14);
}

class ServiceProbeList extends $pb.GeneratedMessage {
  factory ServiceProbeList({
    $core.Iterable<ServiceProbe>? probes,
  }) {
    final result = create();
    if (probes != null) result.probes.addAll(probes);
    return result;
  }

  ServiceProbeList._();

  factory ServiceProbeList.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServiceProbeList.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServiceProbeList',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..pPM<ServiceProbe>(1, _omitFieldNames ? '' : 'probes',
        subBuilder: ServiceProbe.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceProbeList clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceProbeList copyWith(void Function(ServiceProbeList) updates) =>
      super.copyWith((message) => updates(message as ServiceProbeList))
          as ServiceProbeList;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceProbeList create() => ServiceProbeList._();
  @$core.override
  ServiceProbeList createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ServiceProbeList getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServiceProbeList>(create);
  static ServiceProbeList? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ServiceProbe> get probes => $_getList(0);
}

class RemoveServiceProbeRequest extends $pb.GeneratedMessage {
  factory RemoveServiceProbeRequest({
    $core.String? serviceId,
    $core.String? expectedRevision,
  }) {
    final result = create();
    if (serviceId != null) result.serviceId = serviceId;
    if (expectedRevision != null) result.expectedRevision = expectedRevision;
    return result;
  }

  RemoveServiceProbeRequest._();

  factory RemoveServiceProbeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RemoveServiceProbeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RemoveServiceProbeRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serviceId')
    ..aOS(2, _omitFieldNames ? '' : 'expectedRevision')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveServiceProbeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveServiceProbeRequest copyWith(
          void Function(RemoveServiceProbeRequest) updates) =>
      super.copyWith((message) => updates(message as RemoveServiceProbeRequest))
          as RemoveServiceProbeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RemoveServiceProbeRequest create() => RemoveServiceProbeRequest._();
  @$core.override
  RemoveServiceProbeRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RemoveServiceProbeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RemoveServiceProbeRequest>(create);
  static RemoveServiceProbeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServiceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServiceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get expectedRevision => $_getSZ(1);
  @$pb.TagNumber(2)
  set expectedRevision($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasExpectedRevision() => $_has(1);
  @$pb.TagNumber(2)
  void clearExpectedRevision() => $_clearField(2);
}

class ProbeServiceRequest extends $pb.GeneratedMessage {
  factory ProbeServiceRequest({
    $core.String? serviceId,
    $core.Iterable<$core.String>? nodeIds,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? headers,
    $core.int? attempts,
    $core.int? maxConcurrency,
  }) {
    final result = create();
    if (serviceId != null) result.serviceId = serviceId;
    if (nodeIds != null) result.nodeIds.addAll(nodeIds);
    if (headers != null) result.headers.addEntries(headers);
    if (attempts != null) result.attempts = attempts;
    if (maxConcurrency != null) result.maxConcurrency = maxConcurrency;
    return result;
  }

  ProbeServiceRequest._();

  factory ProbeServiceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ProbeServiceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProbeServiceRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serviceId')
    ..pPS(2, _omitFieldNames ? '' : 'nodeIds')
    ..m<$core.String, $core.String>(3, _omitFieldNames ? '' : 'headers',
        entryClassName: 'ProbeServiceRequest.HeadersEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('targetlib'))
    ..aI(4, _omitFieldNames ? '' : 'attempts', fieldType: $pb.PbFieldType.OU3)
    ..aI(5, _omitFieldNames ? '' : 'maxConcurrency',
        fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProbeServiceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProbeServiceRequest copyWith(void Function(ProbeServiceRequest) updates) =>
      super.copyWith((message) => updates(message as ProbeServiceRequest))
          as ProbeServiceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProbeServiceRequest create() => ProbeServiceRequest._();
  @$core.override
  ProbeServiceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ProbeServiceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProbeServiceRequest>(create);
  static ProbeServiceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServiceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServiceId() => $_clearField(1);

  /// Empty probes all ready nodes, up to 256 per request.
  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get nodeIds => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbMap<$core.String, $core.String> get headers => $_getMap(2);

  @$pb.TagNumber(4)
  $core.int get attempts => $_getIZ(3);
  @$pb.TagNumber(4)
  set attempts($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAttempts() => $_has(3);
  @$pb.TagNumber(4)
  void clearAttempts() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get maxConcurrency => $_getIZ(4);
  @$pb.TagNumber(5)
  set maxConcurrency($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMaxConcurrency() => $_has(4);
  @$pb.TagNumber(5)
  void clearMaxConcurrency() => $_clearField(5);
}

class ProbeResult extends $pb.GeneratedMessage {
  factory ProbeResult({
    $core.String? id,
    $core.String? serviceId,
    $core.String? nodeId,
    $core.String? nodePoolRevision,
    $core.String? probeRevision,
    ProbeStage? stage,
    $core.String? errorMessage,
    $fixnum.Int64? testedAtUnixMs,
    $fixnum.Int64? expiresAtUnixMs,
    $core.int? latencyMilliseconds,
    $core.int? httpStatus,
    $core.String? declaredCountry,
    $core.String? observedCountry,
    $core.String? serviceCountry,
    $core.String? egressIp,
    $core.int? attempts,
    $core.int? successes,
    $core.double? failureRatio,
    $core.int? jitterMilliseconds,
    $core.bool? packetLossAvailable,
    $core.double? packetLossRatio,
    $core.int? packetsSent,
    $core.int? packetsReceived,
    $core.String? packetError,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (serviceId != null) result.serviceId = serviceId;
    if (nodeId != null) result.nodeId = nodeId;
    if (nodePoolRevision != null) result.nodePoolRevision = nodePoolRevision;
    if (probeRevision != null) result.probeRevision = probeRevision;
    if (stage != null) result.stage = stage;
    if (errorMessage != null) result.errorMessage = errorMessage;
    if (testedAtUnixMs != null) result.testedAtUnixMs = testedAtUnixMs;
    if (expiresAtUnixMs != null) result.expiresAtUnixMs = expiresAtUnixMs;
    if (latencyMilliseconds != null)
      result.latencyMilliseconds = latencyMilliseconds;
    if (httpStatus != null) result.httpStatus = httpStatus;
    if (declaredCountry != null) result.declaredCountry = declaredCountry;
    if (observedCountry != null) result.observedCountry = observedCountry;
    if (serviceCountry != null) result.serviceCountry = serviceCountry;
    if (egressIp != null) result.egressIp = egressIp;
    if (attempts != null) result.attempts = attempts;
    if (successes != null) result.successes = successes;
    if (failureRatio != null) result.failureRatio = failureRatio;
    if (jitterMilliseconds != null)
      result.jitterMilliseconds = jitterMilliseconds;
    if (packetLossAvailable != null)
      result.packetLossAvailable = packetLossAvailable;
    if (packetLossRatio != null) result.packetLossRatio = packetLossRatio;
    if (packetsSent != null) result.packetsSent = packetsSent;
    if (packetsReceived != null) result.packetsReceived = packetsReceived;
    if (packetError != null) result.packetError = packetError;
    return result;
  }

  ProbeResult._();

  factory ProbeResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ProbeResult.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProbeResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'serviceId')
    ..aOS(3, _omitFieldNames ? '' : 'nodeId')
    ..aOS(4, _omitFieldNames ? '' : 'nodePoolRevision')
    ..aOS(5, _omitFieldNames ? '' : 'probeRevision')
    ..aE<ProbeStage>(6, _omitFieldNames ? '' : 'stage',
        enumValues: ProbeStage.values)
    ..aOS(7, _omitFieldNames ? '' : 'errorMessage')
    ..aInt64(8, _omitFieldNames ? '' : 'testedAtUnixMs')
    ..aInt64(9, _omitFieldNames ? '' : 'expiresAtUnixMs')
    ..aI(10, _omitFieldNames ? '' : 'latencyMilliseconds',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(11, _omitFieldNames ? '' : 'httpStatus',
        fieldType: $pb.PbFieldType.OU3)
    ..aOS(12, _omitFieldNames ? '' : 'declaredCountry')
    ..aOS(13, _omitFieldNames ? '' : 'observedCountry')
    ..aOS(14, _omitFieldNames ? '' : 'serviceCountry')
    ..aOS(15, _omitFieldNames ? '' : 'egressIp')
    ..aI(16, _omitFieldNames ? '' : 'attempts', fieldType: $pb.PbFieldType.OU3)
    ..aI(17, _omitFieldNames ? '' : 'successes', fieldType: $pb.PbFieldType.OU3)
    ..aD(18, _omitFieldNames ? '' : 'failureRatio')
    ..aI(19, _omitFieldNames ? '' : 'jitterMilliseconds',
        fieldType: $pb.PbFieldType.OU3)
    ..aOB(20, _omitFieldNames ? '' : 'packetLossAvailable')
    ..aD(21, _omitFieldNames ? '' : 'packetLossRatio')
    ..aI(22, _omitFieldNames ? '' : 'packetsSent',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(23, _omitFieldNames ? '' : 'packetsReceived',
        fieldType: $pb.PbFieldType.OU3)
    ..aOS(24, _omitFieldNames ? '' : 'packetError')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProbeResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProbeResult copyWith(void Function(ProbeResult) updates) =>
      super.copyWith((message) => updates(message as ProbeResult))
          as ProbeResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProbeResult create() => ProbeResult._();
  @$core.override
  ProbeResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ProbeResult getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProbeResult>(create);
  static ProbeResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get serviceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set serviceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasServiceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearServiceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get nodeId => $_getSZ(2);
  @$pb.TagNumber(3)
  set nodeId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNodeId() => $_has(2);
  @$pb.TagNumber(3)
  void clearNodeId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get nodePoolRevision => $_getSZ(3);
  @$pb.TagNumber(4)
  set nodePoolRevision($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNodePoolRevision() => $_has(3);
  @$pb.TagNumber(4)
  void clearNodePoolRevision() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get probeRevision => $_getSZ(4);
  @$pb.TagNumber(5)
  set probeRevision($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasProbeRevision() => $_has(4);
  @$pb.TagNumber(5)
  void clearProbeRevision() => $_clearField(5);

  @$pb.TagNumber(6)
  ProbeStage get stage => $_getN(5);
  @$pb.TagNumber(6)
  set stage(ProbeStage value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasStage() => $_has(5);
  @$pb.TagNumber(6)
  void clearStage() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get errorMessage => $_getSZ(6);
  @$pb.TagNumber(7)
  set errorMessage($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasErrorMessage() => $_has(6);
  @$pb.TagNumber(7)
  void clearErrorMessage() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get testedAtUnixMs => $_getI64(7);
  @$pb.TagNumber(8)
  set testedAtUnixMs($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasTestedAtUnixMs() => $_has(7);
  @$pb.TagNumber(8)
  void clearTestedAtUnixMs() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get expiresAtUnixMs => $_getI64(8);
  @$pb.TagNumber(9)
  set expiresAtUnixMs($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasExpiresAtUnixMs() => $_has(8);
  @$pb.TagNumber(9)
  void clearExpiresAtUnixMs() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get latencyMilliseconds => $_getIZ(9);
  @$pb.TagNumber(10)
  set latencyMilliseconds($core.int value) => $_setUnsignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasLatencyMilliseconds() => $_has(9);
  @$pb.TagNumber(10)
  void clearLatencyMilliseconds() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get httpStatus => $_getIZ(10);
  @$pb.TagNumber(11)
  set httpStatus($core.int value) => $_setUnsignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasHttpStatus() => $_has(10);
  @$pb.TagNumber(11)
  void clearHttpStatus() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get declaredCountry => $_getSZ(11);
  @$pb.TagNumber(12)
  set declaredCountry($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasDeclaredCountry() => $_has(11);
  @$pb.TagNumber(12)
  void clearDeclaredCountry() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get observedCountry => $_getSZ(12);
  @$pb.TagNumber(13)
  set observedCountry($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasObservedCountry() => $_has(12);
  @$pb.TagNumber(13)
  void clearObservedCountry() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get serviceCountry => $_getSZ(13);
  @$pb.TagNumber(14)
  set serviceCountry($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasServiceCountry() => $_has(13);
  @$pb.TagNumber(14)
  void clearServiceCountry() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get egressIp => $_getSZ(14);
  @$pb.TagNumber(15)
  set egressIp($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasEgressIp() => $_has(14);
  @$pb.TagNumber(15)
  void clearEgressIp() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.int get attempts => $_getIZ(15);
  @$pb.TagNumber(16)
  set attempts($core.int value) => $_setUnsignedInt32(15, value);
  @$pb.TagNumber(16)
  $core.bool hasAttempts() => $_has(15);
  @$pb.TagNumber(16)
  void clearAttempts() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.int get successes => $_getIZ(16);
  @$pb.TagNumber(17)
  set successes($core.int value) => $_setUnsignedInt32(16, value);
  @$pb.TagNumber(17)
  $core.bool hasSuccesses() => $_has(16);
  @$pb.TagNumber(17)
  void clearSuccesses() => $_clearField(17);

  /// Failed application probes / attempts, not ICMP or UDP packet loss.
  @$pb.TagNumber(18)
  $core.double get failureRatio => $_getN(17);
  @$pb.TagNumber(18)
  set failureRatio($core.double value) => $_setDouble(17, value);
  @$pb.TagNumber(18)
  $core.bool hasFailureRatio() => $_has(17);
  @$pb.TagNumber(18)
  void clearFailureRatio() => $_clearField(18);

  @$pb.TagNumber(19)
  $core.int get jitterMilliseconds => $_getIZ(18);
  @$pb.TagNumber(19)
  set jitterMilliseconds($core.int value) => $_setUnsignedInt32(18, value);
  @$pb.TagNumber(19)
  $core.bool hasJitterMilliseconds() => $_has(18);
  @$pb.TagNumber(19)
  void clearJitterMilliseconds() => $_clearField(19);

  @$pb.TagNumber(20)
  $core.bool get packetLossAvailable => $_getBF(19);
  @$pb.TagNumber(20)
  set packetLossAvailable($core.bool value) => $_setBool(19, value);
  @$pb.TagNumber(20)
  $core.bool hasPacketLossAvailable() => $_has(19);
  @$pb.TagNumber(20)
  void clearPacketLossAvailable() => $_clearField(20);

  @$pb.TagNumber(21)
  $core.double get packetLossRatio => $_getN(20);
  @$pb.TagNumber(21)
  set packetLossRatio($core.double value) => $_setDouble(20, value);
  @$pb.TagNumber(21)
  $core.bool hasPacketLossRatio() => $_has(20);
  @$pb.TagNumber(21)
  void clearPacketLossRatio() => $_clearField(21);

  @$pb.TagNumber(22)
  $core.int get packetsSent => $_getIZ(21);
  @$pb.TagNumber(22)
  set packetsSent($core.int value) => $_setUnsignedInt32(21, value);
  @$pb.TagNumber(22)
  $core.bool hasPacketsSent() => $_has(21);
  @$pb.TagNumber(22)
  void clearPacketsSent() => $_clearField(22);

  @$pb.TagNumber(23)
  $core.int get packetsReceived => $_getIZ(22);
  @$pb.TagNumber(23)
  set packetsReceived($core.int value) => $_setUnsignedInt32(22, value);
  @$pb.TagNumber(23)
  $core.bool hasPacketsReceived() => $_has(22);
  @$pb.TagNumber(23)
  void clearPacketsReceived() => $_clearField(23);

  @$pb.TagNumber(24)
  $core.String get packetError => $_getSZ(23);
  @$pb.TagNumber(24)
  set packetError($core.String value) => $_setString(23, value);
  @$pb.TagNumber(24)
  $core.bool hasPacketError() => $_has(23);
  @$pb.TagNumber(24)
  void clearPacketError() => $_clearField(24);
}

class QualityHistoryRequest extends $pb.GeneratedMessage {
  factory QualityHistoryRequest({
    $core.String? serviceId,
    $core.String? nodeId,
    $core.int? limit,
  }) {
    final result = create();
    if (serviceId != null) result.serviceId = serviceId;
    if (nodeId != null) result.nodeId = nodeId;
    if (limit != null) result.limit = limit;
    return result;
  }

  QualityHistoryRequest._();

  factory QualityHistoryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory QualityHistoryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'QualityHistoryRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serviceId')
    ..aOS(2, _omitFieldNames ? '' : 'nodeId')
    ..aI(3, _omitFieldNames ? '' : 'limit', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QualityHistoryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QualityHistoryRequest copyWith(
          void Function(QualityHistoryRequest) updates) =>
      super.copyWith((message) => updates(message as QualityHistoryRequest))
          as QualityHistoryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static QualityHistoryRequest create() => QualityHistoryRequest._();
  @$core.override
  QualityHistoryRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static QualityHistoryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QualityHistoryRequest>(create);
  static QualityHistoryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServiceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServiceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get nodeId => $_getSZ(1);
  @$pb.TagNumber(2)
  set nodeId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNodeId() => $_has(1);
  @$pb.TagNumber(2)
  void clearNodeId() => $_clearField(2);

  /// Default 100, maximum 1024. Newest first.
  @$pb.TagNumber(3)
  $core.int get limit => $_getIZ(2);
  @$pb.TagNumber(3)
  set limit($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLimit() => $_has(2);
  @$pb.TagNumber(3)
  void clearLimit() => $_clearField(3);
}

class QualityHistory extends $pb.GeneratedMessage {
  factory QualityHistory({
    $core.Iterable<ProbeResult>? results,
  }) {
    final result = create();
    if (results != null) result.results.addAll(results);
    return result;
  }

  QualityHistory._();

  factory QualityHistory.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory QualityHistory.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'QualityHistory',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..pPM<ProbeResult>(1, _omitFieldNames ? '' : 'results',
        subBuilder: ProbeResult.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QualityHistory clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QualityHistory copyWith(void Function(QualityHistory) updates) =>
      super.copyWith((message) => updates(message as QualityHistory))
          as QualityHistory;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static QualityHistory create() => QualityHistory._();
  @$core.override
  QualityHistory createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static QualityHistory getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QualityHistory>(create);
  static QualityHistory? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ProbeResult> get results => $_getList(0);
}

class EvaluateServiceRequest extends $pb.GeneratedMessage {
  factory EvaluateServiceRequest({
    $core.String? serviceId,
  }) {
    final result = create();
    if (serviceId != null) result.serviceId = serviceId;
    return result;
  }

  EvaluateServiceRequest._();

  factory EvaluateServiceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EvaluateServiceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EvaluateServiceRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serviceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EvaluateServiceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EvaluateServiceRequest copyWith(
          void Function(EvaluateServiceRequest) updates) =>
      super.copyWith((message) => updates(message as EvaluateServiceRequest))
          as EvaluateServiceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EvaluateServiceRequest create() => EvaluateServiceRequest._();
  @$core.override
  EvaluateServiceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EvaluateServiceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EvaluateServiceRequest>(create);
  static EvaluateServiceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServiceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServiceId() => $_clearField(1);
}

class ServiceSelectionPolicyRequest extends $pb.GeneratedMessage {
  factory ServiceSelectionPolicyRequest({
    $core.String? serviceId,
  }) {
    final result = create();
    if (serviceId != null) result.serviceId = serviceId;
    return result;
  }

  ServiceSelectionPolicyRequest._();

  factory ServiceSelectionPolicyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServiceSelectionPolicyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServiceSelectionPolicyRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serviceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceSelectionPolicyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceSelectionPolicyRequest copyWith(
          void Function(ServiceSelectionPolicyRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ServiceSelectionPolicyRequest))
          as ServiceSelectionPolicyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceSelectionPolicyRequest create() =>
      ServiceSelectionPolicyRequest._();
  @$core.override
  ServiceSelectionPolicyRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ServiceSelectionPolicyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServiceSelectionPolicyRequest>(create);
  static ServiceSelectionPolicyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServiceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServiceId() => $_clearField(1);
}

class ServiceSelectionPolicy extends $pb.GeneratedMessage {
  factory ServiceSelectionPolicy({
    $core.String? serviceId,
    $core.Iterable<$core.String>? preferredCountries,
    $core.Iterable<$core.String>? subscriptionIds,
    $core.Iterable<$core.String>? excludedNodeIds,
    $core.Iterable<$core.String>? favoriteNodeIds,
    $core.bool? allowDirect,
    $core.int? maxCandidates,
    $core.String? revision,
    $core.String? expectedRevision,
  }) {
    final result = create();
    if (serviceId != null) result.serviceId = serviceId;
    if (preferredCountries != null)
      result.preferredCountries.addAll(preferredCountries);
    if (subscriptionIds != null) result.subscriptionIds.addAll(subscriptionIds);
    if (excludedNodeIds != null) result.excludedNodeIds.addAll(excludedNodeIds);
    if (favoriteNodeIds != null) result.favoriteNodeIds.addAll(favoriteNodeIds);
    if (allowDirect != null) result.allowDirect = allowDirect;
    if (maxCandidates != null) result.maxCandidates = maxCandidates;
    if (revision != null) result.revision = revision;
    if (expectedRevision != null) result.expectedRevision = expectedRevision;
    return result;
  }

  ServiceSelectionPolicy._();

  factory ServiceSelectionPolicy.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServiceSelectionPolicy.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServiceSelectionPolicy',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serviceId')
    ..pPS(2, _omitFieldNames ? '' : 'preferredCountries')
    ..pPS(3, _omitFieldNames ? '' : 'subscriptionIds')
    ..pPS(4, _omitFieldNames ? '' : 'excludedNodeIds')
    ..pPS(5, _omitFieldNames ? '' : 'favoriteNodeIds')
    ..aOB(6, _omitFieldNames ? '' : 'allowDirect')
    ..aI(7, _omitFieldNames ? '' : 'maxCandidates',
        fieldType: $pb.PbFieldType.OU3)
    ..aOS(8, _omitFieldNames ? '' : 'revision')
    ..aOS(9, _omitFieldNames ? '' : 'expectedRevision')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceSelectionPolicy clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceSelectionPolicy copyWith(
          void Function(ServiceSelectionPolicy) updates) =>
      super.copyWith((message) => updates(message as ServiceSelectionPolicy))
          as ServiceSelectionPolicy;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceSelectionPolicy create() => ServiceSelectionPolicy._();
  @$core.override
  ServiceSelectionPolicy createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ServiceSelectionPolicy getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServiceSelectionPolicy>(create);
  static ServiceSelectionPolicy? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServiceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServiceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get preferredCountries => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get subscriptionIds => $_getList(2);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get excludedNodeIds => $_getList(3);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get favoriteNodeIds => $_getList(4);

  @$pb.TagNumber(6)
  $core.bool get allowDirect => $_getBF(5);
  @$pb.TagNumber(6)
  set allowDirect($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAllowDirect() => $_has(5);
  @$pb.TagNumber(6)
  void clearAllowDirect() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get maxCandidates => $_getIZ(6);
  @$pb.TagNumber(7)
  set maxCandidates($core.int value) => $_setUnsignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasMaxCandidates() => $_has(6);
  @$pb.TagNumber(7)
  void clearMaxCandidates() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get revision => $_getSZ(7);
  @$pb.TagNumber(8)
  set revision($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasRevision() => $_has(7);
  @$pb.TagNumber(8)
  void clearRevision() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get expectedRevision => $_getSZ(8);
  @$pb.TagNumber(9)
  set expectedRevision($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasExpectedRevision() => $_has(8);
  @$pb.TagNumber(9)
  void clearExpectedRevision() => $_clearField(9);
}

class ServiceCandidate extends $pb.GeneratedMessage {
  factory ServiceCandidate({
    $core.String? nodeId,
    $core.bool? eligible,
    $core.double? score,
    $core.String? reason,
    ProbeResult? latest,
    $core.double? successRatio,
    $core.double? meanLatencyMilliseconds,
    $core.double? latencyTrendMilliseconds,
  }) {
    final result = create();
    if (nodeId != null) result.nodeId = nodeId;
    if (eligible != null) result.eligible = eligible;
    if (score != null) result.score = score;
    if (reason != null) result.reason = reason;
    if (latest != null) result.latest = latest;
    if (successRatio != null) result.successRatio = successRatio;
    if (meanLatencyMilliseconds != null)
      result.meanLatencyMilliseconds = meanLatencyMilliseconds;
    if (latencyTrendMilliseconds != null)
      result.latencyTrendMilliseconds = latencyTrendMilliseconds;
    return result;
  }

  ServiceCandidate._();

  factory ServiceCandidate.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServiceCandidate.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServiceCandidate',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'nodeId')
    ..aOB(2, _omitFieldNames ? '' : 'eligible')
    ..aD(3, _omitFieldNames ? '' : 'score')
    ..aOS(4, _omitFieldNames ? '' : 'reason')
    ..aOM<ProbeResult>(5, _omitFieldNames ? '' : 'latest',
        subBuilder: ProbeResult.create)
    ..aD(6, _omitFieldNames ? '' : 'successRatio')
    ..aD(7, _omitFieldNames ? '' : 'meanLatencyMilliseconds')
    ..aD(8, _omitFieldNames ? '' : 'latencyTrendMilliseconds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceCandidate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceCandidate copyWith(void Function(ServiceCandidate) updates) =>
      super.copyWith((message) => updates(message as ServiceCandidate))
          as ServiceCandidate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceCandidate create() => ServiceCandidate._();
  @$core.override
  ServiceCandidate createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ServiceCandidate getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServiceCandidate>(create);
  static ServiceCandidate? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get nodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set nodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNodeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get eligible => $_getBF(1);
  @$pb.TagNumber(2)
  set eligible($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEligible() => $_has(1);
  @$pb.TagNumber(2)
  void clearEligible() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get score => $_getN(2);
  @$pb.TagNumber(3)
  set score($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasScore() => $_has(2);
  @$pb.TagNumber(3)
  void clearScore() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get reason => $_getSZ(3);
  @$pb.TagNumber(4)
  set reason($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReason() => $_has(3);
  @$pb.TagNumber(4)
  void clearReason() => $_clearField(4);

  @$pb.TagNumber(5)
  ProbeResult get latest => $_getN(4);
  @$pb.TagNumber(5)
  set latest(ProbeResult value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasLatest() => $_has(4);
  @$pb.TagNumber(5)
  void clearLatest() => $_clearField(5);
  @$pb.TagNumber(5)
  ProbeResult ensureLatest() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.double get successRatio => $_getN(5);
  @$pb.TagNumber(6)
  set successRatio($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSuccessRatio() => $_has(5);
  @$pb.TagNumber(6)
  void clearSuccessRatio() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get meanLatencyMilliseconds => $_getN(6);
  @$pb.TagNumber(7)
  set meanLatencyMilliseconds($core.double value) => $_setDouble(6, value);
  @$pb.TagNumber(7)
  $core.bool hasMeanLatencyMilliseconds() => $_has(6);
  @$pb.TagNumber(7)
  void clearMeanLatencyMilliseconds() => $_clearField(7);

  /// Recent half mean latency minus older half; positive means slower.
  @$pb.TagNumber(8)
  $core.double get latencyTrendMilliseconds => $_getN(7);
  @$pb.TagNumber(8)
  set latencyTrendMilliseconds($core.double value) => $_setDouble(7, value);
  @$pb.TagNumber(8)
  $core.bool hasLatencyTrendMilliseconds() => $_has(7);
  @$pb.TagNumber(8)
  void clearLatencyTrendMilliseconds() => $_clearField(8);
}

class ServiceEvaluation extends $pb.GeneratedMessage {
  factory ServiceEvaluation({
    $core.String? serviceId,
    $core.String? nodePoolRevision,
    $core.String? runtimeRevision,
    $core.Iterable<ServiceCandidate>? candidates,
    $fixnum.Int64? evaluatedAtUnixMs,
    $core.String? probeRevision,
  }) {
    final result = create();
    if (serviceId != null) result.serviceId = serviceId;
    if (nodePoolRevision != null) result.nodePoolRevision = nodePoolRevision;
    if (runtimeRevision != null) result.runtimeRevision = runtimeRevision;
    if (candidates != null) result.candidates.addAll(candidates);
    if (evaluatedAtUnixMs != null) result.evaluatedAtUnixMs = evaluatedAtUnixMs;
    if (probeRevision != null) result.probeRevision = probeRevision;
    return result;
  }

  ServiceEvaluation._();

  factory ServiceEvaluation.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServiceEvaluation.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServiceEvaluation',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serviceId')
    ..aOS(2, _omitFieldNames ? '' : 'nodePoolRevision')
    ..aOS(3, _omitFieldNames ? '' : 'runtimeRevision')
    ..pPM<ServiceCandidate>(4, _omitFieldNames ? '' : 'candidates',
        subBuilder: ServiceCandidate.create)
    ..aInt64(5, _omitFieldNames ? '' : 'evaluatedAtUnixMs')
    ..aOS(6, _omitFieldNames ? '' : 'probeRevision')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceEvaluation clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceEvaluation copyWith(void Function(ServiceEvaluation) updates) =>
      super.copyWith((message) => updates(message as ServiceEvaluation))
          as ServiceEvaluation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceEvaluation create() => ServiceEvaluation._();
  @$core.override
  ServiceEvaluation createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ServiceEvaluation getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServiceEvaluation>(create);
  static ServiceEvaluation? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServiceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServiceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get nodePoolRevision => $_getSZ(1);
  @$pb.TagNumber(2)
  set nodePoolRevision($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNodePoolRevision() => $_has(1);
  @$pb.TagNumber(2)
  void clearNodePoolRevision() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get runtimeRevision => $_getSZ(2);
  @$pb.TagNumber(3)
  set runtimeRevision($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRuntimeRevision() => $_has(2);
  @$pb.TagNumber(3)
  void clearRuntimeRevision() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<ServiceCandidate> get candidates => $_getList(3);

  @$pb.TagNumber(5)
  $fixnum.Int64 get evaluatedAtUnixMs => $_getI64(4);
  @$pb.TagNumber(5)
  set evaluatedAtUnixMs($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasEvaluatedAtUnixMs() => $_has(4);
  @$pb.TagNumber(5)
  void clearEvaluatedAtUnixMs() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get probeRevision => $_getSZ(5);
  @$pb.TagNumber(6)
  set probeRevision($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasProbeRevision() => $_has(5);
  @$pb.TagNumber(6)
  void clearProbeRevision() => $_clearField(6);
}

class SmartConnectDiagnostics extends $pb.GeneratedMessage {
  factory SmartConnectDiagnostics({
    RuntimeState? runtime,
    $core.Iterable<ServiceEvaluation>? evaluations,
    $core.String? policyRevision,
    $fixnum.Int64? generatedAtUnixMs,
  }) {
    final result = create();
    if (runtime != null) result.runtime = runtime;
    if (evaluations != null) result.evaluations.addAll(evaluations);
    if (policyRevision != null) result.policyRevision = policyRevision;
    if (generatedAtUnixMs != null) result.generatedAtUnixMs = generatedAtUnixMs;
    return result;
  }

  SmartConnectDiagnostics._();

  factory SmartConnectDiagnostics.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SmartConnectDiagnostics.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SmartConnectDiagnostics',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOM<RuntimeState>(1, _omitFieldNames ? '' : 'runtime',
        subBuilder: RuntimeState.create)
    ..pPM<ServiceEvaluation>(2, _omitFieldNames ? '' : 'evaluations',
        subBuilder: ServiceEvaluation.create)
    ..aOS(3, _omitFieldNames ? '' : 'policyRevision')
    ..aInt64(4, _omitFieldNames ? '' : 'generatedAtUnixMs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SmartConnectDiagnostics clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SmartConnectDiagnostics copyWith(
          void Function(SmartConnectDiagnostics) updates) =>
      super.copyWith((message) => updates(message as SmartConnectDiagnostics))
          as SmartConnectDiagnostics;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SmartConnectDiagnostics create() => SmartConnectDiagnostics._();
  @$core.override
  SmartConnectDiagnostics createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SmartConnectDiagnostics getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SmartConnectDiagnostics>(create);
  static SmartConnectDiagnostics? _defaultInstance;

  @$pb.TagNumber(1)
  RuntimeState get runtime => $_getN(0);
  @$pb.TagNumber(1)
  set runtime(RuntimeState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRuntime() => $_has(0);
  @$pb.TagNumber(1)
  void clearRuntime() => $_clearField(1);
  @$pb.TagNumber(1)
  RuntimeState ensureRuntime() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<ServiceEvaluation> get evaluations => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get policyRevision => $_getSZ(2);
  @$pb.TagNumber(3)
  set policyRevision($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPolicyRevision() => $_has(2);
  @$pb.TagNumber(3)
  void clearPolicyRevision() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get generatedAtUnixMs => $_getI64(3);
  @$pb.TagNumber(4)
  set generatedAtUnixMs($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasGeneratedAtUnixMs() => $_has(3);
  @$pb.TagNumber(4)
  void clearGeneratedAtUnixMs() => $_clearField(4);
}

class RuntimeEvent extends $pb.GeneratedMessage {
  factory RuntimeEvent({
    $fixnum.Int64? sequence,
    RuntimeEventType? type,
    $fixnum.Int64? occurredAtUnixMs,
    RuntimeState? state,
    ProbeResult? probe,
    $core.String? serviceId,
    $core.String? nodeId,
  }) {
    final result = create();
    if (sequence != null) result.sequence = sequence;
    if (type != null) result.type = type;
    if (occurredAtUnixMs != null) result.occurredAtUnixMs = occurredAtUnixMs;
    if (state != null) result.state = state;
    if (probe != null) result.probe = probe;
    if (serviceId != null) result.serviceId = serviceId;
    if (nodeId != null) result.nodeId = nodeId;
    return result;
  }

  RuntimeEvent._();

  factory RuntimeEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RuntimeEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RuntimeEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(
        1, _omitFieldNames ? '' : 'sequence', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aE<RuntimeEventType>(2, _omitFieldNames ? '' : 'type',
        enumValues: RuntimeEventType.values)
    ..aInt64(3, _omitFieldNames ? '' : 'occurredAtUnixMs')
    ..aOM<RuntimeState>(4, _omitFieldNames ? '' : 'state',
        subBuilder: RuntimeState.create)
    ..aOM<ProbeResult>(5, _omitFieldNames ? '' : 'probe',
        subBuilder: ProbeResult.create)
    ..aOS(6, _omitFieldNames ? '' : 'serviceId')
    ..aOS(7, _omitFieldNames ? '' : 'nodeId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RuntimeEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RuntimeEvent copyWith(void Function(RuntimeEvent) updates) =>
      super.copyWith((message) => updates(message as RuntimeEvent))
          as RuntimeEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RuntimeEvent create() => RuntimeEvent._();
  @$core.override
  RuntimeEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RuntimeEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RuntimeEvent>(create);
  static RuntimeEvent? _defaultInstance;

  /// Monotonic within an event stream epoch. Reconnect starts with a snapshot.
  @$pb.TagNumber(1)
  $fixnum.Int64 get sequence => $_getI64(0);
  @$pb.TagNumber(1)
  set sequence($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSequence() => $_has(0);
  @$pb.TagNumber(1)
  void clearSequence() => $_clearField(1);

  @$pb.TagNumber(2)
  RuntimeEventType get type => $_getN(1);
  @$pb.TagNumber(2)
  set type(RuntimeEventType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get occurredAtUnixMs => $_getI64(2);
  @$pb.TagNumber(3)
  set occurredAtUnixMs($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOccurredAtUnixMs() => $_has(2);
  @$pb.TagNumber(3)
  void clearOccurredAtUnixMs() => $_clearField(3);

  @$pb.TagNumber(4)
  RuntimeState get state => $_getN(3);
  @$pb.TagNumber(4)
  set state(RuntimeState value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasState() => $_has(3);
  @$pb.TagNumber(4)
  void clearState() => $_clearField(4);
  @$pb.TagNumber(4)
  RuntimeState ensureState() => $_ensure(3);

  @$pb.TagNumber(5)
  ProbeResult get probe => $_getN(4);
  @$pb.TagNumber(5)
  set probe(ProbeResult value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasProbe() => $_has(4);
  @$pb.TagNumber(5)
  void clearProbe() => $_clearField(5);
  @$pb.TagNumber(5)
  ProbeResult ensureProbe() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get serviceId => $_getSZ(5);
  @$pb.TagNumber(6)
  set serviceId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasServiceId() => $_has(5);
  @$pb.TagNumber(6)
  void clearServiceId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get nodeId => $_getSZ(6);
  @$pb.TagNumber(7)
  set nodeId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasNodeId() => $_has(6);
  @$pb.TagNumber(7)
  void clearNodeId() => $_clearField(7);
}

/// Internal persisted snapshot. Histories are local to this host/network.
class SmartConnectSnapshot extends $pb.GeneratedMessage {
  factory SmartConnectSnapshot({
    $core.Iterable<ServiceProbe>? probes,
    $core.Iterable<ProbeResult>? results,
    $core.Iterable<ServiceSelectionPolicy>? selectionPolicies,
    $core.bool? enabled,
    $core.String? revision,
    SmartRecoveryState? recoveryState,
    $core.Iterable<ServicePolicy>? policies,
    $core.Iterable<SwitchProposal>? proposals,
    $core.Iterable<Operation>? operations,
    $core.Iterable<NodePreference>? nodePreferences,
    $core.Iterable<SchedulerTask>? tasks,
  }) {
    final result = create();
    if (probes != null) result.probes.addAll(probes);
    if (results != null) result.results.addAll(results);
    if (selectionPolicies != null)
      result.selectionPolicies.addAll(selectionPolicies);
    if (enabled != null) result.enabled = enabled;
    if (revision != null) result.revision = revision;
    if (recoveryState != null) result.recoveryState = recoveryState;
    if (policies != null) result.policies.addAll(policies);
    if (proposals != null) result.proposals.addAll(proposals);
    if (operations != null) result.operations.addAll(operations);
    if (nodePreferences != null) result.nodePreferences.addAll(nodePreferences);
    if (tasks != null) result.tasks.addAll(tasks);
    return result;
  }

  SmartConnectSnapshot._();

  factory SmartConnectSnapshot.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SmartConnectSnapshot.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SmartConnectSnapshot',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..pPM<ServiceProbe>(1, _omitFieldNames ? '' : 'probes',
        subBuilder: ServiceProbe.create)
    ..pPM<ProbeResult>(2, _omitFieldNames ? '' : 'results',
        subBuilder: ProbeResult.create)
    ..pPM<ServiceSelectionPolicy>(3, _omitFieldNames ? '' : 'selectionPolicies',
        subBuilder: ServiceSelectionPolicy.create)
    ..aOB(4, _omitFieldNames ? '' : 'enabled')
    ..aOS(5, _omitFieldNames ? '' : 'revision')
    ..aE<SmartRecoveryState>(6, _omitFieldNames ? '' : 'recoveryState',
        enumValues: SmartRecoveryState.values)
    ..pPM<ServicePolicy>(7, _omitFieldNames ? '' : 'policies',
        subBuilder: ServicePolicy.create)
    ..pPM<SwitchProposal>(8, _omitFieldNames ? '' : 'proposals',
        subBuilder: SwitchProposal.create)
    ..pPM<Operation>(9, _omitFieldNames ? '' : 'operations',
        subBuilder: Operation.create)
    ..pPM<NodePreference>(10, _omitFieldNames ? '' : 'nodePreferences',
        subBuilder: NodePreference.create)
    ..pPM<SchedulerTask>(11, _omitFieldNames ? '' : 'tasks',
        subBuilder: SchedulerTask.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SmartConnectSnapshot clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SmartConnectSnapshot copyWith(void Function(SmartConnectSnapshot) updates) =>
      super.copyWith((message) => updates(message as SmartConnectSnapshot))
          as SmartConnectSnapshot;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SmartConnectSnapshot create() => SmartConnectSnapshot._();
  @$core.override
  SmartConnectSnapshot createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SmartConnectSnapshot getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SmartConnectSnapshot>(create);
  static SmartConnectSnapshot? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ServiceProbe> get probes => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<ProbeResult> get results => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<ServiceSelectionPolicy> get selectionPolicies => $_getList(2);

  @$pb.TagNumber(4)
  $core.bool get enabled => $_getBF(3);
  @$pb.TagNumber(4)
  set enabled($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEnabled() => $_has(3);
  @$pb.TagNumber(4)
  void clearEnabled() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get revision => $_getSZ(4);
  @$pb.TagNumber(5)
  set revision($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRevision() => $_has(4);
  @$pb.TagNumber(5)
  void clearRevision() => $_clearField(5);

  @$pb.TagNumber(6)
  SmartRecoveryState get recoveryState => $_getN(5);
  @$pb.TagNumber(6)
  set recoveryState(SmartRecoveryState value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasRecoveryState() => $_has(5);
  @$pb.TagNumber(6)
  void clearRecoveryState() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<ServicePolicy> get policies => $_getList(6);

  @$pb.TagNumber(8)
  $pb.PbList<SwitchProposal> get proposals => $_getList(7);

  @$pb.TagNumber(9)
  $pb.PbList<Operation> get operations => $_getList(8);

  @$pb.TagNumber(10)
  $pb.PbList<NodePreference> get nodePreferences => $_getList(9);

  @$pb.TagNumber(11)
  $pb.PbList<SchedulerTask> get tasks => $_getList(10);
}

class SwitchPolicy extends $pb.GeneratedMessage {
  factory SwitchPolicy({
    SwitchMode? mode,
    $core.Iterable<$core.String>? allowedCountries,
    $core.Iterable<$core.String>? allowedSubscriptionIds,
    $core.bool? allowCrossCountry,
    $core.bool? allowCrossSubscription,
    $core.bool? allowDirect,
    $core.int? consecutiveFailures,
    $core.double? minimumScoreDelta,
    $core.double? minimumHealthScore,
    $core.int? minimumDwellSeconds,
    $core.int? cooldownSeconds,
    $core.int? maxSwitchesPerHour,
    $core.bool? verifyAfterSwitch,
    $core.bool? rollbackOnVerificationFailure,
  }) {
    final result = create();
    if (mode != null) result.mode = mode;
    if (allowedCountries != null)
      result.allowedCountries.addAll(allowedCountries);
    if (allowedSubscriptionIds != null)
      result.allowedSubscriptionIds.addAll(allowedSubscriptionIds);
    if (allowCrossCountry != null) result.allowCrossCountry = allowCrossCountry;
    if (allowCrossSubscription != null)
      result.allowCrossSubscription = allowCrossSubscription;
    if (allowDirect != null) result.allowDirect = allowDirect;
    if (consecutiveFailures != null)
      result.consecutiveFailures = consecutiveFailures;
    if (minimumScoreDelta != null) result.minimumScoreDelta = minimumScoreDelta;
    if (minimumHealthScore != null)
      result.minimumHealthScore = minimumHealthScore;
    if (minimumDwellSeconds != null)
      result.minimumDwellSeconds = minimumDwellSeconds;
    if (cooldownSeconds != null) result.cooldownSeconds = cooldownSeconds;
    if (maxSwitchesPerHour != null)
      result.maxSwitchesPerHour = maxSwitchesPerHour;
    if (verifyAfterSwitch != null) result.verifyAfterSwitch = verifyAfterSwitch;
    if (rollbackOnVerificationFailure != null)
      result.rollbackOnVerificationFailure = rollbackOnVerificationFailure;
    return result;
  }

  SwitchPolicy._();

  factory SwitchPolicy.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SwitchPolicy.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SwitchPolicy',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aE<SwitchMode>(1, _omitFieldNames ? '' : 'mode',
        enumValues: SwitchMode.values)
    ..pPS(2, _omitFieldNames ? '' : 'allowedCountries')
    ..pPS(3, _omitFieldNames ? '' : 'allowedSubscriptionIds')
    ..aOB(4, _omitFieldNames ? '' : 'allowCrossCountry')
    ..aOB(5, _omitFieldNames ? '' : 'allowCrossSubscription')
    ..aOB(6, _omitFieldNames ? '' : 'allowDirect')
    ..aI(7, _omitFieldNames ? '' : 'consecutiveFailures',
        fieldType: $pb.PbFieldType.OU3)
    ..aD(8, _omitFieldNames ? '' : 'minimumScoreDelta')
    ..aD(9, _omitFieldNames ? '' : 'minimumHealthScore')
    ..aI(10, _omitFieldNames ? '' : 'minimumDwellSeconds',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(11, _omitFieldNames ? '' : 'cooldownSeconds',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(12, _omitFieldNames ? '' : 'maxSwitchesPerHour',
        fieldType: $pb.PbFieldType.OU3)
    ..aOB(13, _omitFieldNames ? '' : 'verifyAfterSwitch')
    ..aOB(14, _omitFieldNames ? '' : 'rollbackOnVerificationFailure')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SwitchPolicy clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SwitchPolicy copyWith(void Function(SwitchPolicy) updates) =>
      super.copyWith((message) => updates(message as SwitchPolicy))
          as SwitchPolicy;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SwitchPolicy create() => SwitchPolicy._();
  @$core.override
  SwitchPolicy createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SwitchPolicy getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SwitchPolicy>(create);
  static SwitchPolicy? _defaultInstance;

  @$pb.TagNumber(1)
  SwitchMode get mode => $_getN(0);
  @$pb.TagNumber(1)
  set mode(SwitchMode value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMode() => $_has(0);
  @$pb.TagNumber(1)
  void clearMode() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get allowedCountries => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get allowedSubscriptionIds => $_getList(2);

  @$pb.TagNumber(4)
  $core.bool get allowCrossCountry => $_getBF(3);
  @$pb.TagNumber(4)
  set allowCrossCountry($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAllowCrossCountry() => $_has(3);
  @$pb.TagNumber(4)
  void clearAllowCrossCountry() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get allowCrossSubscription => $_getBF(4);
  @$pb.TagNumber(5)
  set allowCrossSubscription($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAllowCrossSubscription() => $_has(4);
  @$pb.TagNumber(5)
  void clearAllowCrossSubscription() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get allowDirect => $_getBF(5);
  @$pb.TagNumber(6)
  set allowDirect($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAllowDirect() => $_has(5);
  @$pb.TagNumber(6)
  void clearAllowDirect() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get consecutiveFailures => $_getIZ(6);
  @$pb.TagNumber(7)
  set consecutiveFailures($core.int value) => $_setUnsignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasConsecutiveFailures() => $_has(6);
  @$pb.TagNumber(7)
  void clearConsecutiveFailures() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get minimumScoreDelta => $_getN(7);
  @$pb.TagNumber(8)
  set minimumScoreDelta($core.double value) => $_setDouble(7, value);
  @$pb.TagNumber(8)
  $core.bool hasMinimumScoreDelta() => $_has(7);
  @$pb.TagNumber(8)
  void clearMinimumScoreDelta() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.double get minimumHealthScore => $_getN(8);
  @$pb.TagNumber(9)
  set minimumHealthScore($core.double value) => $_setDouble(8, value);
  @$pb.TagNumber(9)
  $core.bool hasMinimumHealthScore() => $_has(8);
  @$pb.TagNumber(9)
  void clearMinimumHealthScore() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get minimumDwellSeconds => $_getIZ(9);
  @$pb.TagNumber(10)
  set minimumDwellSeconds($core.int value) => $_setUnsignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasMinimumDwellSeconds() => $_has(9);
  @$pb.TagNumber(10)
  void clearMinimumDwellSeconds() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get cooldownSeconds => $_getIZ(10);
  @$pb.TagNumber(11)
  set cooldownSeconds($core.int value) => $_setUnsignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasCooldownSeconds() => $_has(10);
  @$pb.TagNumber(11)
  void clearCooldownSeconds() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.int get maxSwitchesPerHour => $_getIZ(11);
  @$pb.TagNumber(12)
  set maxSwitchesPerHour($core.int value) => $_setUnsignedInt32(11, value);
  @$pb.TagNumber(12)
  $core.bool hasMaxSwitchesPerHour() => $_has(11);
  @$pb.TagNumber(12)
  void clearMaxSwitchesPerHour() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.bool get verifyAfterSwitch => $_getBF(12);
  @$pb.TagNumber(13)
  set verifyAfterSwitch($core.bool value) => $_setBool(12, value);
  @$pb.TagNumber(13)
  $core.bool hasVerifyAfterSwitch() => $_has(12);
  @$pb.TagNumber(13)
  void clearVerifyAfterSwitch() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.bool get rollbackOnVerificationFailure => $_getBF(13);
  @$pb.TagNumber(14)
  set rollbackOnVerificationFailure($core.bool value) => $_setBool(13, value);
  @$pb.TagNumber(14)
  $core.bool hasRollbackOnVerificationFailure() => $_has(13);
  @$pb.TagNumber(14)
  void clearRollbackOnVerificationFailure() => $_clearField(14);
}

class ServicePolicy extends $pb.GeneratedMessage {
  factory ServicePolicy({
    $core.String? serviceId,
    $core.String? displayName,
    $core.Iterable<$core.String>? domains,
    $core.Iterable<ServiceProbe>? probes,
    ServiceSelectionPolicy? selection,
    SwitchPolicy? switchPolicy,
    $core.String? revision,
    $core.int? schemaVersion,
    $core.int? qualityValiditySeconds,
    $core.int? bindingValiditySeconds,
    $core.int? evaluationIntervalSeconds,
  }) {
    final result = create();
    if (serviceId != null) result.serviceId = serviceId;
    if (displayName != null) result.displayName = displayName;
    if (domains != null) result.domains.addAll(domains);
    if (probes != null) result.probes.addAll(probes);
    if (selection != null) result.selection = selection;
    if (switchPolicy != null) result.switchPolicy = switchPolicy;
    if (revision != null) result.revision = revision;
    if (schemaVersion != null) result.schemaVersion = schemaVersion;
    if (qualityValiditySeconds != null)
      result.qualityValiditySeconds = qualityValiditySeconds;
    if (bindingValiditySeconds != null)
      result.bindingValiditySeconds = bindingValiditySeconds;
    if (evaluationIntervalSeconds != null)
      result.evaluationIntervalSeconds = evaluationIntervalSeconds;
    return result;
  }

  ServicePolicy._();

  factory ServicePolicy.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServicePolicy.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServicePolicy',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serviceId')
    ..aOS(2, _omitFieldNames ? '' : 'displayName')
    ..pPS(3, _omitFieldNames ? '' : 'domains')
    ..pPM<ServiceProbe>(4, _omitFieldNames ? '' : 'probes',
        subBuilder: ServiceProbe.create)
    ..aOM<ServiceSelectionPolicy>(5, _omitFieldNames ? '' : 'selection',
        subBuilder: ServiceSelectionPolicy.create)
    ..aOM<SwitchPolicy>(6, _omitFieldNames ? '' : 'switchPolicy',
        subBuilder: SwitchPolicy.create)
    ..aOS(7, _omitFieldNames ? '' : 'revision')
    ..aI(8, _omitFieldNames ? '' : 'schemaVersion',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(9, _omitFieldNames ? '' : 'qualityValiditySeconds',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(10, _omitFieldNames ? '' : 'bindingValiditySeconds',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(11, _omitFieldNames ? '' : 'evaluationIntervalSeconds',
        fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServicePolicy clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServicePolicy copyWith(void Function(ServicePolicy) updates) =>
      super.copyWith((message) => updates(message as ServicePolicy))
          as ServicePolicy;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServicePolicy create() => ServicePolicy._();
  @$core.override
  ServicePolicy createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ServicePolicy getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServicePolicy>(create);
  static ServicePolicy? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServiceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServiceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get displayName => $_getSZ(1);
  @$pb.TagNumber(2)
  set displayName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDisplayName() => $_has(1);
  @$pb.TagNumber(2)
  void clearDisplayName() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get domains => $_getList(2);

  @$pb.TagNumber(4)
  $pb.PbList<ServiceProbe> get probes => $_getList(3);

  @$pb.TagNumber(5)
  ServiceSelectionPolicy get selection => $_getN(4);
  @$pb.TagNumber(5)
  set selection(ServiceSelectionPolicy value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasSelection() => $_has(4);
  @$pb.TagNumber(5)
  void clearSelection() => $_clearField(5);
  @$pb.TagNumber(5)
  ServiceSelectionPolicy ensureSelection() => $_ensure(4);

  @$pb.TagNumber(6)
  SwitchPolicy get switchPolicy => $_getN(5);
  @$pb.TagNumber(6)
  set switchPolicy(SwitchPolicy value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasSwitchPolicy() => $_has(5);
  @$pb.TagNumber(6)
  void clearSwitchPolicy() => $_clearField(6);
  @$pb.TagNumber(6)
  SwitchPolicy ensureSwitchPolicy() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.String get revision => $_getSZ(6);
  @$pb.TagNumber(7)
  set revision($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRevision() => $_has(6);
  @$pb.TagNumber(7)
  void clearRevision() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get schemaVersion => $_getIZ(7);
  @$pb.TagNumber(8)
  set schemaVersion($core.int value) => $_setUnsignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasSchemaVersion() => $_has(7);
  @$pb.TagNumber(8)
  void clearSchemaVersion() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get qualityValiditySeconds => $_getIZ(8);
  @$pb.TagNumber(9)
  set qualityValiditySeconds($core.int value) => $_setUnsignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasQualityValiditySeconds() => $_has(8);
  @$pb.TagNumber(9)
  void clearQualityValiditySeconds() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get bindingValiditySeconds => $_getIZ(9);
  @$pb.TagNumber(10)
  set bindingValiditySeconds($core.int value) => $_setUnsignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasBindingValiditySeconds() => $_has(9);
  @$pb.TagNumber(10)
  void clearBindingValiditySeconds() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get evaluationIntervalSeconds => $_getIZ(10);
  @$pb.TagNumber(11)
  set evaluationIntervalSeconds($core.int value) =>
      $_setUnsignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasEvaluationIntervalSeconds() => $_has(10);
  @$pb.TagNumber(11)
  void clearEvaluationIntervalSeconds() => $_clearField(11);
}

class ServicePolicyList extends $pb.GeneratedMessage {
  factory ServicePolicyList({
    $core.Iterable<ServicePolicy>? policies,
  }) {
    final result = create();
    if (policies != null) result.policies.addAll(policies);
    return result;
  }

  ServicePolicyList._();

  factory ServicePolicyList.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServicePolicyList.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServicePolicyList',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..pPM<ServicePolicy>(1, _omitFieldNames ? '' : 'policies',
        subBuilder: ServicePolicy.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServicePolicyList clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServicePolicyList copyWith(void Function(ServicePolicyList) updates) =>
      super.copyWith((message) => updates(message as ServicePolicyList))
          as ServicePolicyList;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServicePolicyList create() => ServicePolicyList._();
  @$core.override
  ServicePolicyList createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ServicePolicyList getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServicePolicyList>(create);
  static ServicePolicyList? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ServicePolicy> get policies => $_getList(0);
}

class NodePreference extends $pb.GeneratedMessage {
  factory NodePreference({
    $core.String? nodeId,
    $core.bool? enabled,
    $core.bool? excluded,
    $core.bool? favorite,
    $core.Iterable<$core.String>? labels,
    $core.int? subscriptionPriority,
    $core.String? revision,
  }) {
    final result = create();
    if (nodeId != null) result.nodeId = nodeId;
    if (enabled != null) result.enabled = enabled;
    if (excluded != null) result.excluded = excluded;
    if (favorite != null) result.favorite = favorite;
    if (labels != null) result.labels.addAll(labels);
    if (subscriptionPriority != null)
      result.subscriptionPriority = subscriptionPriority;
    if (revision != null) result.revision = revision;
    return result;
  }

  NodePreference._();

  factory NodePreference.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NodePreference.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NodePreference',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'nodeId')
    ..aOB(2, _omitFieldNames ? '' : 'enabled')
    ..aOB(3, _omitFieldNames ? '' : 'excluded')
    ..aOB(4, _omitFieldNames ? '' : 'favorite')
    ..pPS(5, _omitFieldNames ? '' : 'labels')
    ..aI(6, _omitFieldNames ? '' : 'subscriptionPriority')
    ..aOS(7, _omitFieldNames ? '' : 'revision')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NodePreference clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NodePreference copyWith(void Function(NodePreference) updates) =>
      super.copyWith((message) => updates(message as NodePreference))
          as NodePreference;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NodePreference create() => NodePreference._();
  @$core.override
  NodePreference createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static NodePreference getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NodePreference>(create);
  static NodePreference? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get nodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set nodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNodeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get enabled => $_getBF(1);
  @$pb.TagNumber(2)
  set enabled($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEnabled() => $_has(1);
  @$pb.TagNumber(2)
  void clearEnabled() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get excluded => $_getBF(2);
  @$pb.TagNumber(3)
  set excluded($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExcluded() => $_has(2);
  @$pb.TagNumber(3)
  void clearExcluded() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get favorite => $_getBF(3);
  @$pb.TagNumber(4)
  set favorite($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFavorite() => $_has(3);
  @$pb.TagNumber(4)
  void clearFavorite() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get labels => $_getList(4);

  @$pb.TagNumber(6)
  $core.int get subscriptionPriority => $_getIZ(5);
  @$pb.TagNumber(6)
  set subscriptionPriority($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSubscriptionPriority() => $_has(5);
  @$pb.TagNumber(6)
  void clearSubscriptionPriority() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get revision => $_getSZ(6);
  @$pb.TagNumber(7)
  set revision($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRevision() => $_has(6);
  @$pb.TagNumber(7)
  void clearRevision() => $_clearField(7);
}

class SwitchProposal extends $pb.GeneratedMessage {
  factory SwitchProposal({
    $core.String? id,
    $core.String? serviceId,
    $core.String? currentNodeId,
    $core.String? suggestedNodeId,
    $core.Iterable<ServiceCandidate>? candidates,
    $core.String? reason,
    $core.String? policyRevision,
    $core.String? nodePoolRevision,
    $core.String? bindingRevision,
    $fixnum.Int64? createdAtUnixMs,
    $fixnum.Int64? expiresAtUnixMs,
    $core.bool? autoAuthorized,
    $core.bool? approved,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (serviceId != null) result.serviceId = serviceId;
    if (currentNodeId != null) result.currentNodeId = currentNodeId;
    if (suggestedNodeId != null) result.suggestedNodeId = suggestedNodeId;
    if (candidates != null) result.candidates.addAll(candidates);
    if (reason != null) result.reason = reason;
    if (policyRevision != null) result.policyRevision = policyRevision;
    if (nodePoolRevision != null) result.nodePoolRevision = nodePoolRevision;
    if (bindingRevision != null) result.bindingRevision = bindingRevision;
    if (createdAtUnixMs != null) result.createdAtUnixMs = createdAtUnixMs;
    if (expiresAtUnixMs != null) result.expiresAtUnixMs = expiresAtUnixMs;
    if (autoAuthorized != null) result.autoAuthorized = autoAuthorized;
    if (approved != null) result.approved = approved;
    return result;
  }

  SwitchProposal._();

  factory SwitchProposal.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SwitchProposal.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SwitchProposal',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'serviceId')
    ..aOS(3, _omitFieldNames ? '' : 'currentNodeId')
    ..aOS(4, _omitFieldNames ? '' : 'suggestedNodeId')
    ..pPM<ServiceCandidate>(5, _omitFieldNames ? '' : 'candidates',
        subBuilder: ServiceCandidate.create)
    ..aOS(6, _omitFieldNames ? '' : 'reason')
    ..aOS(7, _omitFieldNames ? '' : 'policyRevision')
    ..aOS(8, _omitFieldNames ? '' : 'nodePoolRevision')
    ..aOS(9, _omitFieldNames ? '' : 'bindingRevision')
    ..aInt64(10, _omitFieldNames ? '' : 'createdAtUnixMs')
    ..aInt64(11, _omitFieldNames ? '' : 'expiresAtUnixMs')
    ..aOB(12, _omitFieldNames ? '' : 'autoAuthorized')
    ..aOB(13, _omitFieldNames ? '' : 'approved')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SwitchProposal clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SwitchProposal copyWith(void Function(SwitchProposal) updates) =>
      super.copyWith((message) => updates(message as SwitchProposal))
          as SwitchProposal;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SwitchProposal create() => SwitchProposal._();
  @$core.override
  SwitchProposal createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SwitchProposal getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SwitchProposal>(create);
  static SwitchProposal? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get serviceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set serviceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasServiceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearServiceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get currentNodeId => $_getSZ(2);
  @$pb.TagNumber(3)
  set currentNodeId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCurrentNodeId() => $_has(2);
  @$pb.TagNumber(3)
  void clearCurrentNodeId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get suggestedNodeId => $_getSZ(3);
  @$pb.TagNumber(4)
  set suggestedNodeId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSuggestedNodeId() => $_has(3);
  @$pb.TagNumber(4)
  void clearSuggestedNodeId() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<ServiceCandidate> get candidates => $_getList(4);

  @$pb.TagNumber(6)
  $core.String get reason => $_getSZ(5);
  @$pb.TagNumber(6)
  set reason($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasReason() => $_has(5);
  @$pb.TagNumber(6)
  void clearReason() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get policyRevision => $_getSZ(6);
  @$pb.TagNumber(7)
  set policyRevision($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPolicyRevision() => $_has(6);
  @$pb.TagNumber(7)
  void clearPolicyRevision() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get nodePoolRevision => $_getSZ(7);
  @$pb.TagNumber(8)
  set nodePoolRevision($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasNodePoolRevision() => $_has(7);
  @$pb.TagNumber(8)
  void clearNodePoolRevision() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get bindingRevision => $_getSZ(8);
  @$pb.TagNumber(9)
  set bindingRevision($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasBindingRevision() => $_has(8);
  @$pb.TagNumber(9)
  void clearBindingRevision() => $_clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get createdAtUnixMs => $_getI64(9);
  @$pb.TagNumber(10)
  set createdAtUnixMs($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasCreatedAtUnixMs() => $_has(9);
  @$pb.TagNumber(10)
  void clearCreatedAtUnixMs() => $_clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get expiresAtUnixMs => $_getI64(10);
  @$pb.TagNumber(11)
  set expiresAtUnixMs($fixnum.Int64 value) => $_setInt64(10, value);
  @$pb.TagNumber(11)
  $core.bool hasExpiresAtUnixMs() => $_has(10);
  @$pb.TagNumber(11)
  void clearExpiresAtUnixMs() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.bool get autoAuthorized => $_getBF(11);
  @$pb.TagNumber(12)
  set autoAuthorized($core.bool value) => $_setBool(11, value);
  @$pb.TagNumber(12)
  $core.bool hasAutoAuthorized() => $_has(11);
  @$pb.TagNumber(12)
  void clearAutoAuthorized() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.bool get approved => $_getBF(12);
  @$pb.TagNumber(13)
  set approved($core.bool value) => $_setBool(12, value);
  @$pb.TagNumber(13)
  $core.bool hasApproved() => $_has(12);
  @$pb.TagNumber(13)
  void clearApproved() => $_clearField(13);
}

class Operation extends $pb.GeneratedMessage {
  factory Operation({
    $core.String? id,
    $core.String? kind,
    $core.String? resourceId,
    $core.String? idempotencyKey,
    OperationStatus? status,
    $core.String? phase,
    $core.int? progressCurrent,
    $core.int? progressTotal,
    $fixnum.Int64? createdAtUnixMs,
    $fixnum.Int64? startedAtUnixMs,
    $fixnum.Int64? updatedAtUnixMs,
    $fixnum.Int64? completedAtUnixMs,
    $core.String? policyRevision,
    $core.String? nodePoolRevision,
    $core.String? bindingRevision,
    $core.String? runtimeRevision,
    $core.String? proposalId,
    $core.String? resultSummary,
    $core.String? errorCode,
    $core.String? errorMessage,
    $core.String? requestSignature,
    $core.String? desiredNodeId,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (kind != null) result.kind = kind;
    if (resourceId != null) result.resourceId = resourceId;
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    if (status != null) result.status = status;
    if (phase != null) result.phase = phase;
    if (progressCurrent != null) result.progressCurrent = progressCurrent;
    if (progressTotal != null) result.progressTotal = progressTotal;
    if (createdAtUnixMs != null) result.createdAtUnixMs = createdAtUnixMs;
    if (startedAtUnixMs != null) result.startedAtUnixMs = startedAtUnixMs;
    if (updatedAtUnixMs != null) result.updatedAtUnixMs = updatedAtUnixMs;
    if (completedAtUnixMs != null) result.completedAtUnixMs = completedAtUnixMs;
    if (policyRevision != null) result.policyRevision = policyRevision;
    if (nodePoolRevision != null) result.nodePoolRevision = nodePoolRevision;
    if (bindingRevision != null) result.bindingRevision = bindingRevision;
    if (runtimeRevision != null) result.runtimeRevision = runtimeRevision;
    if (proposalId != null) result.proposalId = proposalId;
    if (resultSummary != null) result.resultSummary = resultSummary;
    if (errorCode != null) result.errorCode = errorCode;
    if (errorMessage != null) result.errorMessage = errorMessage;
    if (requestSignature != null) result.requestSignature = requestSignature;
    if (desiredNodeId != null) result.desiredNodeId = desiredNodeId;
    return result;
  }

  Operation._();

  factory Operation.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Operation.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Operation',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'kind')
    ..aOS(3, _omitFieldNames ? '' : 'resourceId')
    ..aOS(4, _omitFieldNames ? '' : 'idempotencyKey')
    ..aE<OperationStatus>(5, _omitFieldNames ? '' : 'status',
        enumValues: OperationStatus.values)
    ..aOS(6, _omitFieldNames ? '' : 'phase')
    ..aI(7, _omitFieldNames ? '' : 'progressCurrent',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(8, _omitFieldNames ? '' : 'progressTotal',
        fieldType: $pb.PbFieldType.OU3)
    ..aInt64(9, _omitFieldNames ? '' : 'createdAtUnixMs')
    ..aInt64(10, _omitFieldNames ? '' : 'startedAtUnixMs')
    ..aInt64(11, _omitFieldNames ? '' : 'updatedAtUnixMs')
    ..aInt64(12, _omitFieldNames ? '' : 'completedAtUnixMs')
    ..aOS(13, _omitFieldNames ? '' : 'policyRevision')
    ..aOS(14, _omitFieldNames ? '' : 'nodePoolRevision')
    ..aOS(15, _omitFieldNames ? '' : 'bindingRevision')
    ..aOS(16, _omitFieldNames ? '' : 'runtimeRevision')
    ..aOS(17, _omitFieldNames ? '' : 'proposalId')
    ..aOS(18, _omitFieldNames ? '' : 'resultSummary')
    ..aOS(19, _omitFieldNames ? '' : 'errorCode')
    ..aOS(20, _omitFieldNames ? '' : 'errorMessage')
    ..aOS(21, _omitFieldNames ? '' : 'requestSignature')
    ..aOS(22, _omitFieldNames ? '' : 'desiredNodeId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Operation clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Operation copyWith(void Function(Operation) updates) =>
      super.copyWith((message) => updates(message as Operation)) as Operation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Operation create() => Operation._();
  @$core.override
  Operation createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Operation getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Operation>(create);
  static Operation? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get kind => $_getSZ(1);
  @$pb.TagNumber(2)
  set kind($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearKind() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get resourceId => $_getSZ(2);
  @$pb.TagNumber(3)
  set resourceId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasResourceId() => $_has(2);
  @$pb.TagNumber(3)
  void clearResourceId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get idempotencyKey => $_getSZ(3);
  @$pb.TagNumber(4)
  set idempotencyKey($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIdempotencyKey() => $_has(3);
  @$pb.TagNumber(4)
  void clearIdempotencyKey() => $_clearField(4);

  @$pb.TagNumber(5)
  OperationStatus get status => $_getN(4);
  @$pb.TagNumber(5)
  set status(OperationStatus value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasStatus() => $_has(4);
  @$pb.TagNumber(5)
  void clearStatus() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get phase => $_getSZ(5);
  @$pb.TagNumber(6)
  set phase($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPhase() => $_has(5);
  @$pb.TagNumber(6)
  void clearPhase() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get progressCurrent => $_getIZ(6);
  @$pb.TagNumber(7)
  set progressCurrent($core.int value) => $_setUnsignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasProgressCurrent() => $_has(6);
  @$pb.TagNumber(7)
  void clearProgressCurrent() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get progressTotal => $_getIZ(7);
  @$pb.TagNumber(8)
  set progressTotal($core.int value) => $_setUnsignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasProgressTotal() => $_has(7);
  @$pb.TagNumber(8)
  void clearProgressTotal() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get createdAtUnixMs => $_getI64(8);
  @$pb.TagNumber(9)
  set createdAtUnixMs($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCreatedAtUnixMs() => $_has(8);
  @$pb.TagNumber(9)
  void clearCreatedAtUnixMs() => $_clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get startedAtUnixMs => $_getI64(9);
  @$pb.TagNumber(10)
  set startedAtUnixMs($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasStartedAtUnixMs() => $_has(9);
  @$pb.TagNumber(10)
  void clearStartedAtUnixMs() => $_clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get updatedAtUnixMs => $_getI64(10);
  @$pb.TagNumber(11)
  set updatedAtUnixMs($fixnum.Int64 value) => $_setInt64(10, value);
  @$pb.TagNumber(11)
  $core.bool hasUpdatedAtUnixMs() => $_has(10);
  @$pb.TagNumber(11)
  void clearUpdatedAtUnixMs() => $_clearField(11);

  @$pb.TagNumber(12)
  $fixnum.Int64 get completedAtUnixMs => $_getI64(11);
  @$pb.TagNumber(12)
  set completedAtUnixMs($fixnum.Int64 value) => $_setInt64(11, value);
  @$pb.TagNumber(12)
  $core.bool hasCompletedAtUnixMs() => $_has(11);
  @$pb.TagNumber(12)
  void clearCompletedAtUnixMs() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get policyRevision => $_getSZ(12);
  @$pb.TagNumber(13)
  set policyRevision($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasPolicyRevision() => $_has(12);
  @$pb.TagNumber(13)
  void clearPolicyRevision() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get nodePoolRevision => $_getSZ(13);
  @$pb.TagNumber(14)
  set nodePoolRevision($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasNodePoolRevision() => $_has(13);
  @$pb.TagNumber(14)
  void clearNodePoolRevision() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get bindingRevision => $_getSZ(14);
  @$pb.TagNumber(15)
  set bindingRevision($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasBindingRevision() => $_has(14);
  @$pb.TagNumber(15)
  void clearBindingRevision() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.String get runtimeRevision => $_getSZ(15);
  @$pb.TagNumber(16)
  set runtimeRevision($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasRuntimeRevision() => $_has(15);
  @$pb.TagNumber(16)
  void clearRuntimeRevision() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.String get proposalId => $_getSZ(16);
  @$pb.TagNumber(17)
  set proposalId($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasProposalId() => $_has(16);
  @$pb.TagNumber(17)
  void clearProposalId() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.String get resultSummary => $_getSZ(17);
  @$pb.TagNumber(18)
  set resultSummary($core.String value) => $_setString(17, value);
  @$pb.TagNumber(18)
  $core.bool hasResultSummary() => $_has(17);
  @$pb.TagNumber(18)
  void clearResultSummary() => $_clearField(18);

  @$pb.TagNumber(19)
  $core.String get errorCode => $_getSZ(18);
  @$pb.TagNumber(19)
  set errorCode($core.String value) => $_setString(18, value);
  @$pb.TagNumber(19)
  $core.bool hasErrorCode() => $_has(18);
  @$pb.TagNumber(19)
  void clearErrorCode() => $_clearField(19);

  @$pb.TagNumber(20)
  $core.String get errorMessage => $_getSZ(19);
  @$pb.TagNumber(20)
  set errorMessage($core.String value) => $_setString(19, value);
  @$pb.TagNumber(20)
  $core.bool hasErrorMessage() => $_has(19);
  @$pb.TagNumber(20)
  void clearErrorMessage() => $_clearField(20);

  /// Server-owned hash used to reject idempotency-key reuse with another payload.
  @$pb.TagNumber(21)
  $core.String get requestSignature => $_getSZ(20);
  @$pb.TagNumber(21)
  set requestSignature($core.String value) => $_setString(20, value);
  @$pb.TagNumber(21)
  $core.bool hasRequestSignature() => $_has(20);
  @$pb.TagNumber(21)
  void clearRequestSignature() => $_clearField(21);

  @$pb.TagNumber(22)
  $core.String get desiredNodeId => $_getSZ(21);
  @$pb.TagNumber(22)
  set desiredNodeId($core.String value) => $_setString(21, value);
  @$pb.TagNumber(22)
  $core.bool hasDesiredNodeId() => $_has(21);
  @$pb.TagNumber(22)
  void clearDesiredNodeId() => $_clearField(22);
}

class SchedulerTask extends $pb.GeneratedMessage {
  factory SchedulerTask({
    $core.String? id,
    $core.String? serviceId,
    $core.String? kind,
    $core.String? reason,
    $core.String? policyRevision,
    $core.String? nodePoolRevision,
    $fixnum.Int64? nextRunAtUnixMs,
    $core.int? attempt,
    $core.int? backoffSeconds,
    $fixnum.Int64? deadlineUnixMs,
    $core.String? operationId,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (serviceId != null) result.serviceId = serviceId;
    if (kind != null) result.kind = kind;
    if (reason != null) result.reason = reason;
    if (policyRevision != null) result.policyRevision = policyRevision;
    if (nodePoolRevision != null) result.nodePoolRevision = nodePoolRevision;
    if (nextRunAtUnixMs != null) result.nextRunAtUnixMs = nextRunAtUnixMs;
    if (attempt != null) result.attempt = attempt;
    if (backoffSeconds != null) result.backoffSeconds = backoffSeconds;
    if (deadlineUnixMs != null) result.deadlineUnixMs = deadlineUnixMs;
    if (operationId != null) result.operationId = operationId;
    return result;
  }

  SchedulerTask._();

  factory SchedulerTask.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SchedulerTask.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SchedulerTask',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'serviceId')
    ..aOS(3, _omitFieldNames ? '' : 'kind')
    ..aOS(4, _omitFieldNames ? '' : 'reason')
    ..aOS(5, _omitFieldNames ? '' : 'policyRevision')
    ..aOS(6, _omitFieldNames ? '' : 'nodePoolRevision')
    ..aInt64(7, _omitFieldNames ? '' : 'nextRunAtUnixMs')
    ..aI(8, _omitFieldNames ? '' : 'attempt', fieldType: $pb.PbFieldType.OU3)
    ..aI(9, _omitFieldNames ? '' : 'backoffSeconds',
        fieldType: $pb.PbFieldType.OU3)
    ..aInt64(10, _omitFieldNames ? '' : 'deadlineUnixMs')
    ..aOS(11, _omitFieldNames ? '' : 'operationId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SchedulerTask clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SchedulerTask copyWith(void Function(SchedulerTask) updates) =>
      super.copyWith((message) => updates(message as SchedulerTask))
          as SchedulerTask;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SchedulerTask create() => SchedulerTask._();
  @$core.override
  SchedulerTask createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SchedulerTask getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SchedulerTask>(create);
  static SchedulerTask? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get serviceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set serviceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasServiceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearServiceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get kind => $_getSZ(2);
  @$pb.TagNumber(3)
  set kind($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasKind() => $_has(2);
  @$pb.TagNumber(3)
  void clearKind() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get reason => $_getSZ(3);
  @$pb.TagNumber(4)
  set reason($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReason() => $_has(3);
  @$pb.TagNumber(4)
  void clearReason() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get policyRevision => $_getSZ(4);
  @$pb.TagNumber(5)
  set policyRevision($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPolicyRevision() => $_has(4);
  @$pb.TagNumber(5)
  void clearPolicyRevision() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get nodePoolRevision => $_getSZ(5);
  @$pb.TagNumber(6)
  set nodePoolRevision($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasNodePoolRevision() => $_has(5);
  @$pb.TagNumber(6)
  void clearNodePoolRevision() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get nextRunAtUnixMs => $_getI64(6);
  @$pb.TagNumber(7)
  set nextRunAtUnixMs($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasNextRunAtUnixMs() => $_has(6);
  @$pb.TagNumber(7)
  void clearNextRunAtUnixMs() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get attempt => $_getIZ(7);
  @$pb.TagNumber(8)
  set attempt($core.int value) => $_setUnsignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasAttempt() => $_has(7);
  @$pb.TagNumber(8)
  void clearAttempt() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get backoffSeconds => $_getIZ(8);
  @$pb.TagNumber(9)
  set backoffSeconds($core.int value) => $_setUnsignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasBackoffSeconds() => $_has(8);
  @$pb.TagNumber(9)
  void clearBackoffSeconds() => $_clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get deadlineUnixMs => $_getI64(9);
  @$pb.TagNumber(10)
  set deadlineUnixMs($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasDeadlineUnixMs() => $_has(9);
  @$pb.TagNumber(10)
  void clearDeadlineUnixMs() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get operationId => $_getSZ(10);
  @$pb.TagNumber(11)
  set operationId($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasOperationId() => $_has(10);
  @$pb.TagNumber(11)
  void clearOperationId() => $_clearField(11);
}

class OperationList extends $pb.GeneratedMessage {
  factory OperationList({
    $core.Iterable<Operation>? operations,
  }) {
    final result = create();
    if (operations != null) result.operations.addAll(operations);
    return result;
  }

  OperationList._();

  factory OperationList.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OperationList.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OperationList',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..pPM<Operation>(1, _omitFieldNames ? '' : 'operations',
        subBuilder: Operation.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OperationList clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OperationList copyWith(void Function(OperationList) updates) =>
      super.copyWith((message) => updates(message as OperationList))
          as OperationList;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OperationList create() => OperationList._();
  @$core.override
  OperationList createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OperationList getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OperationList>(create);
  static OperationList? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Operation> get operations => $_getList(0);
}

class SetSmartConnectEnabledRequest extends $pb.GeneratedMessage {
  factory SetSmartConnectEnabledRequest({
    $core.bool? enabled,
    $core.String? expectedRevision,
    $core.String? idempotencyKey,
  }) {
    final result = create();
    if (enabled != null) result.enabled = enabled;
    if (expectedRevision != null) result.expectedRevision = expectedRevision;
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    return result;
  }

  SetSmartConnectEnabledRequest._();

  factory SetSmartConnectEnabledRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetSmartConnectEnabledRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetSmartConnectEnabledRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'enabled')
    ..aOS(2, _omitFieldNames ? '' : 'expectedRevision')
    ..aOS(3, _omitFieldNames ? '' : 'idempotencyKey')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetSmartConnectEnabledRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetSmartConnectEnabledRequest copyWith(
          void Function(SetSmartConnectEnabledRequest) updates) =>
      super.copyWith(
              (message) => updates(message as SetSmartConnectEnabledRequest))
          as SetSmartConnectEnabledRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetSmartConnectEnabledRequest create() =>
      SetSmartConnectEnabledRequest._();
  @$core.override
  SetSmartConnectEnabledRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetSmartConnectEnabledRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetSmartConnectEnabledRequest>(create);
  static SetSmartConnectEnabledRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get enabled => $_getBF(0);
  @$pb.TagNumber(1)
  set enabled($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEnabled() => $_has(0);
  @$pb.TagNumber(1)
  void clearEnabled() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get expectedRevision => $_getSZ(1);
  @$pb.TagNumber(2)
  set expectedRevision($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasExpectedRevision() => $_has(1);
  @$pb.TagNumber(2)
  void clearExpectedRevision() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get idempotencyKey => $_getSZ(2);
  @$pb.TagNumber(3)
  set idempotencyKey($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIdempotencyKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearIdempotencyKey() => $_clearField(3);
}

class UpsertServicePolicyRequest extends $pb.GeneratedMessage {
  factory UpsertServicePolicyRequest({
    ServicePolicy? policy,
    $core.String? expectedRevision,
    $core.String? idempotencyKey,
  }) {
    final result = create();
    if (policy != null) result.policy = policy;
    if (expectedRevision != null) result.expectedRevision = expectedRevision;
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    return result;
  }

  UpsertServicePolicyRequest._();

  factory UpsertServicePolicyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpsertServicePolicyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpsertServicePolicyRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOM<ServicePolicy>(1, _omitFieldNames ? '' : 'policy',
        subBuilder: ServicePolicy.create)
    ..aOS(2, _omitFieldNames ? '' : 'expectedRevision')
    ..aOS(3, _omitFieldNames ? '' : 'idempotencyKey')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpsertServicePolicyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpsertServicePolicyRequest copyWith(
          void Function(UpsertServicePolicyRequest) updates) =>
      super.copyWith(
              (message) => updates(message as UpsertServicePolicyRequest))
          as UpsertServicePolicyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpsertServicePolicyRequest create() => UpsertServicePolicyRequest._();
  @$core.override
  UpsertServicePolicyRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpsertServicePolicyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpsertServicePolicyRequest>(create);
  static UpsertServicePolicyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  ServicePolicy get policy => $_getN(0);
  @$pb.TagNumber(1)
  set policy(ServicePolicy value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPolicy() => $_has(0);
  @$pb.TagNumber(1)
  void clearPolicy() => $_clearField(1);
  @$pb.TagNumber(1)
  ServicePolicy ensurePolicy() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get expectedRevision => $_getSZ(1);
  @$pb.TagNumber(2)
  set expectedRevision($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasExpectedRevision() => $_has(1);
  @$pb.TagNumber(2)
  void clearExpectedRevision() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get idempotencyKey => $_getSZ(2);
  @$pb.TagNumber(3)
  set idempotencyKey($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIdempotencyKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearIdempotencyKey() => $_clearField(3);
}

class DeleteServicePolicyRequest extends $pb.GeneratedMessage {
  factory DeleteServicePolicyRequest({
    $core.String? serviceId,
    $core.String? expectedRevision,
    $core.String? idempotencyKey,
  }) {
    final result = create();
    if (serviceId != null) result.serviceId = serviceId;
    if (expectedRevision != null) result.expectedRevision = expectedRevision;
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    return result;
  }

  DeleteServicePolicyRequest._();

  factory DeleteServicePolicyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteServicePolicyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteServicePolicyRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serviceId')
    ..aOS(2, _omitFieldNames ? '' : 'expectedRevision')
    ..aOS(3, _omitFieldNames ? '' : 'idempotencyKey')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteServicePolicyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteServicePolicyRequest copyWith(
          void Function(DeleteServicePolicyRequest) updates) =>
      super.copyWith(
              (message) => updates(message as DeleteServicePolicyRequest))
          as DeleteServicePolicyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteServicePolicyRequest create() => DeleteServicePolicyRequest._();
  @$core.override
  DeleteServicePolicyRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteServicePolicyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteServicePolicyRequest>(create);
  static DeleteServicePolicyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServiceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServiceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get expectedRevision => $_getSZ(1);
  @$pb.TagNumber(2)
  set expectedRevision($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasExpectedRevision() => $_has(1);
  @$pb.TagNumber(2)
  void clearExpectedRevision() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get idempotencyKey => $_getSZ(2);
  @$pb.TagNumber(3)
  set idempotencyKey($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIdempotencyKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearIdempotencyKey() => $_clearField(3);
}

class SetNodePreferenceRequest extends $pb.GeneratedMessage {
  factory SetNodePreferenceRequest({
    NodePreference? preference,
    $core.String? expectedRevision,
    $core.String? idempotencyKey,
  }) {
    final result = create();
    if (preference != null) result.preference = preference;
    if (expectedRevision != null) result.expectedRevision = expectedRevision;
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    return result;
  }

  SetNodePreferenceRequest._();

  factory SetNodePreferenceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetNodePreferenceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetNodePreferenceRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOM<NodePreference>(1, _omitFieldNames ? '' : 'preference',
        subBuilder: NodePreference.create)
    ..aOS(2, _omitFieldNames ? '' : 'expectedRevision')
    ..aOS(3, _omitFieldNames ? '' : 'idempotencyKey')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetNodePreferenceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetNodePreferenceRequest copyWith(
          void Function(SetNodePreferenceRequest) updates) =>
      super.copyWith((message) => updates(message as SetNodePreferenceRequest))
          as SetNodePreferenceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetNodePreferenceRequest create() => SetNodePreferenceRequest._();
  @$core.override
  SetNodePreferenceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetNodePreferenceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetNodePreferenceRequest>(create);
  static SetNodePreferenceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  NodePreference get preference => $_getN(0);
  @$pb.TagNumber(1)
  set preference(NodePreference value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPreference() => $_has(0);
  @$pb.TagNumber(1)
  void clearPreference() => $_clearField(1);
  @$pb.TagNumber(1)
  NodePreference ensurePreference() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get expectedRevision => $_getSZ(1);
  @$pb.TagNumber(2)
  set expectedRevision($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasExpectedRevision() => $_has(1);
  @$pb.TagNumber(2)
  void clearExpectedRevision() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get idempotencyKey => $_getSZ(2);
  @$pb.TagNumber(3)
  set idempotencyKey($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIdempotencyKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearIdempotencyKey() => $_clearField(3);
}

class RequestServiceEvaluationRequest extends $pb.GeneratedMessage {
  factory RequestServiceEvaluationRequest({
    $core.String? serviceId,
    $core.String? expectedRevision,
    $core.String? idempotencyKey,
  }) {
    final result = create();
    if (serviceId != null) result.serviceId = serviceId;
    if (expectedRevision != null) result.expectedRevision = expectedRevision;
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    return result;
  }

  RequestServiceEvaluationRequest._();

  factory RequestServiceEvaluationRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestServiceEvaluationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestServiceEvaluationRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serviceId')
    ..aOS(2, _omitFieldNames ? '' : 'expectedRevision')
    ..aOS(3, _omitFieldNames ? '' : 'idempotencyKey')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestServiceEvaluationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestServiceEvaluationRequest copyWith(
          void Function(RequestServiceEvaluationRequest) updates) =>
      super.copyWith(
              (message) => updates(message as RequestServiceEvaluationRequest))
          as RequestServiceEvaluationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestServiceEvaluationRequest create() =>
      RequestServiceEvaluationRequest._();
  @$core.override
  RequestServiceEvaluationRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestServiceEvaluationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestServiceEvaluationRequest>(
          create);
  static RequestServiceEvaluationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServiceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServiceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get expectedRevision => $_getSZ(1);
  @$pb.TagNumber(2)
  set expectedRevision($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasExpectedRevision() => $_has(1);
  @$pb.TagNumber(2)
  void clearExpectedRevision() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get idempotencyKey => $_getSZ(2);
  @$pb.TagNumber(3)
  set idempotencyKey($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIdempotencyKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearIdempotencyKey() => $_clearField(3);
}

class ProposalCommandRequest extends $pb.GeneratedMessage {
  factory ProposalCommandRequest({
    $core.String? proposalId,
    $core.String? expectedRevision,
    $core.String? idempotencyKey,
  }) {
    final result = create();
    if (proposalId != null) result.proposalId = proposalId;
    if (expectedRevision != null) result.expectedRevision = expectedRevision;
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    return result;
  }

  ProposalCommandRequest._();

  factory ProposalCommandRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ProposalCommandRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProposalCommandRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'proposalId')
    ..aOS(2, _omitFieldNames ? '' : 'expectedRevision')
    ..aOS(3, _omitFieldNames ? '' : 'idempotencyKey')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProposalCommandRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProposalCommandRequest copyWith(
          void Function(ProposalCommandRequest) updates) =>
      super.copyWith((message) => updates(message as ProposalCommandRequest))
          as ProposalCommandRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProposalCommandRequest create() => ProposalCommandRequest._();
  @$core.override
  ProposalCommandRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ProposalCommandRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProposalCommandRequest>(create);
  static ProposalCommandRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get proposalId => $_getSZ(0);
  @$pb.TagNumber(1)
  set proposalId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProposalId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProposalId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get expectedRevision => $_getSZ(1);
  @$pb.TagNumber(2)
  set expectedRevision($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasExpectedRevision() => $_has(1);
  @$pb.TagNumber(2)
  void clearExpectedRevision() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get idempotencyKey => $_getSZ(2);
  @$pb.TagNumber(3)
  set idempotencyKey($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIdempotencyKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearIdempotencyKey() => $_clearField(3);
}

class ForceServiceBindingRequest extends $pb.GeneratedMessage {
  factory ForceServiceBindingRequest({
    $core.String? serviceId,
    $core.String? nodeId,
    $core.String? expectedRevision,
    $core.String? idempotencyKey,
    $core.bool? closeExistingConnections,
  }) {
    final result = create();
    if (serviceId != null) result.serviceId = serviceId;
    if (nodeId != null) result.nodeId = nodeId;
    if (expectedRevision != null) result.expectedRevision = expectedRevision;
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    if (closeExistingConnections != null)
      result.closeExistingConnections = closeExistingConnections;
    return result;
  }

  ForceServiceBindingRequest._();

  factory ForceServiceBindingRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ForceServiceBindingRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ForceServiceBindingRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serviceId')
    ..aOS(2, _omitFieldNames ? '' : 'nodeId')
    ..aOS(3, _omitFieldNames ? '' : 'expectedRevision')
    ..aOS(4, _omitFieldNames ? '' : 'idempotencyKey')
    ..aOB(5, _omitFieldNames ? '' : 'closeExistingConnections')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ForceServiceBindingRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ForceServiceBindingRequest copyWith(
          void Function(ForceServiceBindingRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ForceServiceBindingRequest))
          as ForceServiceBindingRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ForceServiceBindingRequest create() => ForceServiceBindingRequest._();
  @$core.override
  ForceServiceBindingRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ForceServiceBindingRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ForceServiceBindingRequest>(create);
  static ForceServiceBindingRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServiceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServiceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get nodeId => $_getSZ(1);
  @$pb.TagNumber(2)
  set nodeId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNodeId() => $_has(1);
  @$pb.TagNumber(2)
  void clearNodeId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get expectedRevision => $_getSZ(2);
  @$pb.TagNumber(3)
  set expectedRevision($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExpectedRevision() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpectedRevision() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get idempotencyKey => $_getSZ(3);
  @$pb.TagNumber(4)
  set idempotencyKey($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIdempotencyKey() => $_has(3);
  @$pb.TagNumber(4)
  void clearIdempotencyKey() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get closeExistingConnections => $_getBF(4);
  @$pb.TagNumber(5)
  set closeExistingConnections($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCloseExistingConnections() => $_has(4);
  @$pb.TagNumber(5)
  void clearCloseExistingConnections() => $_clearField(5);
}

class GetOperationRequest extends $pb.GeneratedMessage {
  factory GetOperationRequest({
    $core.String? operationId,
  }) {
    final result = create();
    if (operationId != null) result.operationId = operationId;
    return result;
  }

  GetOperationRequest._();

  factory GetOperationRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetOperationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetOperationRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'operationId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetOperationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetOperationRequest copyWith(void Function(GetOperationRequest) updates) =>
      super.copyWith((message) => updates(message as GetOperationRequest))
          as GetOperationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetOperationRequest create() => GetOperationRequest._();
  @$core.override
  GetOperationRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetOperationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetOperationRequest>(create);
  static GetOperationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get operationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set operationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOperationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOperationId() => $_clearField(1);
}

class ListOperationsRequest extends $pb.GeneratedMessage {
  factory ListOperationsRequest({
    $core.String? resourceId,
    $core.int? limit,
  }) {
    final result = create();
    if (resourceId != null) result.resourceId = resourceId;
    if (limit != null) result.limit = limit;
    return result;
  }

  ListOperationsRequest._();

  factory ListOperationsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListOperationsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListOperationsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'resourceId')
    ..aI(2, _omitFieldNames ? '' : 'limit', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOperationsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOperationsRequest copyWith(
          void Function(ListOperationsRequest) updates) =>
      super.copyWith((message) => updates(message as ListOperationsRequest))
          as ListOperationsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListOperationsRequest create() => ListOperationsRequest._();
  @$core.override
  ListOperationsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListOperationsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListOperationsRequest>(create);
  static ListOperationsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get resourceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set resourceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasResourceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearResourceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get limit => $_getIZ(1);
  @$pb.TagNumber(2)
  set limit($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLimit() => $_has(1);
  @$pb.TagNumber(2)
  void clearLimit() => $_clearField(2);
}

class SmartConnectEventsRequest extends $pb.GeneratedMessage {
  factory SmartConnectEventsRequest({
    $fixnum.Int64? afterSequence,
  }) {
    final result = create();
    if (afterSequence != null) result.afterSequence = afterSequence;
    return result;
  }

  SmartConnectEventsRequest._();

  factory SmartConnectEventsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SmartConnectEventsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SmartConnectEventsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(
        1, _omitFieldNames ? '' : 'afterSequence', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SmartConnectEventsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SmartConnectEventsRequest copyWith(
          void Function(SmartConnectEventsRequest) updates) =>
      super.copyWith((message) => updates(message as SmartConnectEventsRequest))
          as SmartConnectEventsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SmartConnectEventsRequest create() => SmartConnectEventsRequest._();
  @$core.override
  SmartConnectEventsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SmartConnectEventsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SmartConnectEventsRequest>(create);
  static SmartConnectEventsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get afterSequence => $_getI64(0);
  @$pb.TagNumber(1)
  set afterSequence($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAfterSequence() => $_has(0);
  @$pb.TagNumber(1)
  void clearAfterSequence() => $_clearField(1);
}

class SmartConnectEvent extends $pb.GeneratedMessage {
  factory SmartConnectEvent({
    $fixnum.Int64? sequence,
    $core.String? epoch,
    $core.String? operationId,
    $core.String? resourceId,
    $fixnum.Int64? occurredAtUnixMs,
    SmartConnectSnapshot? snapshot,
  }) {
    final result = create();
    if (sequence != null) result.sequence = sequence;
    if (epoch != null) result.epoch = epoch;
    if (operationId != null) result.operationId = operationId;
    if (resourceId != null) result.resourceId = resourceId;
    if (occurredAtUnixMs != null) result.occurredAtUnixMs = occurredAtUnixMs;
    if (snapshot != null) result.snapshot = snapshot;
    return result;
  }

  SmartConnectEvent._();

  factory SmartConnectEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SmartConnectEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SmartConnectEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(
        1, _omitFieldNames ? '' : 'sequence', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(2, _omitFieldNames ? '' : 'epoch')
    ..aOS(3, _omitFieldNames ? '' : 'operationId')
    ..aOS(4, _omitFieldNames ? '' : 'resourceId')
    ..aInt64(5, _omitFieldNames ? '' : 'occurredAtUnixMs')
    ..aOM<SmartConnectSnapshot>(6, _omitFieldNames ? '' : 'snapshot',
        subBuilder: SmartConnectSnapshot.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SmartConnectEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SmartConnectEvent copyWith(void Function(SmartConnectEvent) updates) =>
      super.copyWith((message) => updates(message as SmartConnectEvent))
          as SmartConnectEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SmartConnectEvent create() => SmartConnectEvent._();
  @$core.override
  SmartConnectEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SmartConnectEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SmartConnectEvent>(create);
  static SmartConnectEvent? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get sequence => $_getI64(0);
  @$pb.TagNumber(1)
  set sequence($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSequence() => $_has(0);
  @$pb.TagNumber(1)
  void clearSequence() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get epoch => $_getSZ(1);
  @$pb.TagNumber(2)
  set epoch($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEpoch() => $_has(1);
  @$pb.TagNumber(2)
  void clearEpoch() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get operationId => $_getSZ(2);
  @$pb.TagNumber(3)
  set operationId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOperationId() => $_has(2);
  @$pb.TagNumber(3)
  void clearOperationId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get resourceId => $_getSZ(3);
  @$pb.TagNumber(4)
  set resourceId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasResourceId() => $_has(3);
  @$pb.TagNumber(4)
  void clearResourceId() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get occurredAtUnixMs => $_getI64(4);
  @$pb.TagNumber(5)
  set occurredAtUnixMs($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOccurredAtUnixMs() => $_has(4);
  @$pb.TagNumber(5)
  void clearOccurredAtUnixMs() => $_clearField(5);

  @$pb.TagNumber(6)
  SmartConnectSnapshot get snapshot => $_getN(5);
  @$pb.TagNumber(6)
  set snapshot(SmartConnectSnapshot value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasSnapshot() => $_has(5);
  @$pb.TagNumber(6)
  void clearSnapshot() => $_clearField(6);
  @$pb.TagNumber(6)
  SmartConnectSnapshot ensureSnapshot() => $_ensure(5);
}

/// Portable probe policy only. Quality and runtime bindings remain device-local.
class SmartConnectPolicy extends $pb.GeneratedMessage {
  factory SmartConnectPolicy({
    $core.int? schemaVersion,
    $core.String? revision,
    $core.Iterable<ServiceProbe>? probes,
  }) {
    final result = create();
    if (schemaVersion != null) result.schemaVersion = schemaVersion;
    if (revision != null) result.revision = revision;
    if (probes != null) result.probes.addAll(probes);
    return result;
  }

  SmartConnectPolicy._();

  factory SmartConnectPolicy.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SmartConnectPolicy.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SmartConnectPolicy',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'schemaVersion',
        fieldType: $pb.PbFieldType.OU3)
    ..aOS(2, _omitFieldNames ? '' : 'revision')
    ..pPM<ServiceProbe>(3, _omitFieldNames ? '' : 'probes',
        subBuilder: ServiceProbe.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SmartConnectPolicy clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SmartConnectPolicy copyWith(void Function(SmartConnectPolicy) updates) =>
      super.copyWith((message) => updates(message as SmartConnectPolicy))
          as SmartConnectPolicy;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SmartConnectPolicy create() => SmartConnectPolicy._();
  @$core.override
  SmartConnectPolicy createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SmartConnectPolicy getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SmartConnectPolicy>(create);
  static SmartConnectPolicy? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get schemaVersion => $_getIZ(0);
  @$pb.TagNumber(1)
  set schemaVersion($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSchemaVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearSchemaVersion() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get revision => $_getSZ(1);
  @$pb.TagNumber(2)
  set revision($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRevision() => $_has(1);
  @$pb.TagNumber(2)
  void clearRevision() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<ServiceProbe> get probes => $_getList(2);
}

class ImportSmartConnectPolicyRequest extends $pb.GeneratedMessage {
  factory ImportSmartConnectPolicyRequest({
    SmartConnectPolicy? policy,
    $core.String? expectedRevision,
  }) {
    final result = create();
    if (policy != null) result.policy = policy;
    if (expectedRevision != null) result.expectedRevision = expectedRevision;
    return result;
  }

  ImportSmartConnectPolicyRequest._();

  factory ImportSmartConnectPolicyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ImportSmartConnectPolicyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ImportSmartConnectPolicyRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOM<SmartConnectPolicy>(1, _omitFieldNames ? '' : 'policy',
        subBuilder: SmartConnectPolicy.create)
    ..aOS(2, _omitFieldNames ? '' : 'expectedRevision')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ImportSmartConnectPolicyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ImportSmartConnectPolicyRequest copyWith(
          void Function(ImportSmartConnectPolicyRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ImportSmartConnectPolicyRequest))
          as ImportSmartConnectPolicyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ImportSmartConnectPolicyRequest create() =>
      ImportSmartConnectPolicyRequest._();
  @$core.override
  ImportSmartConnectPolicyRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ImportSmartConnectPolicyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ImportSmartConnectPolicyRequest>(
          create);
  static ImportSmartConnectPolicyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  SmartConnectPolicy get policy => $_getN(0);
  @$pb.TagNumber(1)
  set policy(SmartConnectPolicy value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPolicy() => $_has(0);
  @$pb.TagNumber(1)
  void clearPolicy() => $_clearField(1);
  @$pb.TagNumber(1)
  SmartConnectPolicy ensurePolicy() => $_ensure(0);

  /// Required local export revision. Import atomically replaces probe definitions.
  @$pb.TagNumber(2)
  $core.String get expectedRevision => $_getSZ(1);
  @$pb.TagNumber(2)
  set expectedRevision($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasExpectedRevision() => $_has(1);
  @$pb.TagNumber(2)
  void clearExpectedRevision() => $_clearField(2);
}

class RuntimeState extends $pb.GeneratedMessage {
  factory RuntimeState({
    ConfigApplyPhase? phase,
    $core.String? attemptedRevision,
    $core.String? desiredRevision,
    $core.String? appliedRevision,
    $core.String? errorMessage,
    $core.bool? running,
    $core.Iterable<SelectorState>? selectors,
    $core.Iterable<ServiceRouteState>? serviceRoutes,
    $core.Iterable<ServiceBindingState>? serviceBindings,
    $core.String? nodePoolRevision,
  }) {
    final result = create();
    if (phase != null) result.phase = phase;
    if (attemptedRevision != null) result.attemptedRevision = attemptedRevision;
    if (desiredRevision != null) result.desiredRevision = desiredRevision;
    if (appliedRevision != null) result.appliedRevision = appliedRevision;
    if (errorMessage != null) result.errorMessage = errorMessage;
    if (running != null) result.running = running;
    if (selectors != null) result.selectors.addAll(selectors);
    if (serviceRoutes != null) result.serviceRoutes.addAll(serviceRoutes);
    if (serviceBindings != null) result.serviceBindings.addAll(serviceBindings);
    if (nodePoolRevision != null) result.nodePoolRevision = nodePoolRevision;
    return result;
  }

  RuntimeState._();

  factory RuntimeState.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RuntimeState.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RuntimeState',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aE<ConfigApplyPhase>(1, _omitFieldNames ? '' : 'phase',
        enumValues: ConfigApplyPhase.values)
    ..aOS(2, _omitFieldNames ? '' : 'attemptedRevision')
    ..aOS(3, _omitFieldNames ? '' : 'desiredRevision')
    ..aOS(4, _omitFieldNames ? '' : 'appliedRevision')
    ..aOS(5, _omitFieldNames ? '' : 'errorMessage')
    ..aOB(6, _omitFieldNames ? '' : 'running')
    ..pPM<SelectorState>(7, _omitFieldNames ? '' : 'selectors',
        subBuilder: SelectorState.create)
    ..pPM<ServiceRouteState>(8, _omitFieldNames ? '' : 'serviceRoutes',
        subBuilder: ServiceRouteState.create)
    ..pPM<ServiceBindingState>(9, _omitFieldNames ? '' : 'serviceBindings',
        subBuilder: ServiceBindingState.create)
    ..aOS(10, _omitFieldNames ? '' : 'nodePoolRevision')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RuntimeState clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RuntimeState copyWith(void Function(RuntimeState) updates) =>
      super.copyWith((message) => updates(message as RuntimeState))
          as RuntimeState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RuntimeState create() => RuntimeState._();
  @$core.override
  RuntimeState createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RuntimeState getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RuntimeState>(create);
  static RuntimeState? _defaultInstance;

  @$pb.TagNumber(1)
  ConfigApplyPhase get phase => $_getN(0);
  @$pb.TagNumber(1)
  set phase(ConfigApplyPhase value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPhase() => $_has(0);
  @$pb.TagNumber(1)
  void clearPhase() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get attemptedRevision => $_getSZ(1);
  @$pb.TagNumber(2)
  set attemptedRevision($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAttemptedRevision() => $_has(1);
  @$pb.TagNumber(2)
  void clearAttemptedRevision() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get desiredRevision => $_getSZ(2);
  @$pb.TagNumber(3)
  set desiredRevision($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDesiredRevision() => $_has(2);
  @$pb.TagNumber(3)
  void clearDesiredRevision() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get appliedRevision => $_getSZ(3);
  @$pb.TagNumber(4)
  set appliedRevision($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAppliedRevision() => $_has(3);
  @$pb.TagNumber(4)
  void clearAppliedRevision() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get errorMessage => $_getSZ(4);
  @$pb.TagNumber(5)
  set errorMessage($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasErrorMessage() => $_has(4);
  @$pb.TagNumber(5)
  void clearErrorMessage() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get running => $_getBF(5);
  @$pb.TagNumber(6)
  set running($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRunning() => $_has(5);
  @$pb.TagNumber(6)
  void clearRunning() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<SelectorState> get selectors => $_getList(6);

  @$pb.TagNumber(8)
  $pb.PbList<ServiceRouteState> get serviceRoutes => $_getList(7);

  @$pb.TagNumber(9)
  $pb.PbList<ServiceBindingState> get serviceBindings => $_getList(8);

  @$pb.TagNumber(10)
  $core.String get nodePoolRevision => $_getSZ(9);
  @$pb.TagNumber(10)
  set nodePoolRevision($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasNodePoolRevision() => $_has(9);
  @$pb.TagNumber(10)
  void clearNodePoolRevision() => $_clearField(10);
}

class TestOutboundRequest extends $pb.GeneratedMessage {
  factory TestOutboundRequest({
    $core.String? outboundTag,
    $core.int? timeoutMilliseconds,
  }) {
    final result = create();
    if (outboundTag != null) result.outboundTag = outboundTag;
    if (timeoutMilliseconds != null)
      result.timeoutMilliseconds = timeoutMilliseconds;
    return result;
  }

  TestOutboundRequest._();

  factory TestOutboundRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TestOutboundRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TestOutboundRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'outboundTag')
    ..aI(2, _omitFieldNames ? '' : 'timeoutMilliseconds',
        fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TestOutboundRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TestOutboundRequest copyWith(void Function(TestOutboundRequest) updates) =>
      super.copyWith((message) => updates(message as TestOutboundRequest))
          as TestOutboundRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TestOutboundRequest create() => TestOutboundRequest._();
  @$core.override
  TestOutboundRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TestOutboundRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TestOutboundRequest>(create);
  static TestOutboundRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get outboundTag => $_getSZ(0);
  @$pb.TagNumber(1)
  set outboundTag($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOutboundTag() => $_has(0);
  @$pb.TagNumber(1)
  void clearOutboundTag() => $_clearField(1);

  /// Zero uses the server default. Values above 60 seconds are rejected.
  @$pb.TagNumber(2)
  $core.int get timeoutMilliseconds => $_getIZ(1);
  @$pb.TagNumber(2)
  set timeoutMilliseconds($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTimeoutMilliseconds() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimeoutMilliseconds() => $_clearField(2);
}

class TestOutboundsRequest extends $pb.GeneratedMessage {
  factory TestOutboundsRequest({
    $core.Iterable<$core.String>? outboundTags,
    $core.int? timeoutMilliseconds,
    $core.int? maxConcurrency,
  }) {
    final result = create();
    if (outboundTags != null) result.outboundTags.addAll(outboundTags);
    if (timeoutMilliseconds != null)
      result.timeoutMilliseconds = timeoutMilliseconds;
    if (maxConcurrency != null) result.maxConcurrency = maxConcurrency;
    return result;
  }

  TestOutboundsRequest._();

  factory TestOutboundsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TestOutboundsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TestOutboundsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'outboundTags')
    ..aI(2, _omitFieldNames ? '' : 'timeoutMilliseconds',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(3, _omitFieldNames ? '' : 'maxConcurrency',
        fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TestOutboundsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TestOutboundsRequest copyWith(void Function(TestOutboundsRequest) updates) =>
      super.copyWith((message) => updates(message as TestOutboundsRequest))
          as TestOutboundsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TestOutboundsRequest create() => TestOutboundsRequest._();
  @$core.override
  TestOutboundsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TestOutboundsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TestOutboundsRequest>(create);
  static TestOutboundsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get outboundTags => $_getList(0);

  /// Zero uses the server default. Values above 60 seconds are rejected.
  @$pb.TagNumber(2)
  $core.int get timeoutMilliseconds => $_getIZ(1);
  @$pb.TagNumber(2)
  set timeoutMilliseconds($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTimeoutMilliseconds() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimeoutMilliseconds() => $_clearField(2);

  /// Number of URLTest groups tested concurrently. Zero uses the server
  /// default; the server caps this at four.
  @$pb.TagNumber(3)
  $core.int get maxConcurrency => $_getIZ(2);
  @$pb.TagNumber(3)
  set maxConcurrency($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMaxConcurrency() => $_has(2);
  @$pb.TagNumber(3)
  void clearMaxConcurrency() => $_clearField(3);
}

class LatencyTestResult extends $pb.GeneratedMessage {
  factory LatencyTestResult({
    $core.String? outboundTag,
    LatencyTestStatus? status,
    $core.int? delayMilliseconds,
    $fixnum.Int64? testedAtUnixMs,
    $core.String? errorMessage,
  }) {
    final result = create();
    if (outboundTag != null) result.outboundTag = outboundTag;
    if (status != null) result.status = status;
    if (delayMilliseconds != null) result.delayMilliseconds = delayMilliseconds;
    if (testedAtUnixMs != null) result.testedAtUnixMs = testedAtUnixMs;
    if (errorMessage != null) result.errorMessage = errorMessage;
    return result;
  }

  LatencyTestResult._();

  factory LatencyTestResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LatencyTestResult.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LatencyTestResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'outboundTag')
    ..aE<LatencyTestStatus>(2, _omitFieldNames ? '' : 'status',
        enumValues: LatencyTestStatus.values)
    ..aI(3, _omitFieldNames ? '' : 'delayMilliseconds',
        fieldType: $pb.PbFieldType.OU3)
    ..aInt64(4, _omitFieldNames ? '' : 'testedAtUnixMs')
    ..aOS(5, _omitFieldNames ? '' : 'errorMessage')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LatencyTestResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LatencyTestResult copyWith(void Function(LatencyTestResult) updates) =>
      super.copyWith((message) => updates(message as LatencyTestResult))
          as LatencyTestResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LatencyTestResult create() => LatencyTestResult._();
  @$core.override
  LatencyTestResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LatencyTestResult getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LatencyTestResult>(create);
  static LatencyTestResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get outboundTag => $_getSZ(0);
  @$pb.TagNumber(1)
  set outboundTag($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOutboundTag() => $_has(0);
  @$pb.TagNumber(1)
  void clearOutboundTag() => $_clearField(1);

  @$pb.TagNumber(2)
  LatencyTestStatus get status => $_getN(1);
  @$pb.TagNumber(2)
  set status(LatencyTestStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get delayMilliseconds => $_getIZ(2);
  @$pb.TagNumber(3)
  set delayMilliseconds($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDelayMilliseconds() => $_has(2);
  @$pb.TagNumber(3)
  void clearDelayMilliseconds() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get testedAtUnixMs => $_getI64(3);
  @$pb.TagNumber(4)
  set testedAtUnixMs($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTestedAtUnixMs() => $_has(3);
  @$pb.TagNumber(4)
  void clearTestedAtUnixMs() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get errorMessage => $_getSZ(4);
  @$pb.TagNumber(5)
  set errorMessage($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasErrorMessage() => $_has(4);
  @$pb.TagNumber(5)
  void clearErrorMessage() => $_clearField(5);
}

class ResolvedEndpoints extends $pb.GeneratedMessage {
  factory ResolvedEndpoints({
    $core.Iterable<$core.String>? addresses,
  }) {
    final result = create();
    if (addresses != null) result.addresses.addAll(addresses);
    return result;
  }

  ResolvedEndpoints._();

  factory ResolvedEndpoints.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResolvedEndpoints.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResolvedEndpoints',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'addresses')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolvedEndpoints clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolvedEndpoints copyWith(void Function(ResolvedEndpoints) updates) =>
      super.copyWith((message) => updates(message as ResolvedEndpoints))
          as ResolvedEndpoints;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResolvedEndpoints create() => ResolvedEndpoints._();
  @$core.override
  ResolvedEndpoints createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResolvedEndpoints getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResolvedEndpoints>(create);
  static ResolvedEndpoints? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get addresses => $_getList(0);
}

class IpInfoResponse extends $pb.GeneratedMessage {
  factory IpInfoResponse({
    $core.String? ip,
    $core.String? country,
    $core.String? countryCode,
    $core.String? city,
    $core.String? isp,
    $core.String? org,
    $core.String? asName,
  }) {
    final result = create();
    if (ip != null) result.ip = ip;
    if (country != null) result.country = country;
    if (countryCode != null) result.countryCode = countryCode;
    if (city != null) result.city = city;
    if (isp != null) result.isp = isp;
    if (org != null) result.org = org;
    if (asName != null) result.asName = asName;
    return result;
  }

  IpInfoResponse._();

  factory IpInfoResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IpInfoResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IpInfoResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'ip')
    ..aOS(2, _omitFieldNames ? '' : 'country')
    ..aOS(3, _omitFieldNames ? '' : 'countryCode')
    ..aOS(4, _omitFieldNames ? '' : 'city')
    ..aOS(5, _omitFieldNames ? '' : 'isp')
    ..aOS(6, _omitFieldNames ? '' : 'org')
    ..aOS(7, _omitFieldNames ? '' : 'asName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IpInfoResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IpInfoResponse copyWith(void Function(IpInfoResponse) updates) =>
      super.copyWith((message) => updates(message as IpInfoResponse))
          as IpInfoResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IpInfoResponse create() => IpInfoResponse._();
  @$core.override
  IpInfoResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IpInfoResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IpInfoResponse>(create);
  static IpInfoResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get ip => $_getSZ(0);
  @$pb.TagNumber(1)
  set ip($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIp() => $_has(0);
  @$pb.TagNumber(1)
  void clearIp() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get country => $_getSZ(1);
  @$pb.TagNumber(2)
  set country($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCountry() => $_has(1);
  @$pb.TagNumber(2)
  void clearCountry() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get countryCode => $_getSZ(2);
  @$pb.TagNumber(3)
  set countryCode($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCountryCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearCountryCode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get city => $_getSZ(3);
  @$pb.TagNumber(4)
  set city($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCity() => $_has(3);
  @$pb.TagNumber(4)
  void clearCity() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get isp => $_getSZ(4);
  @$pb.TagNumber(5)
  set isp($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIsp() => $_has(4);
  @$pb.TagNumber(5)
  void clearIsp() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get org => $_getSZ(5);
  @$pb.TagNumber(6)
  set org($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasOrg() => $_has(5);
  @$pb.TagNumber(6)
  void clearOrg() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get asName => $_getSZ(6);
  @$pb.TagNumber(7)
  set asName($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAsName() => $_has(6);
  @$pb.TagNumber(7)
  void clearAsName() => $_clearField(7);
}

class SubscriptionEvent extends $pb.GeneratedMessage {
  factory SubscriptionEvent({
    SubscriptionEventType? type,
    SubscriptionView? subscription,
    $fixnum.Int64? occurredAtUnixMs,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (subscription != null) result.subscription = subscription;
    if (occurredAtUnixMs != null) result.occurredAtUnixMs = occurredAtUnixMs;
    return result;
  }

  SubscriptionEvent._();

  factory SubscriptionEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SubscriptionEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubscriptionEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: create)
    ..aE<SubscriptionEventType>(1, _omitFieldNames ? '' : 'type',
        enumValues: SubscriptionEventType.values)
    ..aOM<SubscriptionView>(2, _omitFieldNames ? '' : 'subscription',
        subBuilder: SubscriptionView.create)
    ..aInt64(3, _omitFieldNames ? '' : 'occurredAtUnixMs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubscriptionEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubscriptionEvent copyWith(void Function(SubscriptionEvent) updates) =>
      super.copyWith((message) => updates(message as SubscriptionEvent))
          as SubscriptionEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubscriptionEvent create() => SubscriptionEvent._();
  @$core.override
  SubscriptionEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SubscriptionEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubscriptionEvent>(create);
  static SubscriptionEvent? _defaultInstance;

  @$pb.TagNumber(1)
  SubscriptionEventType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(SubscriptionEventType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  SubscriptionView get subscription => $_getN(1);
  @$pb.TagNumber(2)
  set subscription(SubscriptionView value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSubscription() => $_has(1);
  @$pb.TagNumber(2)
  void clearSubscription() => $_clearField(2);
  @$pb.TagNumber(2)
  SubscriptionView ensureSubscription() => $_ensure(1);

  @$pb.TagNumber(3)
  $fixnum.Int64 get occurredAtUnixMs => $_getI64(2);
  @$pb.TagNumber(3)
  set occurredAtUnixMs($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOccurredAtUnixMs() => $_has(2);
  @$pb.TagNumber(3)
  void clearOccurredAtUnixMs() => $_clearField(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
