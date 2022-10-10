import 'package:get/get.dart';
import 'package:qualnote/app/data/models/project_model.dart';

class HomeController extends GetxController {
  List<Project> projects = [];

  init() async {
    // projects.addAll(Get.find<HiveDb>().getAllProjects());
  }

  @override
  void onInit() {
    init();
    super.onInit();
  }
}
