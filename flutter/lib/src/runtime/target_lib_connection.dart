import 'dart:async';
import 'dart:io';

import 'package:grpc/grpc.dart';
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
    final options = CallOptions();
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

  Future<OperationResponse> restart() =>
      client.restart(Empty(), options: options);

  Future<OperationResponse> stop() => client.stop(Empty(), options: options);

  Future<ServiceState> state() => client.getState(Empty(), options: options);

  Future<RuntimeConfig> getRuntimeConfig() =>
      client.getRuntimeConfig(Empty(), options: options);

  Future<RuntimeConfig> updateRuntimeConfig(RuntimeSettings settings) =>
      client.updateRuntimeConfig(
        UpdateRuntimeConfigRequest(settings: settings),
        options: options,
      );
}
