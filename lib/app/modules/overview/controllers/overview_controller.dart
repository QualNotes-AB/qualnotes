import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/data/models/project.dart';
import 'package:qualnote/app/data/services/firestore_db.dart';
import 'package:qualnote/app/data/services/local_db.dart';

class OverviewController extends GetxController {
  bool isLocal = false;
  Rx<Project> project = Project().obs;
  RxBool loaded = false.obs;
  late TextEditingController textEditingController;
  RxString link = ''.obs;
  createShareLink() {
    String domain = 'https://qualnotesdev.web.app/#';
    link.value = '$domain/map?id=${project.value.id!}';
  }

  getProjectFromUrl() async {
    var data = Get.parameters;
    String? id = data["id"];
    int? local = int.parse(data["local"] ?? '0');

    local == 0 ? isLocal = false : isLocal = true;
    if (id == null) return;
    Project? result;
    if (kIsWeb) {
      result = await Get.find<FirebaseDatabase>().getProjectForWeb(id);
    } else {
      result = (await Get.find<HiveDb>().getProject(id));
    }
    if (kDebugMode) {
      print(result);
    }

    if (result == null) {
      loaded.value = false;
    } else {
      project.value = result;
      loaded.value = true;
      textEditingController = TextEditingController(
          text: project.value.description ?? 'Project description');
    }
  }

  selectProject({required Project newProject, bool? local}) {
    project.value = newProject;
    isLocal = local ?? isLocal;
    loaded.value = true;
    textEditingController = TextEditingController(
        text: project.value.description ?? 'Project description');
  }

  @override
  void onInit() {
    getProjectFromUrl();

    super.onInit();
  }

  @override
  void onClose() {
    textEditingController.dispose();
    super.onClose();
  }
}
