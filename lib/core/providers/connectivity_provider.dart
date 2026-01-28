import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

enum ConnectivityStatus { isConnected, isDisconnected }

final connectivityStatusProvider = StreamProvider<ConnectivityStatus>((ref) {
  final controller = StreamController<ConnectivityStatus>();

  // Check initial connection
  InternetConnection().hasInternetAccess.then((hasConnection) {
    if (hasConnection) {
      controller.add(ConnectivityStatus.isConnected);
    } else {
      controller.add(ConnectivityStatus.isDisconnected);
    }
  });

  // Listen for changes
  final subscription = InternetConnection().onStatusChange.listen((status) {
    switch (status) {
      case InternetStatus.connected:
        controller.add(ConnectivityStatus.isConnected);
        break;
      case InternetStatus.disconnected:
        controller.add(ConnectivityStatus.isDisconnected);
        break;
    }
  });

  ref.onDispose(() {
    subscription.cancel();
    controller.close();
  });

  return controller.stream;
});
