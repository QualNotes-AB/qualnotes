import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InternetAvailability extends GetxController {
  late StreamSubscription subscription;
  RxBool isConnected = false.obs;
  SnackbarController? _controller;

  displaySnackbar(ConnectivityResult result) {
    if (result == ConnectivityResult.none ||
        result == ConnectivityResult.bluetooth) {
      isConnected.value = false;

      _controller = Get.showSnackbar(
        GetSnackBar(
          messageText: const SizedBox(),
          titleText: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.red[700],
                  borderRadius: BorderRadius.circular(3),
                ),
                padding: const EdgeInsets.all(3),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.wifi_off_sharp,
                      size: 20,
                      color: Colors.white,
                    ),
                    Text(
                      ' No internet ',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            ],
          ),
          padding: const EdgeInsets.only(left: 5, top: 3),
          backgroundColor: Colors.transparent,
          snackPosition: SnackPosition.TOP,
          isDismissible: false,
        ),
      );
    } else {
      isConnected.value = true;
      if (_controller != null) {
        _controller!.close();
      }
    }
  }

  checkInternet() async =>
      displaySnackbar(await Connectivity().checkConnectivity());

  @override
  void onInit() {
    checkInternet();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      displaySnackbar(result);
    });
    super.onInit();
  }

  @override
  void onClose() {
    _controller = null;
    subscription.cancel();
    super.onClose();
  }
}
