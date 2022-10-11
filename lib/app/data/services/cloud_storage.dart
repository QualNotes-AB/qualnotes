import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class CloudStorage {
  final _storage = FirebaseStorage.instance;

  Future<void> deleteProjectFile({
    required String projectId,
    required String fileName,
    required String fileType,
  }) async {
    late String storagePath;
    if (fileType == 'RecordingType.audio' ||
        fileType == 'RecordingType.video') {
      //if it's a recording of the route then save here
      storagePath = 'projects/$projectId/routeRecording/$fileName';
    } else {
      //type posibilities //video,audio,photo,other//
      //gets rid of NoteType. prefix
      fileType = fileType.substring(9, 14);
      storagePath = 'projects/$projectId/$fileType/$fileName';
    }
    await _storage.ref(storagePath).delete();
  }

  Future<void> uploadFile({
    required String path,
    required String projectId,
    required String fileName,
    required String fileType,
  }) async {
    File file = File(path);

    late String storagePath;
    if (fileType == 'RecordingType.audio' ||
        fileType == 'RecordingType.video') {
      //if it's a recording of the route then save here
      storagePath = 'projects/$projectId/routeRecording/$fileName';
    } else {
      //type posibilities //video,audio,photo,other//
      //gets rid of NoteType. prefix
      fileType = fileType.substring(9, 14);
      storagePath = 'projects/$projectId/$fileType/$fileName';
    }

    try {
      var uploadTask = _storage.ref(storagePath).putFile(file);
      // Get.showSnackbar(
      //   GetSnackBar(
      //     isDismissible: false,
      //     title: 'Uploading...',
      //     messageText: StreamBuilder(
      //       stream: uploadTask.snapshotEvents,
      //       builder: (context, snapshot) {
      //         final data = snapshot.data!;
      //         double progress = data.bytesTransferred / data.totalBytes;
      //         return LinearProgressIndicator(value: progress);
      //       },
      //     ),
      //   ),
      // );
      log('Done');
    } on FirebaseException catch (e) {
      log(e.toString());
    }
  }
}
