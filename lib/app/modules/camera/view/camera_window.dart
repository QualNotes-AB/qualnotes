import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/config/text_styles.dart';
import 'package:qualnote/app/modules/camera/controller/camera_controller.dart';
import 'package:qualnote/app/modules/map/controllers/map_controller.dart';

class CameraWindow extends StatelessWidget {
  const CameraWindow({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final MapGetxController controller;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Obx(() {
        final cameraGetx = Get.find<CameraGetxController>();
        return controller.type.value == RecordingType.video
            ? GestureDetector(
                onTap: () => cameraGetx.toggleMinizedCamera(),
                child: cameraGetx.minimizedCamera.value
                    ? Obx(() {
                        return Container(
                          margin: const EdgeInsets.only(left: 10, bottom: 80),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: AppColors.black,
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.circle,
                                color: AppColors.red,
                              ),
                              Text(
                                formatDuration(Duration(
                                    seconds:
                                        cameraGetx.durationInSeconds.value)),
                                style: AppTextStyle.regular13White,
                              ),
                            ],
                          ),
                        );
                      })
                    : Padding(
                        padding: const EdgeInsets.only(left: 10, bottom: 80),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Obx(() {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: AppColors.black,
                                ),
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.circle,
                                      color: AppColors.red,
                                    ),
                                    Text(
                                      formatDuration(Duration(
                                          seconds: cameraGetx
                                              .durationInSeconds.value)),
                                      style: AppTextStyle.regular13White,
                                    ),
                                  ],
                                ),
                              );
                            }),
                            SizedBox(
                              width: 130,
                              height: 200,
                              child: cameraGetx.cameraController.buildPreview(),
                            ),
                          ],
                        ),
                      ),
              )
            : const SizedBox();
      }),
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
