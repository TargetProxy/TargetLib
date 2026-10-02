import 'target_lib_connection.dart';
import '../generated/api/TargetLib/targetlib.pb.dart';

typedef TargetLibConnectionResolver = Future<TargetLibConnection> Function();

final class TargetLibConfig {
  TargetLibConfig(this._resolve);

  final TargetLibConnectionResolver _resolve;

  Future<RuntimeConfig> get() => _resolve().then((connection) =>
      connection.getRuntimeConfig());

  Future<RuntimeConfig> update(RuntimeSettings settings) =>
      _resolve().then((connection) => connection.updateRuntimeConfig(settings));
}

final class TargetLibProxy {
  TargetLibProxy(this._resolve);

  final TargetLibConnectionResolver _resolve;

  Future<OperationResponse> start() =>
      _resolve().then((connection) => connection.start());

  Future<OperationResponse> restart() =>
      _resolve().then((connection) => connection.restart());

  Future<OperationResponse> stop() =>
      _resolve().then((connection) => connection.stop());

  Future<ServiceState> state() =>
      _resolve().then((connection) => connection.state());

  Stream<ServiceState> subscribeState() async* {
    yield* (await _resolve()).subscribeState();
  }

  Stream<LogBatch> subscribeLogs() async* {
    yield* (await _resolve()).subscribeLogs();
  }

  Stream<TrafficStatus> subscribeTraffic({
    Duration interval = const Duration(seconds: 1),
  }) async* {
    yield* (await _resolve()).subscribeTraffic(interval: interval);
  }

  Future<NodePool> nodePool() =>
      _resolve().then((connection) => connection.getNodePool());

  Future<SelectNodeResponse> selectNode(String nodeId) =>
      _resolve().then((connection) => connection.selectNode(nodeId));

  Future<ProxyStatus> status() =>
      _resolve().then((connection) => connection.getProxyStatus());

  Future<IpInfoResponse> ipInfo() =>
      _resolve().then((connection) => connection.getIpInfo());

  Future<void> closeConnection(String id) =>
      _resolve().then((connection) => connection.closeConnection(id));

  Future<void> closeAllConnections() =>
      _resolve().then((connection) => connection.closeAllConnections());
}

final class TargetLibSubscriptions {
  TargetLibSubscriptions(this._resolve);

  final TargetLibConnectionResolver _resolve;

  Future<SubscriptionList> list() =>
      _resolve().then((connection) => connection.listSubscriptions());

  Future<SubscriptionView> get(String id) =>
      _resolve().then((connection) => connection.getSubscription(id));

  Future<SubscriptionView> add(AddSubscriptionRequest request) =>
      _resolve().then((connection) => connection.addSubscription(request));

  Future<void> remove(String id) =>
      _resolve().then((connection) => connection.removeSubscription(id));

  Future<SubscriptionView> rename(RenameSubscriptionRequest request) =>
      _resolve().then((connection) => connection.renameSubscription(request));

  Future<SubscriptionView> setEnabled(
    SetSubscriptionEnabledRequest request,
  ) => _resolve().then((connection) => connection.setSubscriptionEnabled(request));

  Future<SubscriptionView> configureUpdates(
    ConfigureSubscriptionUpdatesRequest request,
  ) => _resolve().then(
        (connection) => connection.configureSubscriptionUpdates(request),
      );

  Future<SubscriptionUpdateResult> update(String id) =>
      _resolve().then((connection) => connection.updateSubscription(id));

  Future<ResolvedEndpoints> resolvedEndpoints({bool enabledOnly = false}) =>
      _resolve().then(
        (connection) => connection.getResolvedEndpoints(
          enabledOnly: enabledOnly,
        ),
      );

  Stream<SubscriptionEvent> subscribeEvents() async* {
    yield* (await _resolve()).subscribeSubscriptionEvents();
  }
}

final class TargetLibRoutes {
  TargetLibRoutes(this._resolve);

  final TargetLibConnectionResolver _resolve;

  Future<RouteInfo> upsert(UpsertRouteRequest request) =>
      _resolve().then((connection) => connection.upsertRoute(request));

  Future<void> delete(String serviceId) =>
      _resolve().then((connection) => connection.deleteRoute(serviceId));

  Future<RouteList> list() =>
      _resolve().then((connection) => connection.listRoutes());

  Future<SelectNodeResponse> selectNode(String serviceId, String nodeId) =>
      _resolve().then(
        (connection) => connection.selectRouteNode(serviceId, nodeId),
      );
}
