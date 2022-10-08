import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/modules/audio_recording/controllers/audio_recording_controller.dart';
import 'package:qualnote/app/modules/camera/controller/camera_controller.dart';
import 'package:qualnote/app/modules/camera/view/camera_record_page.dart';
import 'package:qualnote/app/modules/map/controllers/add_media_controller.dart';
import 'package:qualnote/app/modules/map/controllers/map_controller.dart';
import 'package:qualnote/app/routes/app_pages.dart';

addMediaDialog() {
  var addController = Get.find<AddMediaController>();
  var mapController = Get.find<MapGetxController>();
  var cameraGetxController = Get.find<CameraGetxController>();
  var audioGetxController = Get.find<AudioRecordingController>();
  mapController.isMapping.value
      ? Get.dialog(
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
                      onPressed: () {
                        cameraGetxController.stopVideoRecording();
                        Get.back();
                        Get.to(() => const CameraRecordPage(isPhoto: true));
                      },
                      child: const Center(
                        child: Text(
                          'Photo',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  const Divider(
                      height: 1, thickness: 1, color: AppColors.lightGrey),
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        cameraGetxController.stopVideoRecording();
                        Get.back();
                        Get.to(() => const CameraRecordPage());
                      },
                      child: const Center(
                        child: Text(
                          'Video',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  const Divider(
                      height: 1, thickness: 1, color: AppColors.lightGrey),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        audioGetxController.stopRecorder(isFinish: true);
                        Get.offAndToNamed(Routes.AUDIO_RECORDING);
                      },
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
        )
      : Get.snackbar('Not recording',
          'Please select recording method and then you can add notes',
          duration: const Duration(seconds: 5));
}
