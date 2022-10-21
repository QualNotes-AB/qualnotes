import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/config/text_styles.dart';
import 'package:qualnote/app/modules/home/controllers/progress_controller.dart';

class StorageProgressIndicator extends StatelessWidget {
  StorageProgressIndicator({
    Key? key,
  }) : super(key: key);

  final ProgressController progressController = Get.find<ProgressController>();

  @override
  Widget build(BuildContext context) {
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
