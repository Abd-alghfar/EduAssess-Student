import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

enum ConnectivityStatus { isConnected, isDisconnected }

final connectivityStatusProvider = StreamProvider<ConnectivityStatus>((ref) {
  final controller = StreamController<ConnectivityStatus>();
  Timer? debounceTimer;

  void checkInitial() async {
    final hasConnection = await InternetConnection().hasInternetAccess;
    controller.add(
      hasConnection
          ? ConnectivityStatus.isConnected
          : ConnectivityStatus.isDisconnected,
    );
  }

  checkInitial();

  final subscription = InternetConnection().onStatusChange.listen((status) {
    if (status == InternetStatus.connected) {
      debounceTimer?.cancel();
      controller.add(ConnectivityStatus.isConnected);
    } else {
      // Wait 5 seconds before reporting disconnection to avoid flickering on weak signal
      debounceTimer?.cancel();
      debounceTimer = Timer(const Duration(seconds: 5), () async {
        final stillDisconnected =
            !(await InternetConnection().hasInternetAccess);
        if (stillDisconnected) {
          controller.add(ConnectivityStatus.isDisconnected);
        }
      });
    }
  });

  ref.onDispose(() {
    debounceTimer?.cancel();
    subscription.cancel();
    controller.close();
  });

  return controller.stream;
});
