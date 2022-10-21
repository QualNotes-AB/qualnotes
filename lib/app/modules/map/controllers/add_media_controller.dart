import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qualnote/app/data/models/coordinate.dart';
import 'package:qualnote/app/data/models/note.dart';
import 'package:qualnote/app/data/services/cloud_storage.dart';
import 'package:qualnote/app/data/services/local_db.dart';
import 'package:qualnote/app/modules/audio_recording/controllers/audio_recording_controller.dart';
import 'package:qualnote/app/modules/audio_recording/views/audio_recording_view.dart';
import 'package:qualnote/app/modules/camera/controller/camera_controller.dart';
import 'package:qualnote/app/modules/camera/view/camera_record_page.dart';
import 'package:qualnote/app/modules/home/controllers/progress_controller.dart';
import 'package:qualnote/app/modules/map/controllers/map_controller.dart';
import 'package:qualnote/app/utils/note_type.dart';

final dateFormat = DateFormat('yyMMddhhmmss');

class AddMediaController extends GetxController {
  MapGetxController mapGetxController = Get.find<MapGetxController>();
  HiveDb localDB = Get.find<HiveDb>();
  // Function() onAddMediaContinue = () {};
  List<String> consentsPaths = [];

  Future<void> addNote({required Note newNote}) async {
    // if (mapGetxController.type.value == RecordingType.video) {
    //   await Get.find<CameraGetxController>()
    //       .stopVideoRecording(isMainRecording: true);
    // }
    // if (mapGetxController.type.value == RecordingType.audio) {
    //   await Get.find<AudioRecordingController>()
    //       .stopRecorder(isMainRecording: true);
    // }
    var location = await mapGetxController.getCurrentLocation();
    var note = Note(
      title: newNote.title ?? 'Note${dateFormat.format(DateTime.now())}',
      description: newNote.description,
      coordinate: Coordinate.fromLatLng(location),
      path: newNote.path!,
      author: FirebaseAuth.instance.currentUser!.displayName!,
      duration: newNote.duration,
      type: newNote.type!,
      fileExtension: newNote.fileExtension,
    );
    mapGetxController.notes.add(note);
    mapGetxController.triggerRebuild();
  }

  void addPhotoNote() async {
    if (mapGetxController.type.value == RecordingType.video) {
      await Get.find<CameraGetxController>()
          .stopVideoRecording(isMainRecording: true);
    }
    if (mapGetxController.type.value == RecordingType.audio) {
      await Get.find<AudioRecordingController>()
          .stopRecorder(isMainRecording: true);
    }
    Get.to(() => CameraRecordPage(
          isPhoto: true,
          onDone: (path) => addNote(
            newNote: Note(
              path: path,
              fileExtension: 'jpeg',
              type: NoteType.photo.toString(),
            ),
          ),
        ));
  }

  void addVideoNote() async {
    if (mapGetxController.type.value == RecordingType.video) {
      await Get.find<CameraGetxController>()
          .stopVideoRecording(isMainRecording: true);
    }
    if (mapGetxController.type.value == RecordingType.audio) {
      await Get.find<AudioRecordingController>()
          .stopRecorder(isMainRecording: true);
    }
    Get.to(() => CameraRecordPage(
          onDone: (path) => addNote(
            newNote: Note(
              path: path,
              fileExtension: 'mp4',
              type: NoteType.video.toString(),
            ),
          ),
        ));
  }

  void addAudioNote() async {
    if (mapGetxController.type.value == RecordingType.video) {
      await Get.find<CameraGetxController>()
          .stopVideoRecording(isMainRecording: true);
    }
    if (mapGetxController.type.value == RecordingType.audio) {
      await Get.find<AudioRecordingController>()
          .stopRecorder(isMainRecording: true);
    }
    Get.to(() => AudioRecordingView());
  }

  Future<void> addTextNote(String text) async {
    if (mapGetxController.type.value == RecordingType.video) {
      await Get.find<CameraGetxController>()
          .stopVideoRecording(isMainRecording: true);
    }
    if (mapGetxController.type.value == RecordingType.audio) {
      await Get.find<AudioRecordingController>()
          .stopRecorder(isMainRecording: true);
    }
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
    if (mapGetxController.type.value == RecordingType.video) {
      await Get.find<CameraGetxController>()
          .startVideoRecording(isMainRecording: true);
    }
    if (mapGetxController.type.value == RecordingType.audio) {
      Get.find<AudioRecordingController>().startRecorder(isMainRecording: true);
    }
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
        "${appDocDir.path}/consents/Consent${dateFormat.format(DateTime.now())}.png";
    log(filePath);
    await File.fromRawPath(data!).rename(filePath);
    consentsPaths.add(filePath);
  }

  void saveAudioConsent(String path) => consentsPaths.add(path);

  void addFileNote({LatLng? tapCoordinate, int? index}) async {
    if (mapGetxController.type.value == RecordingType.video) {
      await Get.find<CameraGetxController>()
          .stopVideoRecording(isMainRecording: true);
    }
    // if (mapGetxController.type.value == RecordingType.audio) {
    //   await Get.find<AudioRecordingController>()
    //       .stopRecorder(isMainRecording: true);
    // }
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'mp4', 'mp3', 'jpeg', 'jpg', 'png', 'docx']);
    if (result == null) return;
    String fileType = await checkNoteType(result.files.first.extension!);
    File file = File('');
    final CloudStorage cloudStorage = CloudStorage();
    String name =
        '${dateFormat.format(DateTime.now())}${result.files.first.name}';
    if (kIsWeb) {
      Get.find<ProgressController>().showProgress('Uploading file', 0);
      final path = await cloudStorage.getStoragePath(
          fileType: fileType,
          projectId: mapGetxController.selectedProject.id!,
          fileName: name);

      await FirebaseStorage.instance.ref(path).putData(
          result.files.first.bytes!,
          SettableMetadata(contentType: result.files.first.extension!));
      Get.find<ProgressController>().showProgress('Uploading file', 1);
    } else {
      file = await saveFileToAppStorage(result.files.first);
      FilePicker.platform.clearTemporaryFiles();
    }

    ///tap coordinate used when adding fiels to specific point on route
    var location =
        tapCoordinate ?? await mapGetxController.getCurrentLocation();
    var note = Note(
      title: name,
      description: '',
      coordinate: Coordinate.fromLatLng(location),
      author: FirebaseAuth.instance.currentUser!.displayName!,
      type: fileType,
      path: kIsWeb
          ? await cloudStorage.getStoragePath(
              fileType: fileType,
              projectId: mapGetxController.selectedProject.id!,
              fileName: name,
              downloadUrl: true)
          : file.path,
      fileExtension: result.files.first.extension,
    );

    if (!kIsWeb && !mapGetxController.isMapping.value) {
      cloudStorage.uploadFile(
        path: file.path,
        projectId: mapGetxController.selectedProject.id!,
        fileName: name,
        fileType: fileType,
        numberOfFiles: 1,
        filePosition: 1,
      );
      if (Get.find<MapGetxController>().type.value == RecordingType.video) {
        await Get.find<CameraGetxController>()
            .startVideoRecording(isMainRecording: true);
      }
      if (Get.find<MapGetxController>().type.value == RecordingType.audio) {
        Get.find<AudioRecordingController>()
            .startRecorder(isMainRecording: true);
      }
    }

    ///used when adding files on a specific point on route
    if (index != null) {
      mapGetxController.notes.insert(index, note);
      mapGetxController.triggerRebuild();
      // Get.find<FirebaseDatabase>()
      //     .addNote(mapGetxController.selectedProject.id!, note);
      return;
    }

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
    if (fileExtension.toLowerCase() == 'jpeg' ||
        fileExtension.toLowerCase() == 'jpg' ||
        fileExtension.toLowerCase() == 'png') {
      return NoteType.photo.toString();
    }
    if (fileExtension.toLowerCase() == 'mp4') {
      return NoteType.video.toString();
    }
    if (fileExtension.toLowerCase() == 'mp3') {
      return NoteType.audio.toString();
    }
    return NoteType.document.toString();
  }
}
