import 'package:get/get.dart';
import 'package:qualnote/app/modules/map/controllers/add_media_controller.dart';
import 'package:qualnote/app/modules/map/controllers/map_controller.dart';

import '../controllers/overview_controller.dart';

class OverviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OverviewController>(
      () => OverviewController(),
    );
    Get.lazyPut<AddMediaController>(
      () => AddMediaController(),
    );
    Get.lazyPut<MapGetxController>(
      () => MapGetxController(),
    );
  }
}
