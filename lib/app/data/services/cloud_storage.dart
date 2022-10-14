import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qualnote/app/modules/home/controllers/progress_controller.dart';
import 'package:qualnote/app/modules/map/controllers/map_controller.dart';
import 'package:qualnote/app/utils/note_type.dart';

class CloudStorage {
  final _storage = FirebaseStorage.instance;

  Future<String> downloadFile({
    required String projectId,
    required String fileName,
    required String fileType,
  }) async {
    String storagePath = getStoragePath(
        fileType: fileType, projectId: projectId, fileName: fileName);

    log(storagePath);
    final storageRef = _storage.ref(storagePath);
    final appDocDir = await getApplicationDocumentsDirectory();
    String filePath;
    if (fileType == NoteType.photo.toString()) {
      filePath = "${appDocDir.path}/$fileName.jpg";
    } else {
      filePath = "${appDocDir.path}/$fileName.mp4";
    }
    log(filePath);
    final file = File(filePath);
    try {
      final downloadTask = storageRef.writeToFile(file);

      downloadTask.snapshotEvents.listen((event) {
        log(event.state.toString());

        Get.find<ProgressController>().showProgress(
            'Downloading files', event.bytesTransferred / event.totalBytes);
      });
    } catch (e) {
      log(e.toString());
    }
    return file.path;
  }

  Future<void> deleteFile({
    required String projectId,
    required String fileName,
    required String fileType,
  }) async {
    String storagePath = getStoragePath(
        fileType: fileType, projectId: projectId, fileName: fileName);

    Get.find<ProgressController>().showProgress('Deleting project', 0);
    await _storage.ref(storagePath).delete();
    Get.find<ProgressController>().showProgress('Deleting project', 1);
  }

  Future<void> uploadFile({
    required String path,
    required String projectId,
    required String fileName,
    required String fileType,
    required int numberOfFiles,
    required int filePosition,
  }) async {
    File file = File(path);

    String storagePath = getStoragePath(
        fileType: fileType, projectId: projectId, fileName: fileName);

    try {
      var uploadTask =
          _storage.ref(storagePath).putData(file.readAsBytesSync());

      uploadTask.snapshotEvents.listen(
        (event) {
          log(event.state.toString());
          Get.find<ProgressController>().showProgress(
              'Uploading file $filePosition/$numberOfFiles',
              event.bytesTransferred / event.totalBytes);
          if (numberOfFiles == filePosition &&
              event.state == TaskState.success) {
            Get.snackbar(
              'Hooray!',
              'File uploaded',
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
          }
        },
      );
    } on FirebaseException catch (e) {
      log(e.toString());
    }
  }

  String getStoragePath(
      {required String fileType,
      required String projectId,
      required String fileName}) {
    if (fileType == RecordingType.audio.toString() ||
        fileType == RecordingType.video.toString()) {
      //if it's a recording of the route then save here
      return 'projects/$projectId/routeRecording/$fileName.mp4';
    } else if (fileType == NoteType.audio.toString()) {
      return 'projects/$projectId/audio/$fileName.mp4';
    } else if (fileType == NoteType.video.toString()) {
      return 'projects/$projectId/video/$fileName.mp4';
    } else if (fileType == NoteType.photo.toString()) {
      return 'projects/$projectId/photo/$fileName.jpg';
    }
    return 'projects/$projectId/$fileType/$fileName';
  }
}
