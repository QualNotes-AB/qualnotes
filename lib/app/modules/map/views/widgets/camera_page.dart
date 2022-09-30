import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/modules/map/controllers/camera_controller.dart';
import 'package:qualnote/app/modules/map/views/widgets/video_player.dart';

/// CameraApp is the Main Application.
class CameraApp extends StatefulWidget {
  /// Default Constructor
  const CameraApp({Key? key}) : super(key: key);

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  final cameraGetx = Get.find<CameraGetxController>();
  late CameraController controller;
  // late bool isRecording;
  // late FlashMode flashMode;
  @override
  void initState() {
    super.initState();
    // isRecording = false;
    // flashMode = FlashMode.off;
    controller = CameraController(
      Get.find<CameraGetxController>().cameras.first,
      ResolutionPreset.high,
    );
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }

      setState(() {});
    }).catchError(
      (Object e) {
        if (e is CameraException) {
          switch (e.code) {
            case 'CameraAccessDenied':
              Get.snackbar(
                'Error',
                'User denied camera access.',
                backgroundColor: Colors.red,
                colorText: Colors.white,
                duration: const Duration(seconds: 5),
              );
              break;
            default:
              Get.snackbar(
                'Error',
                'Unexpected error on camera initialization',
                backgroundColor: Colors.red,
                colorText: Colors.white,
                duration: const Duration(seconds: 5),
              );
              break;
          }
        }
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          CameraPreview(controller),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 80,
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        setFlashMode(cameraGetx.toggleFlash());
                      });
                    },
                    child: Obx(
                      () => Icon(
                        cameraGetx.flashMode.value == FlashMode.off
                            ? Icons.flash_off
                            : Icons.flash_on,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onLongPress: () async {
                      await startVideoRecording();
                    },
                    onLongPressUp: () async {
                      await stopVideoRecording();
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Obx(
                          () => AnimatedCrossFade(
                            crossFadeState: cameraGetx.isRecording.value
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                            duration: const Duration(milliseconds: 200),
                            firstChild: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: AppColors.red,
                              ),
                            ),
                            secondChild: const SizedBox(),
                          ),
                        ),
                        const Icon(
                          Icons.circle_outlined,
                          color: Colors.white,
                          size: 60,
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      controller.description == cameraGetx.cameras.first
                          ? onNewCameraSelected(cameraGetx.cameras.last)
                          : onNewCameraSelected(cameraGetx.cameras.first);
                    },
                    child: const Icon(
                      Icons.flip_camera_android,
                      size: 30,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCameraException(CameraException e) {
    Get.snackbar('Error', '${e.code}\n${e.description}');
  }

  Future<void> startVideoRecording() async {
    cameraGetx.setRecording(true);

    final CameraController? cameraController = controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      Get.snackbar('Camera', 'Error: select a camera first.');
      return;
    }
    if (cameraController.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return;
    }
    try {
      await cameraController.startVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return;
    }
  }

  Future<void> stopVideoRecording() async {
    setState(() {
      setFlashMode(FlashMode.off);
      cameraGetx.setFlash(FlashMode.off);
      cameraGetx.setRecording(false);
    });

    final CameraController? cameraController = controller;
    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return;
    }
    try {
      var videoFile = await cameraController.stopVideoRecording();
      Get.to(() => VideoPlayerWidget(path: videoFile.path));
    } on CameraException catch (e) {
      _showCameraException(e);
      return;
    }
  }

  Future<void> setFlashMode(FlashMode mode) async {
    try {
      await controller.setFlashMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    final CameraController? oldController = controller;
    if (oldController != null) {
      // `controller` needs to be set to null before getting disposed,
      // to avoid a race condition when we use the controller that is being
      // disposed. This happens when camera permission dialog shows up,
      // which triggers `didChangeAppLifecycleState`, which disposes and
      // re-creates the controller.
      //controller = null;
      await oldController.dispose();
    }

    final CameraController cameraController = CameraController(
      cameraDescription,
      kIsWeb ? ResolutionPreset.max : ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    controller = cameraController;

    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (cameraController.value.hasError) {
        // showInSnackBar(
        //     'Camera error ${cameraController.value.errorDescription}');
      }
    });

    try {
      await cameraController.initialize();
      await Future.wait(<Future<Object?>>[
        // The exposure mode is currently not supported on the web.
        // ...!kIsWeb
        //     ? <Future<Object?>>[
        //         cameraController.getMinExposureOffset().then(
        //             (double value) => _minAvailableExposureOffset = value),
        //         cameraController
        //             .getMaxExposureOffset()
        //             .then((double value) => _maxAvailableExposureOffset = value)
        //       ]
        //     : <Future<Object?>>[],
        // cameraController
        //     .getMaxZoomLevel()
        //     .then((double value) => _maxAvailableZoom = value),
        // cameraController
        //     .getMinZoomLevel()
        //     .then((double value) => _minAvailableZoom = value),
      ]);
    } on CameraException {
      // switch (e.code) {
      //   case 'CameraAccessDenied':
      //     showInSnackBar('You have denied camera access.');
      //     break;
      //   case 'CameraAccessDeniedWithoutPrompt':
      //     // iOS only
      //     showInSnackBar('Please go to Settings app to enable camera access.');
      //     break;
      //   case 'CameraAccessRestricted':
      //     // iOS only
      //     showInSnackBar('Camera access is restricted.');
      //     break;
      //   case 'AudioAccessDenied':
      //     showInSnackBar('You have denied audio access.');
      //     break;
      //   case 'AudioAccessDeniedWithoutPrompt':
      //     // iOS only
      //     showInSnackBar('Please go to Settings app to enable audio access.');
      //     break;
      //   case 'AudioAccessRestricted':
      //     // iOS only
      //     showInSnackBar('Audio access is restricted.');
      //     break;
      //   default:
      //     _showCameraException(e);
      //     break;
      // }
    }

    if (mounted) {
      setState(() {});
    }
  }
}
