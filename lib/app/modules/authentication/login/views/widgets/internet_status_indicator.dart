import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/data/services/internet_availability.dart';

class InternetStatusIndicator extends StatelessWidget {
  InternetStatusIndicator({
    Key? key,
  }) : super(key: key);

  final InternetAvailability connectivity = Get.find<InternetAvailability>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: !connectivity.isConnected.value,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.orange[700],
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
                ' Offline mode ',
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
