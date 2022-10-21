import 'package:get/get.dart';
import 'package:qualnote/app/modules/audio_recording/controllers/audio_recording_controller.dart';
import 'package:qualnote/app/modules/camera/controller/camera_controller.dart';
import 'package:qualnote/app/modules/map/controllers/add_media_controller.dart';
import 'package:qualnote/app/modules/overview/controllers/overview_controller.dart';

import '../controllers/map_controller.dart';

class MapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AudioRecordingController>(
      () => AudioRecordingController(),
      fenix: true,
    );
    Get.lazyPut<AddMediaController>(
      () => AddMediaController(),
      fenix: true,
    );
    Get.lazyPut<MapGetxController>(
      () => MapGetxController(),
      fenix: true,
    );
    Get.put(OverviewController());
    Get.lazyPut<CameraGetxController>(
      () => CameraGetxController(),
      fenix: true,
    );
  }
}
