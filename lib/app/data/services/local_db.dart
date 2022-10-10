import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:qualnote/app/data/models/project_model.dart';
import 'package:qualnote/app/modules/home/controllers/home_controller.dart';

class HiveDb extends GetxController {
  late Box box;
  late Box<String> keys;

  int index = 0;

  Future<void> saveProject(Project project) async {
    final homeController = Get.find<HomeController>();
    await box.put(project.id, project.toJson());
    await keys.add(project.id!);
    homeController.projects.add(project);
    if (kDebugMode) {
      print(project.toJson());
    }
    log('Route Saved');
  }

  Future<Project?> getProject(String id) async {
    var project = box.get(id);
    if (project == null) {
      return null;
    }
    return Project.fromJson(project);
  }

  List<Project> getAllProjects() {
    List<String> ids = keys.values.toList();
    return ids.map((id) => Project.fromJson(box.get(id))).toList();
  }

  Future<void> init() async {
    box = await Hive.openBox('box');
    keys = await Hive.openBox('keys');
  }

  @override
  void dispose() async {
    await box.close();
    await keys.close();
    super.dispose();
  }
}
