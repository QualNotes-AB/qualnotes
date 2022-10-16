import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qualnote/app/data/models/coordinate.dart';
import 'package:qualnote/app/data/models/note.dart';
import 'package:qualnote/app/data/services/local_db.dart';
import 'package:qualnote/app/modules/audio_recording/controllers/audio_recording_controller.dart';
import 'package:qualnote/app/modules/audio_recording/views/audio_recording_view.dart';
import 'package:qualnote/app/modules/camera/controller/camera_controller.dart';
import 'package:qualnote/app/modules/camera/view/camera_record_page.dart';
import 'package:qualnote/app/modules/map/controllers/map_controller.dart';
import 'package:qualnote/app/utils/note_type.dart';

final dateFormat = DateFormat('yyMMddhhmmss');

class AddMediaController extends GetxController {
  MapGetxController mapGetxController = Get.find<MapGetxController>();
  HiveDb localDB = Get.find<HiveDb>();
  // Function() onAddMediaContinue = () {};
  List<String> consentsPaths = [];

  Future<void> addNote({required Note newNote}) async {
    var location = await mapGetxController.getCurrentLocation();
    var note = Note(
      title: newNote.title ?? 'Note${dateFormat.format(DateTime.now())}',
      description: newNote.description,
      coordinate: Coordinate.fromLatLng(location),
      path: newNote.path!,
      author: FirebaseAuth.instance.currentUser!.displayName!,
      duration: newNote.duration,
      type: newNote.type!,
    );
    mapGetxController.notes.add(note);
    mapGetxController.triggerRebuild();
  }

  void addPhotoNote() async {
    log('Continue photo');
    if (mapGetxController.type.value == RecordingType.video) {
      await Get.find<CameraGetxController>().stopVideoRecording();
    }
    Get.to(() => CameraRecordPage(
          isPhoto: true,
          onDone: (path) => addNote(
            newNote: Note(
              path: path,
              type: NoteType.photo.toString(),
            ),
          ),
        ));
  }

  void addVideoNote() async {
    log('Continue video');
    if (mapGetxController.type.value == RecordingType.video) {
      await Get.find<CameraGetxController>().stopVideoRecording();
    }
    Get.to(() => CameraRecordPage(
          onDone: (path) => addNote(
            newNote: Note(
              path: path,
              type: NoteType.video.toString(),
            ),
          ),
        ));
  }

  void addAudioNote() async {
    log('Continue audio');
    if (mapGetxController.type.value == RecordingType.audio) {
      await Get.find<AudioRecordingController>().stopRecorder(isFinish: true);
    }
    Get.to(() => AudioRecordingView());
  }

  Future<void> addTextNote(String text) async {
    var location = await mapGetxController.getCurrentLocation();
    var note = Note(
      title: 'TextNote${dateFormat.format(DateTime.now())}',
      description: text,
      coordinate: Coordinate.fromLatLng(location),
      author: FirebaseAuth.instance.currentUser!.displayName!,
      type: NoteType.text.toString(),
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

  Future<void> savePhotoConsent(Uint8List? data) async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final filePath =
        "${appDocDir.path}/consents/Coonsent${dateFormat.format(DateTime.now())}.png";
    log(filePath);
    await File.fromRawPath(data!).rename(filePath);
    consentsPaths.add(filePath);
  }

  void saveAudioConsent(String path) => consentsPaths.add(path);

  void addFileNote() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'mp4', 'jpeg', 'jpg', 'png', 'docx']);
    if (result == null) return;

    File file = await saveFileToAppStorage(result.files.first);
    FilePicker.platform.clearTemporaryFiles();
    var location = await mapGetxController.getCurrentLocation();
    var note = Note(
      title: '${result.files.first.name}-${dateFormat.format(DateTime.now())}',
      description: '',
      coordinate: Coordinate.fromLatLng(location),
      author: FirebaseAuth.instance.currentUser!.displayName!,
      type: await checkNoteType(result.files.first.extension!),
      path: file.path,
    );
    mapGetxController.notes.add(note);
    mapGetxController.triggerRebuild();
  }

  Future<File> saveFileToAppStorage(PlatformFile file) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final newFile = File('${appStorage.path}/${file.name}');
    return await File(file.path!).copy(newFile.path);
  }

  Future<String> checkNoteType(String fileExtension) async {
    log(fileExtension);
    if (fileExtension == 'jpeg' ||
        fileExtension == 'jpg' ||
        fileExtension == 'png') {
      return NoteType.photo.toString();
    }
    if (fileExtension == 'MP4' || fileExtension == 'mp4') {
      return NoteType.video.toString();
    }
    return NoteType.document.toString();
  }
}
