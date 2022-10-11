import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/data/models/project.dart';
import 'package:qualnote/app/data/services/cloud_storage.dart';

class FirebaseDatabase extends GetxController {
  final CloudStorage _storage = CloudStorage();
  final _db = FirebaseFirestore.instance;

  Future<void> deleteProject(Project project) async {
    await _db.collection('projects').doc(project.id).delete();
    //delete all notes to cloud storage
    for (var element in project.notes!) {
      await _storage.deleteProjectFile(
        projectId: project.id!,
        fileName: element.title!,
        fileType: element.type!,
      );
    }
    //delete main route recordings
    if (project.type! == 'RecordingType.video') {
      int i = 0;
      for (var path in project.routeVideos!) {
        i++;
        await _storage.deleteProjectFile(
          projectId: project.id!,
          fileName: 'VideoRecording$i',
          fileType: project.type!,
        );
      }
    }
    if (project.type! == 'RecordingType.audio') {
      int i = 0;
      for (var path in project.routeVideos!) {
        i++;
        await _storage.deleteProjectFile(
          projectId: project.id!,
          fileName: 'AudioRecording$i',
          fileType: project.type!,
        );
      }
    }

    log('Project deleted from cloud!');
  }

  Future<void> saveProjectToCloud(Project project) async {
    //uploads all notes to cloud storage
    for (var element in project.notes!) {
      await _storage.uploadFile(
        path: element.path!,
        projectId: project.id!,
        fileName: element.title!,
        fileType: element.type!,
      );
    }
    //upload main route recordings
    if (project.type! == 'RecordingType.video') {
      int i = 0;
      for (var path in project.routeVideos!) {
        i++;
        await _storage.uploadFile(
          path: path,
          projectId: project.id!,
          fileName: 'VideoRecording$i',
          fileType: project.type!,
        );
      }
    }
    if (project.type! == 'RecordingType.audio') {
      int i = 0;
      for (var path in project.routeVideos!) {
        i++;
        await _storage.uploadFile(
          path: path,
          projectId: project.id!,
          fileName: 'AudioRecording$i',
          fileType: project.type!,
        );
      }
    }
    await _db.collection('projects').doc(project.id!).set(project.toJson());
    Get.snackbar(
      'Success',
      'Project uploaded! Hooray!',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    log('Project uploaded! Hooray!');
  }

  ///Fetches all projects that the current user has created
  Future<List<Project>> getProjects() async {
    return await _db
        .collection('projects')
        .where('author',
            isEqualTo: FirebaseAuth.instance.currentUser!.displayName!)
        .get()
        .then(
          (value) => value.docs.map((e) => Project.fromJson(e.data())).toList(),
        );
  }
}
