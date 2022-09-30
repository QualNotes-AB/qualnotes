import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/modules/map/controllers/map_controller.dart';
import 'package:video_player/video_player.dart';

class CameraGetxController extends GetxController {
  MapGetxController mapGetxController = Get.find<MapGetxController>();
  late List<CameraDescription> cameras;
  late Rx<CameraController> controller;
  RxBool isRecording = false.obs;
  Rx<FlashMode> flashMode = FlashMode.off.obs;
  XFile? imageFile;
  XFile? videoFile;
  VideoPlayerController? videoController;

  FlashMode toggleFlash() {
    flashMode.value == FlashMode.off
        ? flashMode.value = FlashMode.torch
        : flashMode.value = FlashMode.off;
    return flashMode.value;
  }

  void setRecording(bool value) => isRecording.value = value;
  void setFlash(value) => flashMode.value = value;

  // Future<void> onPausePreviewButtonPressed() async {
  //   final CameraController? cameraController = controller.value;
  //   if (cameraController == null || !cameraController.value.isInitialized) {
  //     Get.snackbar('Camera', 'Error: select a camera first.');
  //     return;
  //   }

  //   if (cameraController.value.isPreviewPaused) {
  //     await cameraController.resumePreview();
  //     isRecording.value = true;
  //   } else {
  //     await cameraController.pausePreview();
  //   }
  //   refresh();
  // }

  // void _showCameraException(CameraException e) {
  //   Get.snackbar('Error', '${e.code}\n${e.description}');
  // }

  // Future<void> startVideoRecording() async {
  //   isRecording.value = true;
  //   final CameraController? cameraController = controller.value;
  //   if (cameraController == null || !cameraController.value.isInitialized) {
  //     Get.snackbar('Camera', 'Error: select a camera first.');
  //     return;
  //   }
  //   if (cameraController.value.isRecordingVideo) {
  //     // A recording is already started, do nothing.
  //     return;
  //   }
  //   try {
  //     await cameraController.startVideoRecording();
  //   } on CameraException catch (e) {
  //     _showCameraException(e);
  //     return;
  //   }
  // }

  // Future<void> stopVideoRecording() async {
  //   isRecording.value = false;
  //   //  log('stop1');
  //   final CameraController? cameraController = controller.value;
  //   if (cameraController == null || !cameraController.value.isRecordingVideo) {
  //     return;
  //   }
  //   try {
  //     videoFile = await cameraController.stopVideoRecording();
  //     log('stop2');
  //     print(videoFile!.path);
  //     if (videoFile != null) {
  //       Get.to(() => VideoPlayerWidget(path: videoFile!.path));
  //     }
  //   } on CameraException catch (e) {
  //     _showCameraException(e);
  //     return;
  //   }
  // }

  // Future<void> saveVideo() async {
  //   await Get.find<AddMediaController>().addVideo(videoFile!.path);
  // }

  // Future<void> pauseVideoRecording() async {
  //   final CameraController? cameraController = controller.value;
  //   if (cameraController == null || !cameraController.value.isRecordingVideo) {
  //     return;
  //   }
  //   try {
  //     await cameraController.pauseVideoRecording();
  //   } on CameraException catch (e) {
  //     _showCameraException(e);
  //     rethrow;
  //   }
  // }

  // Future<void> resumeVideoRecording() async {
  //   final CameraController? cameraController = controller.value;
  //   if (cameraController == null || !cameraController.value.isRecordingVideo) {
  //     return;
  //   }
  //   try {
  //     await cameraController.resumeVideoRecording();
  //   } on CameraException catch (e) {
  //     _showCameraException(e);
  //     rethrow;
  //   }
  // }

  // Future<void> setFlashMode(FlashMode mode) async {
  //   try {
  //     await controller.value.setFlashMode(mode);
  //   } on CameraException catch (e) {
  //     _showCameraException(e);
  //     rethrow;
  //   }
  // }

  @override
  void onInit() async {
    cameras = await availableCameras();
    // controller = CameraController(cameras[0], ResolutionPreset.max).obs;
    // controller.value = CameraController(cameras[0], ResolutionPreset.max);

    // controller.value.initialize().then((_) {
    //   refresh();
    // }).catchError((Object e) {
    //   if (e is CameraException) {
    //     switch (e.code) {
    //       case 'CameraAccessDenied':
    //         print('User denied camera access.');
    //         break;
    //       default:
    //         print('Handle other errors.');
    //         break;
    //     }
    //   }
    // });
    super.onInit();
  }

  @override
  void dispose() {
    controller.value.dispose();
    super.dispose();
  }
}
