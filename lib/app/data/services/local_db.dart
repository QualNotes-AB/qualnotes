import 'dart:developer';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:qualnote/app/data/models/project_model.dart';
import 'package:qualnote/app/modules/home/controllers/home_controller.dart';

class HiveDb extends GetxController {
  late Box box;
  int index = 0;

  Future<void> saveProject(Project project) async {
    final homeController = Get.find<HomeController>();
    await box.put(project.title, project.toJson());
    log(project.photos!.length.toString());
    homeController.projects.add(project);
    // homeController.projects.last.photos = project.photos;
    print(project.toJson());
    log('Route Saved');
  }

  Future<Project?> getProject(String title) async {
    var project = box.get(title);
    if (project == null) {
      return null;
    }
    return Project.fromJson(project);
  }

  Future<void> init() async {
    box = await Hive.openBox('box');
  }

  @override
  void dispose() async {
    await box.close();
    super.dispose();
  }
}
