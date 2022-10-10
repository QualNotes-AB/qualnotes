import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/config/text_styles.dart';
import 'package:qualnote/app/modules/audio_recording/controllers/audio_recording_controller.dart';
import 'package:qualnote/app/modules/camera/controller/camera_controller.dart';
import 'package:qualnote/app/modules/camera/view/video_player.dart';
import 'package:qualnote/app/modules/map/views/widgets/blue_text_button.dart';
import 'package:qualnote/app/modules/map/views/widgets/custom_checkbox_tile.dart';
import 'package:qualnote/app/routes/app_pages.dart';

class VideoBottomSheet extends StatelessWidget {
  final String path;
  VideoBottomSheet({super.key, required this.path});
  final AudioRecordingController audioRecordingController =
      Get.find<AudioRecordingController>();
  final CameraGetxController cameraGetxController =
      Get.find<CameraGetxController>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 5),
          decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 5,
                width: 120,
                color: AppColors.grey,
              ),
              Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: BlueTextButton(
                            title: 'PLAY VIDEO',
                            onPressed: () =>
                                Get.to(VideoPlayerWidget(path: path)),
                          ),
                        ),
                        BlueTextButton(title: 'RETAKE VIDEO', onPressed: () {}),
                      ],
                    ),
                    const Text(
                      'Consent:',
                      style: AppTextStyle.regular14GreyHeight,
                    ),
                    Obx(
                      () => CustomCheckboxTile(
                        title: 'I have it already',
                        onCheckbox: (value) => cameraGetxController
                            .consentInRecording.value = value!,
                        onPressed: () =>
                            cameraGetxController.toggleConsentInRecording(),
                        value: cameraGetxController.consentInRecording.value,
                      ),
                    ),
                    Obx(
                      () => CustomCheckboxTile(
                        title: 'I have it here',
                        onCheckbox: (value) =>
                            cameraGetxController.consentRecorded.value = value!,
                        onPressed: () =>
                            cameraGetxController.toggleConsentRecorded(),
                        value: cameraGetxController.consentRecorded.value,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: BlueTextButton(
                                title: 'SAVE',
                                onPressed: () async {
                                  // cameraGetxController
                                  //     .updateVideoRecording(path);
                                  Get.back();
                                  await SystemChrome.setEnabledSystemUIMode(
                                      SystemUiMode.immersiveSticky);
                                }),
                          ),
                          BlueTextButton(
                            title: 'RECORD ORAL CONSENT',
                            onPressed: () {
                              audioRecordingController.isConsent = true;
                              Get.toNamed(Routes.AUDIO_RECORDING);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
