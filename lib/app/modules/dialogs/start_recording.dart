import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/modules/map/controllers/map_controller.dart';

startRecordingDialog() {
  var mapGetxController = Get.find<MapGetxController>();
  Get.dialog(
    Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: AppColors.popupGrey,
      child: SizedBox(
        height: 260,
        width: 260,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Which method will use?',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: AppColors.lightGrey,
            ),
            Expanded(
              child: TextButton(
                onPressed: () {},
                child: const Center(
                  child: Text(
                    'Record audio',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const Divider(height: 1, thickness: 1, color: AppColors.lightGrey),
            Expanded(
              child: TextButton(
                onPressed: () {},
                child: const Center(
                  child: Text(
                    'Record video',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const Divider(height: 1, thickness: 1, color: AppColors.lightGrey),
            Expanded(
              child: TextButton(
                onPressed: () {
                  mapGetxController.startMapping();
                  Get.back();
                },
                child: const Center(
                  child: Text(
                    'Just mapping',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
