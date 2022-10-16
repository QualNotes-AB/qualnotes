import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/config/text_styles.dart';
import 'package:qualnote/app/modules/audio_recording/controllers/audio_recording_controller.dart';
import 'package:qualnote/app/modules/audio_recording/views/widgets/custom_audio_player.dart';
import 'package:qualnote/app/modules/map/views/widgets/blue_text_button.dart';
import 'package:qualnote/app/routes/app_pages.dart';
import 'package:qualnote/app/utils/datetime_helper.dart';
import 'package:qualnote/app/utils/distance_helper.dart';

class AudioDetailsCard extends StatelessWidget {
  final String? path;
  AudioDetailsCard({
    Key? key,
    required this.path,
  }) : super(key: key);
  final AudioRecordingController audioRecordingController =
      Get.find<AudioRecordingController>();

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
                    TextField(
                      minLines: 3,
                      maxLines: 5,
                      autocorrect: false,
                      style: AppTextStyle.regular14Grey,
                      onChanged: (value) {
                        audioRecordingController.description.value = value;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                          borderSide: const BorderSide(
                              color: Color(0xFF9E9E9E), width: 2),
                        ),
                        fillColor: const Color(0xFFF3F3F3),
                        filled: true,
                        hintText: 'Add a description to this audio...',
                      ),
                    ),
                    path == null
                        ? const Text('Audio not found')
                        : CustomAudioPlayer(
                            path: path!,
                            duration: audioRecordingController.duration.value,
                          ),
                    BlueTextButton(
                      title: 'RETAKE AUDIO',
                      onPressed: () {
                        audioRecordingController.isRetake = true;
                        Get.toNamed(Routes.AUDIO_RECORDING);
                      },
                    ),
                    Obx(
                      () => Text(
                        'DETAILS: ${audioRecordingController.description.value} \nlength: ${convertTime(audioRecordingController.duration.value)}\nGPS ${convertLocation(audioRecordingController.location)}\nby  ${FirebaseAuth.instance.currentUser!.displayName!}',
                        style: AppTextStyle.regular14GreyHeight,
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
                                  audioRecordingController.saveAudioDetails();
                                  await SystemChrome.setEnabledSystemUIMode(
                                      SystemUiMode.immersiveSticky);
                                }),
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
