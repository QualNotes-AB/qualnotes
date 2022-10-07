import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/modules/map/controllers/map_controller.dart';
import 'package:qualnote/app/routes/app_pages.dart';

recordMethodDialog() {
  var controller = Get.find<MapGetxController>();
  Get.dialog(
    Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: AppColors.popupGrey,
      child: SizedBox(
        height: 260,
        width: 260,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Which method will use?',
                    textAlign: TextAlign.left,
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
                onPressed: () {
                  Get.back();
                  controller.selectRecordingType(RecordingType.justMapping);
                  controller.resetFields();
                  Get.toNamed(Routes.MAP);
                },
                child: const Center(
                  child: Text(
                    'New Mobile Mapping',
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
                    'New Interview / Focus Gorup\n(coming soon..)',
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
                    'New Participant Observation / Autoethnography\n(coming soon..)',
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
