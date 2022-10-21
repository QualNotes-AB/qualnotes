import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/modules/audio_recording/controllers/audio_recording_controller.dart';
import 'package:qualnote/app/modules/camera/controller/camera_controller.dart';
import 'package:qualnote/app/modules/map/controllers/add_media_controller.dart';
import 'package:qualnote/app/modules/map/controllers/map_controller.dart';

addTextNoteDialog() {
  var mediaController = Get.find<AddMediaController>();
  String? text;

  Get.dialog(
    Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: AppColors.popupGrey,
      child: SizedBox(
        height: 160,
        width: 180,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15, right: 15),
              child: TextField(
                onChanged: (value) => text = value,
                maxLines: 5,
                autocorrect: false,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 20),
                  hintText: 'Enter text',
                ),
              ),
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: AppColors.lightGrey,
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Center(
                      child: Text('Go back'),
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  width: 1,
                  color: AppColors.lightGrey,
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      if (text == null || text!.isEmpty) {
                        Get.snackbar(
                            'Sorry', 'Please enter the title of the route');
                      } else {
                        if (Get.find<MapGetxController>().type.value ==
                            RecordingType.video) {
                          await Get.find<CameraGetxController>()
                              .stopVideoRecording(isMainRecording: true);
                        }
                        if (Get.find<MapGetxController>().type.value ==
                            RecordingType.audio) {
                          Get.find<AudioRecordingController>()
                              .stopRecorder(isMainRecording: true);
                        }
                        Get.back();
                        mediaController.addTextNote(text!);
                        if (Get.find<MapGetxController>().type.value ==
                            RecordingType.video) {
                          await Get.find<CameraGetxController>()
                              .startVideoRecording(isMainRecording: true);
                        }
                        if (Get.find<MapGetxController>().type.value ==
                            RecordingType.audio) {
                          Get.find<AudioRecordingController>()
                              .startRecorder(isMainRecording: true);
                        }
                      }
                    },
                    child: const Center(
                      child: Text('Add Note'),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}
