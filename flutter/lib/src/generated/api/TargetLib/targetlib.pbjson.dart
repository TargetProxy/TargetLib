// This is a generated file - do not edit.
//
// Generated from api/TargetLib/targetlib.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use logLevelDescriptor instead')
const LogLevel$json = {
  '1': 'LogLevel',
  '2': [
    {'1': 'LOG_LEVEL_UNSPECIFIED', '2': 0},
    {'1': 'LOG_LEVEL_PANIC', '2': 1},
    {'1': 'LOG_LEVEL_FATAL', '2': 2},
    {'1': 'LOG_LEVEL_ERROR', '2': 3},
    {'1': 'LOG_LEVEL_WARN', '2': 4},
    {'1': 'LOG_LEVEL_INFO', '2': 5},
    {'1': 'LOG_LEVEL_DEBUG', '2': 6},
    {'1': 'LOG_LEVEL_TRACE', '2': 7},
  ],
};

/// Descriptor for `LogLevel`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List logLevelDescriptor = $convert.base64Decode(
    'CghMb2dMZXZlbBIZChVMT0dfTEVWRUxfVU5TUEVDSUZJRUQQABITCg9MT0dfTEVWRUxfUEFOSU'
    'MQARITCg9MT0dfTEVWRUxfRkFUQUwQAhITCg9MT0dfTEVWRUxfRVJST1IQAxISCg5MT0dfTEVW'
    'RUxfV0FSThAEEhIKDkxPR19MRVZFTF9JTkZPEAUSEwoPTE9HX0xFVkVMX0RFQlVHEAYSEwoPTE'
    '9HX0xFVkVMX1RSQUNFEAc=');

@$core.Deprecated('Use serviceStateTypeDescriptor instead')
const ServiceStateType$json = {
  '1': 'ServiceStateType',
  '2': [
    {'1': 'SERVICE_STATE_UNSPECIFIED', '2': 0},
    {'1': 'SERVICE_STATE_IDLE', '2': 1},
    {'1': 'SERVICE_STATE_STARTING', '2': 2},
    {'1': 'SERVICE_STATE_RUNNING', '2': 3},
    {'1': 'SERVICE_STATE_STOPPING', '2': 4},
    {'1': 'SERVICE_STATE_FAILED', '2': 5},
  ],
};

/// Descriptor for `ServiceStateType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List serviceStateTypeDescriptor = $convert.base64Decode(
    'ChBTZXJ2aWNlU3RhdGVUeXBlEh0KGVNFUlZJQ0VfU1RBVEVfVU5TUEVDSUZJRUQQABIWChJTRV'
    'JWSUNFX1NUQVRFX0lETEUQARIaChZTRVJWSUNFX1NUQVRFX1NUQVJUSU5HEAISGQoVU0VSVklD'
    'RV9TVEFURV9SVU5OSU5HEAMSGgoWU0VSVklDRV9TVEFURV9TVE9QUElORxAEEhgKFFNFUlZJQ0'
    'VfU1RBVEVfRkFJTEVEEAU=');

@$core.Deprecated('Use proxyModeDescriptor instead')
const ProxyMode$json = {
  '1': 'ProxyMode',
  '2': [
    {'1': 'PROXY_MODE_UNSPECIFIED', '2': 0},
    {'1': 'PROXY_MODE_MIXED', '2': 1},
    {'1': 'PROXY_MODE_TUN', '2': 2},
  ],
};

/// Descriptor for `ProxyMode`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List proxyModeDescriptor = $convert.base64Decode(
    'CglQcm94eU1vZGUSGgoWUFJPWFlfTU9ERV9VTlNQRUNJRklFRBAAEhQKEFBST1hZX01PREVfTU'
    'lYRUQQARISCg5QUk9YWV9NT0RFX1RVThAC');

@$core.Deprecated('Use routeModeDescriptor instead')
const RouteMode$json = {
  '1': 'RouteMode',
  '2': [
    {'1': 'ROUTE_MODE_UNSPECIFIED', '2': 0},
    {'1': 'ROUTE_MODE_DIRECT', '2': 1},
    {'1': 'ROUTE_MODE_RULE', '2': 2},
    {'1': 'ROUTE_MODE_ALL', '2': 3},
  ],
};

/// Descriptor for `RouteMode`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List routeModeDescriptor = $convert.base64Decode(
    'CglSb3V0ZU1vZGUSGgoWUk9VVEVfTU9ERV9VTlNQRUNJRklFRBAAEhUKEVJPVVRFX01PREVfRE'
    'lSRUNUEAESEwoPUk9VVEVfTU9ERV9SVUxFEAISEgoOUk9VVEVfTU9ERV9BTEwQAw==');

@$core.Deprecated('Use configApplyPhaseDescriptor instead')
const ConfigApplyPhase$json = {
  '1': 'ConfigApplyPhase',
  '2': [
    {'1': 'CONFIG_APPLY_PHASE_UNSPECIFIED', '2': 0},
    {'1': 'CONFIG_APPLY_PHASE_VALIDATING', '2': 1},
    {'1': 'CONFIG_APPLY_PHASE_BUILDING', '2': 2},
    {'1': 'CONFIG_APPLY_PHASE_APPLYING', '2': 3},
    {'1': 'CONFIG_APPLY_PHASE_READY', '2': 4},
    {'1': 'CONFIG_APPLY_PHASE_FAILED', '2': 5},
  ],
};

/// Descriptor for `ConfigApplyPhase`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List configApplyPhaseDescriptor = $convert.base64Decode(
    'ChBDb25maWdBcHBseVBoYXNlEiIKHkNPTkZJR19BUFBMWV9QSEFTRV9VTlNQRUNJRklFRBAAEi'
    'EKHUNPTkZJR19BUFBMWV9QSEFTRV9WQUxJREFUSU5HEAESHwobQ09ORklHX0FQUExZX1BIQVNF'
    'X0JVSUxESU5HEAISHwobQ09ORklHX0FQUExZX1BIQVNFX0FQUExZSU5HEAMSHAoYQ09ORklHX0'
    'FQUExZX1BIQVNFX1JFQURZEAQSHQoZQ09ORklHX0FQUExZX1BIQVNFX0ZBSUxFRBAF');

@$core.Deprecated('Use probeStageDescriptor instead')
const ProbeStage$json = {
  '1': 'ProbeStage',
  '2': [
    {'1': 'PROBE_STAGE_UNSPECIFIED', '2': 0},
    {'1': 'PROBE_STAGE_READY', '2': 1},
    {'1': 'PROBE_STAGE_DNS', '2': 2},
    {'1': 'PROBE_STAGE_TCP', '2': 3},
    {'1': 'PROBE_STAGE_TLS', '2': 4},
    {'1': 'PROBE_STAGE_HTTP', '2': 5},
    {'1': 'PROBE_STAGE_AUTH', '2': 6},
    {'1': 'PROBE_STAGE_TIMEOUT', '2': 7},
    {'1': 'PROBE_STAGE_REGION', '2': 8},
    {'1': 'PROBE_STAGE_CONTENT', '2': 9},
    {'1': 'PROBE_STAGE_NODE', '2': 10},
    {'1': 'PROBE_STAGE_EGRESS', '2': 11},
  ],
};

/// Descriptor for `ProbeStage`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List probeStageDescriptor = $convert.base64Decode(
    'CgpQcm9iZVN0YWdlEhsKF1BST0JFX1NUQUdFX1VOU1BFQ0lGSUVEEAASFQoRUFJPQkVfU1RBR0'
    'VfUkVBRFkQARITCg9QUk9CRV9TVEFHRV9ETlMQAhITCg9QUk9CRV9TVEFHRV9UQ1AQAxITCg9Q'
    'Uk9CRV9TVEFHRV9UTFMQBBIUChBQUk9CRV9TVEFHRV9IVFRQEAUSFAoQUFJPQkVfU1RBR0VfQV'
    'VUSBAGEhcKE1BST0JFX1NUQUdFX1RJTUVPVVQQBxIWChJQUk9CRV9TVEFHRV9SRUdJT04QCBIX'
    'ChNQUk9CRV9TVEFHRV9DT05URU5UEAkSFAoQUFJPQkVfU1RBR0VfTk9ERRAKEhYKElBST0JFX1'
    'NUQUdFX0VHUkVTUxAL');

@$core.Deprecated('Use runtimeEventTypeDescriptor instead')
const RuntimeEventType$json = {
  '1': 'RuntimeEventType',
  '2': [
    {'1': 'RUNTIME_EVENT_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'RUNTIME_EVENT_TYPE_SNAPSHOT', '2': 1},
    {'1': 'RUNTIME_EVENT_TYPE_CONFIG', '2': 2},
    {'1': 'RUNTIME_EVENT_TYPE_NODE_POOL', '2': 3},
    {'1': 'RUNTIME_EVENT_TYPE_BINDING', '2': 4},
    {'1': 'RUNTIME_EVENT_TYPE_PROBE_STARTED', '2': 5},
    {'1': 'RUNTIME_EVENT_TYPE_PROBE_COMPLETED', '2': 6},
    {'1': 'RUNTIME_EVENT_TYPE_PROBE_DEFINITION', '2': 7},
    {'1': 'RUNTIME_EVENT_TYPE_STOPPED', '2': 8},
  ],
};

/// Descriptor for `RuntimeEventType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List runtimeEventTypeDescriptor = $convert.base64Decode(
    'ChBSdW50aW1lRXZlbnRUeXBlEiIKHlJVTlRJTUVfRVZFTlRfVFlQRV9VTlNQRUNJRklFRBAAEh'
    '8KG1JVTlRJTUVfRVZFTlRfVFlQRV9TTkFQU0hPVBABEh0KGVJVTlRJTUVfRVZFTlRfVFlQRV9D'
    'T05GSUcQAhIgChxSVU5USU1FX0VWRU5UX1RZUEVfTk9ERV9QT09MEAMSHgoaUlVOVElNRV9FVk'
    'VOVF9UWVBFX0JJTkRJTkcQBBIkCiBSVU5USU1FX0VWRU5UX1RZUEVfUFJPQkVfU1RBUlRFRBAF'
    'EiYKIlJVTlRJTUVfRVZFTlRfVFlQRV9QUk9CRV9DT01QTEVURUQQBhInCiNSVU5USU1FX0VWRU'
    '5UX1RZUEVfUFJPQkVfREVGSU5JVElPThAHEh4KGlJVTlRJTUVfRVZFTlRfVFlQRV9TVE9QUEVE'
    'EAg=');

@$core.Deprecated('Use smartRecoveryStateDescriptor instead')
const SmartRecoveryState$json = {
  '1': 'SmartRecoveryState',
  '2': [
    {'1': 'SMART_RECOVERY_STATE_UNSPECIFIED', '2': 0},
    {'1': 'SMART_RECOVERY_STATE_RECOVERING', '2': 1},
    {'1': 'SMART_RECOVERY_STATE_READY', '2': 2},
    {'1': 'SMART_RECOVERY_STATE_DEGRADED', '2': 3},
  ],
};

/// Descriptor for `SmartRecoveryState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List smartRecoveryStateDescriptor = $convert.base64Decode(
    'ChJTbWFydFJlY292ZXJ5U3RhdGUSJAogU01BUlRfUkVDT1ZFUllfU1RBVEVfVU5TUEVDSUZJRU'
    'QQABIjCh9TTUFSVF9SRUNPVkVSWV9TVEFURV9SRUNPVkVSSU5HEAESHgoaU01BUlRfUkVDT1ZF'
    'UllfU1RBVEVfUkVBRFkQAhIhCh1TTUFSVF9SRUNPVkVSWV9TVEFURV9ERUdSQURFRBAD');

@$core.Deprecated('Use switchModeDescriptor instead')
const SwitchMode$json = {
  '1': 'SwitchMode',
  '2': [
    {'1': 'SWITCH_MODE_UNSPECIFIED', '2': 0},
    {'1': 'SWITCH_MODE_MANUAL', '2': 1},
    {'1': 'SWITCH_MODE_AUTO_CONSTRAINED', '2': 2},
    {'1': 'SWITCH_MODE_LOCKED', '2': 3},
    {'1': 'SWITCH_MODE_DIRECT', '2': 4},
  ],
};

/// Descriptor for `SwitchMode`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List switchModeDescriptor = $convert.base64Decode(
    'CgpTd2l0Y2hNb2RlEhsKF1NXSVRDSF9NT0RFX1VOU1BFQ0lGSUVEEAASFgoSU1dJVENIX01PRE'
    'VfTUFOVUFMEAESIAocU1dJVENIX01PREVfQVVUT19DT05TVFJBSU5FRBACEhYKElNXSVRDSF9N'
    'T0RFX0xPQ0tFRBADEhYKElNXSVRDSF9NT0RFX0RJUkVDVBAE');

@$core.Deprecated('Use operationStatusDescriptor instead')
const OperationStatus$json = {
  '1': 'OperationStatus',
  '2': [
    {'1': 'OPERATION_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'OPERATION_STATUS_QUEUED', '2': 1},
    {'1': 'OPERATION_STATUS_RUNNING', '2': 2},
    {'1': 'OPERATION_STATUS_WAITING_APPROVAL', '2': 3},
    {'1': 'OPERATION_STATUS_SUCCEEDED', '2': 4},
    {'1': 'OPERATION_STATUS_FAILED', '2': 5},
    {'1': 'OPERATION_STATUS_CANCELLED', '2': 6},
    {'1': 'OPERATION_STATUS_ROLLED_BACK', '2': 7},
  ],
};

/// Descriptor for `OperationStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List operationStatusDescriptor = $convert.base64Decode(
    'Cg9PcGVyYXRpb25TdGF0dXMSIAocT1BFUkFUSU9OX1NUQVRVU19VTlNQRUNJRklFRBAAEhsKF0'
    '9QRVJBVElPTl9TVEFUVVNfUVVFVUVEEAESHAoYT1BFUkFUSU9OX1NUQVRVU19SVU5OSU5HEAIS'
    'JQohT1BFUkFUSU9OX1NUQVRVU19XQUlUSU5HX0FQUFJPVkFMEAMSHgoaT1BFUkFUSU9OX1NUQV'
    'RVU19TVUNDRUVERUQQBBIbChdPUEVSQVRJT05fU1RBVFVTX0ZBSUxFRBAFEh4KGk9QRVJBVElP'
    'Tl9TVEFUVVNfQ0FOQ0VMTEVEEAYSIAocT1BFUkFUSU9OX1NUQVRVU19ST0xMRURfQkFDSxAH');

@$core.Deprecated('Use latencyTestStatusDescriptor instead')
const LatencyTestStatus$json = {
  '1': 'LatencyTestStatus',
  '2': [
    {'1': 'LATENCY_TEST_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'LATENCY_TEST_STATUS_SUCCESS', '2': 1},
    {'1': 'LATENCY_TEST_STATUS_FAILED', '2': 2},
    {'1': 'LATENCY_TEST_STATUS_TIMEOUT', '2': 3},
    {'1': 'LATENCY_TEST_STATUS_NOT_FOUND', '2': 4},
  ],
};

/// Descriptor for `LatencyTestStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List latencyTestStatusDescriptor = $convert.base64Decode(
    'ChFMYXRlbmN5VGVzdFN0YXR1cxIjCh9MQVRFTkNZX1RFU1RfU1RBVFVTX1VOU1BFQ0lGSUVEEA'
    'ASHwobTEFURU5DWV9URVNUX1NUQVRVU19TVUNDRVNTEAESHgoaTEFURU5DWV9URVNUX1NUQVRV'
    'U19GQUlMRUQQAhIfChtMQVRFTkNZX1RFU1RfU1RBVFVTX1RJTUVPVVQQAxIhCh1MQVRFTkNZX1'
    'RFU1RfU1RBVFVTX05PVF9GT1VORBAE');

@$core.Deprecated('Use subscriptionStatusDescriptor instead')
const SubscriptionStatus$json = {
  '1': 'SubscriptionStatus',
  '2': [
    {'1': 'SUBSCRIPTION_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'SUBSCRIPTION_STATUS_IDLE', '2': 1},
    {'1': 'SUBSCRIPTION_STATUS_UPDATING', '2': 2},
    {'1': 'SUBSCRIPTION_STATUS_READY', '2': 3},
    {'1': 'SUBSCRIPTION_STATUS_FAILED', '2': 4},
  ],
};

/// Descriptor for `SubscriptionStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List subscriptionStatusDescriptor = $convert.base64Decode(
    'ChJTdWJzY3JpcHRpb25TdGF0dXMSIwofU1VCU0NSSVBUSU9OX1NUQVRVU19VTlNQRUNJRklFRB'
    'AAEhwKGFNVQlNDUklQVElPTl9TVEFUVVNfSURMRRABEiAKHFNVQlNDUklQVElPTl9TVEFUVVNf'
    'VVBEQVRJTkcQAhIdChlTVUJTQ1JJUFRJT05fU1RBVFVTX1JFQURZEAMSHgoaU1VCU0NSSVBUSU'
    '9OX1NUQVRVU19GQUlMRUQQBA==');

@$core.Deprecated('Use subscriptionUpdateStageDescriptor instead')
const SubscriptionUpdateStage$json = {
  '1': 'SubscriptionUpdateStage',
  '2': [
    {'1': 'SUBSCRIPTION_UPDATE_STAGE_UNSPECIFIED', '2': 0},
    {'1': 'SUBSCRIPTION_UPDATE_STAGE_IDLE', '2': 1},
    {'1': 'SUBSCRIPTION_UPDATE_STAGE_FETCHING', '2': 2},
    {'1': 'SUBSCRIPTION_UPDATE_STAGE_PARSING', '2': 3},
    {'1': 'SUBSCRIPTION_UPDATE_STAGE_RESOLVING', '2': 4},
    {'1': 'SUBSCRIPTION_UPDATE_STAGE_PERSISTING', '2': 5},
    {'1': 'SUBSCRIPTION_UPDATE_STAGE_COMPLETE', '2': 6},
    {'1': 'SUBSCRIPTION_UPDATE_STAGE_FAILED', '2': 7},
  ],
};

/// Descriptor for `SubscriptionUpdateStage`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List subscriptionUpdateStageDescriptor = $convert.base64Decode(
    'ChdTdWJzY3JpcHRpb25VcGRhdGVTdGFnZRIpCiVTVUJTQ1JJUFRJT05fVVBEQVRFX1NUQUdFX1'
    'VOU1BFQ0lGSUVEEAASIgoeU1VCU0NSSVBUSU9OX1VQREFURV9TVEFHRV9JRExFEAESJgoiU1VC'
    'U0NSSVBUSU9OX1VQREFURV9TVEFHRV9GRVRDSElORxACEiUKIVNVQlNDUklQVElPTl9VUERBVE'
    'VfU1RBR0VfUEFSU0lORxADEicKI1NVQlNDUklQVElPTl9VUERBVEVfU1RBR0VfUkVTT0xWSU5H'
    'EAQSKAokU1VCU0NSSVBUSU9OX1VQREFURV9TVEFHRV9QRVJTSVNUSU5HEAUSJgoiU1VCU0NSSV'
    'BUSU9OX1VQREFURV9TVEFHRV9DT01QTEVURRAGEiQKIFNVQlNDUklQVElPTl9VUERBVEVfU1RB'
    'R0VfRkFJTEVEEAc=');

@$core.Deprecated('Use profileNodePhaseDescriptor instead')
const ProfileNodePhase$json = {
  '1': 'ProfileNodePhase',
  '2': [
    {'1': 'PROFILE_NODE_PHASE_UNSPECIFIED', '2': 0},
    {'1': 'PROFILE_NODE_PHASE_DISCOVERED', '2': 1},
    {'1': 'PROFILE_NODE_PHASE_NORMALIZED', '2': 2},
    {'1': 'PROFILE_NODE_PHASE_READY', '2': 3},
    {'1': 'PROFILE_NODE_PHASE_FAILED', '2': 4},
  ],
};

/// Descriptor for `ProfileNodePhase`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List profileNodePhaseDescriptor = $convert.base64Decode(
    'ChBQcm9maWxlTm9kZVBoYXNlEiIKHlBST0ZJTEVfTk9ERV9QSEFTRV9VTlNQRUNJRklFRBAAEi'
    'EKHVBST0ZJTEVfTk9ERV9QSEFTRV9ESVNDT1ZFUkVEEAESIQodUFJPRklMRV9OT0RFX1BIQVNF'
    'X05PUk1BTElaRUQQAhIcChhQUk9GSUxFX05PREVfUEhBU0VfUkVBRFkQAxIdChlQUk9GSUxFX0'
    '5PREVfUEhBU0VfRkFJTEVEEAQ=');

@$core.Deprecated('Use subscriptionEventTypeDescriptor instead')
const SubscriptionEventType$json = {
  '1': 'SubscriptionEventType',
  '2': [
    {'1': 'SUBSCRIPTION_EVENT_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'SUBSCRIPTION_EVENT_TYPE_ADDED', '2': 1},
    {'1': 'SUBSCRIPTION_EVENT_TYPE_UPDATED', '2': 2},
    {'1': 'SUBSCRIPTION_EVENT_TYPE_REMOVED', '2': 3},
    {'1': 'SUBSCRIPTION_EVENT_TYPE_STAGE', '2': 4},
  ],
};

/// Descriptor for `SubscriptionEventType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List subscriptionEventTypeDescriptor = $convert.base64Decode(
    'ChVTdWJzY3JpcHRpb25FdmVudFR5cGUSJwojU1VCU0NSSVBUSU9OX0VWRU5UX1RZUEVfVU5TUE'
    'VDSUZJRUQQABIhCh1TVUJTQ1JJUFRJT05fRVZFTlRfVFlQRV9BRERFRBABEiMKH1NVQlNDUklQ'
    'VElPTl9FVkVOVF9UWVBFX1VQREFURUQQAhIjCh9TVUJTQ1JJUFRJT05fRVZFTlRfVFlQRV9SRU'
    '1PVkVEEAMSIQodU1VCU0NSSVBUSU9OX0VWRU5UX1RZUEVfU1RBR0UQBA==');

@$core.Deprecated('Use logMessageDescriptor instead')
const LogMessage$json = {
  '1': 'LogMessage',
  '2': [
    {
      '1': 'level',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.targetlib.LogLevel',
      '10': 'level'
    },
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `LogMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List logMessageDescriptor = $convert.base64Decode(
    'CgpMb2dNZXNzYWdlEikKBWxldmVsGAEgASgOMhMudGFyZ2V0bGliLkxvZ0xldmVsUgVsZXZlbB'
    'IYCgdtZXNzYWdlGAIgASgJUgdtZXNzYWdl');

@$core.Deprecated('Use logBatchDescriptor instead')
const LogBatch$json = {
  '1': 'LogBatch',
  '2': [
    {
      '1': 'messages',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.targetlib.LogMessage',
      '10': 'messages'
    },
    {'1': 'reset', '3': 2, '4': 1, '5': 8, '10': 'reset'},
  ],
};

/// Descriptor for `LogBatch`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List logBatchDescriptor = $convert.base64Decode(
    'CghMb2dCYXRjaBIxCghtZXNzYWdlcxgBIAMoCzIVLnRhcmdldGxpYi5Mb2dNZXNzYWdlUghtZX'
    'NzYWdlcxIUCgVyZXNldBgCIAEoCFIFcmVzZXQ=');

@$core.Deprecated('Use selectOutboundRequestDescriptor instead')
const SelectOutboundRequest$json = {
  '1': 'SelectOutboundRequest',
  '2': [
    {'1': 'group_tag', '3': 1, '4': 1, '5': 9, '10': 'groupTag'},
    {'1': 'outbound_tag', '3': 2, '4': 1, '5': 9, '10': 'outboundTag'},
  ],
};

/// Descriptor for `SelectOutboundRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List selectOutboundRequestDescriptor = $convert.base64Decode(
    'ChVTZWxlY3RPdXRib3VuZFJlcXVlc3QSGwoJZ3JvdXBfdGFnGAEgASgJUghncm91cFRhZxIhCg'
    'xvdXRib3VuZF90YWcYAiABKAlSC291dGJvdW5kVGFn');

@$core.Deprecated('Use closeConnectionRequestDescriptor instead')
const CloseConnectionRequest$json = {
  '1': 'CloseConnectionRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `CloseConnectionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closeConnectionRequestDescriptor = $convert
    .base64Decode('ChZDbG9zZUNvbm5lY3Rpb25SZXF1ZXN0Eg4KAmlkGAEgASgJUgJpZA==');

@$core.Deprecated('Use versionResponseDescriptor instead')
const VersionResponse$json = {
  '1': 'VersionResponse',
  '2': [
    {
      '1': 'targetlib_version',
      '3': 1,
      '4': 1,
      '5': 9,
      '10': 'targetlibVersion'
    },
    {'1': 'sing_box_version', '3': 2, '4': 1, '5': 9, '10': 'singBoxVersion'},
    {'1': 'go_version', '3': 3, '4': 1, '5': 9, '10': 'goVersion'},
    {'1': 'protocol_version', '3': 4, '4': 1, '5': 13, '10': 'protocolVersion'},
  ],
};

/// Descriptor for `VersionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List versionResponseDescriptor = $convert.base64Decode(
    'Cg9WZXJzaW9uUmVzcG9uc2USKwoRdGFyZ2V0bGliX3ZlcnNpb24YASABKAlSEHRhcmdldGxpYl'
    'ZlcnNpb24SKAoQc2luZ19ib3hfdmVyc2lvbhgCIAEoCVIOc2luZ0JveFZlcnNpb24SHQoKZ29f'
    'dmVyc2lvbhgDIAEoCVIJZ29WZXJzaW9uEikKEHByb3RvY29sX3ZlcnNpb24YBCABKA1SD3Byb3'
    'RvY29sVmVyc2lvbg==');

@$core.Deprecated('Use capabilitiesResponseDescriptor instead')
const CapabilitiesResponse$json = {
  '1': 'CapabilitiesResponse',
  '2': [
    {'1': 'platform', '3': 1, '4': 1, '5': 9, '10': 'platform'},
    {'1': 'platform_vpn', '3': 3, '4': 1, '5': 8, '10': 'platformVpn'},
    {
      '1': 'subscription_management',
      '3': 5,
      '4': 1,
      '5': 8,
      '10': 'subscriptionManagement'
    },
    {'1': 'real_time_traffic', '3': 6, '4': 1, '5': 8, '10': 'realTimeTraffic'},
    {'1': 'smart_connect', '3': 7, '4': 1, '5': 8, '10': 'smartConnect'},
    {'1': 'service_probes', '3': 8, '4': 1, '5': 8, '10': 'serviceProbes'},
    {'1': 'runtime_events', '3': 9, '4': 1, '5': 8, '10': 'runtimeEvents'},
    {
      '1': 'smart_connect_intent_api',
      '3': 10,
      '4': 1,
      '5': 8,
      '10': 'smartConnectIntentApi'
    },
  ],
  '9': [
    {'1': 2, '2': 3},
    {'1': 4, '2': 5},
  ],
  '10': ['system_proxy'],
};

/// Descriptor for `CapabilitiesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List capabilitiesResponseDescriptor = $convert.base64Decode(
    'ChRDYXBhYmlsaXRpZXNSZXNwb25zZRIaCghwbGF0Zm9ybRgBIAEoCVIIcGxhdGZvcm0SIQoMcG'
    'xhdGZvcm1fdnBuGAMgASgIUgtwbGF0Zm9ybVZwbhI3ChdzdWJzY3JpcHRpb25fbWFuYWdlbWVu'
    'dBgFIAEoCFIWc3Vic2NyaXB0aW9uTWFuYWdlbWVudBIqChFyZWFsX3RpbWVfdHJhZmZpYxgGIA'
    'EoCFIPcmVhbFRpbWVUcmFmZmljEiMKDXNtYXJ0X2Nvbm5lY3QYByABKAhSDHNtYXJ0Q29ubmVj'
    'dBIlCg5zZXJ2aWNlX3Byb2JlcxgIIAEoCFINc2VydmljZVByb2JlcxIlCg5ydW50aW1lX2V2ZW'
    '50cxgJIAEoCFINcnVudGltZUV2ZW50cxI3ChhzbWFydF9jb25uZWN0X2ludGVudF9hcGkYCiAB'
    'KAhSFXNtYXJ0Q29ubmVjdEludGVudEFwaUoECAIQA0oECAQQBVIMc3lzdGVtX3Byb3h5');

@$core.Deprecated('Use operationResponseDescriptor instead')
const OperationResponse$json = {
  '1': 'OperationResponse',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.targetlib.ServiceState',
      '10': 'state'
    },
  ],
};

/// Descriptor for `OperationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List operationResponseDescriptor = $convert.base64Decode(
    'ChFPcGVyYXRpb25SZXNwb25zZRItCgVzdGF0ZRgBIAEoCzIXLnRhcmdldGxpYi5TZXJ2aWNlU3'
    'RhdGVSBXN0YXRl');

@$core.Deprecated('Use serviceStateDescriptor instead')
const ServiceState$json = {
  '1': 'ServiceState',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.targetlib.ServiceStateType',
      '10': 'state'
    },
    {'1': 'error_message', '3': 2, '4': 1, '5': 9, '10': 'errorMessage'},
    {
      '1': 'changed_at_unix_ms',
      '3': 3,
      '4': 1,
      '5': 3,
      '10': 'changedAtUnixMs'
    },
  ],
};

/// Descriptor for `ServiceState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serviceStateDescriptor = $convert.base64Decode(
    'CgxTZXJ2aWNlU3RhdGUSMQoFc3RhdGUYASABKA4yGy50YXJnZXRsaWIuU2VydmljZVN0YXRlVH'
    'lwZVIFc3RhdGUSIwoNZXJyb3JfbWVzc2FnZRgCIAEoCVIMZXJyb3JNZXNzYWdlEisKEmNoYW5n'
    'ZWRfYXRfdW5peF9tcxgDIAEoA1IPY2hhbmdlZEF0VW5peE1z');

@$core.Deprecated('Use trafficRequestDescriptor instead')
const TrafficRequest$json = {
  '1': 'TrafficRequest',
  '2': [
    {
      '1': 'interval_milliseconds',
      '3': 1,
      '4': 1,
      '5': 13,
      '10': 'intervalMilliseconds'
    },
  ],
};

/// Descriptor for `TrafficRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trafficRequestDescriptor = $convert.base64Decode(
    'Cg5UcmFmZmljUmVxdWVzdBIzChVpbnRlcnZhbF9taWxsaXNlY29uZHMYASABKA1SFGludGVydm'
    'FsTWlsbGlzZWNvbmRz');

@$core.Deprecated('Use trafficStatusDescriptor instead')
const TrafficStatus$json = {
  '1': 'TrafficStatus',
  '2': [
    {'1': 'available', '3': 1, '4': 1, '5': 8, '10': 'available'},
    {
      '1': 'upload_bytes_per_second',
      '3': 2,
      '4': 1,
      '5': 3,
      '10': 'uploadBytesPerSecond'
    },
    {
      '1': 'download_bytes_per_second',
      '3': 3,
      '4': 1,
      '5': 3,
      '10': 'downloadBytesPerSecond'
    },
    {
      '1': 'upload_total_bytes',
      '3': 4,
      '4': 1,
      '5': 3,
      '10': 'uploadTotalBytes'
    },
    {
      '1': 'download_total_bytes',
      '3': 5,
      '4': 1,
      '5': 3,
      '10': 'downloadTotalBytes'
    },
    {
      '1': 'inbound_connections',
      '3': 6,
      '4': 1,
      '5': 5,
      '10': 'inboundConnections'
    },
    {
      '1': 'outbound_connections',
      '3': 7,
      '4': 1,
      '5': 5,
      '10': 'outboundConnections'
    },
    {
      '1': 'sampled_at_unix_ms',
      '3': 8,
      '4': 1,
      '5': 3,
      '10': 'sampledAtUnixMs'
    },
    {
      '1': 'interval_milliseconds',
      '3': 9,
      '4': 1,
      '5': 13,
      '10': 'intervalMilliseconds'
    },
  ],
};

/// Descriptor for `TrafficStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trafficStatusDescriptor = $convert.base64Decode(
    'Cg1UcmFmZmljU3RhdHVzEhwKCWF2YWlsYWJsZRgBIAEoCFIJYXZhaWxhYmxlEjUKF3VwbG9hZF'
    '9ieXRlc19wZXJfc2Vjb25kGAIgASgDUhR1cGxvYWRCeXRlc1BlclNlY29uZBI5Chlkb3dubG9h'
    'ZF9ieXRlc19wZXJfc2Vjb25kGAMgASgDUhZkb3dubG9hZEJ5dGVzUGVyU2Vjb25kEiwKEnVwbG'
    '9hZF90b3RhbF9ieXRlcxgEIAEoA1IQdXBsb2FkVG90YWxCeXRlcxIwChRkb3dubG9hZF90b3Rh'
    'bF9ieXRlcxgFIAEoA1ISZG93bmxvYWRUb3RhbEJ5dGVzEi8KE2luYm91bmRfY29ubmVjdGlvbn'
    'MYBiABKAVSEmluYm91bmRDb25uZWN0aW9ucxIxChRvdXRib3VuZF9jb25uZWN0aW9ucxgHIAEo'
    'BVITb3V0Ym91bmRDb25uZWN0aW9ucxIrChJzYW1wbGVkX2F0X3VuaXhfbXMYCCABKANSD3NhbX'
    'BsZWRBdFVuaXhNcxIzChVpbnRlcnZhbF9taWxsaXNlY29uZHMYCSABKA1SFGludGVydmFsTWls'
    'bGlzZWNvbmRz');

@$core.Deprecated('Use subscriptionIdDescriptor instead')
const SubscriptionId$json = {
  '1': 'SubscriptionId',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `SubscriptionId`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subscriptionIdDescriptor =
    $convert.base64Decode('Cg5TdWJzY3JpcHRpb25JZBIOCgJpZBgBIAEoCVICaWQ=');

@$core.Deprecated('Use addSubscriptionRequestDescriptor instead')
const AddSubscriptionRequest$json = {
  '1': 'AddSubscriptionRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'url', '3': 3, '4': 1, '5': 9, '10': 'url'},
    {
      '1': 'enabled',
      '3': 4,
      '4': 1,
      '5': 8,
      '9': 0,
      '10': 'enabled',
      '17': true
    },
    {
      '1': 'auto_update',
      '3': 5,
      '4': 1,
      '5': 8,
      '9': 1,
      '10': 'autoUpdate',
      '17': true
    },
    {
      '1': 'update_interval_seconds',
      '3': 6,
      '4': 1,
      '5': 3,
      '10': 'updateIntervalSeconds'
    },
    {
      '1': 'headers',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.targetlib.AddSubscriptionRequest.HeadersEntry',
      '10': 'headers'
    },
    {'1': 'update_now', '3': 9, '4': 1, '5': 8, '10': 'updateNow'},
  ],
  '3': [AddSubscriptionRequest_HeadersEntry$json],
  '8': [
    {'1': '_enabled'},
    {'1': '_auto_update'},
  ],
  '9': [
    {'1': 8, '2': 9},
  ],
  '10': ['activate'],
};

@$core.Deprecated('Use addSubscriptionRequestDescriptor instead')
const AddSubscriptionRequest_HeadersEntry$json = {
  '1': 'HeadersEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `AddSubscriptionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addSubscriptionRequestDescriptor = $convert.base64Decode(
    'ChZBZGRTdWJzY3JpcHRpb25SZXF1ZXN0Eg4KAmlkGAEgASgJUgJpZBISCgRuYW1lGAIgASgJUg'
    'RuYW1lEhAKA3VybBgDIAEoCVIDdXJsEh0KB2VuYWJsZWQYBCABKAhIAFIHZW5hYmxlZIgBARIk'
    'CgthdXRvX3VwZGF0ZRgFIAEoCEgBUgphdXRvVXBkYXRliAEBEjYKF3VwZGF0ZV9pbnRlcnZhbF'
    '9zZWNvbmRzGAYgASgDUhV1cGRhdGVJbnRlcnZhbFNlY29uZHMSSAoHaGVhZGVycxgHIAMoCzIu'
    'LnRhcmdldGxpYi5BZGRTdWJzY3JpcHRpb25SZXF1ZXN0LkhlYWRlcnNFbnRyeVIHaGVhZGVycx'
    'IdCgp1cGRhdGVfbm93GAkgASgIUgl1cGRhdGVOb3caOgoMSGVhZGVyc0VudHJ5EhAKA2tleRgB'
    'IAEoCVIDa2V5EhQKBXZhbHVlGAIgASgJUgV2YWx1ZToCOAFCCgoIX2VuYWJsZWRCDgoMX2F1dG'
    '9fdXBkYXRlSgQICBAJUghhY3RpdmF0ZQ==');

@$core.Deprecated('Use renameSubscriptionRequestDescriptor instead')
const RenameSubscriptionRequest$json = {
  '1': 'RenameSubscriptionRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `RenameSubscriptionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List renameSubscriptionRequestDescriptor =
    $convert.base64Decode(
        'ChlSZW5hbWVTdWJzY3JpcHRpb25SZXF1ZXN0Eg4KAmlkGAEgASgJUgJpZBISCgRuYW1lGAIgAS'
        'gJUgRuYW1l');

@$core.Deprecated('Use setSubscriptionEnabledRequestDescriptor instead')
const SetSubscriptionEnabledRequest$json = {
  '1': 'SetSubscriptionEnabledRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'enabled', '3': 2, '4': 1, '5': 8, '10': 'enabled'},
  ],
};

/// Descriptor for `SetSubscriptionEnabledRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setSubscriptionEnabledRequestDescriptor =
    $convert.base64Decode(
        'Ch1TZXRTdWJzY3JpcHRpb25FbmFibGVkUmVxdWVzdBIOCgJpZBgBIAEoCVICaWQSGAoHZW5hYm'
        'xlZBgCIAEoCFIHZW5hYmxlZA==');

@$core.Deprecated('Use configureSubscriptionUpdatesRequestDescriptor instead')
const ConfigureSubscriptionUpdatesRequest$json = {
  '1': 'ConfigureSubscriptionUpdatesRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'enabled', '3': 2, '4': 1, '5': 8, '10': 'enabled'},
    {
      '1': 'update_interval_seconds',
      '3': 3,
      '4': 1,
      '5': 3,
      '10': 'updateIntervalSeconds'
    },
  ],
};

/// Descriptor for `ConfigureSubscriptionUpdatesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List configureSubscriptionUpdatesRequestDescriptor =
    $convert.base64Decode(
        'CiNDb25maWd1cmVTdWJzY3JpcHRpb25VcGRhdGVzUmVxdWVzdBIOCgJpZBgBIAEoCVICaWQSGA'
        'oHZW5hYmxlZBgCIAEoCFIHZW5hYmxlZBI2Chd1cGRhdGVfaW50ZXJ2YWxfc2Vjb25kcxgDIAEo'
        'A1IVdXBkYXRlSW50ZXJ2YWxTZWNvbmRz');

@$core.Deprecated('Use resolvedEndpointsRequestDescriptor instead')
const ResolvedEndpointsRequest$json = {
  '1': 'ResolvedEndpointsRequest',
  '2': [
    {'1': 'enabled_only', '3': 1, '4': 1, '5': 8, '10': 'enabledOnly'},
  ],
};

/// Descriptor for `ResolvedEndpointsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resolvedEndpointsRequestDescriptor =
    $convert.base64Decode(
        'ChhSZXNvbHZlZEVuZHBvaW50c1JlcXVlc3QSIQoMZW5hYmxlZF9vbmx5GAEgASgIUgtlbmFibG'
        'VkT25seQ==');

@$core.Deprecated('Use subscriptionListDescriptor instead')
const SubscriptionList$json = {
  '1': 'SubscriptionList',
  '2': [
    {
      '1': 'subscriptions',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.targetlib.SubscriptionView',
      '10': 'subscriptions'
    },
  ],
  '9': [
    {'1': 2, '2': 3},
  ],
  '10': ['active_id'],
};

/// Descriptor for `SubscriptionList`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subscriptionListDescriptor = $convert.base64Decode(
    'ChBTdWJzY3JpcHRpb25MaXN0EkEKDXN1YnNjcmlwdGlvbnMYASADKAsyGy50YXJnZXRsaWIuU3'
    'Vic2NyaXB0aW9uVmlld1INc3Vic2NyaXB0aW9uc0oECAIQA1IJYWN0aXZlX2lk');

@$core.Deprecated('Use subscriptionViewDescriptor instead')
const SubscriptionView$json = {
  '1': 'SubscriptionView',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'source', '3': 3, '4': 1, '5': 9, '10': 'source'},
    {'1': 'enabled', '3': 4, '4': 1, '5': 8, '10': 'enabled'},
    {'1': 'auto_update', '3': 5, '4': 1, '5': 8, '10': 'autoUpdate'},
    {
      '1': 'update_interval_seconds',
      '3': 6,
      '4': 1,
      '5': 3,
      '10': 'updateIntervalSeconds'
    },
    {
      '1': 'status',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.targetlib.SubscriptionStatus',
      '10': 'status'
    },
    {
      '1': 'stage',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.targetlib.SubscriptionUpdateStage',
      '10': 'stage'
    },
    {
      '1': 'profile',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.targetlib.ProfileView',
      '10': 'profile'
    },
    {'1': 'error_code', '3': 10, '4': 1, '5': 9, '10': 'errorCode'},
    {'1': 'error_message', '3': 11, '4': 1, '5': 9, '10': 'errorMessage'},
    {
      '1': 'updated_at_unix_ms',
      '3': 12,
      '4': 1,
      '5': 3,
      '10': 'updatedAtUnixMs'
    },
    {
      '1': 'next_update_at_unix_ms',
      '3': 13,
      '4': 1,
      '5': 3,
      '10': 'nextUpdateAtUnixMs'
    },
    {'1': 'upload_bytes', '3': 14, '4': 1, '5': 3, '10': 'uploadBytes'},
    {'1': 'download_bytes', '3': 15, '4': 1, '5': 3, '10': 'downloadBytes'},
    {'1': 'total_bytes', '3': 16, '4': 1, '5': 3, '10': 'totalBytes'},
    {
      '1': 'expires_at_unix_ms',
      '3': 17,
      '4': 1,
      '5': 3,
      '10': 'expiresAtUnixMs'
    },
    {'1': 'title', '3': 18, '4': 1, '5': 9, '10': 'title'},
    {'1': 'web_page_url', '3': 19, '4': 1, '5': 9, '10': 'webPageUrl'},
    {'1': 'support_url', '3': 20, '4': 1, '5': 9, '10': 'supportUrl'},
    {
      '1': 'moved_permanently_to',
      '3': 21,
      '4': 1,
      '5': 9,
      '10': 'movedPermanentlyTo'
    },
  ],
};

/// Descriptor for `SubscriptionView`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subscriptionViewDescriptor = $convert.base64Decode(
    'ChBTdWJzY3JpcHRpb25WaWV3Eg4KAmlkGAEgASgJUgJpZBISCgRuYW1lGAIgASgJUgRuYW1lEh'
    'YKBnNvdXJjZRgDIAEoCVIGc291cmNlEhgKB2VuYWJsZWQYBCABKAhSB2VuYWJsZWQSHwoLYXV0'
    'b191cGRhdGUYBSABKAhSCmF1dG9VcGRhdGUSNgoXdXBkYXRlX2ludGVydmFsX3NlY29uZHMYBi'
    'ABKANSFXVwZGF0ZUludGVydmFsU2Vjb25kcxI1CgZzdGF0dXMYByABKA4yHS50YXJnZXRsaWIu'
    'U3Vic2NyaXB0aW9uU3RhdHVzUgZzdGF0dXMSOAoFc3RhZ2UYCCABKA4yIi50YXJnZXRsaWIuU3'
    'Vic2NyaXB0aW9uVXBkYXRlU3RhZ2VSBXN0YWdlEjAKB3Byb2ZpbGUYCSABKAsyFi50YXJnZXRs'
    'aWIuUHJvZmlsZVZpZXdSB3Byb2ZpbGUSHQoKZXJyb3JfY29kZRgKIAEoCVIJZXJyb3JDb2RlEi'
    'MKDWVycm9yX21lc3NhZ2UYCyABKAlSDGVycm9yTWVzc2FnZRIrChJ1cGRhdGVkX2F0X3VuaXhf'
    'bXMYDCABKANSD3VwZGF0ZWRBdFVuaXhNcxIyChZuZXh0X3VwZGF0ZV9hdF91bml4X21zGA0gAS'
    'gDUhJuZXh0VXBkYXRlQXRVbml4TXMSIQoMdXBsb2FkX2J5dGVzGA4gASgDUgt1cGxvYWRCeXRl'
    'cxIlCg5kb3dubG9hZF9ieXRlcxgPIAEoA1INZG93bmxvYWRCeXRlcxIfCgt0b3RhbF9ieXRlcx'
    'gQIAEoA1IKdG90YWxCeXRlcxIrChJleHBpcmVzX2F0X3VuaXhfbXMYESABKANSD2V4cGlyZXNB'
    'dFVuaXhNcxIUCgV0aXRsZRgSIAEoCVIFdGl0bGUSIAoMd2ViX3BhZ2VfdXJsGBMgASgJUgp3ZW'
    'JQYWdlVXJsEh8KC3N1cHBvcnRfdXJsGBQgASgJUgpzdXBwb3J0VXJsEjAKFG1vdmVkX3Blcm1h'
    'bmVudGx5X3RvGBUgASgJUhJtb3ZlZFBlcm1hbmVudGx5VG8=');

@$core.Deprecated('Use profileViewDescriptor instead')
const ProfileView$json = {
  '1': 'ProfileView',
  '2': [
    {
      '1': 'nodes',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.targetlib.ProfileNode',
      '10': 'nodes'
    },
  ],
  '9': [
    {'1': 2, '2': 7},
  ],
  '10': [
    'groups',
    'custom_outbounds',
    'custom_inbounds',
    'route_rule_count',
    'dns'
  ],
};

/// Descriptor for `ProfileView`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List profileViewDescriptor = $convert.base64Decode(
    'CgtQcm9maWxlVmlldxIsCgVub2RlcxgBIAMoCzIWLnRhcmdldGxpYi5Qcm9maWxlTm9kZVIFbm'
    '9kZXNKBAgCEAdSBmdyb3Vwc1IQY3VzdG9tX291dGJvdW5kc1IPY3VzdG9tX2luYm91bmRzUhBy'
    'b3V0ZV9ydWxlX2NvdW50UgNkbnM=');

@$core.Deprecated('Use profileNodeDescriptor instead')
const ProfileNode$json = {
  '1': 'ProfileNode',
  '2': [
    {'1': 'subscription_id', '3': 10, '4': 1, '5': 9, '10': 'subscriptionId'},
    {'1': 'tag', '3': 1, '4': 1, '5': 9, '10': 'tag'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'type', '3': 3, '4': 1, '5': 9, '10': 'type'},
    {'1': 'server', '3': 4, '4': 1, '5': 9, '10': 'server'},
    {'1': 'port', '3': 5, '4': 1, '5': 5, '10': 'port'},
    {
      '1': 'phase',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.targetlib.ProfileNodePhase',
      '10': 'phase'
    },
    {'1': 'error_message', '3': 8, '4': 1, '5': 9, '10': 'errorMessage'},
    {'1': 'country_code', '3': 9, '4': 1, '5': 9, '10': 'countryCode'},
  ],
  '9': [
    {'1': 6, '2': 7},
  ],
  '10': ['group_tags'],
};

/// Descriptor for `ProfileNode`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List profileNodeDescriptor = $convert.base64Decode(
    'CgtQcm9maWxlTm9kZRInCg9zdWJzY3JpcHRpb25faWQYCiABKAlSDnN1YnNjcmlwdGlvbklkEh'
    'AKA3RhZxgBIAEoCVIDdGFnEhIKBG5hbWUYAiABKAlSBG5hbWUSEgoEdHlwZRgDIAEoCVIEdHlw'
    'ZRIWCgZzZXJ2ZXIYBCABKAlSBnNlcnZlchISCgRwb3J0GAUgASgFUgRwb3J0EjEKBXBoYXNlGA'
    'cgASgOMhsudGFyZ2V0bGliLlByb2ZpbGVOb2RlUGhhc2VSBXBoYXNlEiMKDWVycm9yX21lc3Nh'
    'Z2UYCCABKAlSDGVycm9yTWVzc2FnZRIhCgxjb3VudHJ5X2NvZGUYCSABKAlSC2NvdW50cnlDb2'
    'RlSgQIBhAHUgpncm91cF90YWdz');

@$core.Deprecated('Use subscriptionUpdateResultDescriptor instead')
const SubscriptionUpdateResult$json = {
  '1': 'SubscriptionUpdateResult',
  '2': [
    {
      '1': 'subscription',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.targetlib.SubscriptionView',
      '10': 'subscription'
    },
    {'1': 'changed', '3': 2, '4': 1, '5': 8, '10': 'changed'},
    {'1': 'not_modified', '3': 3, '4': 1, '5': 8, '10': 'notModified'},
    {
      '1': 'duration_milliseconds',
      '3': 4,
      '4': 1,
      '5': 3,
      '10': 'durationMilliseconds'
    },
    {'1': 'original_config', '3': 5, '4': 1, '5': 12, '10': 'originalConfig'},
    {'1': 'generated_config', '3': 6, '4': 1, '5': 12, '10': 'generatedConfig'},
  ],
};

/// Descriptor for `SubscriptionUpdateResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subscriptionUpdateResultDescriptor = $convert.base64Decode(
    'ChhTdWJzY3JpcHRpb25VcGRhdGVSZXN1bHQSPwoMc3Vic2NyaXB0aW9uGAEgASgLMhsudGFyZ2'
    'V0bGliLlN1YnNjcmlwdGlvblZpZXdSDHN1YnNjcmlwdGlvbhIYCgdjaGFuZ2VkGAIgASgIUgdj'
    'aGFuZ2VkEiEKDG5vdF9tb2RpZmllZBgDIAEoCFILbm90TW9kaWZpZWQSMwoVZHVyYXRpb25fbW'
    'lsbGlzZWNvbmRzGAQgASgDUhRkdXJhdGlvbk1pbGxpc2Vjb25kcxInCg9vcmlnaW5hbF9jb25m'
    'aWcYBSABKAxSDm9yaWdpbmFsQ29uZmlnEikKEGdlbmVyYXRlZF9jb25maWcYBiABKAxSD2dlbm'
    'VyYXRlZENvbmZpZw==');

@$core.Deprecated('Use runtimeSettingsDescriptor instead')
const RuntimeSettings$json = {
  '1': 'RuntimeSettings',
  '2': [
    {'1': 'listen_address', '3': 1, '4': 1, '5': 9, '10': 'listenAddress'},
    {'1': 'mixed_port', '3': 2, '4': 1, '5': 13, '10': 'mixedPort'},
    {
      '1': 'proxy_mode',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.targetlib.ProxyMode',
      '10': 'proxyMode'
    },
    {'1': 'ipv6', '3': 4, '4': 1, '5': 8, '10': 'ipv6'},
    {
      '1': 'route_mode',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.targetlib.RouteMode',
      '10': 'routeMode'
    },
  ],
};

/// Descriptor for `RuntimeSettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List runtimeSettingsDescriptor = $convert.base64Decode(
    'Cg9SdW50aW1lU2V0dGluZ3MSJQoObGlzdGVuX2FkZHJlc3MYASABKAlSDWxpc3RlbkFkZHJlc3'
    'MSHQoKbWl4ZWRfcG9ydBgCIAEoDVIJbWl4ZWRQb3J0EjMKCnByb3h5X21vZGUYAyABKA4yFC50'
    'YXJnZXRsaWIuUHJveHlNb2RlUglwcm94eU1vZGUSEgoEaXB2NhgEIAEoCFIEaXB2NhIzCgpyb3'
    'V0ZV9tb2RlGAUgASgOMhQudGFyZ2V0bGliLlJvdXRlTW9kZVIJcm91dGVNb2Rl');

@$core.Deprecated('Use runtimeConfigDescriptor instead')
const RuntimeConfig$json = {
  '1': 'RuntimeConfig',
  '2': [
    {
      '1': 'settings',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.targetlib.RuntimeSettings',
      '10': 'settings'
    },
    {
      '1': 'selectors',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.targetlib.SelectorConfig',
      '10': 'selectors'
    },
    {
      '1': 'service_routes',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.targetlib.ServiceRoute',
      '10': 'serviceRoutes'
    },
    {
      '1': 'service_bindings',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.targetlib.ServiceBinding',
      '10': 'serviceBindings'
    },
    {'1': 'revision', '3': 5, '4': 1, '5': 9, '10': 'revision'},
    {
      '1': 'node_pool_revision',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'nodePoolRevision'
    },
  ],
};

/// Descriptor for `RuntimeConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List runtimeConfigDescriptor = $convert.base64Decode(
    'Cg1SdW50aW1lQ29uZmlnEjYKCHNldHRpbmdzGAEgASgLMhoudGFyZ2V0bGliLlJ1bnRpbWVTZX'
    'R0aW5nc1IIc2V0dGluZ3MSNwoJc2VsZWN0b3JzGAIgAygLMhkudGFyZ2V0bGliLlNlbGVjdG9y'
    'Q29uZmlnUglzZWxlY3RvcnMSPgoOc2VydmljZV9yb3V0ZXMYAyADKAsyFy50YXJnZXRsaWIuU2'
    'VydmljZVJvdXRlUg1zZXJ2aWNlUm91dGVzEkQKEHNlcnZpY2VfYmluZGluZ3MYBCADKAsyGS50'
    'YXJnZXRsaWIuU2VydmljZUJpbmRpbmdSD3NlcnZpY2VCaW5kaW5ncxIaCghyZXZpc2lvbhgFIA'
    'EoCVIIcmV2aXNpb24SLAoSbm9kZV9wb29sX3JldmlzaW9uGAYgASgJUhBub2RlUG9vbFJldmlz'
    'aW9u');

@$core.Deprecated('Use updateRuntimeConfigRequestDescriptor instead')
const UpdateRuntimeConfigRequest$json = {
  '1': 'UpdateRuntimeConfigRequest',
  '2': [
    {
      '1': 'settings',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.targetlib.RuntimeSettings',
      '10': 'settings'
    },
    {
      '1': 'model',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.targetlib.RuntimeModel',
      '10': 'model'
    },
    {
      '1': 'expected_revision',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'expectedRevision'
    },
  ],
};

/// Descriptor for `UpdateRuntimeConfigRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateRuntimeConfigRequestDescriptor = $convert.base64Decode(
    'ChpVcGRhdGVSdW50aW1lQ29uZmlnUmVxdWVzdBI2CghzZXR0aW5ncxgBIAEoCzIaLnRhcmdldG'
    'xpYi5SdW50aW1lU2V0dGluZ3NSCHNldHRpbmdzEi0KBW1vZGVsGAIgASgLMhcudGFyZ2V0bGli'
    'LlJ1bnRpbWVNb2RlbFIFbW9kZWwSKwoRZXhwZWN0ZWRfcmV2aXNpb24YAyABKAlSEGV4cGVjdG'
    'VkUmV2aXNpb24=');

@$core.Deprecated('Use selectorConfigDescriptor instead')
const SelectorConfig$json = {
  '1': 'SelectorConfig',
  '2': [
    {'1': 'tag', '3': 1, '4': 1, '5': 9, '10': 'tag'},
    {'1': 'node_ids', '3': 2, '4': 3, '5': 9, '10': 'nodeIds'},
    {'1': 'selected_node_id', '3': 3, '4': 1, '5': 9, '10': 'selectedNodeId'},
  ],
};

/// Descriptor for `SelectorConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List selectorConfigDescriptor = $convert.base64Decode(
    'Cg5TZWxlY3RvckNvbmZpZxIQCgN0YWcYASABKAlSA3RhZxIZCghub2RlX2lkcxgCIAMoCVIHbm'
    '9kZUlkcxIoChBzZWxlY3RlZF9ub2RlX2lkGAMgASgJUg5zZWxlY3RlZE5vZGVJZA==');

@$core.Deprecated('Use serviceRouteDescriptor instead')
const ServiceRoute$json = {
  '1': 'ServiceRoute',
  '2': [
    {'1': 'service_id', '3': 1, '4': 1, '5': 9, '10': 'serviceId'},
    {'1': 'domains', '3': 2, '4': 3, '5': 9, '10': 'domains'},
    {'1': 'selector_tag', '3': 3, '4': 1, '5': 9, '10': 'selectorTag'},
    {'1': 'enabled', '3': 4, '4': 1, '5': 8, '10': 'enabled'},
  ],
};

/// Descriptor for `ServiceRoute`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serviceRouteDescriptor = $convert.base64Decode(
    'CgxTZXJ2aWNlUm91dGUSHQoKc2VydmljZV9pZBgBIAEoCVIJc2VydmljZUlkEhgKB2RvbWFpbn'
    'MYAiADKAlSB2RvbWFpbnMSIQoMc2VsZWN0b3JfdGFnGAMgASgJUgtzZWxlY3RvclRhZxIYCgdl'
    'bmFibGVkGAQgASgIUgdlbmFibGVk');

@$core.Deprecated('Use serviceBindingDescriptor instead')
const ServiceBinding$json = {
  '1': 'ServiceBinding',
  '2': [
    {'1': 'service_id', '3': 1, '4': 1, '5': 9, '10': 'serviceId'},
    {'1': 'selector_tag', '3': 2, '4': 1, '5': 9, '10': 'selectorTag'},
    {'1': 'node_id', '3': 3, '4': 1, '5': 9, '10': 'nodeId'},
    {'1': 'revision', '3': 4, '4': 1, '5': 9, '10': 'revision'},
    {
      '1': 'expires_at_unix_ms',
      '3': 5,
      '4': 1,
      '5': 3,
      '10': 'expiresAtUnixMs'
    },
    {
      '1': 'selected_at_unix_ms',
      '3': 6,
      '4': 1,
      '5': 3,
      '10': 'selectedAtUnixMs'
    },
    {'1': 'selected_score', '3': 7, '4': 1, '5': 1, '10': 'selectedScore'},
    {'1': 'selection_reason', '3': 8, '4': 1, '5': 9, '10': 'selectionReason'},
    {
      '1': 'selection_policy_revision',
      '3': 9,
      '4': 1,
      '5': 9,
      '10': 'selectionPolicyRevision'
    },
  ],
};

/// Descriptor for `ServiceBinding`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serviceBindingDescriptor = $convert.base64Decode(
    'Cg5TZXJ2aWNlQmluZGluZxIdCgpzZXJ2aWNlX2lkGAEgASgJUglzZXJ2aWNlSWQSIQoMc2VsZW'
    'N0b3JfdGFnGAIgASgJUgtzZWxlY3RvclRhZxIXCgdub2RlX2lkGAMgASgJUgZub2RlSWQSGgoI'
    'cmV2aXNpb24YBCABKAlSCHJldmlzaW9uEisKEmV4cGlyZXNfYXRfdW5peF9tcxgFIAEoA1IPZX'
    'hwaXJlc0F0VW5peE1zEi0KE3NlbGVjdGVkX2F0X3VuaXhfbXMYBiABKANSEHNlbGVjdGVkQXRV'
    'bml4TXMSJQoOc2VsZWN0ZWRfc2NvcmUYByABKAFSDXNlbGVjdGVkU2NvcmUSKQoQc2VsZWN0aW'
    '9uX3JlYXNvbhgIIAEoCVIPc2VsZWN0aW9uUmVhc29uEjoKGXNlbGVjdGlvbl9wb2xpY3lfcmV2'
    'aXNpb24YCSABKAlSF3NlbGVjdGlvblBvbGljeVJldmlzaW9u');

@$core.Deprecated('Use runtimeModelDescriptor instead')
const RuntimeModel$json = {
  '1': 'RuntimeModel',
  '2': [
    {
      '1': 'selectors',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.targetlib.SelectorConfig',
      '10': 'selectors'
    },
    {
      '1': 'service_routes',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.targetlib.ServiceRoute',
      '10': 'serviceRoutes'
    },
    {
      '1': 'service_bindings',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.targetlib.ServiceBinding',
      '10': 'serviceBindings'
    },
  ],
};

/// Descriptor for `RuntimeModel`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List runtimeModelDescriptor = $convert.base64Decode(
    'CgxSdW50aW1lTW9kZWwSNwoJc2VsZWN0b3JzGAEgAygLMhkudGFyZ2V0bGliLlNlbGVjdG9yQ2'
    '9uZmlnUglzZWxlY3RvcnMSPgoOc2VydmljZV9yb3V0ZXMYAiADKAsyFy50YXJnZXRsaWIuU2Vy'
    'dmljZVJvdXRlUg1zZXJ2aWNlUm91dGVzEkQKEHNlcnZpY2VfYmluZGluZ3MYAyADKAsyGS50YX'
    'JnZXRsaWIuU2VydmljZUJpbmRpbmdSD3NlcnZpY2VCaW5kaW5ncw==');

@$core.Deprecated('Use nodePoolDescriptor instead')
const NodePool$json = {
  '1': 'NodePool',
  '2': [
    {'1': 'revision', '3': 1, '4': 1, '5': 9, '10': 'revision'},
    {
      '1': 'nodes',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.targetlib.ProfileNode',
      '10': 'nodes'
    },
  ],
};

/// Descriptor for `NodePool`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List nodePoolDescriptor = $convert.base64Decode(
    'CghOb2RlUG9vbBIaCghyZXZpc2lvbhgBIAEoCVIIcmV2aXNpb24SLAoFbm9kZXMYAiADKAsyFi'
    '50YXJnZXRsaWIuUHJvZmlsZU5vZGVSBW5vZGVz');

@$core.Deprecated('Use applyServiceBindingRequestDescriptor instead')
const ApplyServiceBindingRequest$json = {
  '1': 'ApplyServiceBindingRequest',
  '2': [
    {
      '1': 'binding',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.targetlib.ServiceBinding',
      '10': 'binding'
    },
    {
      '1': 'expected_revision',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'expectedRevision'
    },
  ],
};

/// Descriptor for `ApplyServiceBindingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List applyServiceBindingRequestDescriptor =
    $convert.base64Decode(
        'ChpBcHBseVNlcnZpY2VCaW5kaW5nUmVxdWVzdBIzCgdiaW5kaW5nGAEgASgLMhkudGFyZ2V0bG'
        'liLlNlcnZpY2VCaW5kaW5nUgdiaW5kaW5nEisKEWV4cGVjdGVkX3JldmlzaW9uGAIgASgJUhBl'
        'eHBlY3RlZFJldmlzaW9u');

@$core.Deprecated('Use removeServiceBindingRequestDescriptor instead')
const RemoveServiceBindingRequest$json = {
  '1': 'RemoveServiceBindingRequest',
  '2': [
    {'1': 'service_id', '3': 1, '4': 1, '5': 9, '10': 'serviceId'},
    {
      '1': 'expected_revision',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'expectedRevision'
    },
  ],
};

/// Descriptor for `RemoveServiceBindingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removeServiceBindingRequestDescriptor =
    $convert.base64Decode(
        'ChtSZW1vdmVTZXJ2aWNlQmluZGluZ1JlcXVlc3QSHQoKc2VydmljZV9pZBgBIAEoCVIJc2Vydm'
        'ljZUlkEisKEWV4cGVjdGVkX3JldmlzaW9uGAIgASgJUhBleHBlY3RlZFJldmlzaW9u');

@$core.Deprecated('Use serviceBindingListDescriptor instead')
const ServiceBindingList$json = {
  '1': 'ServiceBindingList',
  '2': [
    {
      '1': 'bindings',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.targetlib.ServiceBinding',
      '10': 'bindings'
    },
  ],
};

/// Descriptor for `ServiceBindingList`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serviceBindingListDescriptor = $convert.base64Decode(
    'ChJTZXJ2aWNlQmluZGluZ0xpc3QSNQoIYmluZGluZ3MYASADKAsyGS50YXJnZXRsaWIuU2Vydm'
    'ljZUJpbmRpbmdSCGJpbmRpbmdz');

@$core.Deprecated('Use selectorStateDescriptor instead')
const SelectorState$json = {
  '1': 'SelectorState',
  '2': [
    {
      '1': 'desired',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.targetlib.SelectorConfig',
      '10': 'desired'
    },
    {'1': 'actual_node_id', '3': 2, '4': 1, '5': 9, '10': 'actualNodeId'},
    {'1': 'effective', '3': 3, '4': 1, '5': 8, '10': 'effective'},
  ],
};

/// Descriptor for `SelectorState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List selectorStateDescriptor = $convert.base64Decode(
    'Cg1TZWxlY3RvclN0YXRlEjMKB2Rlc2lyZWQYASABKAsyGS50YXJnZXRsaWIuU2VsZWN0b3JDb2'
    '5maWdSB2Rlc2lyZWQSJAoOYWN0dWFsX25vZGVfaWQYAiABKAlSDGFjdHVhbE5vZGVJZBIcCgll'
    'ZmZlY3RpdmUYAyABKAhSCWVmZmVjdGl2ZQ==');

@$core.Deprecated('Use serviceRouteStateDescriptor instead')
const ServiceRouteState$json = {
  '1': 'ServiceRouteState',
  '2': [
    {
      '1': 'desired',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.targetlib.ServiceRoute',
      '10': 'desired'
    },
    {'1': 'effective', '3': 2, '4': 1, '5': 8, '10': 'effective'},
  ],
};

/// Descriptor for `ServiceRouteState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serviceRouteStateDescriptor = $convert.base64Decode(
    'ChFTZXJ2aWNlUm91dGVTdGF0ZRIxCgdkZXNpcmVkGAEgASgLMhcudGFyZ2V0bGliLlNlcnZpY2'
    'VSb3V0ZVIHZGVzaXJlZBIcCgllZmZlY3RpdmUYAiABKAhSCWVmZmVjdGl2ZQ==');

@$core.Deprecated('Use serviceBindingStateDescriptor instead')
const ServiceBindingState$json = {
  '1': 'ServiceBindingState',
  '2': [
    {
      '1': 'desired',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.targetlib.ServiceBinding',
      '10': 'desired'
    },
    {'1': 'effective', '3': 2, '4': 1, '5': 8, '10': 'effective'},
    {'1': 'node_available', '3': 3, '4': 1, '5': 8, '10': 'nodeAvailable'},
    {'1': 'needs_evaluation', '3': 4, '4': 1, '5': 8, '10': 'needsEvaluation'},
    {
      '1': 'evaluation_reason',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'evaluationReason'
    },
  ],
};

/// Descriptor for `ServiceBindingState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serviceBindingStateDescriptor = $convert.base64Decode(
    'ChNTZXJ2aWNlQmluZGluZ1N0YXRlEjMKB2Rlc2lyZWQYASABKAsyGS50YXJnZXRsaWIuU2Vydm'
    'ljZUJpbmRpbmdSB2Rlc2lyZWQSHAoJZWZmZWN0aXZlGAIgASgIUgllZmZlY3RpdmUSJQoObm9k'
    'ZV9hdmFpbGFibGUYAyABKAhSDW5vZGVBdmFpbGFibGUSKQoQbmVlZHNfZXZhbHVhdGlvbhgEIA'
    'EoCFIPbmVlZHNFdmFsdWF0aW9uEisKEWV2YWx1YXRpb25fcmVhc29uGAUgASgJUhBldmFsdWF0'
    'aW9uUmVhc29u');

@$core.Deprecated('Use serviceProbeDescriptor instead')
const ServiceProbe$json = {
  '1': 'ServiceProbe',
  '2': [
    {'1': 'service_id', '3': 1, '4': 1, '5': 9, '10': 'serviceId'},
    {'1': 'url', '3': 2, '4': 1, '5': 9, '10': 'url'},
    {'1': 'expected_status', '3': 3, '4': 3, '5': 13, '10': 'expectedStatus'},
    {'1': 'body_contains', '3': 4, '4': 1, '5': 9, '10': 'bodyContains'},
    {
      '1': 'allowed_countries',
      '3': 5,
      '4': 3,
      '5': 9,
      '10': 'allowedCountries'
    },
    {'1': 'egress_url', '3': 6, '4': 1, '5': 9, '10': 'egressUrl'},
    {
      '1': 'service_country_header',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'serviceCountryHeader'
    },
    {
      '1': 'timeout_milliseconds',
      '3': 8,
      '4': 1,
      '5': 13,
      '10': 'timeoutMilliseconds'
    },
    {'1': 'validity_seconds', '3': 9, '4': 1, '5': 13, '10': 'validitySeconds'},
    {'1': 'revision', '3': 10, '4': 1, '5': 9, '10': 'revision'},
    {'1': 'udp_echo_address', '3': 11, '4': 1, '5': 9, '10': 'udpEchoAddress'},
    {'1': 'packet_count', '3': 12, '4': 1, '5': 13, '10': 'packetCount'},
    {
      '1': 'packet_timeout_milliseconds',
      '3': 13,
      '4': 1,
      '5': 13,
      '10': 'packetTimeoutMilliseconds'
    },
    {
      '1': 'maximum_packet_loss',
      '3': 14,
      '4': 1,
      '5': 1,
      '9': 0,
      '10': 'maximumPacketLoss',
      '17': true
    },
  ],
  '8': [
    {'1': '_maximum_packet_loss'},
  ],
};

/// Descriptor for `ServiceProbe`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serviceProbeDescriptor = $convert.base64Decode(
    'CgxTZXJ2aWNlUHJvYmUSHQoKc2VydmljZV9pZBgBIAEoCVIJc2VydmljZUlkEhAKA3VybBgCIA'
    'EoCVIDdXJsEicKD2V4cGVjdGVkX3N0YXR1cxgDIAMoDVIOZXhwZWN0ZWRTdGF0dXMSIwoNYm9k'
    'eV9jb250YWlucxgEIAEoCVIMYm9keUNvbnRhaW5zEisKEWFsbG93ZWRfY291bnRyaWVzGAUgAy'
    'gJUhBhbGxvd2VkQ291bnRyaWVzEh0KCmVncmVzc191cmwYBiABKAlSCWVncmVzc1VybBI0ChZz'
    'ZXJ2aWNlX2NvdW50cnlfaGVhZGVyGAcgASgJUhRzZXJ2aWNlQ291bnRyeUhlYWRlchIxChR0aW'
    '1lb3V0X21pbGxpc2Vjb25kcxgIIAEoDVITdGltZW91dE1pbGxpc2Vjb25kcxIpChB2YWxpZGl0'
    'eV9zZWNvbmRzGAkgASgNUg92YWxpZGl0eVNlY29uZHMSGgoIcmV2aXNpb24YCiABKAlSCHJldm'
    'lzaW9uEigKEHVkcF9lY2hvX2FkZHJlc3MYCyABKAlSDnVkcEVjaG9BZGRyZXNzEiEKDHBhY2tl'
    'dF9jb3VudBgMIAEoDVILcGFja2V0Q291bnQSPgobcGFja2V0X3RpbWVvdXRfbWlsbGlzZWNvbm'
    'RzGA0gASgNUhlwYWNrZXRUaW1lb3V0TWlsbGlzZWNvbmRzEjMKE21heGltdW1fcGFja2V0X2xv'
    'c3MYDiABKAFIAFIRbWF4aW11bVBhY2tldExvc3OIAQFCFgoUX21heGltdW1fcGFja2V0X2xvc3'
    'M=');

@$core.Deprecated('Use serviceProbeListDescriptor instead')
const ServiceProbeList$json = {
  '1': 'ServiceProbeList',
  '2': [
    {
      '1': 'probes',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.targetlib.ServiceProbe',
      '10': 'probes'
    },
  ],
};

/// Descriptor for `ServiceProbeList`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serviceProbeListDescriptor = $convert.base64Decode(
    'ChBTZXJ2aWNlUHJvYmVMaXN0Ei8KBnByb2JlcxgBIAMoCzIXLnRhcmdldGxpYi5TZXJ2aWNlUH'
    'JvYmVSBnByb2Jlcw==');

@$core.Deprecated('Use removeServiceProbeRequestDescriptor instead')
const RemoveServiceProbeRequest$json = {
  '1': 'RemoveServiceProbeRequest',
  '2': [
    {'1': 'service_id', '3': 1, '4': 1, '5': 9, '10': 'serviceId'},
    {
      '1': 'expected_revision',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'expectedRevision'
    },
  ],
};

/// Descriptor for `RemoveServiceProbeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removeServiceProbeRequestDescriptor =
    $convert.base64Decode(
        'ChlSZW1vdmVTZXJ2aWNlUHJvYmVSZXF1ZXN0Eh0KCnNlcnZpY2VfaWQYASABKAlSCXNlcnZpY2'
        'VJZBIrChFleHBlY3RlZF9yZXZpc2lvbhgCIAEoCVIQZXhwZWN0ZWRSZXZpc2lvbg==');

@$core.Deprecated('Use probeServiceRequestDescriptor instead')
const ProbeServiceRequest$json = {
  '1': 'ProbeServiceRequest',
  '2': [
    {'1': 'service_id', '3': 1, '4': 1, '5': 9, '10': 'serviceId'},
    {'1': 'node_ids', '3': 2, '4': 3, '5': 9, '10': 'nodeIds'},
    {
      '1': 'headers',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.targetlib.ProbeServiceRequest.HeadersEntry',
      '10': 'headers'
    },
    {'1': 'attempts', '3': 4, '4': 1, '5': 13, '10': 'attempts'},
    {'1': 'max_concurrency', '3': 5, '4': 1, '5': 13, '10': 'maxConcurrency'},
  ],
  '3': [ProbeServiceRequest_HeadersEntry$json],
};

@$core.Deprecated('Use probeServiceRequestDescriptor instead')
const ProbeServiceRequest_HeadersEntry$json = {
  '1': 'HeadersEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `ProbeServiceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List probeServiceRequestDescriptor = $convert.base64Decode(
    'ChNQcm9iZVNlcnZpY2VSZXF1ZXN0Eh0KCnNlcnZpY2VfaWQYASABKAlSCXNlcnZpY2VJZBIZCg'
    'hub2RlX2lkcxgCIAMoCVIHbm9kZUlkcxJFCgdoZWFkZXJzGAMgAygLMisudGFyZ2V0bGliLlBy'
    'b2JlU2VydmljZVJlcXVlc3QuSGVhZGVyc0VudHJ5UgdoZWFkZXJzEhoKCGF0dGVtcHRzGAQgAS'
    'gNUghhdHRlbXB0cxInCg9tYXhfY29uY3VycmVuY3kYBSABKA1SDm1heENvbmN1cnJlbmN5GjoK'
    'DEhlYWRlcnNFbnRyeRIQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoCVIFdmFsdWU6Aj'
    'gB');

@$core.Deprecated('Use probeResultDescriptor instead')
const ProbeResult$json = {
  '1': 'ProbeResult',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'service_id', '3': 2, '4': 1, '5': 9, '10': 'serviceId'},
    {'1': 'node_id', '3': 3, '4': 1, '5': 9, '10': 'nodeId'},
    {
      '1': 'node_pool_revision',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'nodePoolRevision'
    },
    {'1': 'probe_revision', '3': 5, '4': 1, '5': 9, '10': 'probeRevision'},
    {
      '1': 'stage',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.targetlib.ProbeStage',
      '10': 'stage'
    },
    {'1': 'error_message', '3': 7, '4': 1, '5': 9, '10': 'errorMessage'},
    {'1': 'tested_at_unix_ms', '3': 8, '4': 1, '5': 3, '10': 'testedAtUnixMs'},
    {
      '1': 'expires_at_unix_ms',
      '3': 9,
      '4': 1,
      '5': 3,
      '10': 'expiresAtUnixMs'
    },
    {
      '1': 'latency_milliseconds',
      '3': 10,
      '4': 1,
      '5': 13,
      '10': 'latencyMilliseconds'
    },
    {'1': 'http_status', '3': 11, '4': 1, '5': 13, '10': 'httpStatus'},
    {'1': 'declared_country', '3': 12, '4': 1, '5': 9, '10': 'declaredCountry'},
    {'1': 'observed_country', '3': 13, '4': 1, '5': 9, '10': 'observedCountry'},
    {'1': 'service_country', '3': 14, '4': 1, '5': 9, '10': 'serviceCountry'},
    {'1': 'egress_ip', '3': 15, '4': 1, '5': 9, '10': 'egressIp'},
    {'1': 'attempts', '3': 16, '4': 1, '5': 13, '10': 'attempts'},
    {'1': 'successes', '3': 17, '4': 1, '5': 13, '10': 'successes'},
    {'1': 'failure_ratio', '3': 18, '4': 1, '5': 1, '10': 'failureRatio'},
    {
      '1': 'jitter_milliseconds',
      '3': 19,
      '4': 1,
      '5': 13,
      '10': 'jitterMilliseconds'
    },
    {
      '1': 'packet_loss_available',
      '3': 20,
      '4': 1,
      '5': 8,
      '10': 'packetLossAvailable'
    },
    {
      '1': 'packet_loss_ratio',
      '3': 21,
      '4': 1,
      '5': 1,
      '10': 'packetLossRatio'
    },
    {'1': 'packets_sent', '3': 22, '4': 1, '5': 13, '10': 'packetsSent'},
    {
      '1': 'packets_received',
      '3': 23,
      '4': 1,
      '5': 13,
      '10': 'packetsReceived'
    },
    {'1': 'packet_error', '3': 24, '4': 1, '5': 9, '10': 'packetError'},
  ],
};

/// Descriptor for `ProbeResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List probeResultDescriptor = $convert.base64Decode(
    'CgtQcm9iZVJlc3VsdBIOCgJpZBgBIAEoCVICaWQSHQoKc2VydmljZV9pZBgCIAEoCVIJc2Vydm'
    'ljZUlkEhcKB25vZGVfaWQYAyABKAlSBm5vZGVJZBIsChJub2RlX3Bvb2xfcmV2aXNpb24YBCAB'
    'KAlSEG5vZGVQb29sUmV2aXNpb24SJQoOcHJvYmVfcmV2aXNpb24YBSABKAlSDXByb2JlUmV2aX'
    'Npb24SKwoFc3RhZ2UYBiABKA4yFS50YXJnZXRsaWIuUHJvYmVTdGFnZVIFc3RhZ2USIwoNZXJy'
    'b3JfbWVzc2FnZRgHIAEoCVIMZXJyb3JNZXNzYWdlEikKEXRlc3RlZF9hdF91bml4X21zGAggAS'
    'gDUg50ZXN0ZWRBdFVuaXhNcxIrChJleHBpcmVzX2F0X3VuaXhfbXMYCSABKANSD2V4cGlyZXNB'
    'dFVuaXhNcxIxChRsYXRlbmN5X21pbGxpc2Vjb25kcxgKIAEoDVITbGF0ZW5jeU1pbGxpc2Vjb2'
    '5kcxIfCgtodHRwX3N0YXR1cxgLIAEoDVIKaHR0cFN0YXR1cxIpChBkZWNsYXJlZF9jb3VudHJ5'
    'GAwgASgJUg9kZWNsYXJlZENvdW50cnkSKQoQb2JzZXJ2ZWRfY291bnRyeRgNIAEoCVIPb2JzZX'
    'J2ZWRDb3VudHJ5EicKD3NlcnZpY2VfY291bnRyeRgOIAEoCVIOc2VydmljZUNvdW50cnkSGwoJ'
    'ZWdyZXNzX2lwGA8gASgJUghlZ3Jlc3NJcBIaCghhdHRlbXB0cxgQIAEoDVIIYXR0ZW1wdHMSHA'
    'oJc3VjY2Vzc2VzGBEgASgNUglzdWNjZXNzZXMSIwoNZmFpbHVyZV9yYXRpbxgSIAEoAVIMZmFp'
    'bHVyZVJhdGlvEi8KE2ppdHRlcl9taWxsaXNlY29uZHMYEyABKA1SEmppdHRlck1pbGxpc2Vjb2'
    '5kcxIyChVwYWNrZXRfbG9zc19hdmFpbGFibGUYFCABKAhSE3BhY2tldExvc3NBdmFpbGFibGUS'
    'KgoRcGFja2V0X2xvc3NfcmF0aW8YFSABKAFSD3BhY2tldExvc3NSYXRpbxIhCgxwYWNrZXRzX3'
    'NlbnQYFiABKA1SC3BhY2tldHNTZW50EikKEHBhY2tldHNfcmVjZWl2ZWQYFyABKA1SD3BhY2tl'
    'dHNSZWNlaXZlZBIhCgxwYWNrZXRfZXJyb3IYGCABKAlSC3BhY2tldEVycm9y');

@$core.Deprecated('Use qualityHistoryRequestDescriptor instead')
const QualityHistoryRequest$json = {
  '1': 'QualityHistoryRequest',
  '2': [
    {'1': 'service_id', '3': 1, '4': 1, '5': 9, '10': 'serviceId'},
    {'1': 'node_id', '3': 2, '4': 1, '5': 9, '10': 'nodeId'},
    {'1': 'limit', '3': 3, '4': 1, '5': 13, '10': 'limit'},
  ],
};

/// Descriptor for `QualityHistoryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List qualityHistoryRequestDescriptor = $convert.base64Decode(
    'ChVRdWFsaXR5SGlzdG9yeVJlcXVlc3QSHQoKc2VydmljZV9pZBgBIAEoCVIJc2VydmljZUlkEh'
    'cKB25vZGVfaWQYAiABKAlSBm5vZGVJZBIUCgVsaW1pdBgDIAEoDVIFbGltaXQ=');

@$core.Deprecated('Use qualityHistoryDescriptor instead')
const QualityHistory$json = {
  '1': 'QualityHistory',
  '2': [
    {
      '1': 'results',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.targetlib.ProbeResult',
      '10': 'results'
    },
  ],
};

/// Descriptor for `QualityHistory`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List qualityHistoryDescriptor = $convert.base64Decode(
    'Cg5RdWFsaXR5SGlzdG9yeRIwCgdyZXN1bHRzGAEgAygLMhYudGFyZ2V0bGliLlByb2JlUmVzdW'
    'x0UgdyZXN1bHRz');

@$core.Deprecated('Use evaluateServiceRequestDescriptor instead')
const EvaluateServiceRequest$json = {
  '1': 'EvaluateServiceRequest',
  '2': [
    {'1': 'service_id', '3': 1, '4': 1, '5': 9, '10': 'serviceId'},
  ],
};

/// Descriptor for `EvaluateServiceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List evaluateServiceRequestDescriptor =
    $convert.base64Decode(
        'ChZFdmFsdWF0ZVNlcnZpY2VSZXF1ZXN0Eh0KCnNlcnZpY2VfaWQYASABKAlSCXNlcnZpY2VJZA'
        '==');

@$core.Deprecated('Use serviceSelectionPolicyRequestDescriptor instead')
const ServiceSelectionPolicyRequest$json = {
  '1': 'ServiceSelectionPolicyRequest',
  '2': [
    {'1': 'service_id', '3': 1, '4': 1, '5': 9, '10': 'serviceId'},
  ],
};

/// Descriptor for `ServiceSelectionPolicyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serviceSelectionPolicyRequestDescriptor =
    $convert.base64Decode(
        'Ch1TZXJ2aWNlU2VsZWN0aW9uUG9saWN5UmVxdWVzdBIdCgpzZXJ2aWNlX2lkGAEgASgJUglzZX'
        'J2aWNlSWQ=');

@$core.Deprecated('Use serviceSelectionPolicyDescriptor instead')
const ServiceSelectionPolicy$json = {
  '1': 'ServiceSelectionPolicy',
  '2': [
    {'1': 'service_id', '3': 1, '4': 1, '5': 9, '10': 'serviceId'},
    {
      '1': 'preferred_countries',
      '3': 2,
      '4': 3,
      '5': 9,
      '10': 'preferredCountries'
    },
    {'1': 'subscription_ids', '3': 3, '4': 3, '5': 9, '10': 'subscriptionIds'},
    {'1': 'excluded_node_ids', '3': 4, '4': 3, '5': 9, '10': 'excludedNodeIds'},
    {'1': 'favorite_node_ids', '3': 5, '4': 3, '5': 9, '10': 'favoriteNodeIds'},
    {'1': 'allow_direct', '3': 6, '4': 1, '5': 8, '10': 'allowDirect'},
    {'1': 'max_candidates', '3': 7, '4': 1, '5': 13, '10': 'maxCandidates'},
    {'1': 'revision', '3': 8, '4': 1, '5': 9, '10': 'revision'},
    {
      '1': 'expected_revision',
      '3': 9,
      '4': 1,
      '5': 9,
      '10': 'expectedRevision'
    },
  ],
};

/// Descriptor for `ServiceSelectionPolicy`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serviceSelectionPolicyDescriptor = $convert.base64Decode(
    'ChZTZXJ2aWNlU2VsZWN0aW9uUG9saWN5Eh0KCnNlcnZpY2VfaWQYASABKAlSCXNlcnZpY2VJZB'
    'IvChNwcmVmZXJyZWRfY291bnRyaWVzGAIgAygJUhJwcmVmZXJyZWRDb3VudHJpZXMSKQoQc3Vi'
    'c2NyaXB0aW9uX2lkcxgDIAMoCVIPc3Vic2NyaXB0aW9uSWRzEioKEWV4Y2x1ZGVkX25vZGVfaW'
    'RzGAQgAygJUg9leGNsdWRlZE5vZGVJZHMSKgoRZmF2b3JpdGVfbm9kZV9pZHMYBSADKAlSD2Zh'
    'dm9yaXRlTm9kZUlkcxIhCgxhbGxvd19kaXJlY3QYBiABKAhSC2FsbG93RGlyZWN0EiUKDm1heF'
    '9jYW5kaWRhdGVzGAcgASgNUg1tYXhDYW5kaWRhdGVzEhoKCHJldmlzaW9uGAggASgJUghyZXZp'
    'c2lvbhIrChFleHBlY3RlZF9yZXZpc2lvbhgJIAEoCVIQZXhwZWN0ZWRSZXZpc2lvbg==');

@$core.Deprecated('Use serviceCandidateDescriptor instead')
const ServiceCandidate$json = {
  '1': 'ServiceCandidate',
  '2': [
    {'1': 'node_id', '3': 1, '4': 1, '5': 9, '10': 'nodeId'},
    {'1': 'eligible', '3': 2, '4': 1, '5': 8, '10': 'eligible'},
    {'1': 'score', '3': 3, '4': 1, '5': 1, '10': 'score'},
    {'1': 'reason', '3': 4, '4': 1, '5': 9, '10': 'reason'},
    {
      '1': 'latest',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.targetlib.ProbeResult',
      '10': 'latest'
    },
    {'1': 'success_ratio', '3': 6, '4': 1, '5': 1, '10': 'successRatio'},
    {
      '1': 'mean_latency_milliseconds',
      '3': 7,
      '4': 1,
      '5': 1,
      '10': 'meanLatencyMilliseconds'
    },
    {
      '1': 'latency_trend_milliseconds',
      '3': 8,
      '4': 1,
      '5': 1,
      '10': 'latencyTrendMilliseconds'
    },
  ],
};

/// Descriptor for `ServiceCandidate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serviceCandidateDescriptor = $convert.base64Decode(
    'ChBTZXJ2aWNlQ2FuZGlkYXRlEhcKB25vZGVfaWQYASABKAlSBm5vZGVJZBIaCghlbGlnaWJsZR'
    'gCIAEoCFIIZWxpZ2libGUSFAoFc2NvcmUYAyABKAFSBXNjb3JlEhYKBnJlYXNvbhgEIAEoCVIG'
    'cmVhc29uEi4KBmxhdGVzdBgFIAEoCzIWLnRhcmdldGxpYi5Qcm9iZVJlc3VsdFIGbGF0ZXN0Ei'
    'MKDXN1Y2Nlc3NfcmF0aW8YBiABKAFSDHN1Y2Nlc3NSYXRpbxI6ChltZWFuX2xhdGVuY3lfbWls'
    'bGlzZWNvbmRzGAcgASgBUhdtZWFuTGF0ZW5jeU1pbGxpc2Vjb25kcxI8ChpsYXRlbmN5X3RyZW'
    '5kX21pbGxpc2Vjb25kcxgIIAEoAVIYbGF0ZW5jeVRyZW5kTWlsbGlzZWNvbmRz');

@$core.Deprecated('Use serviceEvaluationDescriptor instead')
const ServiceEvaluation$json = {
  '1': 'ServiceEvaluation',
  '2': [
    {'1': 'service_id', '3': 1, '4': 1, '5': 9, '10': 'serviceId'},
    {
      '1': 'node_pool_revision',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'nodePoolRevision'
    },
    {'1': 'runtime_revision', '3': 3, '4': 1, '5': 9, '10': 'runtimeRevision'},
    {
      '1': 'candidates',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.targetlib.ServiceCandidate',
      '10': 'candidates'
    },
    {
      '1': 'evaluated_at_unix_ms',
      '3': 5,
      '4': 1,
      '5': 3,
      '10': 'evaluatedAtUnixMs'
    },
    {'1': 'probe_revision', '3': 6, '4': 1, '5': 9, '10': 'probeRevision'},
  ],
};

/// Descriptor for `ServiceEvaluation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serviceEvaluationDescriptor = $convert.base64Decode(
    'ChFTZXJ2aWNlRXZhbHVhdGlvbhIdCgpzZXJ2aWNlX2lkGAEgASgJUglzZXJ2aWNlSWQSLAoSbm'
    '9kZV9wb29sX3JldmlzaW9uGAIgASgJUhBub2RlUG9vbFJldmlzaW9uEikKEHJ1bnRpbWVfcmV2'
    'aXNpb24YAyABKAlSD3J1bnRpbWVSZXZpc2lvbhI7CgpjYW5kaWRhdGVzGAQgAygLMhsudGFyZ2'
    'V0bGliLlNlcnZpY2VDYW5kaWRhdGVSCmNhbmRpZGF0ZXMSLwoUZXZhbHVhdGVkX2F0X3VuaXhf'
    'bXMYBSABKANSEWV2YWx1YXRlZEF0VW5peE1zEiUKDnByb2JlX3JldmlzaW9uGAYgASgJUg1wcm'
    '9iZVJldmlzaW9u');

@$core.Deprecated('Use smartConnectDiagnosticsDescriptor instead')
const SmartConnectDiagnostics$json = {
  '1': 'SmartConnectDiagnostics',
  '2': [
    {
      '1': 'runtime',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.targetlib.RuntimeState',
      '10': 'runtime'
    },
    {
      '1': 'evaluations',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.targetlib.ServiceEvaluation',
      '10': 'evaluations'
    },
    {'1': 'policy_revision', '3': 3, '4': 1, '5': 9, '10': 'policyRevision'},
    {
      '1': 'generated_at_unix_ms',
      '3': 4,
      '4': 1,
      '5': 3,
      '10': 'generatedAtUnixMs'
    },
  ],
};

/// Descriptor for `SmartConnectDiagnostics`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List smartConnectDiagnosticsDescriptor = $convert.base64Decode(
    'ChdTbWFydENvbm5lY3REaWFnbm9zdGljcxIxCgdydW50aW1lGAEgASgLMhcudGFyZ2V0bGliLl'
    'J1bnRpbWVTdGF0ZVIHcnVudGltZRI+CgtldmFsdWF0aW9ucxgCIAMoCzIcLnRhcmdldGxpYi5T'
    'ZXJ2aWNlRXZhbHVhdGlvblILZXZhbHVhdGlvbnMSJwoPcG9saWN5X3JldmlzaW9uGAMgASgJUg'
    '5wb2xpY3lSZXZpc2lvbhIvChRnZW5lcmF0ZWRfYXRfdW5peF9tcxgEIAEoA1IRZ2VuZXJhdGVk'
    'QXRVbml4TXM=');

@$core.Deprecated('Use runtimeEventDescriptor instead')
const RuntimeEvent$json = {
  '1': 'RuntimeEvent',
  '2': [
    {'1': 'sequence', '3': 1, '4': 1, '5': 4, '10': 'sequence'},
    {
      '1': 'type',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.targetlib.RuntimeEventType',
      '10': 'type'
    },
    {
      '1': 'occurred_at_unix_ms',
      '3': 3,
      '4': 1,
      '5': 3,
      '10': 'occurredAtUnixMs'
    },
    {
      '1': 'state',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.targetlib.RuntimeState',
      '10': 'state'
    },
    {
      '1': 'probe',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.targetlib.ProbeResult',
      '10': 'probe'
    },
    {'1': 'service_id', '3': 6, '4': 1, '5': 9, '10': 'serviceId'},
    {'1': 'node_id', '3': 7, '4': 1, '5': 9, '10': 'nodeId'},
  ],
};

/// Descriptor for `RuntimeEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List runtimeEventDescriptor = $convert.base64Decode(
    'CgxSdW50aW1lRXZlbnQSGgoIc2VxdWVuY2UYASABKARSCHNlcXVlbmNlEi8KBHR5cGUYAiABKA'
    '4yGy50YXJnZXRsaWIuUnVudGltZUV2ZW50VHlwZVIEdHlwZRItChNvY2N1cnJlZF9hdF91bml4'
    'X21zGAMgASgDUhBvY2N1cnJlZEF0VW5peE1zEi0KBXN0YXRlGAQgASgLMhcudGFyZ2V0bGliLl'
    'J1bnRpbWVTdGF0ZVIFc3RhdGUSLAoFcHJvYmUYBSABKAsyFi50YXJnZXRsaWIuUHJvYmVSZXN1'
    'bHRSBXByb2JlEh0KCnNlcnZpY2VfaWQYBiABKAlSCXNlcnZpY2VJZBIXCgdub2RlX2lkGAcgAS'
    'gJUgZub2RlSWQ=');

@$core.Deprecated('Use smartConnectSnapshotDescriptor instead')
const SmartConnectSnapshot$json = {
  '1': 'SmartConnectSnapshot',
  '2': [
    {
      '1': 'probes',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.targetlib.ServiceProbe',
      '10': 'probes'
    },
    {
      '1': 'results',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.targetlib.ProbeResult',
      '10': 'results'
    },
    {
      '1': 'selection_policies',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.targetlib.ServiceSelectionPolicy',
      '10': 'selectionPolicies'
    },
    {'1': 'enabled', '3': 4, '4': 1, '5': 8, '10': 'enabled'},
    {'1': 'revision', '3': 5, '4': 1, '5': 9, '10': 'revision'},
    {
      '1': 'recovery_state',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.targetlib.SmartRecoveryState',
      '10': 'recoveryState'
    },
    {
      '1': 'policies',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.targetlib.ServicePolicy',
      '10': 'policies'
    },
    {
      '1': 'proposals',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.targetlib.SwitchProposal',
      '10': 'proposals'
    },
    {
      '1': 'operations',
      '3': 9,
      '4': 3,
      '5': 11,
      '6': '.targetlib.Operation',
      '10': 'operations'
    },
    {
      '1': 'node_preferences',
      '3': 10,
      '4': 3,
      '5': 11,
      '6': '.targetlib.NodePreference',
      '10': 'nodePreferences'
    },
    {
      '1': 'tasks',
      '3': 11,
      '4': 3,
      '5': 11,
      '6': '.targetlib.SchedulerTask',
      '10': 'tasks'
    },
  ],
};

/// Descriptor for `SmartConnectSnapshot`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List smartConnectSnapshotDescriptor = $convert.base64Decode(
    'ChRTbWFydENvbm5lY3RTbmFwc2hvdBIvCgZwcm9iZXMYASADKAsyFy50YXJnZXRsaWIuU2Vydm'
    'ljZVByb2JlUgZwcm9iZXMSMAoHcmVzdWx0cxgCIAMoCzIWLnRhcmdldGxpYi5Qcm9iZVJlc3Vs'
    'dFIHcmVzdWx0cxJQChJzZWxlY3Rpb25fcG9saWNpZXMYAyADKAsyIS50YXJnZXRsaWIuU2Vydm'
    'ljZVNlbGVjdGlvblBvbGljeVIRc2VsZWN0aW9uUG9saWNpZXMSGAoHZW5hYmxlZBgEIAEoCFIH'
    'ZW5hYmxlZBIaCghyZXZpc2lvbhgFIAEoCVIIcmV2aXNpb24SRAoOcmVjb3Zlcnlfc3RhdGUYBi'
    'ABKA4yHS50YXJnZXRsaWIuU21hcnRSZWNvdmVyeVN0YXRlUg1yZWNvdmVyeVN0YXRlEjQKCHBv'
    'bGljaWVzGAcgAygLMhgudGFyZ2V0bGliLlNlcnZpY2VQb2xpY3lSCHBvbGljaWVzEjcKCXByb3'
    'Bvc2FscxgIIAMoCzIZLnRhcmdldGxpYi5Td2l0Y2hQcm9wb3NhbFIJcHJvcG9zYWxzEjQKCm9w'
    'ZXJhdGlvbnMYCSADKAsyFC50YXJnZXRsaWIuT3BlcmF0aW9uUgpvcGVyYXRpb25zEkQKEG5vZG'
    'VfcHJlZmVyZW5jZXMYCiADKAsyGS50YXJnZXRsaWIuTm9kZVByZWZlcmVuY2VSD25vZGVQcmVm'
    'ZXJlbmNlcxIuCgV0YXNrcxgLIAMoCzIYLnRhcmdldGxpYi5TY2hlZHVsZXJUYXNrUgV0YXNrcw'
    '==');

@$core.Deprecated('Use switchPolicyDescriptor instead')
const SwitchPolicy$json = {
  '1': 'SwitchPolicy',
  '2': [
    {
      '1': 'mode',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.targetlib.SwitchMode',
      '10': 'mode'
    },
    {
      '1': 'allowed_countries',
      '3': 2,
      '4': 3,
      '5': 9,
      '10': 'allowedCountries'
    },
    {
      '1': 'allowed_subscription_ids',
      '3': 3,
      '4': 3,
      '5': 9,
      '10': 'allowedSubscriptionIds'
    },
    {
      '1': 'allow_cross_country',
      '3': 4,
      '4': 1,
      '5': 8,
      '10': 'allowCrossCountry'
    },
    {
      '1': 'allow_cross_subscription',
      '3': 5,
      '4': 1,
      '5': 8,
      '10': 'allowCrossSubscription'
    },
    {'1': 'allow_direct', '3': 6, '4': 1, '5': 8, '10': 'allowDirect'},
    {
      '1': 'consecutive_failures',
      '3': 7,
      '4': 1,
      '5': 13,
      '10': 'consecutiveFailures'
    },
    {
      '1': 'minimum_score_delta',
      '3': 8,
      '4': 1,
      '5': 1,
      '10': 'minimumScoreDelta'
    },
    {
      '1': 'minimum_health_score',
      '3': 9,
      '4': 1,
      '5': 1,
      '10': 'minimumHealthScore'
    },
    {
      '1': 'minimum_dwell_seconds',
      '3': 10,
      '4': 1,
      '5': 13,
      '10': 'minimumDwellSeconds'
    },
    {
      '1': 'cooldown_seconds',
      '3': 11,
      '4': 1,
      '5': 13,
      '10': 'cooldownSeconds'
    },
    {
      '1': 'max_switches_per_hour',
      '3': 12,
      '4': 1,
      '5': 13,
      '10': 'maxSwitchesPerHour'
    },
    {
      '1': 'verify_after_switch',
      '3': 13,
      '4': 1,
      '5': 8,
      '10': 'verifyAfterSwitch'
    },
    {
      '1': 'rollback_on_verification_failure',
      '3': 14,
      '4': 1,
      '5': 8,
      '10': 'rollbackOnVerificationFailure'
    },
  ],
};

/// Descriptor for `SwitchPolicy`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List switchPolicyDescriptor = $convert.base64Decode(
    'CgxTd2l0Y2hQb2xpY3kSKQoEbW9kZRgBIAEoDjIVLnRhcmdldGxpYi5Td2l0Y2hNb2RlUgRtb2'
    'RlEisKEWFsbG93ZWRfY291bnRyaWVzGAIgAygJUhBhbGxvd2VkQ291bnRyaWVzEjgKGGFsbG93'
    'ZWRfc3Vic2NyaXB0aW9uX2lkcxgDIAMoCVIWYWxsb3dlZFN1YnNjcmlwdGlvbklkcxIuChNhbG'
    'xvd19jcm9zc19jb3VudHJ5GAQgASgIUhFhbGxvd0Nyb3NzQ291bnRyeRI4ChhhbGxvd19jcm9z'
    'c19zdWJzY3JpcHRpb24YBSABKAhSFmFsbG93Q3Jvc3NTdWJzY3JpcHRpb24SIQoMYWxsb3dfZG'
    'lyZWN0GAYgASgIUgthbGxvd0RpcmVjdBIxChRjb25zZWN1dGl2ZV9mYWlsdXJlcxgHIAEoDVIT'
    'Y29uc2VjdXRpdmVGYWlsdXJlcxIuChNtaW5pbXVtX3Njb3JlX2RlbHRhGAggASgBUhFtaW5pbX'
    'VtU2NvcmVEZWx0YRIwChRtaW5pbXVtX2hlYWx0aF9zY29yZRgJIAEoAVISbWluaW11bUhlYWx0'
    'aFNjb3JlEjIKFW1pbmltdW1fZHdlbGxfc2Vjb25kcxgKIAEoDVITbWluaW11bUR3ZWxsU2Vjb2'
    '5kcxIpChBjb29sZG93bl9zZWNvbmRzGAsgASgNUg9jb29sZG93blNlY29uZHMSMQoVbWF4X3N3'
    'aXRjaGVzX3Blcl9ob3VyGAwgASgNUhJtYXhTd2l0Y2hlc1BlckhvdXISLgoTdmVyaWZ5X2FmdG'
    'VyX3N3aXRjaBgNIAEoCFIRdmVyaWZ5QWZ0ZXJTd2l0Y2gSRwogcm9sbGJhY2tfb25fdmVyaWZp'
    'Y2F0aW9uX2ZhaWx1cmUYDiABKAhSHXJvbGxiYWNrT25WZXJpZmljYXRpb25GYWlsdXJl');

@$core.Deprecated('Use servicePolicyDescriptor instead')
const ServicePolicy$json = {
  '1': 'ServicePolicy',
  '2': [
    {'1': 'service_id', '3': 1, '4': 1, '5': 9, '10': 'serviceId'},
    {'1': 'display_name', '3': 2, '4': 1, '5': 9, '10': 'displayName'},
    {'1': 'domains', '3': 3, '4': 3, '5': 9, '10': 'domains'},
    {
      '1': 'probes',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.targetlib.ServiceProbe',
      '10': 'probes'
    },
    {
      '1': 'selection',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.targetlib.ServiceSelectionPolicy',
      '10': 'selection'
    },
    {
      '1': 'switch_policy',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.targetlib.SwitchPolicy',
      '10': 'switchPolicy'
    },
    {'1': 'revision', '3': 7, '4': 1, '5': 9, '10': 'revision'},
    {'1': 'schema_version', '3': 8, '4': 1, '5': 13, '10': 'schemaVersion'},
    {
      '1': 'quality_validity_seconds',
      '3': 9,
      '4': 1,
      '5': 13,
      '10': 'qualityValiditySeconds'
    },
    {
      '1': 'binding_validity_seconds',
      '3': 10,
      '4': 1,
      '5': 13,
      '10': 'bindingValiditySeconds'
    },
    {
      '1': 'evaluation_interval_seconds',
      '3': 11,
      '4': 1,
      '5': 13,
      '10': 'evaluationIntervalSeconds'
    },
  ],
};

/// Descriptor for `ServicePolicy`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List servicePolicyDescriptor = $convert.base64Decode(
    'Cg1TZXJ2aWNlUG9saWN5Eh0KCnNlcnZpY2VfaWQYASABKAlSCXNlcnZpY2VJZBIhCgxkaXNwbG'
    'F5X25hbWUYAiABKAlSC2Rpc3BsYXlOYW1lEhgKB2RvbWFpbnMYAyADKAlSB2RvbWFpbnMSLwoG'
    'cHJvYmVzGAQgAygLMhcudGFyZ2V0bGliLlNlcnZpY2VQcm9iZVIGcHJvYmVzEj8KCXNlbGVjdG'
    'lvbhgFIAEoCzIhLnRhcmdldGxpYi5TZXJ2aWNlU2VsZWN0aW9uUG9saWN5UglzZWxlY3Rpb24S'
    'PAoNc3dpdGNoX3BvbGljeRgGIAEoCzIXLnRhcmdldGxpYi5Td2l0Y2hQb2xpY3lSDHN3aXRjaF'
    'BvbGljeRIaCghyZXZpc2lvbhgHIAEoCVIIcmV2aXNpb24SJQoOc2NoZW1hX3ZlcnNpb24YCCAB'
    'KA1SDXNjaGVtYVZlcnNpb24SOAoYcXVhbGl0eV92YWxpZGl0eV9zZWNvbmRzGAkgASgNUhZxdW'
    'FsaXR5VmFsaWRpdHlTZWNvbmRzEjgKGGJpbmRpbmdfdmFsaWRpdHlfc2Vjb25kcxgKIAEoDVIW'
    'YmluZGluZ1ZhbGlkaXR5U2Vjb25kcxI+ChtldmFsdWF0aW9uX2ludGVydmFsX3NlY29uZHMYCy'
    'ABKA1SGWV2YWx1YXRpb25JbnRlcnZhbFNlY29uZHM=');

@$core.Deprecated('Use servicePolicyListDescriptor instead')
const ServicePolicyList$json = {
  '1': 'ServicePolicyList',
  '2': [
    {
      '1': 'policies',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.targetlib.ServicePolicy',
      '10': 'policies'
    },
  ],
};

/// Descriptor for `ServicePolicyList`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List servicePolicyListDescriptor = $convert.base64Decode(
    'ChFTZXJ2aWNlUG9saWN5TGlzdBI0Cghwb2xpY2llcxgBIAMoCzIYLnRhcmdldGxpYi5TZXJ2aW'
    'NlUG9saWN5Ughwb2xpY2llcw==');

@$core.Deprecated('Use nodePreferenceDescriptor instead')
const NodePreference$json = {
  '1': 'NodePreference',
  '2': [
    {'1': 'node_id', '3': 1, '4': 1, '5': 9, '10': 'nodeId'},
    {'1': 'enabled', '3': 2, '4': 1, '5': 8, '10': 'enabled'},
    {'1': 'excluded', '3': 3, '4': 1, '5': 8, '10': 'excluded'},
    {'1': 'favorite', '3': 4, '4': 1, '5': 8, '10': 'favorite'},
    {'1': 'labels', '3': 5, '4': 3, '5': 9, '10': 'labels'},
    {
      '1': 'subscription_priority',
      '3': 6,
      '4': 1,
      '5': 5,
      '10': 'subscriptionPriority'
    },
    {'1': 'revision', '3': 7, '4': 1, '5': 9, '10': 'revision'},
  ],
};

/// Descriptor for `NodePreference`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List nodePreferenceDescriptor = $convert.base64Decode(
    'Cg5Ob2RlUHJlZmVyZW5jZRIXCgdub2RlX2lkGAEgASgJUgZub2RlSWQSGAoHZW5hYmxlZBgCIA'
    'EoCFIHZW5hYmxlZBIaCghleGNsdWRlZBgDIAEoCFIIZXhjbHVkZWQSGgoIZmF2b3JpdGUYBCAB'
    'KAhSCGZhdm9yaXRlEhYKBmxhYmVscxgFIAMoCVIGbGFiZWxzEjMKFXN1YnNjcmlwdGlvbl9wcm'
    'lvcml0eRgGIAEoBVIUc3Vic2NyaXB0aW9uUHJpb3JpdHkSGgoIcmV2aXNpb24YByABKAlSCHJl'
    'dmlzaW9u');

@$core.Deprecated('Use switchProposalDescriptor instead')
const SwitchProposal$json = {
  '1': 'SwitchProposal',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'service_id', '3': 2, '4': 1, '5': 9, '10': 'serviceId'},
    {'1': 'current_node_id', '3': 3, '4': 1, '5': 9, '10': 'currentNodeId'},
    {'1': 'suggested_node_id', '3': 4, '4': 1, '5': 9, '10': 'suggestedNodeId'},
    {
      '1': 'candidates',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.targetlib.ServiceCandidate',
      '10': 'candidates'
    },
    {'1': 'reason', '3': 6, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'policy_revision', '3': 7, '4': 1, '5': 9, '10': 'policyRevision'},
    {
      '1': 'node_pool_revision',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'nodePoolRevision'
    },
    {'1': 'binding_revision', '3': 9, '4': 1, '5': 9, '10': 'bindingRevision'},
    {
      '1': 'created_at_unix_ms',
      '3': 10,
      '4': 1,
      '5': 3,
      '10': 'createdAtUnixMs'
    },
    {
      '1': 'expires_at_unix_ms',
      '3': 11,
      '4': 1,
      '5': 3,
      '10': 'expiresAtUnixMs'
    },
    {'1': 'auto_authorized', '3': 12, '4': 1, '5': 8, '10': 'autoAuthorized'},
    {'1': 'approved', '3': 13, '4': 1, '5': 8, '10': 'approved'},
  ],
};

/// Descriptor for `SwitchProposal`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List switchProposalDescriptor = $convert.base64Decode(
    'Cg5Td2l0Y2hQcm9wb3NhbBIOCgJpZBgBIAEoCVICaWQSHQoKc2VydmljZV9pZBgCIAEoCVIJc2'
    'VydmljZUlkEiYKD2N1cnJlbnRfbm9kZV9pZBgDIAEoCVINY3VycmVudE5vZGVJZBIqChFzdWdn'
    'ZXN0ZWRfbm9kZV9pZBgEIAEoCVIPc3VnZ2VzdGVkTm9kZUlkEjsKCmNhbmRpZGF0ZXMYBSADKA'
    'syGy50YXJnZXRsaWIuU2VydmljZUNhbmRpZGF0ZVIKY2FuZGlkYXRlcxIWCgZyZWFzb24YBiAB'
    'KAlSBnJlYXNvbhInCg9wb2xpY3lfcmV2aXNpb24YByABKAlSDnBvbGljeVJldmlzaW9uEiwKEm'
    '5vZGVfcG9vbF9yZXZpc2lvbhgIIAEoCVIQbm9kZVBvb2xSZXZpc2lvbhIpChBiaW5kaW5nX3Jl'
    'dmlzaW9uGAkgASgJUg9iaW5kaW5nUmV2aXNpb24SKwoSY3JlYXRlZF9hdF91bml4X21zGAogAS'
    'gDUg9jcmVhdGVkQXRVbml4TXMSKwoSZXhwaXJlc19hdF91bml4X21zGAsgASgDUg9leHBpcmVz'
    'QXRVbml4TXMSJwoPYXV0b19hdXRob3JpemVkGAwgASgIUg5hdXRvQXV0aG9yaXplZBIaCghhcH'
    'Byb3ZlZBgNIAEoCFIIYXBwcm92ZWQ=');

@$core.Deprecated('Use operationDescriptor instead')
const Operation$json = {
  '1': 'Operation',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'kind', '3': 2, '4': 1, '5': 9, '10': 'kind'},
    {'1': 'resource_id', '3': 3, '4': 1, '5': 9, '10': 'resourceId'},
    {'1': 'idempotency_key', '3': 4, '4': 1, '5': 9, '10': 'idempotencyKey'},
    {
      '1': 'status',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.targetlib.OperationStatus',
      '10': 'status'
    },
    {'1': 'phase', '3': 6, '4': 1, '5': 9, '10': 'phase'},
    {'1': 'progress_current', '3': 7, '4': 1, '5': 13, '10': 'progressCurrent'},
    {'1': 'progress_total', '3': 8, '4': 1, '5': 13, '10': 'progressTotal'},
    {
      '1': 'created_at_unix_ms',
      '3': 9,
      '4': 1,
      '5': 3,
      '10': 'createdAtUnixMs'
    },
    {
      '1': 'started_at_unix_ms',
      '3': 10,
      '4': 1,
      '5': 3,
      '10': 'startedAtUnixMs'
    },
    {
      '1': 'updated_at_unix_ms',
      '3': 11,
      '4': 1,
      '5': 3,
      '10': 'updatedAtUnixMs'
    },
    {
      '1': 'completed_at_unix_ms',
      '3': 12,
      '4': 1,
      '5': 3,
      '10': 'completedAtUnixMs'
    },
    {'1': 'policy_revision', '3': 13, '4': 1, '5': 9, '10': 'policyRevision'},
    {
      '1': 'node_pool_revision',
      '3': 14,
      '4': 1,
      '5': 9,
      '10': 'nodePoolRevision'
    },
    {'1': 'binding_revision', '3': 15, '4': 1, '5': 9, '10': 'bindingRevision'},
    {'1': 'runtime_revision', '3': 16, '4': 1, '5': 9, '10': 'runtimeRevision'},
    {'1': 'proposal_id', '3': 17, '4': 1, '5': 9, '10': 'proposalId'},
    {'1': 'result_summary', '3': 18, '4': 1, '5': 9, '10': 'resultSummary'},
    {'1': 'error_code', '3': 19, '4': 1, '5': 9, '10': 'errorCode'},
    {'1': 'error_message', '3': 20, '4': 1, '5': 9, '10': 'errorMessage'},
    {
      '1': 'request_signature',
      '3': 21,
      '4': 1,
      '5': 9,
      '10': 'requestSignature'
    },
    {'1': 'desired_node_id', '3': 22, '4': 1, '5': 9, '10': 'desiredNodeId'},
  ],
};

/// Descriptor for `Operation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List operationDescriptor = $convert.base64Decode(
    'CglPcGVyYXRpb24SDgoCaWQYASABKAlSAmlkEhIKBGtpbmQYAiABKAlSBGtpbmQSHwoLcmVzb3'
    'VyY2VfaWQYAyABKAlSCnJlc291cmNlSWQSJwoPaWRlbXBvdGVuY3lfa2V5GAQgASgJUg5pZGVt'
    'cG90ZW5jeUtleRIyCgZzdGF0dXMYBSABKA4yGi50YXJnZXRsaWIuT3BlcmF0aW9uU3RhdHVzUg'
    'ZzdGF0dXMSFAoFcGhhc2UYBiABKAlSBXBoYXNlEikKEHByb2dyZXNzX2N1cnJlbnQYByABKA1S'
    'D3Byb2dyZXNzQ3VycmVudBIlCg5wcm9ncmVzc190b3RhbBgIIAEoDVINcHJvZ3Jlc3NUb3RhbB'
    'IrChJjcmVhdGVkX2F0X3VuaXhfbXMYCSABKANSD2NyZWF0ZWRBdFVuaXhNcxIrChJzdGFydGVk'
    'X2F0X3VuaXhfbXMYCiABKANSD3N0YXJ0ZWRBdFVuaXhNcxIrChJ1cGRhdGVkX2F0X3VuaXhfbX'
    'MYCyABKANSD3VwZGF0ZWRBdFVuaXhNcxIvChRjb21wbGV0ZWRfYXRfdW5peF9tcxgMIAEoA1IR'
    'Y29tcGxldGVkQXRVbml4TXMSJwoPcG9saWN5X3JldmlzaW9uGA0gASgJUg5wb2xpY3lSZXZpc2'
    'lvbhIsChJub2RlX3Bvb2xfcmV2aXNpb24YDiABKAlSEG5vZGVQb29sUmV2aXNpb24SKQoQYmlu'
    'ZGluZ19yZXZpc2lvbhgPIAEoCVIPYmluZGluZ1JldmlzaW9uEikKEHJ1bnRpbWVfcmV2aXNpb2'
    '4YECABKAlSD3J1bnRpbWVSZXZpc2lvbhIfCgtwcm9wb3NhbF9pZBgRIAEoCVIKcHJvcG9zYWxJ'
    'ZBIlCg5yZXN1bHRfc3VtbWFyeRgSIAEoCVINcmVzdWx0U3VtbWFyeRIdCgplcnJvcl9jb2RlGB'
    'MgASgJUgllcnJvckNvZGUSIwoNZXJyb3JfbWVzc2FnZRgUIAEoCVIMZXJyb3JNZXNzYWdlEisK'
    'EXJlcXVlc3Rfc2lnbmF0dXJlGBUgASgJUhByZXF1ZXN0U2lnbmF0dXJlEiYKD2Rlc2lyZWRfbm'
    '9kZV9pZBgWIAEoCVINZGVzaXJlZE5vZGVJZA==');

@$core.Deprecated('Use schedulerTaskDescriptor instead')
const SchedulerTask$json = {
  '1': 'SchedulerTask',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'service_id', '3': 2, '4': 1, '5': 9, '10': 'serviceId'},
    {'1': 'kind', '3': 3, '4': 1, '5': 9, '10': 'kind'},
    {'1': 'reason', '3': 4, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'policy_revision', '3': 5, '4': 1, '5': 9, '10': 'policyRevision'},
    {
      '1': 'node_pool_revision',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'nodePoolRevision'
    },
    {
      '1': 'next_run_at_unix_ms',
      '3': 7,
      '4': 1,
      '5': 3,
      '10': 'nextRunAtUnixMs'
    },
    {'1': 'attempt', '3': 8, '4': 1, '5': 13, '10': 'attempt'},
    {'1': 'backoff_seconds', '3': 9, '4': 1, '5': 13, '10': 'backoffSeconds'},
    {'1': 'deadline_unix_ms', '3': 10, '4': 1, '5': 3, '10': 'deadlineUnixMs'},
    {'1': 'operation_id', '3': 11, '4': 1, '5': 9, '10': 'operationId'},
  ],
};

/// Descriptor for `SchedulerTask`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List schedulerTaskDescriptor = $convert.base64Decode(
    'Cg1TY2hlZHVsZXJUYXNrEg4KAmlkGAEgASgJUgJpZBIdCgpzZXJ2aWNlX2lkGAIgASgJUglzZX'
    'J2aWNlSWQSEgoEa2luZBgDIAEoCVIEa2luZBIWCgZyZWFzb24YBCABKAlSBnJlYXNvbhInCg9w'
    'b2xpY3lfcmV2aXNpb24YBSABKAlSDnBvbGljeVJldmlzaW9uEiwKEm5vZGVfcG9vbF9yZXZpc2'
    'lvbhgGIAEoCVIQbm9kZVBvb2xSZXZpc2lvbhIsChNuZXh0X3J1bl9hdF91bml4X21zGAcgASgD'
    'Ug9uZXh0UnVuQXRVbml4TXMSGAoHYXR0ZW1wdBgIIAEoDVIHYXR0ZW1wdBInCg9iYWNrb2ZmX3'
    'NlY29uZHMYCSABKA1SDmJhY2tvZmZTZWNvbmRzEigKEGRlYWRsaW5lX3VuaXhfbXMYCiABKANS'
    'DmRlYWRsaW5lVW5peE1zEiEKDG9wZXJhdGlvbl9pZBgLIAEoCVILb3BlcmF0aW9uSWQ=');

@$core.Deprecated('Use operationListDescriptor instead')
const OperationList$json = {
  '1': 'OperationList',
  '2': [
    {
      '1': 'operations',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.targetlib.Operation',
      '10': 'operations'
    },
  ],
};

/// Descriptor for `OperationList`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List operationListDescriptor = $convert.base64Decode(
    'Cg1PcGVyYXRpb25MaXN0EjQKCm9wZXJhdGlvbnMYASADKAsyFC50YXJnZXRsaWIuT3BlcmF0aW'
    '9uUgpvcGVyYXRpb25z');

@$core.Deprecated('Use setSmartConnectEnabledRequestDescriptor instead')
const SetSmartConnectEnabledRequest$json = {
  '1': 'SetSmartConnectEnabledRequest',
  '2': [
    {'1': 'enabled', '3': 1, '4': 1, '5': 8, '10': 'enabled'},
    {
      '1': 'expected_revision',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'expectedRevision'
    },
    {'1': 'idempotency_key', '3': 3, '4': 1, '5': 9, '10': 'idempotencyKey'},
  ],
};

/// Descriptor for `SetSmartConnectEnabledRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setSmartConnectEnabledRequestDescriptor =
    $convert.base64Decode(
        'Ch1TZXRTbWFydENvbm5lY3RFbmFibGVkUmVxdWVzdBIYCgdlbmFibGVkGAEgASgIUgdlbmFibG'
        'VkEisKEWV4cGVjdGVkX3JldmlzaW9uGAIgASgJUhBleHBlY3RlZFJldmlzaW9uEicKD2lkZW1w'
        'b3RlbmN5X2tleRgDIAEoCVIOaWRlbXBvdGVuY3lLZXk=');

@$core.Deprecated('Use upsertServicePolicyRequestDescriptor instead')
const UpsertServicePolicyRequest$json = {
  '1': 'UpsertServicePolicyRequest',
  '2': [
    {
      '1': 'policy',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.targetlib.ServicePolicy',
      '10': 'policy'
    },
    {
      '1': 'expected_revision',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'expectedRevision'
    },
    {'1': 'idempotency_key', '3': 3, '4': 1, '5': 9, '10': 'idempotencyKey'},
  ],
};

/// Descriptor for `UpsertServicePolicyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List upsertServicePolicyRequestDescriptor = $convert.base64Decode(
    'ChpVcHNlcnRTZXJ2aWNlUG9saWN5UmVxdWVzdBIwCgZwb2xpY3kYASABKAsyGC50YXJnZXRsaW'
    'IuU2VydmljZVBvbGljeVIGcG9saWN5EisKEWV4cGVjdGVkX3JldmlzaW9uGAIgASgJUhBleHBl'
    'Y3RlZFJldmlzaW9uEicKD2lkZW1wb3RlbmN5X2tleRgDIAEoCVIOaWRlbXBvdGVuY3lLZXk=');

@$core.Deprecated('Use deleteServicePolicyRequestDescriptor instead')
const DeleteServicePolicyRequest$json = {
  '1': 'DeleteServicePolicyRequest',
  '2': [
    {'1': 'service_id', '3': 1, '4': 1, '5': 9, '10': 'serviceId'},
    {
      '1': 'expected_revision',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'expectedRevision'
    },
    {'1': 'idempotency_key', '3': 3, '4': 1, '5': 9, '10': 'idempotencyKey'},
  ],
};

/// Descriptor for `DeleteServicePolicyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteServicePolicyRequestDescriptor =
    $convert.base64Decode(
        'ChpEZWxldGVTZXJ2aWNlUG9saWN5UmVxdWVzdBIdCgpzZXJ2aWNlX2lkGAEgASgJUglzZXJ2aW'
        'NlSWQSKwoRZXhwZWN0ZWRfcmV2aXNpb24YAiABKAlSEGV4cGVjdGVkUmV2aXNpb24SJwoPaWRl'
        'bXBvdGVuY3lfa2V5GAMgASgJUg5pZGVtcG90ZW5jeUtleQ==');

@$core.Deprecated('Use setNodePreferenceRequestDescriptor instead')
const SetNodePreferenceRequest$json = {
  '1': 'SetNodePreferenceRequest',
  '2': [
    {
      '1': 'preference',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.targetlib.NodePreference',
      '10': 'preference'
    },
    {
      '1': 'expected_revision',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'expectedRevision'
    },
    {'1': 'idempotency_key', '3': 3, '4': 1, '5': 9, '10': 'idempotencyKey'},
  ],
};

/// Descriptor for `SetNodePreferenceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setNodePreferenceRequestDescriptor = $convert.base64Decode(
    'ChhTZXROb2RlUHJlZmVyZW5jZVJlcXVlc3QSOQoKcHJlZmVyZW5jZRgBIAEoCzIZLnRhcmdldG'
    'xpYi5Ob2RlUHJlZmVyZW5jZVIKcHJlZmVyZW5jZRIrChFleHBlY3RlZF9yZXZpc2lvbhgCIAEo'
    'CVIQZXhwZWN0ZWRSZXZpc2lvbhInCg9pZGVtcG90ZW5jeV9rZXkYAyABKAlSDmlkZW1wb3Rlbm'
    'N5S2V5');

@$core.Deprecated('Use requestServiceEvaluationRequestDescriptor instead')
const RequestServiceEvaluationRequest$json = {
  '1': 'RequestServiceEvaluationRequest',
  '2': [
    {'1': 'service_id', '3': 1, '4': 1, '5': 9, '10': 'serviceId'},
    {
      '1': 'expected_revision',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'expectedRevision'
    },
    {'1': 'idempotency_key', '3': 3, '4': 1, '5': 9, '10': 'idempotencyKey'},
  ],
};

/// Descriptor for `RequestServiceEvaluationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestServiceEvaluationRequestDescriptor =
    $convert.base64Decode(
        'Ch9SZXF1ZXN0U2VydmljZUV2YWx1YXRpb25SZXF1ZXN0Eh0KCnNlcnZpY2VfaWQYASABKAlSCX'
        'NlcnZpY2VJZBIrChFleHBlY3RlZF9yZXZpc2lvbhgCIAEoCVIQZXhwZWN0ZWRSZXZpc2lvbhIn'
        'Cg9pZGVtcG90ZW5jeV9rZXkYAyABKAlSDmlkZW1wb3RlbmN5S2V5');

@$core.Deprecated('Use proposalCommandRequestDescriptor instead')
const ProposalCommandRequest$json = {
  '1': 'ProposalCommandRequest',
  '2': [
    {'1': 'proposal_id', '3': 1, '4': 1, '5': 9, '10': 'proposalId'},
    {
      '1': 'expected_revision',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'expectedRevision'
    },
    {'1': 'idempotency_key', '3': 3, '4': 1, '5': 9, '10': 'idempotencyKey'},
  ],
};

/// Descriptor for `ProposalCommandRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List proposalCommandRequestDescriptor = $convert.base64Decode(
    'ChZQcm9wb3NhbENvbW1hbmRSZXF1ZXN0Eh8KC3Byb3Bvc2FsX2lkGAEgASgJUgpwcm9wb3NhbE'
    'lkEisKEWV4cGVjdGVkX3JldmlzaW9uGAIgASgJUhBleHBlY3RlZFJldmlzaW9uEicKD2lkZW1w'
    'b3RlbmN5X2tleRgDIAEoCVIOaWRlbXBvdGVuY3lLZXk=');

@$core.Deprecated('Use forceServiceBindingRequestDescriptor instead')
const ForceServiceBindingRequest$json = {
  '1': 'ForceServiceBindingRequest',
  '2': [
    {'1': 'service_id', '3': 1, '4': 1, '5': 9, '10': 'serviceId'},
    {'1': 'node_id', '3': 2, '4': 1, '5': 9, '10': 'nodeId'},
    {
      '1': 'expected_revision',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'expectedRevision'
    },
    {'1': 'idempotency_key', '3': 4, '4': 1, '5': 9, '10': 'idempotencyKey'},
    {
      '1': 'close_existing_connections',
      '3': 5,
      '4': 1,
      '5': 8,
      '10': 'closeExistingConnections'
    },
  ],
};

/// Descriptor for `ForceServiceBindingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List forceServiceBindingRequestDescriptor = $convert.base64Decode(
    'ChpGb3JjZVNlcnZpY2VCaW5kaW5nUmVxdWVzdBIdCgpzZXJ2aWNlX2lkGAEgASgJUglzZXJ2aW'
    'NlSWQSFwoHbm9kZV9pZBgCIAEoCVIGbm9kZUlkEisKEWV4cGVjdGVkX3JldmlzaW9uGAMgASgJ'
    'UhBleHBlY3RlZFJldmlzaW9uEicKD2lkZW1wb3RlbmN5X2tleRgEIAEoCVIOaWRlbXBvdGVuY3'
    'lLZXkSPAoaY2xvc2VfZXhpc3RpbmdfY29ubmVjdGlvbnMYBSABKAhSGGNsb3NlRXhpc3RpbmdD'
    'b25uZWN0aW9ucw==');

@$core.Deprecated('Use getOperationRequestDescriptor instead')
const GetOperationRequest$json = {
  '1': 'GetOperationRequest',
  '2': [
    {'1': 'operation_id', '3': 1, '4': 1, '5': 9, '10': 'operationId'},
  ],
};

/// Descriptor for `GetOperationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getOperationRequestDescriptor = $convert.base64Decode(
    'ChNHZXRPcGVyYXRpb25SZXF1ZXN0EiEKDG9wZXJhdGlvbl9pZBgBIAEoCVILb3BlcmF0aW9uSW'
    'Q=');

@$core.Deprecated('Use listOperationsRequestDescriptor instead')
const ListOperationsRequest$json = {
  '1': 'ListOperationsRequest',
  '2': [
    {'1': 'resource_id', '3': 1, '4': 1, '5': 9, '10': 'resourceId'},
    {'1': 'limit', '3': 2, '4': 1, '5': 13, '10': 'limit'},
  ],
};

/// Descriptor for `ListOperationsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listOperationsRequestDescriptor = $convert.base64Decode(
    'ChVMaXN0T3BlcmF0aW9uc1JlcXVlc3QSHwoLcmVzb3VyY2VfaWQYASABKAlSCnJlc291cmNlSW'
    'QSFAoFbGltaXQYAiABKA1SBWxpbWl0');

@$core.Deprecated('Use smartConnectEventsRequestDescriptor instead')
const SmartConnectEventsRequest$json = {
  '1': 'SmartConnectEventsRequest',
  '2': [
    {'1': 'after_sequence', '3': 1, '4': 1, '5': 4, '10': 'afterSequence'},
  ],
};

/// Descriptor for `SmartConnectEventsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List smartConnectEventsRequestDescriptor =
    $convert.base64Decode(
        'ChlTbWFydENvbm5lY3RFdmVudHNSZXF1ZXN0EiUKDmFmdGVyX3NlcXVlbmNlGAEgASgEUg1hZn'
        'RlclNlcXVlbmNl');

@$core.Deprecated('Use smartConnectEventDescriptor instead')
const SmartConnectEvent$json = {
  '1': 'SmartConnectEvent',
  '2': [
    {'1': 'sequence', '3': 1, '4': 1, '5': 4, '10': 'sequence'},
    {'1': 'epoch', '3': 2, '4': 1, '5': 9, '10': 'epoch'},
    {'1': 'operation_id', '3': 3, '4': 1, '5': 9, '10': 'operationId'},
    {'1': 'resource_id', '3': 4, '4': 1, '5': 9, '10': 'resourceId'},
    {
      '1': 'occurred_at_unix_ms',
      '3': 5,
      '4': 1,
      '5': 3,
      '10': 'occurredAtUnixMs'
    },
    {
      '1': 'snapshot',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.targetlib.SmartConnectSnapshot',
      '10': 'snapshot'
    },
  ],
};

/// Descriptor for `SmartConnectEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List smartConnectEventDescriptor = $convert.base64Decode(
    'ChFTbWFydENvbm5lY3RFdmVudBIaCghzZXF1ZW5jZRgBIAEoBFIIc2VxdWVuY2USFAoFZXBvY2'
    'gYAiABKAlSBWVwb2NoEiEKDG9wZXJhdGlvbl9pZBgDIAEoCVILb3BlcmF0aW9uSWQSHwoLcmVz'
    'b3VyY2VfaWQYBCABKAlSCnJlc291cmNlSWQSLQoTb2NjdXJyZWRfYXRfdW5peF9tcxgFIAEoA1'
    'IQb2NjdXJyZWRBdFVuaXhNcxI7CghzbmFwc2hvdBgGIAEoCzIfLnRhcmdldGxpYi5TbWFydENv'
    'bm5lY3RTbmFwc2hvdFIIc25hcHNob3Q=');

@$core.Deprecated('Use smartConnectPolicyDescriptor instead')
const SmartConnectPolicy$json = {
  '1': 'SmartConnectPolicy',
  '2': [
    {'1': 'schema_version', '3': 1, '4': 1, '5': 13, '10': 'schemaVersion'},
    {'1': 'revision', '3': 2, '4': 1, '5': 9, '10': 'revision'},
    {
      '1': 'probes',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.targetlib.ServiceProbe',
      '10': 'probes'
    },
  ],
};

/// Descriptor for `SmartConnectPolicy`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List smartConnectPolicyDescriptor = $convert.base64Decode(
    'ChJTbWFydENvbm5lY3RQb2xpY3kSJQoOc2NoZW1hX3ZlcnNpb24YASABKA1SDXNjaGVtYVZlcn'
    'Npb24SGgoIcmV2aXNpb24YAiABKAlSCHJldmlzaW9uEi8KBnByb2JlcxgDIAMoCzIXLnRhcmdl'
    'dGxpYi5TZXJ2aWNlUHJvYmVSBnByb2Jlcw==');

@$core.Deprecated('Use importSmartConnectPolicyRequestDescriptor instead')
const ImportSmartConnectPolicyRequest$json = {
  '1': 'ImportSmartConnectPolicyRequest',
  '2': [
    {
      '1': 'policy',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.targetlib.SmartConnectPolicy',
      '10': 'policy'
    },
    {
      '1': 'expected_revision',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'expectedRevision'
    },
  ],
};

/// Descriptor for `ImportSmartConnectPolicyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List importSmartConnectPolicyRequestDescriptor =
    $convert.base64Decode(
        'Ch9JbXBvcnRTbWFydENvbm5lY3RQb2xpY3lSZXF1ZXN0EjUKBnBvbGljeRgBIAEoCzIdLnRhcm'
        'dldGxpYi5TbWFydENvbm5lY3RQb2xpY3lSBnBvbGljeRIrChFleHBlY3RlZF9yZXZpc2lvbhgC'
        'IAEoCVIQZXhwZWN0ZWRSZXZpc2lvbg==');

@$core.Deprecated('Use runtimeStateDescriptor instead')
const RuntimeState$json = {
  '1': 'RuntimeState',
  '2': [
    {
      '1': 'phase',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.targetlib.ConfigApplyPhase',
      '10': 'phase'
    },
    {
      '1': 'attempted_revision',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'attemptedRevision'
    },
    {'1': 'desired_revision', '3': 3, '4': 1, '5': 9, '10': 'desiredRevision'},
    {'1': 'applied_revision', '3': 4, '4': 1, '5': 9, '10': 'appliedRevision'},
    {'1': 'error_message', '3': 5, '4': 1, '5': 9, '10': 'errorMessage'},
    {'1': 'running', '3': 6, '4': 1, '5': 8, '10': 'running'},
    {
      '1': 'selectors',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.targetlib.SelectorState',
      '10': 'selectors'
    },
    {
      '1': 'service_routes',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.targetlib.ServiceRouteState',
      '10': 'serviceRoutes'
    },
    {
      '1': 'service_bindings',
      '3': 9,
      '4': 3,
      '5': 11,
      '6': '.targetlib.ServiceBindingState',
      '10': 'serviceBindings'
    },
    {
      '1': 'node_pool_revision',
      '3': 10,
      '4': 1,
      '5': 9,
      '10': 'nodePoolRevision'
    },
  ],
};

/// Descriptor for `RuntimeState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List runtimeStateDescriptor = $convert.base64Decode(
    'CgxSdW50aW1lU3RhdGUSMQoFcGhhc2UYASABKA4yGy50YXJnZXRsaWIuQ29uZmlnQXBwbHlQaG'
    'FzZVIFcGhhc2USLQoSYXR0ZW1wdGVkX3JldmlzaW9uGAIgASgJUhFhdHRlbXB0ZWRSZXZpc2lv'
    'bhIpChBkZXNpcmVkX3JldmlzaW9uGAMgASgJUg9kZXNpcmVkUmV2aXNpb24SKQoQYXBwbGllZF'
    '9yZXZpc2lvbhgEIAEoCVIPYXBwbGllZFJldmlzaW9uEiMKDWVycm9yX21lc3NhZ2UYBSABKAlS'
    'DGVycm9yTWVzc2FnZRIYCgdydW5uaW5nGAYgASgIUgdydW5uaW5nEjYKCXNlbGVjdG9ycxgHIA'
    'MoCzIYLnRhcmdldGxpYi5TZWxlY3RvclN0YXRlUglzZWxlY3RvcnMSQwoOc2VydmljZV9yb3V0'
    'ZXMYCCADKAsyHC50YXJnZXRsaWIuU2VydmljZVJvdXRlU3RhdGVSDXNlcnZpY2VSb3V0ZXMSSQ'
    'oQc2VydmljZV9iaW5kaW5ncxgJIAMoCzIeLnRhcmdldGxpYi5TZXJ2aWNlQmluZGluZ1N0YXRl'
    'Ug9zZXJ2aWNlQmluZGluZ3MSLAoSbm9kZV9wb29sX3JldmlzaW9uGAogASgJUhBub2RlUG9vbF'
    'JldmlzaW9u');

@$core.Deprecated('Use testOutboundRequestDescriptor instead')
const TestOutboundRequest$json = {
  '1': 'TestOutboundRequest',
  '2': [
    {'1': 'outbound_tag', '3': 1, '4': 1, '5': 9, '10': 'outboundTag'},
    {
      '1': 'timeout_milliseconds',
      '3': 2,
      '4': 1,
      '5': 13,
      '10': 'timeoutMilliseconds'
    },
  ],
};

/// Descriptor for `TestOutboundRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List testOutboundRequestDescriptor = $convert.base64Decode(
    'ChNUZXN0T3V0Ym91bmRSZXF1ZXN0EiEKDG91dGJvdW5kX3RhZxgBIAEoCVILb3V0Ym91bmRUYW'
    'cSMQoUdGltZW91dF9taWxsaXNlY29uZHMYAiABKA1SE3RpbWVvdXRNaWxsaXNlY29uZHM=');

@$core.Deprecated('Use testOutboundsRequestDescriptor instead')
const TestOutboundsRequest$json = {
  '1': 'TestOutboundsRequest',
  '2': [
    {'1': 'outbound_tags', '3': 1, '4': 3, '5': 9, '10': 'outboundTags'},
    {
      '1': 'timeout_milliseconds',
      '3': 2,
      '4': 1,
      '5': 13,
      '10': 'timeoutMilliseconds'
    },
    {'1': 'max_concurrency', '3': 3, '4': 1, '5': 13, '10': 'maxConcurrency'},
  ],
};

/// Descriptor for `TestOutboundsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List testOutboundsRequestDescriptor = $convert.base64Decode(
    'ChRUZXN0T3V0Ym91bmRzUmVxdWVzdBIjCg1vdXRib3VuZF90YWdzGAEgAygJUgxvdXRib3VuZF'
    'RhZ3MSMQoUdGltZW91dF9taWxsaXNlY29uZHMYAiABKA1SE3RpbWVvdXRNaWxsaXNlY29uZHMS'
    'JwoPbWF4X2NvbmN1cnJlbmN5GAMgASgNUg5tYXhDb25jdXJyZW5jeQ==');

@$core.Deprecated('Use latencyTestResultDescriptor instead')
const LatencyTestResult$json = {
  '1': 'LatencyTestResult',
  '2': [
    {'1': 'outbound_tag', '3': 1, '4': 1, '5': 9, '10': 'outboundTag'},
    {
      '1': 'status',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.targetlib.LatencyTestStatus',
      '10': 'status'
    },
    {
      '1': 'delay_milliseconds',
      '3': 3,
      '4': 1,
      '5': 13,
      '10': 'delayMilliseconds'
    },
    {'1': 'tested_at_unix_ms', '3': 4, '4': 1, '5': 3, '10': 'testedAtUnixMs'},
    {'1': 'error_message', '3': 5, '4': 1, '5': 9, '10': 'errorMessage'},
  ],
};

/// Descriptor for `LatencyTestResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List latencyTestResultDescriptor = $convert.base64Decode(
    'ChFMYXRlbmN5VGVzdFJlc3VsdBIhCgxvdXRib3VuZF90YWcYASABKAlSC291dGJvdW5kVGFnEj'
    'QKBnN0YXR1cxgCIAEoDjIcLnRhcmdldGxpYi5MYXRlbmN5VGVzdFN0YXR1c1IGc3RhdHVzEi0K'
    'EmRlbGF5X21pbGxpc2Vjb25kcxgDIAEoDVIRZGVsYXlNaWxsaXNlY29uZHMSKQoRdGVzdGVkX2'
    'F0X3VuaXhfbXMYBCABKANSDnRlc3RlZEF0VW5peE1zEiMKDWVycm9yX21lc3NhZ2UYBSABKAlS'
    'DGVycm9yTWVzc2FnZQ==');

@$core.Deprecated('Use resolvedEndpointsDescriptor instead')
const ResolvedEndpoints$json = {
  '1': 'ResolvedEndpoints',
  '2': [
    {'1': 'addresses', '3': 1, '4': 3, '5': 9, '10': 'addresses'},
  ],
};

/// Descriptor for `ResolvedEndpoints`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resolvedEndpointsDescriptor = $convert.base64Decode(
    'ChFSZXNvbHZlZEVuZHBvaW50cxIcCglhZGRyZXNzZXMYASADKAlSCWFkZHJlc3Nlcw==');

@$core.Deprecated('Use ipInfoResponseDescriptor instead')
const IpInfoResponse$json = {
  '1': 'IpInfoResponse',
  '2': [
    {'1': 'ip', '3': 1, '4': 1, '5': 9, '10': 'ip'},
    {'1': 'country', '3': 2, '4': 1, '5': 9, '10': 'country'},
    {'1': 'country_code', '3': 3, '4': 1, '5': 9, '10': 'countryCode'},
    {'1': 'city', '3': 4, '4': 1, '5': 9, '10': 'city'},
    {'1': 'isp', '3': 5, '4': 1, '5': 9, '10': 'isp'},
    {'1': 'org', '3': 6, '4': 1, '5': 9, '10': 'org'},
    {'1': 'as_name', '3': 7, '4': 1, '5': 9, '10': 'asName'},
  ],
};

/// Descriptor for `IpInfoResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ipInfoResponseDescriptor = $convert.base64Decode(
    'Cg5JcEluZm9SZXNwb25zZRIOCgJpcBgBIAEoCVICaXASGAoHY291bnRyeRgCIAEoCVIHY291bn'
    'RyeRIhCgxjb3VudHJ5X2NvZGUYAyABKAlSC2NvdW50cnlDb2RlEhIKBGNpdHkYBCABKAlSBGNp'
    'dHkSEAoDaXNwGAUgASgJUgNpc3ASEAoDb3JnGAYgASgJUgNvcmcSFwoHYXNfbmFtZRgHIAEoCV'
    'IGYXNOYW1l');

@$core.Deprecated('Use subscriptionEventDescriptor instead')
const SubscriptionEvent$json = {
  '1': 'SubscriptionEvent',
  '2': [
    {
      '1': 'type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.targetlib.SubscriptionEventType',
      '10': 'type'
    },
    {
      '1': 'subscription',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.targetlib.SubscriptionView',
      '10': 'subscription'
    },
    {
      '1': 'occurred_at_unix_ms',
      '3': 3,
      '4': 1,
      '5': 3,
      '10': 'occurredAtUnixMs'
    },
  ],
};

/// Descriptor for `SubscriptionEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subscriptionEventDescriptor = $convert.base64Decode(
    'ChFTdWJzY3JpcHRpb25FdmVudBI0CgR0eXBlGAEgASgOMiAudGFyZ2V0bGliLlN1YnNjcmlwdG'
    'lvbkV2ZW50VHlwZVIEdHlwZRI/CgxzdWJzY3JpcHRpb24YAiABKAsyGy50YXJnZXRsaWIuU3Vi'
    'c2NyaXB0aW9uVmlld1IMc3Vic2NyaXB0aW9uEi0KE29jY3VycmVkX2F0X3VuaXhfbXMYAyABKA'
    'NSEG9jY3VycmVkQXRVbml4TXM=');
