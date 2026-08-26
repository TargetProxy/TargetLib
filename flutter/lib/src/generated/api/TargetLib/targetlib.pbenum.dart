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

import 'package:protobuf/protobuf.dart' as $pb;

class LogLevel extends $pb.ProtobufEnum {
  static const LogLevel LOG_LEVEL_UNSPECIFIED =
      LogLevel._(0, _omitEnumNames ? '' : 'LOG_LEVEL_UNSPECIFIED');
  static const LogLevel LOG_LEVEL_PANIC =
      LogLevel._(1, _omitEnumNames ? '' : 'LOG_LEVEL_PANIC');
  static const LogLevel LOG_LEVEL_FATAL =
      LogLevel._(2, _omitEnumNames ? '' : 'LOG_LEVEL_FATAL');
  static const LogLevel LOG_LEVEL_ERROR =
      LogLevel._(3, _omitEnumNames ? '' : 'LOG_LEVEL_ERROR');
  static const LogLevel LOG_LEVEL_WARN =
      LogLevel._(4, _omitEnumNames ? '' : 'LOG_LEVEL_WARN');
  static const LogLevel LOG_LEVEL_INFO =
      LogLevel._(5, _omitEnumNames ? '' : 'LOG_LEVEL_INFO');
  static const LogLevel LOG_LEVEL_DEBUG =
      LogLevel._(6, _omitEnumNames ? '' : 'LOG_LEVEL_DEBUG');
  static const LogLevel LOG_LEVEL_TRACE =
      LogLevel._(7, _omitEnumNames ? '' : 'LOG_LEVEL_TRACE');

  static const $core.List<LogLevel> values = <LogLevel>[
    LOG_LEVEL_UNSPECIFIED,
    LOG_LEVEL_PANIC,
    LOG_LEVEL_FATAL,
    LOG_LEVEL_ERROR,
    LOG_LEVEL_WARN,
    LOG_LEVEL_INFO,
    LOG_LEVEL_DEBUG,
    LOG_LEVEL_TRACE,
  ];

  static final $core.List<LogLevel?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 7);
  static LogLevel? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const LogLevel._(super.value, super.name);
}

class ServiceStateType extends $pb.ProtobufEnum {
  static const ServiceStateType SERVICE_STATE_UNSPECIFIED =
      ServiceStateType._(0, _omitEnumNames ? '' : 'SERVICE_STATE_UNSPECIFIED');
  static const ServiceStateType SERVICE_STATE_IDLE =
      ServiceStateType._(1, _omitEnumNames ? '' : 'SERVICE_STATE_IDLE');
  static const ServiceStateType SERVICE_STATE_STARTING =
      ServiceStateType._(2, _omitEnumNames ? '' : 'SERVICE_STATE_STARTING');
  static const ServiceStateType SERVICE_STATE_RUNNING =
      ServiceStateType._(3, _omitEnumNames ? '' : 'SERVICE_STATE_RUNNING');
  static const ServiceStateType SERVICE_STATE_STOPPING =
      ServiceStateType._(4, _omitEnumNames ? '' : 'SERVICE_STATE_STOPPING');
  static const ServiceStateType SERVICE_STATE_FAILED =
      ServiceStateType._(5, _omitEnumNames ? '' : 'SERVICE_STATE_FAILED');

  static const $core.List<ServiceStateType> values = <ServiceStateType>[
    SERVICE_STATE_UNSPECIFIED,
    SERVICE_STATE_IDLE,
    SERVICE_STATE_STARTING,
    SERVICE_STATE_RUNNING,
    SERVICE_STATE_STOPPING,
    SERVICE_STATE_FAILED,
  ];

  static final $core.List<ServiceStateType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static ServiceStateType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ServiceStateType._(super.value, super.name);
}

class ProxyMode extends $pb.ProtobufEnum {
  static const ProxyMode PROXY_MODE_UNSPECIFIED =
      ProxyMode._(0, _omitEnumNames ? '' : 'PROXY_MODE_UNSPECIFIED');
  static const ProxyMode PROXY_MODE_MIXED =
      ProxyMode._(1, _omitEnumNames ? '' : 'PROXY_MODE_MIXED');
  static const ProxyMode PROXY_MODE_TUN =
      ProxyMode._(2, _omitEnumNames ? '' : 'PROXY_MODE_TUN');

  static const $core.List<ProxyMode> values = <ProxyMode>[
    PROXY_MODE_UNSPECIFIED,
    PROXY_MODE_MIXED,
    PROXY_MODE_TUN,
  ];

  static final $core.List<ProxyMode?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static ProxyMode? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ProxyMode._(super.value, super.name);
}

class RouteMode extends $pb.ProtobufEnum {
  static const RouteMode ROUTE_MODE_UNSPECIFIED =
      RouteMode._(0, _omitEnumNames ? '' : 'ROUTE_MODE_UNSPECIFIED');
  static const RouteMode ROUTE_MODE_DIRECT =
      RouteMode._(1, _omitEnumNames ? '' : 'ROUTE_MODE_DIRECT');
  static const RouteMode ROUTE_MODE_RULE =
      RouteMode._(2, _omitEnumNames ? '' : 'ROUTE_MODE_RULE');
  static const RouteMode ROUTE_MODE_ALL =
      RouteMode._(3, _omitEnumNames ? '' : 'ROUTE_MODE_ALL');

  static const $core.List<RouteMode> values = <RouteMode>[
    ROUTE_MODE_UNSPECIFIED,
    ROUTE_MODE_DIRECT,
    ROUTE_MODE_RULE,
    ROUTE_MODE_ALL,
  ];

  static final $core.List<RouteMode?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static RouteMode? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RouteMode._(super.value, super.name);
}

class LatencyTestStatus extends $pb.ProtobufEnum {
  static const LatencyTestStatus LATENCY_TEST_STATUS_UNSPECIFIED =
      LatencyTestStatus._(
          0, _omitEnumNames ? '' : 'LATENCY_TEST_STATUS_UNSPECIFIED');
  static const LatencyTestStatus LATENCY_TEST_STATUS_SUCCESS =
      LatencyTestStatus._(
          1, _omitEnumNames ? '' : 'LATENCY_TEST_STATUS_SUCCESS');
  static const LatencyTestStatus LATENCY_TEST_STATUS_FAILED =
      LatencyTestStatus._(
          2, _omitEnumNames ? '' : 'LATENCY_TEST_STATUS_FAILED');
  static const LatencyTestStatus LATENCY_TEST_STATUS_TIMEOUT =
      LatencyTestStatus._(
          3, _omitEnumNames ? '' : 'LATENCY_TEST_STATUS_TIMEOUT');
  static const LatencyTestStatus LATENCY_TEST_STATUS_NOT_FOUND =
      LatencyTestStatus._(
          4, _omitEnumNames ? '' : 'LATENCY_TEST_STATUS_NOT_FOUND');

  static const $core.List<LatencyTestStatus> values = <LatencyTestStatus>[
    LATENCY_TEST_STATUS_UNSPECIFIED,
    LATENCY_TEST_STATUS_SUCCESS,
    LATENCY_TEST_STATUS_FAILED,
    LATENCY_TEST_STATUS_TIMEOUT,
    LATENCY_TEST_STATUS_NOT_FOUND,
  ];

  static final $core.List<LatencyTestStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static LatencyTestStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const LatencyTestStatus._(super.value, super.name);
}

class SubscriptionStatus extends $pb.ProtobufEnum {
  static const SubscriptionStatus SUBSCRIPTION_STATUS_UNSPECIFIED =
      SubscriptionStatus._(
          0, _omitEnumNames ? '' : 'SUBSCRIPTION_STATUS_UNSPECIFIED');
  static const SubscriptionStatus SUBSCRIPTION_STATUS_IDLE =
      SubscriptionStatus._(1, _omitEnumNames ? '' : 'SUBSCRIPTION_STATUS_IDLE');
  static const SubscriptionStatus SUBSCRIPTION_STATUS_UPDATING =
      SubscriptionStatus._(
          2, _omitEnumNames ? '' : 'SUBSCRIPTION_STATUS_UPDATING');
  static const SubscriptionStatus SUBSCRIPTION_STATUS_READY =
      SubscriptionStatus._(
          3, _omitEnumNames ? '' : 'SUBSCRIPTION_STATUS_READY');
  static const SubscriptionStatus SUBSCRIPTION_STATUS_FAILED =
      SubscriptionStatus._(
          4, _omitEnumNames ? '' : 'SUBSCRIPTION_STATUS_FAILED');

  static const $core.List<SubscriptionStatus> values = <SubscriptionStatus>[
    SUBSCRIPTION_STATUS_UNSPECIFIED,
    SUBSCRIPTION_STATUS_IDLE,
    SUBSCRIPTION_STATUS_UPDATING,
    SUBSCRIPTION_STATUS_READY,
    SUBSCRIPTION_STATUS_FAILED,
  ];

  static final $core.List<SubscriptionStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static SubscriptionStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SubscriptionStatus._(super.value, super.name);
}

class SubscriptionUpdateStage extends $pb.ProtobufEnum {
  static const SubscriptionUpdateStage SUBSCRIPTION_UPDATE_STAGE_UNSPECIFIED =
      SubscriptionUpdateStage._(
          0, _omitEnumNames ? '' : 'SUBSCRIPTION_UPDATE_STAGE_UNSPECIFIED');
  static const SubscriptionUpdateStage SUBSCRIPTION_UPDATE_STAGE_IDLE =
      SubscriptionUpdateStage._(
          1, _omitEnumNames ? '' : 'SUBSCRIPTION_UPDATE_STAGE_IDLE');
  static const SubscriptionUpdateStage SUBSCRIPTION_UPDATE_STAGE_FETCHING =
      SubscriptionUpdateStage._(
          2, _omitEnumNames ? '' : 'SUBSCRIPTION_UPDATE_STAGE_FETCHING');
  static const SubscriptionUpdateStage SUBSCRIPTION_UPDATE_STAGE_PARSING =
      SubscriptionUpdateStage._(
          3, _omitEnumNames ? '' : 'SUBSCRIPTION_UPDATE_STAGE_PARSING');
  static const SubscriptionUpdateStage SUBSCRIPTION_UPDATE_STAGE_RESOLVING =
      SubscriptionUpdateStage._(
          4, _omitEnumNames ? '' : 'SUBSCRIPTION_UPDATE_STAGE_RESOLVING');
  static const SubscriptionUpdateStage SUBSCRIPTION_UPDATE_STAGE_PERSISTING =
      SubscriptionUpdateStage._(
          5, _omitEnumNames ? '' : 'SUBSCRIPTION_UPDATE_STAGE_PERSISTING');
  static const SubscriptionUpdateStage SUBSCRIPTION_UPDATE_STAGE_COMPLETE =
      SubscriptionUpdateStage._(
          6, _omitEnumNames ? '' : 'SUBSCRIPTION_UPDATE_STAGE_COMPLETE');
  static const SubscriptionUpdateStage SUBSCRIPTION_UPDATE_STAGE_FAILED =
      SubscriptionUpdateStage._(
          7, _omitEnumNames ? '' : 'SUBSCRIPTION_UPDATE_STAGE_FAILED');

  static const $core.List<SubscriptionUpdateStage> values =
      <SubscriptionUpdateStage>[
    SUBSCRIPTION_UPDATE_STAGE_UNSPECIFIED,
    SUBSCRIPTION_UPDATE_STAGE_IDLE,
    SUBSCRIPTION_UPDATE_STAGE_FETCHING,
    SUBSCRIPTION_UPDATE_STAGE_PARSING,
    SUBSCRIPTION_UPDATE_STAGE_RESOLVING,
    SUBSCRIPTION_UPDATE_STAGE_PERSISTING,
    SUBSCRIPTION_UPDATE_STAGE_COMPLETE,
    SUBSCRIPTION_UPDATE_STAGE_FAILED,
  ];

  static final $core.List<SubscriptionUpdateStage?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 7);
  static SubscriptionUpdateStage? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SubscriptionUpdateStage._(super.value, super.name);
}

class ProfileNodePhase extends $pb.ProtobufEnum {
  static const ProfileNodePhase PROFILE_NODE_PHASE_UNSPECIFIED =
      ProfileNodePhase._(
          0, _omitEnumNames ? '' : 'PROFILE_NODE_PHASE_UNSPECIFIED');
  static const ProfileNodePhase PROFILE_NODE_PHASE_DISCOVERED =
      ProfileNodePhase._(
          1, _omitEnumNames ? '' : 'PROFILE_NODE_PHASE_DISCOVERED');
  static const ProfileNodePhase PROFILE_NODE_PHASE_NORMALIZED =
      ProfileNodePhase._(
          2, _omitEnumNames ? '' : 'PROFILE_NODE_PHASE_NORMALIZED');
  static const ProfileNodePhase PROFILE_NODE_PHASE_READY =
      ProfileNodePhase._(3, _omitEnumNames ? '' : 'PROFILE_NODE_PHASE_READY');
  static const ProfileNodePhase PROFILE_NODE_PHASE_FAILED =
      ProfileNodePhase._(4, _omitEnumNames ? '' : 'PROFILE_NODE_PHASE_FAILED');

  static const $core.List<ProfileNodePhase> values = <ProfileNodePhase>[
    PROFILE_NODE_PHASE_UNSPECIFIED,
    PROFILE_NODE_PHASE_DISCOVERED,
    PROFILE_NODE_PHASE_NORMALIZED,
    PROFILE_NODE_PHASE_READY,
    PROFILE_NODE_PHASE_FAILED,
  ];

  static final $core.List<ProfileNodePhase?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static ProfileNodePhase? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ProfileNodePhase._(super.value, super.name);
}

class SubscriptionEventType extends $pb.ProtobufEnum {
  static const SubscriptionEventType SUBSCRIPTION_EVENT_TYPE_UNSPECIFIED =
      SubscriptionEventType._(
          0, _omitEnumNames ? '' : 'SUBSCRIPTION_EVENT_TYPE_UNSPECIFIED');
  static const SubscriptionEventType SUBSCRIPTION_EVENT_TYPE_ADDED =
      SubscriptionEventType._(
          1, _omitEnumNames ? '' : 'SUBSCRIPTION_EVENT_TYPE_ADDED');
  static const SubscriptionEventType SUBSCRIPTION_EVENT_TYPE_UPDATED =
      SubscriptionEventType._(
          2, _omitEnumNames ? '' : 'SUBSCRIPTION_EVENT_TYPE_UPDATED');
  static const SubscriptionEventType SUBSCRIPTION_EVENT_TYPE_REMOVED =
      SubscriptionEventType._(
          3, _omitEnumNames ? '' : 'SUBSCRIPTION_EVENT_TYPE_REMOVED');
  static const SubscriptionEventType SUBSCRIPTION_EVENT_TYPE_STAGE =
      SubscriptionEventType._(
          4, _omitEnumNames ? '' : 'SUBSCRIPTION_EVENT_TYPE_STAGE');

  static const $core.List<SubscriptionEventType> values =
      <SubscriptionEventType>[
    SUBSCRIPTION_EVENT_TYPE_UNSPECIFIED,
    SUBSCRIPTION_EVENT_TYPE_ADDED,
    SUBSCRIPTION_EVENT_TYPE_UPDATED,
    SUBSCRIPTION_EVENT_TYPE_REMOVED,
    SUBSCRIPTION_EVENT_TYPE_STAGE,
  ];

  static final $core.List<SubscriptionEventType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static SubscriptionEventType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SubscriptionEventType._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
