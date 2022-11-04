import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/modules/map/controllers/map_controller.dart';

pausedDialog() {
  var mapGetxController = Get.find<MapGetxController>();
  // var cameraGetxController = Get.find<CameraGetxController>();
  // var audioGetxController = Get.find<AudioRecordingController>();
  mapGetxController.isMapping.value
      ? {
          mapGetxController.stopMapping(),
          // cameraGetxController.pauseVideoRecording(),
          // audioGetxController.pause(),
          Get.dialog(
            Dialog(
              insetPadding: EdgeInsets.zero,
              backgroundColor: AppColors.popupGrey,
              child: SizedBox(
                height: 100,
                width: 180,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 15, top: 15),
                      child: Text('All recordings paused.'),
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.lightGrey,
                    ),
                    TextButton(
                      onPressed: () {
                        mapGetxController.resumeMapping();
                        // cameraGetxController.resumeVideoRecording();
                        // audioGetxController.resume();
                        Get.back();
                      },
                      child: const Center(
                        child: Text('Click here to resume'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            barrierDismissible: false,
          )
        }
      : {
          Get.snackbar(
              'No recording in progress', 'You first have to start recording'),
        };
}
