//import 'package:camera/camera.dart';
import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/data/models/project_model.dart';
import 'package:qualnote/app/data/services/local_db.dart';
import 'package:qualnote/app/modules/map/controllers/map_controller.dart';

class AddMediaController extends GetxController {
  MapGetxController mapGetxController = Get.find<MapGetxController>();
  HiveDb localDB = Get.find<HiveDb>();
  //late List<CameraDescription> cameras;

  Future<void> addPhoto(XFile? image) async {
    // var image = await ImagePicker().pickImage(source: ImageSource.camera);
    var location = await mapGetxController.getCurrentLocation();

    // if (image != null) {
    log(image!.path);
    var note = CameraMedia(
      coordinate: location,
      path: image.path,
      title: 'Photo Note',
      description: '',
    );
    //localDB.savePhotoNote(note);
    mapGetxController.photoNotes.add(note);
    //}
    mapGetxController.triggerRebuild();
  }

  Future<void> addVideo(XFile? video) async {
    // var video = await ImagePicker().pickVideo(source: ImageSource.camera);
    var location = await mapGetxController.getCurrentLocation();

    if (video != null) {
      log(video.path);
      var note = CameraMedia(
        coordinate: location,
        path: video.path,
        title: 'Video Note',
        description: '',
      );
      mapGetxController.videoNotes.add(note);
    }
    mapGetxController.triggerRebuild();
  }

  Future<void> addAudio({required AudioMedia audio}) async {
    var location = await mapGetxController.getCurrentLocation();
    var note = AudioMedia(
      title: 'Audio Note ${TimeOfDay.now()}',
      description: audio.description,
      coordinate: location,
      path: audio.path,
      author: FirebaseAuth.instance.currentUser!.displayName!,
      hasConsent: true,
      duration: audio.duration,
    );
    mapGetxController.audioNotes.add(note);
    mapGetxController.triggerRebuild();
  }

  void updateAudioDetails(String title, String description, int duration) {
    mapGetxController.audioNotes
        .firstWhere((note) => note.title == title)
        .description = description;
    mapGetxController.audioNotes
        .firstWhere((note) => note.title == title)
        .duration = duration;
  }
}
