import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkState {
  final Connectivity _connectivity;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  late ConnectivityResult _connectionStatus;

  NetworkState(this._connectivity);

  ConnectivityResult get status => _connectionStatus;
  Future<void> watchConnectionState() async {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> stablishState() async {
    _connectionStatus = (await _connectivity.checkConnectivity()).first;
  }

  void watchConnectionCustom(
      void Function(List<ConnectivityResult>)? callback) {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(callback);
  }

  Future<void> closeWatchedConnection() async {
    _connectivitySubscription.cancel();
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    _connectionStatus = result.first;
  }
}
