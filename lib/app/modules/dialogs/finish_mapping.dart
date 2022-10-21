import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/modules/audio_recording/controllers/audio_recording_controller.dart';
import 'package:qualnote/app/modules/camera/controller/camera_controller.dart';
import 'package:qualnote/app/modules/map/controllers/map_controller.dart';
import 'package:qualnote/app/modules/overview/controllers/overview_controller.dart';
import 'package:qualnote/app/modules/overview/views/overview_view.dart';

finishedDialog() {
  var mapGetxController = Get.find<MapGetxController>();
  var cameraGetxController = Get.find<CameraGetxController>();
  var audioGetxController = Get.find<AudioRecordingController>();
  String? title;
  mapGetxController.isMapping.value
      ? {
          mapGetxController.stopMapping(),
          cameraGetxController.pauseVideoRecording(),
          audioGetxController.pause(),
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
                      Expanded(
                        child: TextField(
                          onChanged: (value) => title = value,
                          autocorrect: false,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: 20),
                            hintText: 'Enter map title',
                          ),
                        ),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.lightGrey,
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  mapGetxController.resumeMapping();
                                  cameraGetxController.resumeVideoRecording();
                                  audioGetxController.resume();
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
                              child: Obx(
                                () => TextButton(
                                  onPressed: mapGetxController.isFinishing.value
                                      ? null
                                      : () async {
                                          if (title == null || title!.isEmpty) {
                                            Get.snackbar('Sorry',
                                                'Please enter the title of the route');
                                          } else {
                                            mapGetxController
                                                .isFinishing.value = true;
                                            await cameraGetxController
                                                .stopVideoRecording(
                                                    isFinish: true,
                                                    isMainRecording: true);
                                            await audioGetxController
                                                .stopRecorder(
                                                    isMainRecording: true);
                                            final newProject =
                                                await mapGetxController
                                                    .saveRouteLocaly(title!);
                                            mapGetxController
                                                .isFinishing.value = false;
                                            Get.find<OverviewController>()
                                                .selectProject(
                                                    newProject: newProject,
                                                    local: true);
                                            Get.to(() => const OverviewView());
                                          }
                                        },
                                  child: const Center(
                                    child: Text('Save'),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              barrierDismissible: false),
        }
      : {
          Get.snackbar(
              'No recording in progress', 'You first have to start recording'),
        };
}
