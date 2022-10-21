import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/data/models/note.dart';
import 'package:qualnote/app/data/models/project.dart';
import 'package:qualnote/app/data/services/cloud_storage.dart';
import 'package:qualnote/app/data/services/local_db.dart';
import 'package:qualnote/app/modules/home/controllers/progress_controller.dart';
import 'package:qualnote/app/modules/map/controllers/map_controller.dart';
import 'package:qualnote/app/utils/note_type.dart';

class FirebaseDatabase extends GetxController {
  final CloudStorage _storage = CloudStorage();
  final _db = FirebaseFirestore.instance;
  RxDouble uploadProgress = 0.0.obs;
  RxBool isUploading = false.obs;

  Stream<QuerySnapshot<Map<String, dynamic>>> get projectsStream => _db
      .collection('projects')
      .where('author',
          isEqualTo: FirebaseAuth.instance.currentUser!.displayName!)
      .snapshots();

  Stream<QuerySnapshot<Map<String, dynamic>>> get collabProjects => _db
      .collection('projects')
      .where('collaborators',
          arrayContains: FirebaseAuth.instance.currentUser!.email!)
      .snapshots();

  Future<Project?> getProjectForWeb(String projectId) async {
    Project project = Project();
    await _db.collection('projects').doc(projectId).get().then(
        (snapshot) => project = Project.fromJson(snapshot.data()!, projectId));

    for (int i = 0; i < project.notes!.length; i++) {
      var note = project.notes![i];
      if (note.type == NoteType.text.toString()) {
        continue;
      }
      var filePath = await _storage.getStoragePath(
        projectId: projectId,
        fileName: note.title!,
        fileType: note.type!,
        downloadUrl: true,
      );
      project.notes![i].path = filePath;
    }

    for (int i = 1; i <= project.consentsLength!; i++) {
      var filePath = await _storage.getStoragePath(
        projectId: projectId,
        fileName: 'Consent$i',
        fileType: 'consent',
        downloadUrl: true,
      );
      project.consents!.add(filePath);
    }

    if (project.type == RecordingType.video.toString()) {
      for (int i = 1; i <= project.routeVideosLength!; i++) {
        var filePath = await _storage.getStoragePath(
          projectId: projectId,
          fileName: 'VideoRecording$i',
          fileType: project.type!,
          downloadUrl: true,
        );
        project.routeVideos!.add(filePath);
      }
    }

    if (project.type == RecordingType.audio.toString()) {
      for (int i = 1; i <= project.routeAudiosLength!; i++) {
        var filePath = await _storage.getStoragePath(
          projectId: projectId,
          fileName: 'AudioRecording$i',
          fileType: project.type!,
          downloadUrl: true,
        );
        project.routeAudios!.add(filePath);
      }
    }
    Get.find<ProgressController>().showProgress('Downloading project...', 1);
    return project;
  }

  Future<void> getProject(String projectId) async {
    Get.find<ProgressController>().showProgress('Downloading project...', 0);
    try {
      Project project = Project();
      await _db.collection('projects').doc(projectId).get().then((snapshot) =>
          project = Project.fromJson(snapshot.data()!, projectId));

      for (int i = 0; i < project.notes!.length; i++) {
        var note = project.notes![i];
        if (note.type == NoteType.text.toString()) {
          continue;
        }
        var filePath = await _storage.downloadFile(
          projectId: projectId,
          fileName: note.title!,
          fileType: note.type!,
        );
        project.notes![i].path = filePath;
      }

      for (int i = 1; i <= project.consentsLength!; i++) {
        var filePath = await _storage.downloadFile(
          projectId: projectId,
          fileName: 'Consent$i',
          fileType: 'consent',
        );
        project.consents ??= [];
        project.consents!.add(filePath);
      }

      if (project.type == RecordingType.video.toString()) {
        for (int i = 1; i <= project.routeVideosLength!; i++) {
          var filePath = await _storage.downloadFile(
            projectId: projectId,
            fileName: 'VideoRecording$i',
            fileType: project.type!,
          );
          project.routeVideos ??= [];
          project.routeVideos!.add(filePath);
        }
      }

      if (project.type == RecordingType.audio.toString()) {
        for (int i = 1; i <= project.routeAudiosLength!; i++) {
          var filePath = await _storage.downloadFile(
            projectId: projectId,
            fileName: 'AudioRecording$i',
            fileType: project.type!,
          );
          project.routeAudios ??= [];
          project.routeAudios!.add(filePath);
        }
      }
      await Get.find<HiveDb>().saveProject(project);
    } on Exception catch (e) {
      log(e.toString());
    }
    Get.find<ProgressController>().showProgress('Downloading project...', 1);
  }

  Future<void> deleteProject(Project project) async {
    await _db.collection('projects').doc(project.id).delete();
    //delete all notes to cloud storage
    for (var element in project.notes!) {
      if (element.type == NoteType.text.toString()) {
        continue;
      }
      await _storage.deleteFile(
        projectId: project.id!,
        fileName: element.title!,
        fileType: element.type!,
      );
    }

    for (int i = 1; i <= project.consentsLength!; i++) {
      await _storage.deleteFile(
        projectId: project.id!,
        fileName: 'Consent$i',
        fileType: 'consent',
      );
    }

    //delete main route recordings
    if (project.type! == RecordingType.video.toString()) {
      for (var i = 1; i <= project.routeVideos!.length; i++) {
        await _storage.deleteFile(
          projectId: project.id!,
          fileName: 'VideoRecording$i',
          fileType: project.type!,
        );
      }
    }
    if (project.type! == RecordingType.audio.toString()) {
      for (var i = 1; i <= project.routeAudios!.length; i++) {
        await _storage.deleteFile(
          projectId: project.id!,
          fileName: 'AudioRecording$i',
          fileType: project.type!,
        );
      }
    }

    log('Project deleted from cloud!');
  }

  Future<void> uploadProject(Project project) async {
    Get.snackbar(
      'Preparing upload',
      'Try to maintain good connection.',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
    //uploads all notes to cloud storage

    for (int i = 0; i < project.notes!.length; i++) {
      var element = project.notes![i];
      if (element.type == NoteType.text.toString()) {
        continue;
      }
      await _storage.uploadFile(
        path: element.path!,
        projectId: project.id!,
        fileName: element.title!,
        fileType: element.type!,
        numberOfFiles: project.notes!.length,
        filePosition: i + 1,
      );
    }

    int i = 0;
    for (var path in project.consents ?? []) {
      i++;
      await _storage.uploadFile(
        path: path,
        projectId: project.id!,
        fileName: 'Consent$i',
        fileType: 'consent',
        numberOfFiles: project.consentsLength!,
        filePosition: i,
      );
    }

    //upload main route recordings
    if (project.type! == RecordingType.video.toString()) {
      int i = 0;
      for (var path in project.routeVideos!) {
        i++;
        await _storage.uploadFile(
          path: path,
          projectId: project.id!,
          fileName: 'VideoRecording$i',
          fileType: project.type!,
          numberOfFiles: project.routeVideosLength!,
          filePosition: i,
        );
      }
    }
    if (project.type! == RecordingType.audio.toString()) {
      int i = 0;
      for (var path in project.routeAudios!) {
        i++;
        await _storage.uploadFile(
          path: path,
          projectId: project.id!,
          fileName: 'AudioRecording$i',
          fileType: project.type!,
          numberOfFiles: project.routeAudiosLength!,
          filePosition: i,
        );
      }
    }
    await _db.collection('projects').doc(project.id!).set(project.toJson());

    log('Project uploaded! Hooray!');
  }

  Future<void> updateProject(Project project) async {
    await _db.collection('projects').doc(project.id!).update(project.toJson());
    Get.snackbar(
      'Hooray!',
      'Project updated',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  // Future<void> addNote(String id, Note note) async {
  //   try {
  //     await _db.collection('projects').doc(id).update({
  //       "notes": FieldValue.arrayUnion([note])
  //     });
  //   } on Exception catch (e) {
  //     log(e.toString());
  //   }
  // }

  Future<void> addCollaborator(String id, List<String> emails) async {
    await _db.collection('projects').doc(id).update({"collaborators": emails});
  }

  Future<void> updateReflectionNotes(String id, List<Note> reflections) async {
    await _db.collection('projects').doc(id).update(
        {"reflectionNotes": reflections.map((v) => v.toJson()).toList()});
  }

  ///Fetches all projects that the current user has created
  Future<List<Project>> getProjects() async {
    log(FirebaseAuth.instance.currentUser!.displayName!);
    return await _db
        .collection('projects')
        .where('author',
            isEqualTo: FirebaseAuth.instance.currentUser!.displayName!)
        .get()
        .then(
          (value) => value.docs.map((e) {
            log(e.id);
            return Project.fromJson(e.data(), e.id);
          }).toList(),
        );
  }
}
