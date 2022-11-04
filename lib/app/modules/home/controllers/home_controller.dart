import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/data/models/note.dart';
import 'package:qualnote/app/data/models/project.dart';
import 'package:qualnote/app/data/services/cloud_storage.dart';
import 'package:qualnote/app/data/services/firestore_db.dart';
import 'package:qualnote/app/data/services/local_db.dart';
import 'package:qualnote/app/utils/note_type.dart';

class HomeController extends GetxController {
  late StreamSubscription streamSubscription;
  late StreamSubscription cloudStreamSubscription;
  RxList<Project> localProjects = <Project>[].obs;
  RxBool isPublicCatalogue = false.obs;

  ///used to switch between my projects and public or shared projects
  void togglePublicCatalogue(bool value) => isPublicCatalogue.value = value;

  List<Note> getAllAudioRecordings() {
    List<Note> audioNotes = [];
    localProjects.map(
      (project) => audioNotes.addAll(
        project.notes!.where((note) => note.type == NoteType.audio.toString()),
      ),
    );
    return audioNotes;
  }

  init() {
    //initial data fetch
    localProjects.value = Get.find<HiveDb>().getAllProjects();

    //on any changes update home controller lists
    streamSubscription = Get.find<HiveDb>().projectsBox.watch().listen((event) {
      localProjects.clear();
      localProjects.value = Get.find<HiveDb>().getAllProjects();
    });

    //keep local database up to date
    cloudStreamSubscription = Get.find<FirebaseDatabase>()
        .projectsStream
        .asBroadcastStream()
        .listen((query) async {
      if (kDebugMode) {
        print(query.docChanges.length);
      }
      for (var change in query.docChanges) {
        log(change.doc.id);

        // if the project isn't deleted
        if (change.doc.exists) {
          Project project = Project.fromJson(change.doc.data()!, change.doc.id);
          Project? localProject =
              await Get.find<HiveDb>().getProject(change.doc.id);
          //if the project isn't local don't update it
          if (localProject == null) continue;

          //for each note check if it's downloaded
          for (var note in project.notes!) {
            if (note.type == NoteType.text.toString()) continue;
            var result = localProject.notes!.firstWhereOrNull((localNote) {
              //if the note is already downloaded update the path
              if (localNote.title == note.title) {
                note.path = localNote.path!;
                return true;
              }
              return false;
            });
            if (result == null) {
              //if it's not then download and save the path
              String path = await CloudStorage().downloadFile(
                projectId: project.id!,
                fileName: note.title!,
                fileType: note.type!,
              );
              note.path = path;
            }
          }
          project.isUploaded = true;
          await Get.find<HiveDb>().saveOrUpdateProject(project);
        }
        //if the project was deleted then remove localy as well
        else {
          await Get.find<HiveDb>().deleteProjectLocaly(change.doc.id);
        }
      }
    });
  }

  @override
  void onInit() {
    if (!kIsWeb) {
      init();
    }

    //Get.find<HiveDb>().projectsBox.clear();
    super.onInit();
  }

  @override
  void dispose() {
    cloudStreamSubscription.cancel();
    streamSubscription.cancel();
    super.dispose();
  }
}
