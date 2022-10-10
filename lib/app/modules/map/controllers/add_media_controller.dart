import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/data/models/project_model.dart';
import 'package:qualnote/app/data/services/local_db.dart';
import 'package:qualnote/app/modules/map/controllers/map_controller.dart';

class AddMediaController extends GetxController {
  MapGetxController mapGetxController = Get.find<MapGetxController>();
  HiveDb localDB = Get.find<HiveDb>();

  Future<void> addNote({required Note newNote}) async {
    var location = await mapGetxController.getCurrentLocation();
    var note = Note(
      title: 'Note${TimeOfDay.now()}',
      description: newNote.description,
      coordinate: location,
      path: newNote.path!,
      author: FirebaseAuth.instance.currentUser!.displayName!,
      hasConsent: true,
      duration: newNote.duration,
      type: newNote.type!,
    );
    mapGetxController.notes.add(note);
    mapGetxController.triggerRebuild();
  }

  void updateNote(String title, String description, int duration) {
    mapGetxController.notes
        .firstWhere((note) => note.title == title)
        .description = description;
    mapGetxController.notes.firstWhere((note) => note.title == title).duration =
        duration;
  }
}
