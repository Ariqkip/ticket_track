import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'connectivity_service.dart';


class ConnectivityPlusConnectionService implements ConnectivityService {

  final Connectivity _connectivity;
  final InternetConnectionChecker _internetChecker;
  final StreamController<bool> _connectionStatusController;
  StreamSubscription<ConnectivityResult>? _subscription;

  bool _lastResult = false;
  bool _initialCheck = true;

  static const String _tag = "ConnectivityService";

  ConnectivityPlusConnectionService({
    required Connectivity connectivity,
    required InternetConnectionChecker internetChecker,
  }) : _connectivity = connectivity,
        _internetChecker = internetChecker,
        _connectionStatusController = StreamController.broadcast();

  @override
  Stream<bool> get onConnectionChange => _connectionStatusController.stream;

  @override
  bool get lastResult => _lastResult;

  Future<void> initialize() async {
    _subscription = _connectivity.onConnectivityChanged.listen((result) async {
      _lastResult = await _hasActualConnection(result);
      print("internet result $_lastResult");

      if (_initialCheck) {
        _initialCheck = false;
        return;
      }
      _connectionStatusController.add(_lastResult);
    });
  }

  Future<bool> _hasActualConnection(ConnectivityResult result) async {
    // For mobile/wifi, verify actual internet connection
    if (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi) {
      return await _internetChecker.hasConnection;
    }
    return false;
  }

  @override
  Future<bool> hasInternetConnection() async {
    final result = await _connectivity.checkConnectivity();
    return await _hasActualConnection(result);
  }

  void dispose() {
    _subscription?.cancel();
    _connectionStatusController.close();
  }
}