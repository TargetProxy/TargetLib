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
    final result = LogMessage._();
    if (level != null) result.level = level;
    if (message != null) result.message = message;
    return result;
  }

  LogMessage._();

  factory LogMessage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LogMessage()..mergeFromBuffer(data, registry);
  factory LogMessage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LogMessage()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LogMessage',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: LogMessage.$_createMessage)
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
  @$core.Deprecated('Use LogMessage() / LogMessage.new instead')
  static LogMessage create() => LogMessage._();
  static $pb.GeneratedMessage $_createMessage() => LogMessage._();
  @$core.override
  LogMessage createEmptyInstance() => LogMessage._();
  @$core.pragma('dart2js:noInline')
  static LogMessage getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LogMessage>(LogMessage.$_createMessage);
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
    final result = LogBatch._();
    if (messages != null) result.messages.addAll(messages);
    if (reset != null) result.reset = reset;
    return result;
  }

  LogBatch._();

  factory LogBatch.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LogBatch()..mergeFromBuffer(data, registry);
  factory LogBatch.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LogBatch()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LogBatch',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: LogBatch.$_createMessage)
    ..pPM<LogMessage>(1, _omitFieldNames ? '' : 'messages',
        subBuilder: LogMessage.$_createMessage)
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
  @$core.Deprecated('Use LogBatch() / LogBatch.new instead')
  static LogBatch create() => LogBatch._();
  static $pb.GeneratedMessage $_createMessage() => LogBatch._();
  @$core.override
  LogBatch createEmptyInstance() => LogBatch._();
  @$core.pragma('dart2js:noInline')
  static LogBatch getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LogBatch>(LogBatch.$_createMessage);
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

class CloseConnectionRequest extends $pb.GeneratedMessage {
  factory CloseConnectionRequest({
    $core.String? id,
  }) {
    final result = CloseConnectionRequest._();
    if (id != null) result.id = id;
    return result;
  }

  CloseConnectionRequest._();

  factory CloseConnectionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CloseConnectionRequest()..mergeFromBuffer(data, registry);
  factory CloseConnectionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CloseConnectionRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CloseConnectionRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: CloseConnectionRequest.$_createMessage)
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
  @$core.Deprecated(
      'Use CloseConnectionRequest() / CloseConnectionRequest.new instead')
  static CloseConnectionRequest create() => CloseConnectionRequest._();
  static $pb.GeneratedMessage $_createMessage() => CloseConnectionRequest._();
  @$core.override
  CloseConnectionRequest createEmptyInstance() => CloseConnectionRequest._();
  @$core.pragma('dart2js:noInline')
  static CloseConnectionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CloseConnectionRequest>(
          CloseConnectionRequest.$_createMessage);
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

class OperationResponse extends $pb.GeneratedMessage {
  factory OperationResponse({
    ServiceState? state,
  }) {
    final result = OperationResponse._();
    if (state != null) result.state = state;
    return result;
  }

  OperationResponse._();

  factory OperationResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OperationResponse()..mergeFromBuffer(data, registry);
  factory OperationResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OperationResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OperationResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: OperationResponse.$_createMessage)
    ..aOM<ServiceState>(1, _omitFieldNames ? '' : 'state',
        subBuilder: ServiceState.$_createMessage)
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
  @$core.Deprecated('Use OperationResponse() / OperationResponse.new instead')
  static OperationResponse create() => OperationResponse._();
  static $pb.GeneratedMessage $_createMessage() => OperationResponse._();
  @$core.override
  OperationResponse createEmptyInstance() => OperationResponse._();
  @$core.pragma('dart2js:noInline')
  static OperationResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OperationResponse>(
          OperationResponse.$_createMessage);
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
    final result = ServiceState._();
    if (state != null) result.state = state;
    if (errorMessage != null) result.errorMessage = errorMessage;
    if (changedAtUnixMs != null) result.changedAtUnixMs = changedAtUnixMs;
    return result;
  }

  ServiceState._();

  factory ServiceState.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ServiceState()..mergeFromBuffer(data, registry);
  factory ServiceState.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ServiceState()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServiceState',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: ServiceState.$_createMessage)
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
  @$core.Deprecated('Use ServiceState() / ServiceState.new instead')
  static ServiceState create() => ServiceState._();
  static $pb.GeneratedMessage $_createMessage() => ServiceState._();
  @$core.override
  ServiceState createEmptyInstance() => ServiceState._();
  @$core.pragma('dart2js:noInline')
  static ServiceState getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ServiceState>(
          ServiceState.$_createMessage);
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
    final result = TrafficRequest._();
    if (intervalMilliseconds != null)
      result.intervalMilliseconds = intervalMilliseconds;
    return result;
  }

  TrafficRequest._();

  factory TrafficRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TrafficRequest()..mergeFromBuffer(data, registry);
  factory TrafficRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TrafficRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TrafficRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: TrafficRequest.$_createMessage)
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
  @$core.Deprecated('Use TrafficRequest() / TrafficRequest.new instead')
  static TrafficRequest create() => TrafficRequest._();
  static $pb.GeneratedMessage $_createMessage() => TrafficRequest._();
  @$core.override
  TrafficRequest createEmptyInstance() => TrafficRequest._();
  @$core.pragma('dart2js:noInline')
  static TrafficRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TrafficRequest>(
          TrafficRequest.$_createMessage);
  static TrafficRequest? _defaultInstance;

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
    final result = TrafficStatus._();
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
      TrafficStatus()..mergeFromBuffer(data, registry);
  factory TrafficStatus.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TrafficStatus()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TrafficStatus',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: TrafficStatus.$_createMessage)
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
  @$core.Deprecated('Use TrafficStatus() / TrafficStatus.new instead')
  static TrafficStatus create() => TrafficStatus._();
  static $pb.GeneratedMessage $_createMessage() => TrafficStatus._();
  @$core.override
  TrafficStatus createEmptyInstance() => TrafficStatus._();
  @$core.pragma('dart2js:noInline')
  static TrafficStatus getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TrafficStatus>(
          TrafficStatus.$_createMessage);
  static TrafficStatus? _defaultInstance;

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
    final result = SubscriptionId._();
    if (id != null) result.id = id;
    return result;
  }

  SubscriptionId._();

  factory SubscriptionId.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SubscriptionId()..mergeFromBuffer(data, registry);
  factory SubscriptionId.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SubscriptionId()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubscriptionId',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: SubscriptionId.$_createMessage)
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
  @$core.Deprecated('Use SubscriptionId() / SubscriptionId.new instead')
  static SubscriptionId create() => SubscriptionId._();
  static $pb.GeneratedMessage $_createMessage() => SubscriptionId._();
  @$core.override
  SubscriptionId createEmptyInstance() => SubscriptionId._();
  @$core.pragma('dart2js:noInline')
  static SubscriptionId getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SubscriptionId>(
          SubscriptionId.$_createMessage);
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
    final result = AddSubscriptionRequest._();
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
      AddSubscriptionRequest()..mergeFromBuffer(data, registry);
  factory AddSubscriptionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AddSubscriptionRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddSubscriptionRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: AddSubscriptionRequest.$_createMessage)
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
  @$core.Deprecated(
      'Use AddSubscriptionRequest() / AddSubscriptionRequest.new instead')
  static AddSubscriptionRequest create() => AddSubscriptionRequest._();
  static $pb.GeneratedMessage $_createMessage() => AddSubscriptionRequest._();
  @$core.override
  AddSubscriptionRequest createEmptyInstance() => AddSubscriptionRequest._();
  @$core.pragma('dart2js:noInline')
  static AddSubscriptionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddSubscriptionRequest>(
          AddSubscriptionRequest.$_createMessage);
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
    final result = RenameSubscriptionRequest._();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    return result;
  }

  RenameSubscriptionRequest._();

  factory RenameSubscriptionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RenameSubscriptionRequest()..mergeFromBuffer(data, registry);
  factory RenameSubscriptionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RenameSubscriptionRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RenameSubscriptionRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: RenameSubscriptionRequest.$_createMessage)
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
  @$core.Deprecated(
      'Use RenameSubscriptionRequest() / RenameSubscriptionRequest.new instead')
  static RenameSubscriptionRequest create() => RenameSubscriptionRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      RenameSubscriptionRequest._();
  @$core.override
  RenameSubscriptionRequest createEmptyInstance() =>
      RenameSubscriptionRequest._();
  @$core.pragma('dart2js:noInline')
  static RenameSubscriptionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RenameSubscriptionRequest>(
          RenameSubscriptionRequest.$_createMessage);
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
    final result = SetSubscriptionEnabledRequest._();
    if (id != null) result.id = id;
    if (enabled != null) result.enabled = enabled;
    return result;
  }

  SetSubscriptionEnabledRequest._();

  factory SetSubscriptionEnabledRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetSubscriptionEnabledRequest()..mergeFromBuffer(data, registry);
  factory SetSubscriptionEnabledRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetSubscriptionEnabledRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetSubscriptionEnabledRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: SetSubscriptionEnabledRequest.$_createMessage)
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
  @$core.Deprecated(
      'Use SetSubscriptionEnabledRequest() / SetSubscriptionEnabledRequest.new instead')
  static SetSubscriptionEnabledRequest create() =>
      SetSubscriptionEnabledRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SetSubscriptionEnabledRequest._();
  @$core.override
  SetSubscriptionEnabledRequest createEmptyInstance() =>
      SetSubscriptionEnabledRequest._();
  @$core.pragma('dart2js:noInline')
  static SetSubscriptionEnabledRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetSubscriptionEnabledRequest>(
          SetSubscriptionEnabledRequest.$_createMessage);
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
    final result = ConfigureSubscriptionUpdatesRequest._();
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
      ConfigureSubscriptionUpdatesRequest()..mergeFromBuffer(data, registry);
  factory ConfigureSubscriptionUpdatesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ConfigureSubscriptionUpdatesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConfigureSubscriptionUpdatesRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: ConfigureSubscriptionUpdatesRequest.$_createMessage)
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
  @$core.Deprecated(
      'Use ConfigureSubscriptionUpdatesRequest() / ConfigureSubscriptionUpdatesRequest.new instead')
  static ConfigureSubscriptionUpdatesRequest create() =>
      ConfigureSubscriptionUpdatesRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ConfigureSubscriptionUpdatesRequest._();
  @$core.override
  ConfigureSubscriptionUpdatesRequest createEmptyInstance() =>
      ConfigureSubscriptionUpdatesRequest._();
  @$core.pragma('dart2js:noInline')
  static ConfigureSubscriptionUpdatesRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              ConfigureSubscriptionUpdatesRequest>(
          ConfigureSubscriptionUpdatesRequest.$_createMessage);
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
    final result = ResolvedEndpointsRequest._();
    if (enabledOnly != null) result.enabledOnly = enabledOnly;
    return result;
  }

  ResolvedEndpointsRequest._();

  factory ResolvedEndpointsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ResolvedEndpointsRequest()..mergeFromBuffer(data, registry);
  factory ResolvedEndpointsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ResolvedEndpointsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResolvedEndpointsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: ResolvedEndpointsRequest.$_createMessage)
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
  @$core.Deprecated(
      'Use ResolvedEndpointsRequest() / ResolvedEndpointsRequest.new instead')
  static ResolvedEndpointsRequest create() => ResolvedEndpointsRequest._();
  static $pb.GeneratedMessage $_createMessage() => ResolvedEndpointsRequest._();
  @$core.override
  ResolvedEndpointsRequest createEmptyInstance() =>
      ResolvedEndpointsRequest._();
  @$core.pragma('dart2js:noInline')
  static ResolvedEndpointsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResolvedEndpointsRequest>(
          ResolvedEndpointsRequest.$_createMessage);
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
    final result = SubscriptionList._();
    if (subscriptions != null) result.subscriptions.addAll(subscriptions);
    return result;
  }

  SubscriptionList._();

  factory SubscriptionList.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SubscriptionList()..mergeFromBuffer(data, registry);
  factory SubscriptionList.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SubscriptionList()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubscriptionList',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: SubscriptionList.$_createMessage)
    ..pPM<SubscriptionView>(1, _omitFieldNames ? '' : 'subscriptions',
        subBuilder: SubscriptionView.$_createMessage)
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
  @$core.Deprecated('Use SubscriptionList() / SubscriptionList.new instead')
  static SubscriptionList create() => SubscriptionList._();
  static $pb.GeneratedMessage $_createMessage() => SubscriptionList._();
  @$core.override
  SubscriptionList createEmptyInstance() => SubscriptionList._();
  @$core.pragma('dart2js:noInline')
  static SubscriptionList getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SubscriptionList>(
          SubscriptionList.$_createMessage);
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
    final result = SubscriptionView._();
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
      SubscriptionView()..mergeFromBuffer(data, registry);
  factory SubscriptionView.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SubscriptionView()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubscriptionView',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: SubscriptionView.$_createMessage)
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
        subBuilder: ProfileView.$_createMessage)
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
  @$core.Deprecated('Use SubscriptionView() / SubscriptionView.new instead')
  static SubscriptionView create() => SubscriptionView._();
  static $pb.GeneratedMessage $_createMessage() => SubscriptionView._();
  @$core.override
  SubscriptionView createEmptyInstance() => SubscriptionView._();
  @$core.pragma('dart2js:noInline')
  static SubscriptionView getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SubscriptionView>(
          SubscriptionView.$_createMessage);
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
    final result = ProfileView._();
    if (nodes != null) result.nodes.addAll(nodes);
    return result;
  }

  ProfileView._();

  factory ProfileView.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProfileView()..mergeFromBuffer(data, registry);
  factory ProfileView.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProfileView()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProfileView',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: ProfileView.$_createMessage)
    ..pPM<ProfileNode>(1, _omitFieldNames ? '' : 'nodes',
        subBuilder: ProfileNode.$_createMessage)
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
  @$core.Deprecated('Use ProfileView() / ProfileView.new instead')
  static ProfileView create() => ProfileView._();
  static $pb.GeneratedMessage $_createMessage() => ProfileView._();
  @$core.override
  ProfileView createEmptyInstance() => ProfileView._();
  @$core.pragma('dart2js:noInline')
  static ProfileView getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ProfileView>(
          ProfileView.$_createMessage);
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
    final result = ProfileNode._();
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
      ProfileNode()..mergeFromBuffer(data, registry);
  factory ProfileNode.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProfileNode()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProfileNode',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: ProfileNode.$_createMessage)
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
  @$core.Deprecated('Use ProfileNode() / ProfileNode.new instead')
  static ProfileNode create() => ProfileNode._();
  static $pb.GeneratedMessage $_createMessage() => ProfileNode._();
  @$core.override
  ProfileNode createEmptyInstance() => ProfileNode._();
  @$core.pragma('dart2js:noInline')
  static ProfileNode getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ProfileNode>(
          ProfileNode.$_createMessage);
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
    final result = SubscriptionUpdateResult._();
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
      SubscriptionUpdateResult()..mergeFromBuffer(data, registry);
  factory SubscriptionUpdateResult.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SubscriptionUpdateResult()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubscriptionUpdateResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: SubscriptionUpdateResult.$_createMessage)
    ..aOM<SubscriptionView>(1, _omitFieldNames ? '' : 'subscription',
        subBuilder: SubscriptionView.$_createMessage)
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
  @$core.Deprecated(
      'Use SubscriptionUpdateResult() / SubscriptionUpdateResult.new instead')
  static SubscriptionUpdateResult create() => SubscriptionUpdateResult._();
  static $pb.GeneratedMessage $_createMessage() => SubscriptionUpdateResult._();
  @$core.override
  SubscriptionUpdateResult createEmptyInstance() =>
      SubscriptionUpdateResult._();
  @$core.pragma('dart2js:noInline')
  static SubscriptionUpdateResult getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubscriptionUpdateResult>(
          SubscriptionUpdateResult.$_createMessage);
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
    final result = RuntimeSettings._();
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
      RuntimeSettings()..mergeFromBuffer(data, registry);
  factory RuntimeSettings.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RuntimeSettings()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RuntimeSettings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: RuntimeSettings.$_createMessage)
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
  @$core.Deprecated('Use RuntimeSettings() / RuntimeSettings.new instead')
  static RuntimeSettings create() => RuntimeSettings._();
  static $pb.GeneratedMessage $_createMessage() => RuntimeSettings._();
  @$core.override
  RuntimeSettings createEmptyInstance() => RuntimeSettings._();
  @$core.pragma('dart2js:noInline')
  static RuntimeSettings getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RuntimeSettings>(
          RuntimeSettings.$_createMessage);
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
    final result = RuntimeConfig._();
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
      RuntimeConfig()..mergeFromBuffer(data, registry);
  factory RuntimeConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RuntimeConfig()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RuntimeConfig',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: RuntimeConfig.$_createMessage)
    ..aOM<RuntimeSettings>(1, _omitFieldNames ? '' : 'settings',
        subBuilder: RuntimeSettings.$_createMessage)
    ..pPM<SelectorConfig>(2, _omitFieldNames ? '' : 'selectors',
        subBuilder: SelectorConfig.$_createMessage)
    ..pPM<ServiceRoute>(3, _omitFieldNames ? '' : 'serviceRoutes',
        subBuilder: ServiceRoute.$_createMessage)
    ..pPM<ServiceBinding>(4, _omitFieldNames ? '' : 'serviceBindings',
        subBuilder: ServiceBinding.$_createMessage)
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
  @$core.Deprecated('Use RuntimeConfig() / RuntimeConfig.new instead')
  static RuntimeConfig create() => RuntimeConfig._();
  static $pb.GeneratedMessage $_createMessage() => RuntimeConfig._();
  @$core.override
  RuntimeConfig createEmptyInstance() => RuntimeConfig._();
  @$core.pragma('dart2js:noInline')
  static RuntimeConfig getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RuntimeConfig>(
          RuntimeConfig.$_createMessage);
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
    $core.String? expectedRevision,
  }) {
    final result = UpdateRuntimeConfigRequest._();
    if (settings != null) result.settings = settings;
    if (expectedRevision != null) result.expectedRevision = expectedRevision;
    return result;
  }

  UpdateRuntimeConfigRequest._();

  factory UpdateRuntimeConfigRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateRuntimeConfigRequest()..mergeFromBuffer(data, registry);
  factory UpdateRuntimeConfigRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateRuntimeConfigRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateRuntimeConfigRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: UpdateRuntimeConfigRequest.$_createMessage)
    ..aOM<RuntimeSettings>(1, _omitFieldNames ? '' : 'settings',
        subBuilder: RuntimeSettings.$_createMessage)
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
  @$core.Deprecated(
      'Use UpdateRuntimeConfigRequest() / UpdateRuntimeConfigRequest.new instead')
  static UpdateRuntimeConfigRequest create() => UpdateRuntimeConfigRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      UpdateRuntimeConfigRequest._();
  @$core.override
  UpdateRuntimeConfigRequest createEmptyInstance() =>
      UpdateRuntimeConfigRequest._();
  @$core.pragma('dart2js:noInline')
  static UpdateRuntimeConfigRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateRuntimeConfigRequest>(
          UpdateRuntimeConfigRequest.$_createMessage);
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

  @$pb.TagNumber(3)
  $core.String get expectedRevision => $_getSZ(1);
  @$pb.TagNumber(3)
  set expectedRevision($core.String value) => $_setString(1, value);
  @$pb.TagNumber(3)
  $core.bool hasExpectedRevision() => $_has(1);
  @$pb.TagNumber(3)
  void clearExpectedRevision() => $_clearField(3);
}

class SelectorConfig extends $pb.GeneratedMessage {
  factory SelectorConfig({
    $core.String? tag,
    $core.Iterable<$core.String>? nodeIds,
    $core.String? selectedNodeId,
  }) {
    final result = SelectorConfig._();
    if (tag != null) result.tag = tag;
    if (nodeIds != null) result.nodeIds.addAll(nodeIds);
    if (selectedNodeId != null) result.selectedNodeId = selectedNodeId;
    return result;
  }

  SelectorConfig._();

  factory SelectorConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SelectorConfig()..mergeFromBuffer(data, registry);
  factory SelectorConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SelectorConfig()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SelectorConfig',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: SelectorConfig.$_createMessage)
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
  @$core.Deprecated('Use SelectorConfig() / SelectorConfig.new instead')
  static SelectorConfig create() => SelectorConfig._();
  static $pb.GeneratedMessage $_createMessage() => SelectorConfig._();
  @$core.override
  SelectorConfig createEmptyInstance() => SelectorConfig._();
  @$core.pragma('dart2js:noInline')
  static SelectorConfig getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SelectorConfig>(
          SelectorConfig.$_createMessage);
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
    final result = ServiceRoute._();
    if (serviceId != null) result.serviceId = serviceId;
    if (domains != null) result.domains.addAll(domains);
    if (selectorTag != null) result.selectorTag = selectorTag;
    if (enabled != null) result.enabled = enabled;
    return result;
  }

  ServiceRoute._();

  factory ServiceRoute.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ServiceRoute()..mergeFromBuffer(data, registry);
  factory ServiceRoute.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ServiceRoute()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServiceRoute',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: ServiceRoute.$_createMessage)
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
  @$core.Deprecated('Use ServiceRoute() / ServiceRoute.new instead')
  static ServiceRoute create() => ServiceRoute._();
  static $pb.GeneratedMessage $_createMessage() => ServiceRoute._();
  @$core.override
  ServiceRoute createEmptyInstance() => ServiceRoute._();
  @$core.pragma('dart2js:noInline')
  static ServiceRoute getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ServiceRoute>(
          ServiceRoute.$_createMessage);
  static ServiceRoute? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServiceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServiceId() => $_clearField(1);

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
    final result = ServiceBinding._();
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
      ServiceBinding()..mergeFromBuffer(data, registry);
  factory ServiceBinding.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ServiceBinding()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServiceBinding',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: ServiceBinding.$_createMessage)
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
  @$core.Deprecated('Use ServiceBinding() / ServiceBinding.new instead')
  static ServiceBinding create() => ServiceBinding._();
  static $pb.GeneratedMessage $_createMessage() => ServiceBinding._();
  @$core.override
  ServiceBinding createEmptyInstance() => ServiceBinding._();
  @$core.pragma('dart2js:noInline')
  static ServiceBinding getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ServiceBinding>(
          ServiceBinding.$_createMessage);
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
    final result = RuntimeModel._();
    if (selectors != null) result.selectors.addAll(selectors);
    if (serviceRoutes != null) result.serviceRoutes.addAll(serviceRoutes);
    if (serviceBindings != null) result.serviceBindings.addAll(serviceBindings);
    return result;
  }

  RuntimeModel._();

  factory RuntimeModel.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RuntimeModel()..mergeFromBuffer(data, registry);
  factory RuntimeModel.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RuntimeModel()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RuntimeModel',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: RuntimeModel.$_createMessage)
    ..pPM<SelectorConfig>(1, _omitFieldNames ? '' : 'selectors',
        subBuilder: SelectorConfig.$_createMessage)
    ..pPM<ServiceRoute>(2, _omitFieldNames ? '' : 'serviceRoutes',
        subBuilder: ServiceRoute.$_createMessage)
    ..pPM<ServiceBinding>(3, _omitFieldNames ? '' : 'serviceBindings',
        subBuilder: ServiceBinding.$_createMessage)
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
  @$core.Deprecated('Use RuntimeModel() / RuntimeModel.new instead')
  static RuntimeModel create() => RuntimeModel._();
  static $pb.GeneratedMessage $_createMessage() => RuntimeModel._();
  @$core.override
  RuntimeModel createEmptyInstance() => RuntimeModel._();
  @$core.pragma('dart2js:noInline')
  static RuntimeModel getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RuntimeModel>(
          RuntimeModel.$_createMessage);
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
    final result = NodePool._();
    if (revision != null) result.revision = revision;
    if (nodes != null) result.nodes.addAll(nodes);
    return result;
  }

  NodePool._();

  factory NodePool.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      NodePool()..mergeFromBuffer(data, registry);
  factory NodePool.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      NodePool()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NodePool',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: NodePool.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'revision')
    ..pPM<ProfileNode>(2, _omitFieldNames ? '' : 'nodes',
        subBuilder: ProfileNode.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NodePool clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NodePool copyWith(void Function(NodePool) updates) =>
      super.copyWith((message) => updates(message as NodePool)) as NodePool;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use NodePool() / NodePool.new instead')
  static NodePool create() => NodePool._();
  static $pb.GeneratedMessage $_createMessage() => NodePool._();
  @$core.override
  NodePool createEmptyInstance() => NodePool._();
  @$core.pragma('dart2js:noInline')
  static NodePool getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NodePool>(NodePool.$_createMessage);
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

/// Layer 1: Node Selection
class SelectNodeRequest extends $pb.GeneratedMessage {
  factory SelectNodeRequest({
    $core.String? nodeId,
  }) {
    final result = SelectNodeRequest._();
    if (nodeId != null) result.nodeId = nodeId;
    return result;
  }

  SelectNodeRequest._();

  factory SelectNodeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SelectNodeRequest()..mergeFromBuffer(data, registry);
  factory SelectNodeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SelectNodeRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SelectNodeRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: SelectNodeRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'nodeId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SelectNodeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SelectNodeRequest copyWith(void Function(SelectNodeRequest) updates) =>
      super.copyWith((message) => updates(message as SelectNodeRequest))
          as SelectNodeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SelectNodeRequest() / SelectNodeRequest.new instead')
  static SelectNodeRequest create() => SelectNodeRequest._();
  static $pb.GeneratedMessage $_createMessage() => SelectNodeRequest._();
  @$core.override
  SelectNodeRequest createEmptyInstance() => SelectNodeRequest._();
  @$core.pragma('dart2js:noInline')
  static SelectNodeRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SelectNodeRequest>(
          SelectNodeRequest.$_createMessage);
  static SelectNodeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get nodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set nodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNodeId() => $_clearField(1);
}

class SelectNodeResponse extends $pb.GeneratedMessage {
  factory SelectNodeResponse({
    $core.String? nodeId,
    $core.String? nodeName,
    $core.bool? appliedImmediately,
    $core.String? errorMessage,
  }) {
    final result = SelectNodeResponse._();
    if (nodeId != null) result.nodeId = nodeId;
    if (nodeName != null) result.nodeName = nodeName;
    if (appliedImmediately != null)
      result.appliedImmediately = appliedImmediately;
    if (errorMessage != null) result.errorMessage = errorMessage;
    return result;
  }

  SelectNodeResponse._();

  factory SelectNodeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SelectNodeResponse()..mergeFromBuffer(data, registry);
  factory SelectNodeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SelectNodeResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SelectNodeResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: SelectNodeResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'nodeId')
    ..aOS(2, _omitFieldNames ? '' : 'nodeName')
    ..aOB(3, _omitFieldNames ? '' : 'appliedImmediately')
    ..aOS(4, _omitFieldNames ? '' : 'errorMessage')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SelectNodeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SelectNodeResponse copyWith(void Function(SelectNodeResponse) updates) =>
      super.copyWith((message) => updates(message as SelectNodeResponse))
          as SelectNodeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SelectNodeResponse() / SelectNodeResponse.new instead')
  static SelectNodeResponse create() => SelectNodeResponse._();
  static $pb.GeneratedMessage $_createMessage() => SelectNodeResponse._();
  @$core.override
  SelectNodeResponse createEmptyInstance() => SelectNodeResponse._();
  @$core.pragma('dart2js:noInline')
  static SelectNodeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SelectNodeResponse>(
          SelectNodeResponse.$_createMessage);
  static SelectNodeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get nodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set nodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNodeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get nodeName => $_getSZ(1);
  @$pb.TagNumber(2)
  set nodeName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNodeName() => $_has(1);
  @$pb.TagNumber(2)
  void clearNodeName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get appliedImmediately => $_getBF(2);
  @$pb.TagNumber(3)
  set appliedImmediately($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAppliedImmediately() => $_has(2);
  @$pb.TagNumber(3)
  void clearAppliedImmediately() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get errorMessage => $_getSZ(3);
  @$pb.TagNumber(4)
  set errorMessage($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasErrorMessage() => $_has(3);
  @$pb.TagNumber(4)
  void clearErrorMessage() => $_clearField(4);
}

class ProxyStatus extends $pb.GeneratedMessage {
  factory ProxyStatus({
    ServiceStateType? serviceState,
    $core.String? selectedNodeId,
    $core.String? selectedNodeName,
    $core.String? actualNodeId,
    $core.bool? effective,
    $fixnum.Int64? selectedAtUnixMs,
    $core.bool? nodeAvailable,
    $core.String? unavailableReason,
  }) {
    final result = ProxyStatus._();
    if (serviceState != null) result.serviceState = serviceState;
    if (selectedNodeId != null) result.selectedNodeId = selectedNodeId;
    if (selectedNodeName != null) result.selectedNodeName = selectedNodeName;
    if (actualNodeId != null) result.actualNodeId = actualNodeId;
    if (effective != null) result.effective = effective;
    if (selectedAtUnixMs != null) result.selectedAtUnixMs = selectedAtUnixMs;
    if (nodeAvailable != null) result.nodeAvailable = nodeAvailable;
    if (unavailableReason != null) result.unavailableReason = unavailableReason;
    return result;
  }

  ProxyStatus._();

  factory ProxyStatus.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProxyStatus()..mergeFromBuffer(data, registry);
  factory ProxyStatus.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProxyStatus()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProxyStatus',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: ProxyStatus.$_createMessage)
    ..aE<ServiceStateType>(1, _omitFieldNames ? '' : 'serviceState',
        enumValues: ServiceStateType.values)
    ..aOS(2, _omitFieldNames ? '' : 'selectedNodeId')
    ..aOS(3, _omitFieldNames ? '' : 'selectedNodeName')
    ..aOS(4, _omitFieldNames ? '' : 'actualNodeId')
    ..aOB(5, _omitFieldNames ? '' : 'effective')
    ..aInt64(6, _omitFieldNames ? '' : 'selectedAtUnixMs')
    ..aOB(7, _omitFieldNames ? '' : 'nodeAvailable')
    ..aOS(8, _omitFieldNames ? '' : 'unavailableReason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProxyStatus clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProxyStatus copyWith(void Function(ProxyStatus) updates) =>
      super.copyWith((message) => updates(message as ProxyStatus))
          as ProxyStatus;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ProxyStatus() / ProxyStatus.new instead')
  static ProxyStatus create() => ProxyStatus._();
  static $pb.GeneratedMessage $_createMessage() => ProxyStatus._();
  @$core.override
  ProxyStatus createEmptyInstance() => ProxyStatus._();
  @$core.pragma('dart2js:noInline')
  static ProxyStatus getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ProxyStatus>(
          ProxyStatus.$_createMessage);
  static ProxyStatus? _defaultInstance;

  @$pb.TagNumber(1)
  ServiceStateType get serviceState => $_getN(0);
  @$pb.TagNumber(1)
  set serviceState(ServiceStateType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasServiceState() => $_has(0);
  @$pb.TagNumber(1)
  void clearServiceState() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get selectedNodeId => $_getSZ(1);
  @$pb.TagNumber(2)
  set selectedNodeId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSelectedNodeId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSelectedNodeId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get selectedNodeName => $_getSZ(2);
  @$pb.TagNumber(3)
  set selectedNodeName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSelectedNodeName() => $_has(2);
  @$pb.TagNumber(3)
  void clearSelectedNodeName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get actualNodeId => $_getSZ(3);
  @$pb.TagNumber(4)
  set actualNodeId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasActualNodeId() => $_has(3);
  @$pb.TagNumber(4)
  void clearActualNodeId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get effective => $_getBF(4);
  @$pb.TagNumber(5)
  set effective($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasEffective() => $_has(4);
  @$pb.TagNumber(5)
  void clearEffective() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get selectedAtUnixMs => $_getI64(5);
  @$pb.TagNumber(6)
  set selectedAtUnixMs($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSelectedAtUnixMs() => $_has(5);
  @$pb.TagNumber(6)
  void clearSelectedAtUnixMs() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get nodeAvailable => $_getBF(6);
  @$pb.TagNumber(7)
  set nodeAvailable($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasNodeAvailable() => $_has(6);
  @$pb.TagNumber(7)
  void clearNodeAvailable() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get unavailableReason => $_getSZ(7);
  @$pb.TagNumber(8)
  set unavailableReason($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasUnavailableReason() => $_has(7);
  @$pb.TagNumber(8)
  void clearUnavailableReason() => $_clearField(8);
}

/// Layer 2: Rule-based Routing
class UpsertRouteRequest extends $pb.GeneratedMessage {
  factory UpsertRouteRequest({
    $core.String? serviceId,
    $core.String? displayName,
    $core.Iterable<$core.String>? domains,
    $core.String? nodeId,
    $core.bool? enabled,
  }) {
    final result = UpsertRouteRequest._();
    if (serviceId != null) result.serviceId = serviceId;
    if (displayName != null) result.displayName = displayName;
    if (domains != null) result.domains.addAll(domains);
    if (nodeId != null) result.nodeId = nodeId;
    if (enabled != null) result.enabled = enabled;
    return result;
  }

  UpsertRouteRequest._();

  factory UpsertRouteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpsertRouteRequest()..mergeFromBuffer(data, registry);
  factory UpsertRouteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpsertRouteRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpsertRouteRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: UpsertRouteRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'serviceId')
    ..aOS(2, _omitFieldNames ? '' : 'displayName')
    ..pPS(3, _omitFieldNames ? '' : 'domains')
    ..aOS(4, _omitFieldNames ? '' : 'nodeId')
    ..aOB(5, _omitFieldNames ? '' : 'enabled')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpsertRouteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpsertRouteRequest copyWith(void Function(UpsertRouteRequest) updates) =>
      super.copyWith((message) => updates(message as UpsertRouteRequest))
          as UpsertRouteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use UpsertRouteRequest() / UpsertRouteRequest.new instead')
  static UpsertRouteRequest create() => UpsertRouteRequest._();
  static $pb.GeneratedMessage $_createMessage() => UpsertRouteRequest._();
  @$core.override
  UpsertRouteRequest createEmptyInstance() => UpsertRouteRequest._();
  @$core.pragma('dart2js:noInline')
  static UpsertRouteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpsertRouteRequest>(
          UpsertRouteRequest.$_createMessage);
  static UpsertRouteRequest? _defaultInstance;

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
  $core.String get nodeId => $_getSZ(3);
  @$pb.TagNumber(4)
  set nodeId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNodeId() => $_has(3);
  @$pb.TagNumber(4)
  void clearNodeId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get enabled => $_getBF(4);
  @$pb.TagNumber(5)
  set enabled($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasEnabled() => $_has(4);
  @$pb.TagNumber(5)
  void clearEnabled() => $_clearField(5);
}

class RouteInfo extends $pb.GeneratedMessage {
  factory RouteInfo({
    $core.String? serviceId,
    $core.String? displayName,
    $core.Iterable<$core.String>? domains,
    $core.String? selectorTag,
    $core.String? currentNodeId,
    $core.String? currentNodeName,
    $core.bool? enabled,
    $core.bool? effective,
  }) {
    final result = RouteInfo._();
    if (serviceId != null) result.serviceId = serviceId;
    if (displayName != null) result.displayName = displayName;
    if (domains != null) result.domains.addAll(domains);
    if (selectorTag != null) result.selectorTag = selectorTag;
    if (currentNodeId != null) result.currentNodeId = currentNodeId;
    if (currentNodeName != null) result.currentNodeName = currentNodeName;
    if (enabled != null) result.enabled = enabled;
    if (effective != null) result.effective = effective;
    return result;
  }

  RouteInfo._();

  factory RouteInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RouteInfo()..mergeFromBuffer(data, registry);
  factory RouteInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RouteInfo()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RouteInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: RouteInfo.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'serviceId')
    ..aOS(2, _omitFieldNames ? '' : 'displayName')
    ..pPS(3, _omitFieldNames ? '' : 'domains')
    ..aOS(4, _omitFieldNames ? '' : 'selectorTag')
    ..aOS(5, _omitFieldNames ? '' : 'currentNodeId')
    ..aOS(6, _omitFieldNames ? '' : 'currentNodeName')
    ..aOB(7, _omitFieldNames ? '' : 'enabled')
    ..aOB(8, _omitFieldNames ? '' : 'effective')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RouteInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RouteInfo copyWith(void Function(RouteInfo) updates) =>
      super.copyWith((message) => updates(message as RouteInfo)) as RouteInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RouteInfo() / RouteInfo.new instead')
  static RouteInfo create() => RouteInfo._();
  static $pb.GeneratedMessage $_createMessage() => RouteInfo._();
  @$core.override
  RouteInfo createEmptyInstance() => RouteInfo._();
  @$core.pragma('dart2js:noInline')
  static RouteInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RouteInfo>(RouteInfo.$_createMessage);
  static RouteInfo? _defaultInstance;

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
  $core.String get selectorTag => $_getSZ(3);
  @$pb.TagNumber(4)
  set selectorTag($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSelectorTag() => $_has(3);
  @$pb.TagNumber(4)
  void clearSelectorTag() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get currentNodeId => $_getSZ(4);
  @$pb.TagNumber(5)
  set currentNodeId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCurrentNodeId() => $_has(4);
  @$pb.TagNumber(5)
  void clearCurrentNodeId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get currentNodeName => $_getSZ(5);
  @$pb.TagNumber(6)
  set currentNodeName($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCurrentNodeName() => $_has(5);
  @$pb.TagNumber(6)
  void clearCurrentNodeName() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get enabled => $_getBF(6);
  @$pb.TagNumber(7)
  set enabled($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasEnabled() => $_has(6);
  @$pb.TagNumber(7)
  void clearEnabled() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get effective => $_getBF(7);
  @$pb.TagNumber(8)
  set effective($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasEffective() => $_has(7);
  @$pb.TagNumber(8)
  void clearEffective() => $_clearField(8);
}

class DeleteRouteRequest extends $pb.GeneratedMessage {
  factory DeleteRouteRequest({
    $core.String? serviceId,
  }) {
    final result = DeleteRouteRequest._();
    if (serviceId != null) result.serviceId = serviceId;
    return result;
  }

  DeleteRouteRequest._();

  factory DeleteRouteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteRouteRequest()..mergeFromBuffer(data, registry);
  factory DeleteRouteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteRouteRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteRouteRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: DeleteRouteRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'serviceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteRouteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteRouteRequest copyWith(void Function(DeleteRouteRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteRouteRequest))
          as DeleteRouteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DeleteRouteRequest() / DeleteRouteRequest.new instead')
  static DeleteRouteRequest create() => DeleteRouteRequest._();
  static $pb.GeneratedMessage $_createMessage() => DeleteRouteRequest._();
  @$core.override
  DeleteRouteRequest createEmptyInstance() => DeleteRouteRequest._();
  @$core.pragma('dart2js:noInline')
  static DeleteRouteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteRouteRequest>(
          DeleteRouteRequest.$_createMessage);
  static DeleteRouteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServiceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServiceId() => $_clearField(1);
}

class RouteList extends $pb.GeneratedMessage {
  factory RouteList({
    $core.Iterable<RouteInfo>? routes,
    RouteInfo? defaultRoute,
  }) {
    final result = RouteList._();
    if (routes != null) result.routes.addAll(routes);
    if (defaultRoute != null) result.defaultRoute = defaultRoute;
    return result;
  }

  RouteList._();

  factory RouteList.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RouteList()..mergeFromBuffer(data, registry);
  factory RouteList.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RouteList()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RouteList',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: RouteList.$_createMessage)
    ..pPM<RouteInfo>(1, _omitFieldNames ? '' : 'routes',
        subBuilder: RouteInfo.$_createMessage)
    ..aOM<RouteInfo>(2, _omitFieldNames ? '' : 'defaultRoute',
        subBuilder: RouteInfo.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RouteList clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RouteList copyWith(void Function(RouteList) updates) =>
      super.copyWith((message) => updates(message as RouteList)) as RouteList;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RouteList() / RouteList.new instead')
  static RouteList create() => RouteList._();
  static $pb.GeneratedMessage $_createMessage() => RouteList._();
  @$core.override
  RouteList createEmptyInstance() => RouteList._();
  @$core.pragma('dart2js:noInline')
  static RouteList getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RouteList>(RouteList.$_createMessage);
  static RouteList? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<RouteInfo> get routes => $_getList(0);

  @$pb.TagNumber(2)
  RouteInfo get defaultRoute => $_getN(1);
  @$pb.TagNumber(2)
  set defaultRoute(RouteInfo value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDefaultRoute() => $_has(1);
  @$pb.TagNumber(2)
  void clearDefaultRoute() => $_clearField(2);
  @$pb.TagNumber(2)
  RouteInfo ensureDefaultRoute() => $_ensure(1);
}

class SelectRouteNodeRequest extends $pb.GeneratedMessage {
  factory SelectRouteNodeRequest({
    $core.String? serviceId,
    $core.String? nodeId,
  }) {
    final result = SelectRouteNodeRequest._();
    if (serviceId != null) result.serviceId = serviceId;
    if (nodeId != null) result.nodeId = nodeId;
    return result;
  }

  SelectRouteNodeRequest._();

  factory SelectRouteNodeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SelectRouteNodeRequest()..mergeFromBuffer(data, registry);
  factory SelectRouteNodeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SelectRouteNodeRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SelectRouteNodeRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: SelectRouteNodeRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'serviceId')
    ..aOS(2, _omitFieldNames ? '' : 'nodeId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SelectRouteNodeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SelectRouteNodeRequest copyWith(
          void Function(SelectRouteNodeRequest) updates) =>
      super.copyWith((message) => updates(message as SelectRouteNodeRequest))
          as SelectRouteNodeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SelectRouteNodeRequest() / SelectRouteNodeRequest.new instead')
  static SelectRouteNodeRequest create() => SelectRouteNodeRequest._();
  static $pb.GeneratedMessage $_createMessage() => SelectRouteNodeRequest._();
  @$core.override
  SelectRouteNodeRequest createEmptyInstance() => SelectRouteNodeRequest._();
  @$core.pragma('dart2js:noInline')
  static SelectRouteNodeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SelectRouteNodeRequest>(
          SelectRouteNodeRequest.$_createMessage);
  static SelectRouteNodeRequest? _defaultInstance;

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
}

class ResolvedEndpoints extends $pb.GeneratedMessage {
  factory ResolvedEndpoints({
    $core.Iterable<$core.String>? addresses,
  }) {
    final result = ResolvedEndpoints._();
    if (addresses != null) result.addresses.addAll(addresses);
    return result;
  }

  ResolvedEndpoints._();

  factory ResolvedEndpoints.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ResolvedEndpoints()..mergeFromBuffer(data, registry);
  factory ResolvedEndpoints.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ResolvedEndpoints()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResolvedEndpoints',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: ResolvedEndpoints.$_createMessage)
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
  @$core.Deprecated('Use ResolvedEndpoints() / ResolvedEndpoints.new instead')
  static ResolvedEndpoints create() => ResolvedEndpoints._();
  static $pb.GeneratedMessage $_createMessage() => ResolvedEndpoints._();
  @$core.override
  ResolvedEndpoints createEmptyInstance() => ResolvedEndpoints._();
  @$core.pragma('dart2js:noInline')
  static ResolvedEndpoints getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ResolvedEndpoints>(
          ResolvedEndpoints.$_createMessage);
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
    final result = IpInfoResponse._();
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
      IpInfoResponse()..mergeFromBuffer(data, registry);
  factory IpInfoResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IpInfoResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IpInfoResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: IpInfoResponse.$_createMessage)
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
  @$core.Deprecated('Use IpInfoResponse() / IpInfoResponse.new instead')
  static IpInfoResponse create() => IpInfoResponse._();
  static $pb.GeneratedMessage $_createMessage() => IpInfoResponse._();
  @$core.override
  IpInfoResponse createEmptyInstance() => IpInfoResponse._();
  @$core.pragma('dart2js:noInline')
  static IpInfoResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<IpInfoResponse>(
          IpInfoResponse.$_createMessage);
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
    final result = SubscriptionEvent._();
    if (type != null) result.type = type;
    if (subscription != null) result.subscription = subscription;
    if (occurredAtUnixMs != null) result.occurredAtUnixMs = occurredAtUnixMs;
    return result;
  }

  SubscriptionEvent._();

  factory SubscriptionEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SubscriptionEvent()..mergeFromBuffer(data, registry);
  factory SubscriptionEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SubscriptionEvent()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubscriptionEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'targetlib'),
      createEmptyInstance: SubscriptionEvent.$_createMessage)
    ..aE<SubscriptionEventType>(1, _omitFieldNames ? '' : 'type',
        enumValues: SubscriptionEventType.values)
    ..aOM<SubscriptionView>(2, _omitFieldNames ? '' : 'subscription',
        subBuilder: SubscriptionView.$_createMessage)
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
  @$core.Deprecated('Use SubscriptionEvent() / SubscriptionEvent.new instead')
  static SubscriptionEvent create() => SubscriptionEvent._();
  static $pb.GeneratedMessage $_createMessage() => SubscriptionEvent._();
  @$core.override
  SubscriptionEvent createEmptyInstance() => SubscriptionEvent._();
  @$core.pragma('dart2js:noInline')
  static SubscriptionEvent getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SubscriptionEvent>(
          SubscriptionEvent.$_createMessage);
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
