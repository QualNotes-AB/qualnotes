import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/modules/map/controllers/add_media_controller.dart';
import 'package:qualnote/app/modules/map/controllers/camera_controller.dart';

class PhotoPage extends StatelessWidget {
  PhotoPage({super.key});
  final controller = Get.find<CameraGetxController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: controller.cameraController.buildPreview(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.white,
        child: const Icon(
          Icons.photo_camera,
          color: AppColors.black,
        ),
        onPressed: () async {
          await controller.takePicture();
          Get.back();
          controller.startVideoRecording();
        },
      ),
    );
  }
}

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  final controller = Get.find<CameraGetxController>();
  bool secondPress = false;
  XFile? file;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: controller.cameraController.buildPreview(),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          secondPress ? Icons.radio_button_on : Icons.radio_button_off,
          color: AppColors.red,
          size: 55,
        ),
        backgroundColor: AppColors.white,
        onPressed: () async {
          secondPress
              ? {
                  file = await controller.stopVideoRecording(),
                  Get.find<AddMediaController>().addVideo(file!),
                  Get.back(),
                  controller.startVideoRecording(),
                }
              : controller.startVideoRecording().then((value) => setState(() {
                    secondPress = true;
                  }));
        },
      ),
    );
  }
}
