import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/config/text_styles.dart';
import 'package:qualnote/app/modules/audio_recording/controllers/audio_recording_controller.dart';
import 'package:qualnote/app/modules/camera/controller/camera_controller.dart';
import 'package:qualnote/app/modules/map/controllers/map_controller.dart';

class CameraRecordPage extends StatefulWidget {
  final bool isPhoto;
  final Function(String path) onDone;
  const CameraRecordPage(
      {super.key, this.isPhoto = false, required this.onDone});

  @override
  State<CameraRecordPage> createState() => _CameraRecordPageState();
}

class _CameraRecordPageState extends State<CameraRecordPage> {
  final controller = Get.find<CameraGetxController>();
  bool secondPress = false;
  XFile? file;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Obx(() {
            return controller.isInitialized.value
                ? Center(child: controller.buildCameraWidget())
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.camera_alt_outlined),
                        Text(
                          'Camera not available',
                          style: AppTextStyle.bold12Grey,
                        )
                      ],
                    ),
                  );
          }),
          Visibility(
            visible: secondPress && !widget.isPhoto,
            child: Container(
              margin: const EdgeInsets.only(top: 30),
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: AppColors.red,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
              ),
              child: const Text(
                'REC',
                style: AppTextStyle.regular13White,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30, right: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    heroTag: 'return',
                    child: const Icon(
                      Icons.keyboard_arrow_left_rounded,
                      color: AppColors.black,
                      size: 30,
                    ),
                    backgroundColor: AppColors.white,
                    onPressed: () {
                      if (controller.cameraController.value.isRecordingVideo ||
                          controller.cameraController.value.isTakingPicture) {
                        return;
                      }
                      Get.back();

                      if (Get.find<MapGetxController>().type.value ==
                          RecordingType.video) {
                        Get.find<CameraGetxController>()
                            .startVideoRecording(isMainRecording: true);
                      }
                      if (Get.find<MapGetxController>().type.value ==
                          RecordingType.audio) {
                        Get.find<AudioRecordingController>()
                            .startRecorder(isMainRecording: true);
                      }
                    },
                  ),
                  Obx(
                    () => Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: FloatingActionButton(
                        heroTag: 'flash',
                        child: Icon(
                          controller.flashMode.value == FlashMode.off
                              ? Icons.flash_off
                              : controller.flashMode.value == FlashMode.torch
                                  ? Icons.flash_on
                                  : Icons.flash_auto,
                          color: AppColors.black,
                          size: 30,
                        ),
                        backgroundColor: AppColors.white,
                        onPressed: () async {
                          await controller.toggleFlashMode();
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 45),
                    child: FloatingActionButton(
                      heroTag: 'record',
                      child: Icon(
                        widget.isPhoto
                            ? Icons.photo_camera
                            : secondPress
                                ? Icons.radio_button_on
                                : Icons.radio_button_off,
                        color: AppColors.red,
                        size: widget.isPhoto ? 35 : 55,
                      ),
                      backgroundColor: AppColors.white,
                      onPressed: () async {
                        if (widget.isPhoto) {
                          //Take a photo
                          await takePhoto();
                        }
                        //Record a video
                        secondPress
                            ? await stopRecordingAndSave()
                            : controller
                                .startVideoRecording()
                                .then((value) => setState(() {
                                      secondPress = true;
                                    }));
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: FloatingActionButton(
                      heroTag: 'switch',
                      child: const Icon(
                        Icons.autorenew_outlined,
                        color: AppColors.black,
                        size: 30,
                      ),
                      backgroundColor: AppColors.white,
                      onPressed: () async {
                        await controller.switchCamera();
                      },
                    ),
                  ),
                  FloatingActionButton(
                    heroTag: 'quality',
                    child: const Icon(
                      Icons.camera_enhance,
                      color: AppColors.black,
                      size: 30,
                    ),
                    backgroundColor: AppColors.white,
                    onPressed: () async {
                      Get.dialog(
                        Dialog(
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Change camera quality',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyle.regular16Black,
                                ),
                                TextButton(
                                  onPressed: () {
                                    controller.changeCameraQuality(
                                        ResolutionPreset.max);
                                    Get.back();
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text('Max'),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    controller.changeCameraQuality(
                                        ResolutionPreset.high);
                                    Get.back();
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text('High'),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    controller.changeCameraQuality(
                                        ResolutionPreset.medium);
                                    Get.back();
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text('Medium'),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    controller.changeCameraQuality(
                                        ResolutionPreset.low);
                                    Get.back();
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text('Low'),
                                    ],
                                  ),
                                ),
                                const Text(
                                  'Keep in mind that higher quality will take up more memory',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyle.regular12Red,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> stopRecordingAndSave() async {
    file = await controller.stopVideoRecording();
    if (file != null) {
      if (file != null) {
        widget.onDone(file!.path);
      }
    }
    Get.back();
    if (Get.find<MapGetxController>().type.value == RecordingType.video) {
      Get.find<CameraGetxController>()
          .startVideoRecording(isMainRecording: true);
    }
    if (Get.find<MapGetxController>().type.value == RecordingType.audio) {
      Get.find<AudioRecordingController>().startRecorder(isMainRecording: true);
    }
  }

  Future<void> takePhoto() async {
    file = await controller.takePicture();
    if (file != null) {
      widget.onDone(file!.path);
    }
    Get.back();
    if (Get.find<MapGetxController>().type.value == RecordingType.video) {
      Get.find<CameraGetxController>()
          .startVideoRecording(isMainRecording: true);
    }
    if (Get.find<MapGetxController>().type.value == RecordingType.audio) {
      Get.find<AudioRecordingController>().startRecorder(isMainRecording: true);
    }
    return;
  }
}
