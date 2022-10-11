import 'package:get/get.dart';
import 'package:qualnote/app/data/models/project.dart';
import 'package:qualnote/app/data/services/local_db.dart';

class HomeController extends GetxController {
  List<Project> projects = [];
  init() async {
    projects = Get.find<HiveDb>().getAllProjects();
  }

  @override
  void onInit() {
    init();
    super.onInit();
  }
}
