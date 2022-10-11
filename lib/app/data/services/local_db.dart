import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:qualnote/app/data/models/project.dart';
import 'package:qualnote/app/modules/home/controllers/home_controller.dart';

class HiveDb extends GetxController {
  late Box<Project> projectsBox;

  Future<void> deleteProjectLocaly(String projectId) async {
    var project = await getProject(projectId);
    Get.find<HomeController>().projects.remove(project);
    //uploads all notes to cloud storage
    for (var element in project!.notes!) {
      await File(element.path!).delete();
    }
    //upload main route recordings
    if (project.type! == 'RecordingType.video') {
      for (var path in project.routeVideos!) {
        await File(path).delete();
      }
    }
    if (project.type! == 'RecordingType.audio') {
      for (var path in project.routeVideos!) {
        await File(path).delete();
      }
    }
    projectsBox.delete(projectId);

    log('Project deleted from local storage');
  }

  Future<void> saveProject(Project project) async {
    final homeController = Get.find<HomeController>();
    await projectsBox.put(project.id, project);
    var newProject = await getProject(project.id!);
    homeController.projects.add(newProject!);
    if (kDebugMode) {
      print(project.toJson());
    }
    log('Route Saved');
  }

  Future<Project?> getProject(String id) async {
    var project = projectsBox.get(id);
    if (project == null) {
      return null;
    }
    return project;
  }

  List<Project> getAllProjects() => projectsBox.values.toList();

  Future<void> init() async => projectsBox = await Hive.openBox('box');

  @override
  void dispose() async {
    await projectsBox.close();
    super.dispose();
  }
}
