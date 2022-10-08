import 'dart:async';
import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/config/text_styles.dart';
import 'package:qualnote/app/modules/map/controllers/add_media_controller.dart';
import 'package:qualnote/app/modules/map/controllers/map_controller.dart';
import 'package:video_player/video_player.dart';

class CameraGetxController extends GetxController {
  MapGetxController mapGetxController = Get.find<MapGetxController>();
  late List<CameraDescription> cameras;
  late CameraController cameraController;

  List<String> videoPaths = [];
  RxBool minimizedCamera = false.obs;
  RxBool isInitialized = false.obs;
  Rx<FlashMode> flashMode = FlashMode.off.obs;
  XFile? imageFile;
  XFile? videoFile;
  Timer? timer;
  int cameraId = 0;
  RxInt durationInSeconds = 0.obs;
  VideoPlayerController? videoController;

  void toggleMinizedCamera() => minimizedCamera.value = !minimizedCamera.value;

  Widget buildCameraWidget() {
    return isInitialized.value
        ? cameraController.buildPreview()
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
  }

  Future<void> startVideoRecording() async {
    if (!isInitialized.value) {
      return;
    }
    if (!cameraController.value.isInitialized) {
      //Camera isn't initialised
      Get.snackbar('Camera', 'Error: select a camera first.');
      return;
    }
    if (cameraController.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return;
    }

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      durationInSeconds.value++;
    });
    try {
      await cameraController.startVideoRecording();
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  Future<XFile?> stopVideoRecording({bool isFinish = false}) async {
    if (!isInitialized.value) {
      return null;
    }
    if (!cameraController.value.isRecordingVideo) {
      return null;
    }
    if (timer != null) {
      timer!.cancel();
    }
    if (isFinish) {
      durationInSeconds.value = 0;
    }
    try {
      XFile? video = await cameraController.stopVideoRecording();
      videoPaths.add(video.path);
      return video;
    } on Exception catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<void> takePicture() async {
    if (!isInitialized.value) {
      return;
    }
    if (cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return;
    }
    if (cameraController.value.isRecordingVideo) {
      //If the camera is recording then stop the recording
      await stopVideoRecording();
    }
    try {
      final XFile file = await cameraController.takePicture();
      Get.find<AddMediaController>().addPhoto(file);
    } on Exception catch (e) {
      log(e.toString());
      isInitialized.value = false;
      await cameraController.dispose();
      Get.back();
      init();
    }
  }

  Future<void> toggleFlashMode() async {
    if (!isInitialized.value) {
      return;
    }
    if (flashMode.value == FlashMode.off) {
      flashMode.value = FlashMode.torch;
    } else if (flashMode.value == FlashMode.torch) {
      flashMode.value = FlashMode.auto;
    } else if (flashMode.value == FlashMode.auto) {
      flashMode.value = FlashMode.off;
    }
    try {
      await cameraController.setFlashMode(flashMode.value);
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  Future<void> pauseVideoRecording() async {
    if (!isInitialized.value) {
      return;
    }
    if (!cameraController.value.isRecordingVideo) {
      return;
    }
    if (timer != null) {
      timer!.cancel();
    }
    try {
      await cameraController.pauseVideoRecording();
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  Future<void> resumeVideoRecording() async {
    if (!isInitialized.value) {
      return;
    }
    if (!cameraController.value.isRecordingVideo) {
      return;
    }
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      durationInSeconds.value++;
    });

    try {
      await cameraController.resumeVideoRecording();
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  Future<void> changeCameraQuality(ResolutionPreset preset) async {
    if (cameraController.value.isRecordingVideo ||
        cameraController.value.isTakingPicture) {
      return;
    }
    isInitialized.value = false;
    try {
      cameraController = CameraController(
        cameras.first,
        preset,
      );
      await cameraController.initialize();
      isInitialized.value = true;
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  Future<void> switchCamera() async {
    if (cameraController.value.isRecordingVideo ||
        cameraController.value.isTakingPicture) {
      return;
    }
    if (cameras.length <= 1) {
      //check if the front camera is available
      return;
    }
    isInitialized.value = false;
    cameraId == 0 ? cameraId = 1 : cameraId = 0;
    try {
      cameraController = CameraController(
        cameras[cameraId],
        ResolutionPreset.high,
      );
      await cameraController.initialize();
      isInitialized.value = true;
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  Future<void> init() async {
    cameras = await availableCameras();
    cameraController = CameraController(
      cameras.first,
      ResolutionPreset.high,
    );
    try {
      await cameraController.initialize();
      await cameraController.setFlashMode(FlashMode.off);
      isInitialized.value = true;
    } on Exception catch (e) {
      isInitialized.value = false;
      log(e.toString());
    }
  }

  @override
  void onInit() async {
    await init();
    super.onInit();
  }

  @override
  void onClose() {
    if (timer != null) {
      timer!.cancel();
    }
    durationInSeconds.value = 0;
    cameraController.dispose();
    super.onClose();
  }

  @override
  void dispose() {
    if (timer != null) {
      timer!.cancel();
    }
    cameraController.dispose();
    super.dispose();
  }
}
