import 'package:get/get.dart';

import '../controllers/reflection_controller.dart';

class ReflectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReflectionController>(
      () => ReflectionController(),
    );
  }
}
