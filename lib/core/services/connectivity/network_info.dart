import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract interface class INetworkInfo {
  Future<bool> get isConnected;
}

final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfo(connectivity: Connectivity());
});

class NetworkInfo implements INetworkInfo {
  final Connectivity _connectivity;

  NetworkInfo({required Connectivity connectivity})
    : _connectivity = connectivity;

  @override
  Future<bool> get isConnected async {
    // wifi or mobile data check
    final result = await _connectivity.checkConnectivity();
    if (result.contains(ConnectivityResult.none)) {
      return false;
    }
    return await _isWifiOn();
  }

  Future<bool> _isWifiOn() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (e) {
      return false;
    }
  }
}
