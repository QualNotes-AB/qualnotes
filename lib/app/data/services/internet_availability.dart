import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class InternetAvailability extends GetxController {
  late StreamSubscription subscription;
  RxBool isConnected = false.obs;

  checkInternet(ConnectivityResult? result) async {
    if (result != null) {
      result = await Connectivity().checkConnectivity();
    }
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      isConnected.value = true;
    } else {
      isConnected.value = false;
    }
  }

  @override
  void onInit() {
    checkInternet(null);
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      checkInternet(result);
    });
    super.onInit();
  }

  @override
  void onClose() {
    subscription.cancel();
    super.onClose();
  }
}
