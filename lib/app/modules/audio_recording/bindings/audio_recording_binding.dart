import 'package:get/get.dart';
import 'package:qualnote/app/modules/map/controllers/add_media_controller.dart';

import '../controllers/audio_recording_controller.dart';

class AudioRecordingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AudioRecordingController>(
      () => AudioRecordingController(),
    );
    Get.lazyPut<AddMediaController>(
      () => AddMediaController(),
    );
  }
}
