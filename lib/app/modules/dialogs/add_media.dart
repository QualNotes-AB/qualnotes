import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/modules/map/controllers/add_media_controller.dart';
import 'package:qualnote/app/modules/map/views/widgets/camera_page.dart';

addMediaDialog() {
  var addController = Get.find<AddMediaController>();
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
                    'What do we add?',
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
                onPressed: () async {
                  Get.back();
                  await addController.addPhoto();
                },
                child: const Center(
                  child: Text(
                    'Photo',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const Divider(height: 1, thickness: 1, color: AppColors.lightGrey),
            Expanded(
              child: TextButton(
                onPressed: () {
                  Get.to(
                    () => CameraApp(),
                    transition: Transition.downToUp,
                    duration: const Duration(milliseconds: 300),
                  );
                },
                child: const Center(
                  child: Text(
                    'Video',
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
                    'Audio',
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
