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
    'dBgFIAEoCFIWc3Vic2NyaXB0aW9uTWFuYWdlbWVudEoECAIQA0oECAQQBVIMc3lzdGVtX3Byb3'
    'h5');

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
    {'1': 'activate', '3': 8, '4': 1, '5': 8, '10': 'activate'},
    {'1': 'update_now', '3': 9, '4': 1, '5': 8, '10': 'updateNow'},
  ],
  '3': [AddSubscriptionRequest_HeadersEntry$json],
  '8': [
    {'1': '_enabled'},
    {'1': '_auto_update'},
  ],
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
    'IaCghhY3RpdmF0ZRgIIAEoCFIIYWN0aXZhdGUSHQoKdXBkYXRlX25vdxgJIAEoCFIJdXBkYXRl'
    'Tm93GjoKDEhlYWRlcnNFbnRyeRIQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoCVIFdm'
    'FsdWU6AjgBQgoKCF9lbmFibGVkQg4KDF9hdXRvX3VwZGF0ZQ==');

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
    {'1': 'active_id', '3': 2, '4': 1, '5': 9, '10': 'activeId'},
  ],
};

/// Descriptor for `SubscriptionList`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subscriptionListDescriptor = $convert.base64Decode(
    'ChBTdWJzY3JpcHRpb25MaXN0EkEKDXN1YnNjcmlwdGlvbnMYASADKAsyGy50YXJnZXRsaWIuU3'
    'Vic2NyaXB0aW9uVmlld1INc3Vic2NyaXB0aW9ucxIbCglhY3RpdmVfaWQYAiABKAlSCGFjdGl2'
    'ZUlk');

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
    'CgtQcm9maWxlTm9kZRIQCgN0YWcYASABKAlSA3RhZxISCgRuYW1lGAIgASgJUgRuYW1lEhIKBH'
    'R5cGUYAyABKAlSBHR5cGUSFgoGc2VydmVyGAQgASgJUgZzZXJ2ZXISEgoEcG9ydBgFIAEoBVIE'
    'cG9ydBIxCgVwaGFzZRgHIAEoDjIbLnRhcmdldGxpYi5Qcm9maWxlTm9kZVBoYXNlUgVwaGFzZR'
    'IjCg1lcnJvcl9tZXNzYWdlGAggASgJUgxlcnJvck1lc3NhZ2USIQoMY291bnRyeV9jb2RlGAkg'
    'ASgJUgtjb3VudHJ5Q29kZUoECAYQB1IKZ3JvdXBfdGFncw==');

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
  ],
};

/// Descriptor for `RuntimeConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List runtimeConfigDescriptor = $convert.base64Decode(
    'Cg1SdW50aW1lQ29uZmlnEjYKCHNldHRpbmdzGAEgASgLMhoudGFyZ2V0bGliLlJ1bnRpbWVTZX'
    'R0aW5nc1IIc2V0dGluZ3M=');

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
  ],
};

/// Descriptor for `UpdateRuntimeConfigRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateRuntimeConfigRequestDescriptor =
    $convert.base64Decode(
        'ChpVcGRhdGVSdW50aW1lQ29uZmlnUmVxdWVzdBI2CghzZXR0aW5ncxgBIAEoCzIaLnRhcmdldG'
        'xpYi5SdW50aW1lU2V0dGluZ3NSCHNldHRpbmdz');

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

@$core.Deprecated('Use setActiveSubscriptionRequestDescriptor instead')
const SetActiveSubscriptionRequest$json = {
  '1': 'SetActiveSubscriptionRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `SetActiveSubscriptionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setActiveSubscriptionRequestDescriptor =
    $convert.base64Decode(
        'ChxTZXRBY3RpdmVTdWJzY3JpcHRpb25SZXF1ZXN0Eg4KAmlkGAEgASgJUgJpZA==');

@$core.Deprecated('Use activeSubscriptionResponseDescriptor instead')
const ActiveSubscriptionResponse$json = {
  '1': 'ActiveSubscriptionResponse',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `ActiveSubscriptionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List activeSubscriptionResponseDescriptor =
    $convert.base64Decode(
        'ChpBY3RpdmVTdWJzY3JpcHRpb25SZXNwb25zZRIOCgJpZBgBIAEoCVICaWQ=');

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
