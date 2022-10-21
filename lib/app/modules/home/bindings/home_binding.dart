import 'package:get/get.dart';
import 'package:qualnote/app/modules/map/controllers/map_controller.dart';
import 'package:qualnote/app/modules/overview/controllers/overview_controller.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
      fenix: true,
    );
    Get.lazyPut<OverviewController>(
      () => OverviewController(),
    );
    Get.lazyPut<MapGetxController>(
      () => MapGetxController(),
    );
  }
}
