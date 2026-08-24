import 'dart:async';
import 'dart:io';

import 'package:grpc/grpc.dart';
import 'package:protobuf/well_known_types/google/protobuf/empty.pb.dart';

import '../generated/api/TargetLib/targetlib.pbgrpc.dart';

/// Owns the authenticated local TargetLib command connection.
///
/// The socket transport and readiness handshake are deliberately kept in the
/// plugin so applications do not duplicate gRPC setup or retry behavior.
final class TargetLibConnection {
  TargetLibConnection._(this.channel, this.client, this.options);

  final ClientChannel channel;
  final TargetLibClient client;
  final CallOptions options;

  static Future<TargetLibConnection> connect(
    String socketPath, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    final channel = ClientChannel(
      InternetAddress(socketPath, type: InternetAddressType.unix),
      port: 0,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );
    final options = CallOptions();
    final client = TargetLibClient(channel);
    Object? lastError;
    final deadline = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(deadline)) {
      try {
        await client
            .getVersion(Empty(), options: options)
            .timeout(const Duration(seconds: 1));
        return TargetLibConnection._(channel, client, options);
      } on Object catch (error) {
        lastError = error;
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }
    }
    await channel.shutdown();
    throw StateError('TargetLib command server did not become ready: $lastError');
  }

  Future<void> close() => channel.shutdown();
}
