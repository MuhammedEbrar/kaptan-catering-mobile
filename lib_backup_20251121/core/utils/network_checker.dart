import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkChecker {
  final Connectivity _connectivity = Connectivity();
  
  // Stream for listening to connectivity changes
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map((result) {
      return _isConnected(result);
    });
  }
  
  // Check if device is connected to internet
  Future<bool> isConnected() async {
    try {
      final result = await _connectivity.checkConnectivity();
      return _isConnected(result);
    } catch (e) {
      print('❌ Network check error: $e');
      return false;
    }
  }
  
  // Helper method to determine connection status
  bool _isConnected(ConnectivityResult result) {
    // ConnectivityResult can be mobile, wifi, ethernet, vpn, bluetooth, other, none
    return result == ConnectivityResult.mobile || 
           result == ConnectivityResult.wifi ||
           result == ConnectivityResult.ethernet ||
           result == ConnectivityResult.vpn;
  }
  
  // Get connection type as string (for display)
  Future<String> getConnectionType() async {
    try {
      final result = await _connectivity.checkConnectivity();
      
      switch (result) {
        case ConnectivityResult.wifi:
          return 'WiFi';
        case ConnectivityResult.mobile:
          return 'Mobil Veri';
        case ConnectivityResult.ethernet:
          return 'Ethernet';
        case ConnectivityResult.vpn:
          return 'VPN';
        case ConnectivityResult.none:
          return 'Çevrimdışı';
        default:
          return 'Bilinmiyor';
      }
    } catch (e) {
      return 'Bilinmiyor';
    }
  }
}