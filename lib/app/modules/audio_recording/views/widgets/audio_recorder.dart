import 'package:flutter/material.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/config/text_styles.dart';
import 'package:qualnote/app/modules/audio_recording/controllers/audio_recording_controller.dart';
import 'package:qualnote/app/modules/map/controllers/map_controller.dart';

const theSource = AudioSource.microphone;

class SimpleRecorder extends StatefulWidget {
  final String? path;
  const SimpleRecorder({super.key, this.path});

  @override
  _SimpleRecorderState createState() => _SimpleRecorderState();
}

class _SimpleRecorderState extends State<SimpleRecorder> {
  @override
  void initState() {
    audioGetxController
        .openTheRecorder()
        .then((value) => audioGetxController.mRecorderIsInited = true);
    super.initState();
  }

  @override
  void dispose() {
    audioGetxController.mRecorder!.closeRecorder();
    audioGetxController.mRecorder = null;
    super.dispose();
  }

  final audioGetxController = Get.find<AudioRecordingController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => audioGetxController.startRecorder(),
      onLongPressUp: () => audioGetxController.stopRecorder(),
      child: Obx(
        () => Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              width: 3,
              color: audioGetxController.isRecording.value
                  ? AppColors.red
                  : AppColors.white,
            ),
          ),
          child: Center(
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.red,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AudioMapping extends StatefulWidget {
  final String? path;
  const AudioMapping({super.key, this.path});

  @override
  _AudioMappingState createState() => _AudioMappingState();
}

class _AudioMappingState extends State<AudioMapping> {
  @override
  void initState() {
    audioGetxController
        .openTheRecorder()
        .then((value) => audioGetxController.mRecorderIsInited = true);
    super.initState();
  }

  @override
  void dispose() {
    if (audioGetxController.mRecorder != null) {
      audioGetxController.mRecorder!.closeRecorder();
    }
//    audioGetxController.mRecorder = null;
    super.dispose();
  }

  final audioGetxController = Get.find<AudioRecordingController>();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Obx(() {
        return Get.find<MapGetxController>().type.value == RecordingType.audio
            ? Container(
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
                          seconds: audioGetxController.mainDuration.value)),
                      style: AppTextStyle.regular13White,
                    ),
                  ],
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
