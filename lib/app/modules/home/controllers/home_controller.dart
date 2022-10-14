import 'dart:async';

import 'package:get/get.dart';
import 'package:qualnote/app/data/models/note.dart';
import 'package:qualnote/app/data/models/project.dart';
import 'package:qualnote/app/data/services/firestore_db.dart';
import 'package:qualnote/app/data/services/local_db.dart';
import 'package:qualnote/app/utils/note_type.dart';

class HomeController extends GetxController {
  late StreamSubscription streamSubscription;
  late StreamSubscription cloudStreamSubscription;
  RxList<Project> localProjects = <Project>[].obs;
  RxList<Project> cloudProjects = <Project>[].obs;

  List<Note> getAllAudioRecordings() {
    List<Note> audioNotes = [];
    localProjects.map(
      (project) => audioNotes.addAll(
        project.notes!.where((note) => note.type == NoteType.audio.toString()),
      ),
    );
    return audioNotes;
  }

  init() async {
    //initial data fetch
    localProjects.value = Get.find<HiveDb>().getAllProjects();
    cloudProjects.value = await Get.find<FirebaseDatabase>().getProjects();

    //on any changes update home controller lists
    streamSubscription = Get.find<HiveDb>().projectsBox.watch().listen((event) {
      if (event.deleted) {
        localProjects.removeWhere((element) => event.value.id! == element.id!);
      } else {
        localProjects.add(event.value);
      }
    });

    cloudStreamSubscription = Get.find<FirebaseDatabase>()
        .projectsStream
        .asBroadcastStream()
        .listen((query) {
      cloudProjects.clear();
      cloudProjects.addAll(query.docs
          .map((snapshot) => Project.fromJson(snapshot.data(), snapshot.id))
          .toList());
    });
  }

  @override
  void onInit() {
    init();
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
