import 'dart:async';

import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/modules/map/controllers/add_media_controller.dart';
import 'package:qualnote/app/modules/map/controllers/map_controller.dart';
import 'package:video_player/video_player.dart';

class CameraGetxController extends GetxController {
  MapGetxController mapGetxController = Get.find<MapGetxController>();
  late List<CameraDescription> cameras;
  late CameraController cameraController;
  List<String> videoPaths = [];
  RxBool minimizedCamera = false.obs;
  Rx<FlashMode> flashMode = FlashMode.off.obs;
  XFile? imageFile;
  XFile? videoFile;
  Timer? timer;
  RxInt durationInSeconds = 0.obs;
  VideoPlayerController? videoController;

  void toggleMinizedCamera() => minimizedCamera.value = !minimizedCamera.value;

  Future<void> startVideoRecording() async {
    if (!cameraController.value.isInitialized) {
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
    await cameraController.startVideoRecording();
  }

  Future<XFile?> stopVideoRecording({bool isFinish = false}) async {
    if (!cameraController.value.isRecordingVideo) {
      return null;
    }
    if (timer != null) {
      timer!.cancel();
    }
    if (isFinish) {
      durationInSeconds.value = 0;
    }
    XFile? video = await cameraController.stopVideoRecording();
    videoPaths.add(video.path);
    return video;
  }

  Future<void> takePicture() async {
    if (cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return;
    }

    try {
      final XFile file = await cameraController.takePicture();
      Get.find<AddMediaController>().addPhoto(file);
    } on CameraException {
      return;
    }
  }

  Future<void> setFlashMode(FlashMode mode) async {
    await setFlashMode(mode);
  }

  Future<void> pauseVideoRecording() async {
    if (!cameraController.value.isRecordingVideo) {
      return;
    }
    if (timer != null) {
      timer!.cancel();
    }
    await cameraController.pauseVideoRecording();
  }

  Future<void> resumeVideoRecording() async {
    if (!cameraController.value.isRecordingVideo) {
      return;
    }
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      durationInSeconds.value++;
    });

    await cameraController.resumeVideoRecording();
  }

  Future<void> init() async {
    cameras = await availableCameras();
    cameraController = CameraController(
      cameras.first,
      ResolutionPreset.high,
    );
    await cameraController.initialize();
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
    // cameraController.dispose();
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
