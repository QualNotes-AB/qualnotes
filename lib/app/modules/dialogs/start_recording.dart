import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/modules/audio_recording/controllers/audio_recording_controller.dart';
import 'package:qualnote/app/modules/map/controllers/camera_controller.dart';
import 'package:qualnote/app/modules/map/controllers/map_controller.dart';

startRecordingDialog() {
  var mapGetxController = Get.find<MapGetxController>();
  mapGetxController.isMapping.value
      ? Get.snackbar(
          'Already recording', 'Recording method has already been selected')
      : Get.dialog(
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
                      onPressed: () {
                        Get.back();
                        mapGetxController
                            .selectRecordingType(RecordingType.audio);
                        mapGetxController.startMapping();
                        Get.find<AudioRecordingController>()
                            .startRecorder(isMainRecording: true);
                      },
                      child: const Center(
                        child: Text(
                          'Record audio',
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
                        Get.back();
                        mapGetxController
                            .selectRecordingType(RecordingType.video);
                        mapGetxController.startMapping();
                        await Get.find<CameraGetxController>()
                            .startVideoRecording();
                      },
                      child: const Center(
                        child: Text(
                          'Record video',
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
                        Get.back();
                        mapGetxController
                            .selectRecordingType(RecordingType.justMapping);
                        mapGetxController.startMapping();
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
