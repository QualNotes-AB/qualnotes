import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/config/text_styles.dart';
import 'package:qualnote/app/data/services/internet_availability.dart';
import 'package:qualnote/app/modules/home/controllers/progress_controller.dart';

class PageHolder extends StatelessWidget {
  final Widget child;
  const PageHolder({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width > 500.0
        ? 500.0
        : MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: width,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: SingleChildScrollView(child: child),
                ),
                buildInternetStatus(),
                buildProgressIndicatior()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Obx buildInternetStatus() {
    final connectivity = Get.find<InternetAvailability>();
    return Obx(
      () => Visibility(
        visible: !connectivity.isConnected.value,
        child: Container(
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
      ),
    );
  }

  Align buildProgressIndicatior() {
    final progressController = Get.find<ProgressController>();
    return Align(
      alignment: Alignment.bottomCenter,
      child: Obx(
        () => Visibility(
          visible: progressController.inProgress.value,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(color: Colors.blue),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  progressController.message.value,
                  style: AppTextStyle.regular13White,
                ),
                LinearProgressIndicator(
                  color: Colors.white,
                  backgroundColor: Colors.white60,
                  value: progressController.progressValue.value == 0
                      ? null
                      : progressController.progressValue.value,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
