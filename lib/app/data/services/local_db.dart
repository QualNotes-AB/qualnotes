import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:latlong2/latlong.dart';
import 'package:qualnote/app/data/models/project.dart';
import 'package:qualnote/app/modules/home/controllers/home_controller.dart';
import 'package:qualnote/app/utils/note_type.dart';

class HiveDb extends GetxController {
  LatLng lastKnownLocation = LatLng(0, 0);
  late Box<Project> projectsBox;
  RxBool inProgress = false.obs;

  void saveLastKnownLocation(LatLng location) => lastKnownLocation = location;

  Future<void> deleteProjectLocaly(String projectId) async {
    var project = await getProject(projectId);
    Get.find<HomeController>().localProjects.remove(project);

    for (var element in project!.notes!) {
      if (element.type == NoteType.text.toString()) {
        continue;
      }

      try {
        await File(element.path!).delete();
      } on Exception catch (e) {
        log(e.toString());
      }
    }

    if (project.type! == 'RecordingType.video') {
      for (var path in project.routeVideos ?? []) {
        try {
          await File(path!).delete();
        } on Exception catch (e) {
          log(e.toString());
        }
      }
    }
    if (project.type! == 'RecordingType.audio') {
      for (var path in project.routeAudios ?? []) {
        try {
          await File(path!).delete();
        } on Exception catch (e) {
          log(e.toString());
        }
      }
    }
    projectsBox.delete(projectId);
    log('Project deleted from local storage');
  }

  Future<void> saveProject(Project project) async {
    inProgress.value = true;
    await projectsBox.put(project.id!, project);

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
