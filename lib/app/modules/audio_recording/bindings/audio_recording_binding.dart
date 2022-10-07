import 'package:get/get.dart';

import '../controllers/audio_recording_controller.dart';

class AudioRecordingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AudioRecordingController>(
      () => AudioRecordingController(),
    );
  }
}
