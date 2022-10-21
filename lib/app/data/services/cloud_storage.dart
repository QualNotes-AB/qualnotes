import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
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
    String storagePath = await getStoragePath(
        fileType: fileType, projectId: projectId, fileName: fileName);

    log(storagePath);
    final storageRef = _storage.ref(storagePath);

    String filePath = await getAppDirectoryPath(
        fileType: fileType, projectId: projectId, fileName: fileName);

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
    String storagePath = await getStoragePath(
        fileType: fileType, projectId: projectId, fileName: fileName);

    Get.find<ProgressController>().showProgress('Deleting file', 0);
    try {
      await _storage.ref(storagePath).delete();
    } on Exception catch (e) {
      log(storagePath);
      log(e.toString());
    }
    Get.find<ProgressController>().showProgress('Deleting file', 1);
  }

  Future<void> downloadFileFromWeb({required String storagePath}) async {
    await _storage.ref().child(storagePath).getData();
  }

  Future<String> uploadFile({
    required String path,
    required String projectId,
    required String fileName,
    required String fileType,
    required int numberOfFiles,
    required int filePosition,
  }) async {
    File file = File(path);

    String storagePath = await getStoragePath(
        fileType: fileType, projectId: projectId, fileName: fileName);

    try {
      var uploadTask = _storage.ref(storagePath).putFile(file);
      //  _storage.ref(storagePath).putData(file.readAsBytesSync());

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
      return storagePath;
    } on FirebaseException catch (e) {
      log(e.toString());
      return '';
    }
  }

  Future<String> uploadFileWeb({
    required String projectId,
    required String fileName,
    required String fileType,
    required Uint8List data,
    required String fileExtension,
  }) async {
    final path = await getStoragePath(
        fileType: fileType, projectId: projectId, fileName: fileName);

    _storage
        .ref(path)
        .putData(data, SettableMetadata(contentType: fileExtension))
        .asStream()
        .listen((event) {
      log(event.state.toString());
      Get.find<ProgressController>().showProgress(
          'Uploading file ', event.bytesTransferred / event.totalBytes);
      if (event.state == TaskState.success) {
        Get.snackbar(
          'Hooray!',
          'File uploaded',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    });

    return await _storage.ref(path).getDownloadURL();
  }

  Future<String> getStoragePath(
      {required String fileType,
      required String projectId,
      required String fileName,
      bool downloadUrl = false}) async {
    late String path;
    if (fileType == RecordingType.video.toString()) {
      path = 'projects/$projectId/routeRecording/$fileName.mp4';
    } else if (fileType == RecordingType.audio.toString()) {
      path = 'projects/$projectId/routeRecording/$fileName.mp4';
    } else if (fileType == NoteType.audio.toString()) {
      path = 'projects/$projectId/audio/$fileName.mp4';
    } else if (fileType == NoteType.video.toString()) {
      path = 'projects/$projectId/video/$fileName.mp4';
    } else if (fileType == NoteType.photo.toString()) {
      path = 'projects/$projectId/photo/$fileName.jpg';
    } else {
      path = 'projects/$projectId/$fileType/$fileName.pdf';
    }
    final ref = _storage.ref();
    if (downloadUrl) {
      log(path);
      try {
        final url = await ref.child(path).getDownloadURL();
        log(url);
        return url;
      } on Exception catch (e) {
        log(e.toString());
      }
    }
    return path;
  }

  Future<String> getAppDirectoryPath(
      {required String fileType,
      required String projectId,
      required String fileName,
      bool downloadUrl = false}) async {
    final appDocDir = await getApplicationDocumentsDirectory();
    late String path;
    if (fileType == NoteType.photo.toString()) {
      path = "${appDocDir.path}/$fileName.jpg";
    } else if (fileType == NoteType.audio.toString() ||
        fileType == RecordingType.audio.toString()) {
      path = "${appDocDir.path}/$fileName.mp4";
    } else if (fileType == NoteType.video.toString() ||
        fileType == RecordingType.video.toString()) {
      path = "${appDocDir.path}/$fileName.mp4";
    } else {
      path = "${appDocDir.path}/$fileName.pdf";
    }

    return path;
  }
}
