import 'package:get/get.dart';
import 'package:qualnote/app/modules/camera/controller/camera_controller.dart';
import 'package:qualnote/app/modules/map/controllers/map_controller.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<MapGetxController>(
      () => MapGetxController(),
    );

    Get.lazyPut<CameraGetxController>(
      () => CameraGetxController(),
      fenix: true,
    );
  }
}
