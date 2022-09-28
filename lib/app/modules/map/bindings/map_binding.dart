import 'package:get/get.dart';

import '../controllers/map_controller.dart';

class MapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MapGetxController>(
      () => MapGetxController(),
    );
  }
}
