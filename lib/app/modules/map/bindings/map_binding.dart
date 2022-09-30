import 'package:get/get.dart';

import 'package:qualnote/app/modules/map/controllers/add_media_controller.dart';
import 'package:qualnote/app/modules/map/controllers/camera_controller.dart';

import '../controllers/map_controller.dart';

class MapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CameraGetxController>(
      () => CameraGetxController(),
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
  }
}
