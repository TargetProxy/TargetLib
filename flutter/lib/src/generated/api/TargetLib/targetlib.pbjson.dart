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
    '9fdXBkYXRl');

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
};

/// Descriptor for `SubscriptionList`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subscriptionListDescriptor = $convert.base64Decode(
    'ChBTdWJzY3JpcHRpb25MaXN0EkEKDXN1YnNjcmlwdGlvbnMYASADKAsyGy50YXJnZXRsaWIuU3'
    'Vic2NyaXB0aW9uVmlld1INc3Vic2NyaXB0aW9ucw==');

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
};

/// Descriptor for `ProfileView`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List profileViewDescriptor = $convert.base64Decode(
    'CgtQcm9maWxlVmlldxIsCgVub2RlcxgBIAMoCzIWLnRhcmdldGxpYi5Qcm9maWxlTm9kZVIFbm'
    '9kZXM=');

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
};

/// Descriptor for `ProfileNode`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List profileNodeDescriptor = $convert.base64Decode(
    'CgtQcm9maWxlTm9kZRInCg9zdWJzY3JpcHRpb25faWQYCiABKAlSDnN1YnNjcmlwdGlvbklkEh'
    'AKA3RhZxgBIAEoCVIDdGFnEhIKBG5hbWUYAiABKAlSBG5hbWUSEgoEdHlwZRgDIAEoCVIEdHlw'
    'ZRIWCgZzZXJ2ZXIYBCABKAlSBnNlcnZlchISCgRwb3J0GAUgASgFUgRwb3J0EjEKBXBoYXNlGA'
    'cgASgOMhsudGFyZ2V0bGliLlByb2ZpbGVOb2RlUGhhc2VSBXBoYXNlEiMKDWVycm9yX21lc3Nh'
    'Z2UYCCABKAlSDGVycm9yTWVzc2FnZRIhCgxjb3VudHJ5X2NvZGUYCSABKAlSC2NvdW50cnlDb2'
    'Rl');

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
      '1': 'expected_revision',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'expectedRevision'
    },
  ],
};

/// Descriptor for `UpdateRuntimeConfigRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateRuntimeConfigRequestDescriptor =
    $convert.base64Decode(
        'ChpVcGRhdGVSdW50aW1lQ29uZmlnUmVxdWVzdBI2CghzZXR0aW5ncxgBIAEoCzIaLnRhcmdldG'
        'xpYi5SdW50aW1lU2V0dGluZ3NSCHNldHRpbmdzEisKEWV4cGVjdGVkX3JldmlzaW9uGAMgASgJ'
        'UhBleHBlY3RlZFJldmlzaW9u');

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

@$core.Deprecated('Use selectNodeRequestDescriptor instead')
const SelectNodeRequest$json = {
  '1': 'SelectNodeRequest',
  '2': [
    {'1': 'node_id', '3': 1, '4': 1, '5': 9, '10': 'nodeId'},
  ],
};

/// Descriptor for `SelectNodeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List selectNodeRequestDescriptor = $convert.base64Decode(
    'ChFTZWxlY3ROb2RlUmVxdWVzdBIXCgdub2RlX2lkGAEgASgJUgZub2RlSWQ=');

@$core.Deprecated('Use selectNodeResponseDescriptor instead')
const SelectNodeResponse$json = {
  '1': 'SelectNodeResponse',
  '2': [
    {'1': 'node_id', '3': 1, '4': 1, '5': 9, '10': 'nodeId'},
    {'1': 'node_name', '3': 2, '4': 1, '5': 9, '10': 'nodeName'},
    {
      '1': 'applied_immediately',
      '3': 3,
      '4': 1,
      '5': 8,
      '10': 'appliedImmediately'
    },
    {'1': 'error_message', '3': 4, '4': 1, '5': 9, '10': 'errorMessage'},
  ],
};

/// Descriptor for `SelectNodeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List selectNodeResponseDescriptor = $convert.base64Decode(
    'ChJTZWxlY3ROb2RlUmVzcG9uc2USFwoHbm9kZV9pZBgBIAEoCVIGbm9kZUlkEhsKCW5vZGVfbm'
    'FtZRgCIAEoCVIIbm9kZU5hbWUSLwoTYXBwbGllZF9pbW1lZGlhdGVseRgDIAEoCFISYXBwbGll'
    'ZEltbWVkaWF0ZWx5EiMKDWVycm9yX21lc3NhZ2UYBCABKAlSDGVycm9yTWVzc2FnZQ==');

@$core.Deprecated('Use proxyStatusDescriptor instead')
const ProxyStatus$json = {
  '1': 'ProxyStatus',
  '2': [
    {
      '1': 'service_state',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.targetlib.ServiceStateType',
      '10': 'serviceState'
    },
    {'1': 'selected_node_id', '3': 2, '4': 1, '5': 9, '10': 'selectedNodeId'},
    {
      '1': 'selected_node_name',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'selectedNodeName'
    },
    {'1': 'actual_node_id', '3': 4, '4': 1, '5': 9, '10': 'actualNodeId'},
    {'1': 'effective', '3': 5, '4': 1, '5': 8, '10': 'effective'},
    {
      '1': 'selected_at_unix_ms',
      '3': 6,
      '4': 1,
      '5': 3,
      '10': 'selectedAtUnixMs'
    },
    {'1': 'node_available', '3': 7, '4': 1, '5': 8, '10': 'nodeAvailable'},
    {
      '1': 'unavailable_reason',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'unavailableReason'
    },
  ],
};

/// Descriptor for `ProxyStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List proxyStatusDescriptor = $convert.base64Decode(
    'CgtQcm94eVN0YXR1cxJACg1zZXJ2aWNlX3N0YXRlGAEgASgOMhsudGFyZ2V0bGliLlNlcnZpY2'
    'VTdGF0ZVR5cGVSDHNlcnZpY2VTdGF0ZRIoChBzZWxlY3RlZF9ub2RlX2lkGAIgASgJUg5zZWxl'
    'Y3RlZE5vZGVJZBIsChJzZWxlY3RlZF9ub2RlX25hbWUYAyABKAlSEHNlbGVjdGVkTm9kZU5hbW'
    'USJAoOYWN0dWFsX25vZGVfaWQYBCABKAlSDGFjdHVhbE5vZGVJZBIcCgllZmZlY3RpdmUYBSAB'
    'KAhSCWVmZmVjdGl2ZRItChNzZWxlY3RlZF9hdF91bml4X21zGAYgASgDUhBzZWxlY3RlZEF0VW'
    '5peE1zEiUKDm5vZGVfYXZhaWxhYmxlGAcgASgIUg1ub2RlQXZhaWxhYmxlEi0KEnVuYXZhaWxh'
    'YmxlX3JlYXNvbhgIIAEoCVIRdW5hdmFpbGFibGVSZWFzb24=');

@$core.Deprecated('Use upsertRouteRequestDescriptor instead')
const UpsertRouteRequest$json = {
  '1': 'UpsertRouteRequest',
  '2': [
    {'1': 'service_id', '3': 1, '4': 1, '5': 9, '10': 'serviceId'},
    {'1': 'display_name', '3': 2, '4': 1, '5': 9, '10': 'displayName'},
    {'1': 'domains', '3': 3, '4': 3, '5': 9, '10': 'domains'},
    {'1': 'node_id', '3': 4, '4': 1, '5': 9, '10': 'nodeId'},
    {'1': 'enabled', '3': 5, '4': 1, '5': 8, '10': 'enabled'},
  ],
};

/// Descriptor for `UpsertRouteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List upsertRouteRequestDescriptor = $convert.base64Decode(
    'ChJVcHNlcnRSb3V0ZVJlcXVlc3QSHQoKc2VydmljZV9pZBgBIAEoCVIJc2VydmljZUlkEiEKDG'
    'Rpc3BsYXlfbmFtZRgCIAEoCVILZGlzcGxheU5hbWUSGAoHZG9tYWlucxgDIAMoCVIHZG9tYWlu'
    'cxIXCgdub2RlX2lkGAQgASgJUgZub2RlSWQSGAoHZW5hYmxlZBgFIAEoCFIHZW5hYmxlZA==');

@$core.Deprecated('Use routeInfoDescriptor instead')
const RouteInfo$json = {
  '1': 'RouteInfo',
  '2': [
    {'1': 'service_id', '3': 1, '4': 1, '5': 9, '10': 'serviceId'},
    {'1': 'display_name', '3': 2, '4': 1, '5': 9, '10': 'displayName'},
    {'1': 'domains', '3': 3, '4': 3, '5': 9, '10': 'domains'},
    {'1': 'selector_tag', '3': 4, '4': 1, '5': 9, '10': 'selectorTag'},
    {'1': 'current_node_id', '3': 5, '4': 1, '5': 9, '10': 'currentNodeId'},
    {'1': 'current_node_name', '3': 6, '4': 1, '5': 9, '10': 'currentNodeName'},
    {'1': 'enabled', '3': 7, '4': 1, '5': 8, '10': 'enabled'},
    {'1': 'effective', '3': 8, '4': 1, '5': 8, '10': 'effective'},
  ],
};

/// Descriptor for `RouteInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List routeInfoDescriptor = $convert.base64Decode(
    'CglSb3V0ZUluZm8SHQoKc2VydmljZV9pZBgBIAEoCVIJc2VydmljZUlkEiEKDGRpc3BsYXlfbm'
    'FtZRgCIAEoCVILZGlzcGxheU5hbWUSGAoHZG9tYWlucxgDIAMoCVIHZG9tYWlucxIhCgxzZWxl'
    'Y3Rvcl90YWcYBCABKAlSC3NlbGVjdG9yVGFnEiYKD2N1cnJlbnRfbm9kZV9pZBgFIAEoCVINY3'
    'VycmVudE5vZGVJZBIqChFjdXJyZW50X25vZGVfbmFtZRgGIAEoCVIPY3VycmVudE5vZGVOYW1l'
    'EhgKB2VuYWJsZWQYByABKAhSB2VuYWJsZWQSHAoJZWZmZWN0aXZlGAggASgIUgllZmZlY3Rpdm'
    'U=');

@$core.Deprecated('Use deleteRouteRequestDescriptor instead')
const DeleteRouteRequest$json = {
  '1': 'DeleteRouteRequest',
  '2': [
    {'1': 'service_id', '3': 1, '4': 1, '5': 9, '10': 'serviceId'},
  ],
};

/// Descriptor for `DeleteRouteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteRouteRequestDescriptor =
    $convert.base64Decode(
        'ChJEZWxldGVSb3V0ZVJlcXVlc3QSHQoKc2VydmljZV9pZBgBIAEoCVIJc2VydmljZUlk');

@$core.Deprecated('Use routeListDescriptor instead')
const RouteList$json = {
  '1': 'RouteList',
  '2': [
    {
      '1': 'routes',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.targetlib.RouteInfo',
      '10': 'routes'
    },
    {
      '1': 'default_route',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.targetlib.RouteInfo',
      '10': 'defaultRoute'
    },
  ],
};

/// Descriptor for `RouteList`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List routeListDescriptor = $convert.base64Decode(
    'CglSb3V0ZUxpc3QSLAoGcm91dGVzGAEgAygLMhQudGFyZ2V0bGliLlJvdXRlSW5mb1IGcm91dG'
    'VzEjkKDWRlZmF1bHRfcm91dGUYAiABKAsyFC50YXJnZXRsaWIuUm91dGVJbmZvUgxkZWZhdWx0'
    'Um91dGU=');

@$core.Deprecated('Use selectRouteNodeRequestDescriptor instead')
const SelectRouteNodeRequest$json = {
  '1': 'SelectRouteNodeRequest',
  '2': [
    {'1': 'service_id', '3': 1, '4': 1, '5': 9, '10': 'serviceId'},
    {'1': 'node_id', '3': 2, '4': 1, '5': 9, '10': 'nodeId'},
  ],
};

/// Descriptor for `SelectRouteNodeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List selectRouteNodeRequestDescriptor =
    $convert.base64Decode(
        'ChZTZWxlY3RSb3V0ZU5vZGVSZXF1ZXN0Eh0KCnNlcnZpY2VfaWQYASABKAlSCXNlcnZpY2VJZB'
        'IXCgdub2RlX2lkGAIgASgJUgZub2RlSWQ=');

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
