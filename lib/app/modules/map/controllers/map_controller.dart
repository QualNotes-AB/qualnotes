// ignore_for_file: invalid_use_of_protected_member

import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:qualnote/app/data/models/coordinate.dart';
import 'package:qualnote/app/data/models/note.dart';
import 'package:qualnote/app/data/models/project.dart';
import 'package:qualnote/app/data/services/local_db.dart';
import 'package:qualnote/app/modules/audio_recording/controllers/audio_recording_controller.dart';
import 'package:qualnote/app/modules/camera/controller/camera_controller.dart';
import 'package:qualnote/app/modules/map/controllers/add_media_controller.dart';
import 'package:qualnote/app/modules/map/views/widgets/note_bottom_sheet.dart';
import 'package:qualnote/app/utils/distance_helper.dart';
import 'package:qualnote/app/utils/id_generator.dart';

class MapGetxController extends GetxController {
  MapController mapController = MapController();
  Project selectedProject = Project();
  RxInt selectedNoteIndex = (-1).obs;
  Location location = Location();
  late StreamSubscription locationStream;
  late Timer timer;
  int duration = 0;
  Rx<LatLng> currentLocation = LatLng(0, 0).obs;
  Rx<LatLng> center = LatLng(0, 0).obs;
  RxBool isMapping = false.obs;
  RxBool isPreview = false.obs;
  RxBool rebuild = false.obs;
  Rx<RecordingType> type = RecordingType.justMapping.obs;
  RxList<LatLng> routePoints = <LatLng>[].obs;
  RxList<Note> notes = <Note>[].obs;

  Future<LatLng> getCurrentLocation() async {
    Location _location = Location();
    _location.changeSettings(
        accuracy: LocationAccuracy.high, distanceFilter: 10);

    if (await location.hasPermission() == PermissionStatus.granted) {
      LocationData location = await _location.getLocation();
      log('Got location');
      return LatLng(location.latitude ?? 0, location.longitude ?? 0);
    }
    return LatLng(0, 0);
  }

  void startMapping() {
    routePoints.clear();
    isMapping.value = true;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      duration++;
    });
  }

  void stopMapping() {
    isMapping.value = false;
    timer.cancel();
  }

  void resumeMapping() {
    isMapping.value = true;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      duration++;
    });
  }

  void selectRecordingType(RecordingType value) {
    type.value = value;
    isPreview.value = false;
  }

  void recenter() async {
    mapController.move(currentLocation.value, 17)
        ? log('recenter success')
        : log('recenter failed');
  }

  Future<Project> saveRouteLocaly(String title) async {
    final cameraGetx = Get.find<CameraGetxController>();
    final audioGetx = Get.find<AudioRecordingController>();
    final addMediaController = Get.find<AddMediaController>();
    // audioGetx.audioPaths.removeAt(0);
    Project newProject = Project(
      id: getRandomString(20),
      title: title,
      description: '',
      totalTime: duration,
      type: type.value.toString(),
      author: FirebaseAuth.instance.currentUser!.displayName ?? 'No username',
      date: DateTime.now(),
      distance: calculateRouteDistance(routePoints.value),
      notes: notes.value.toList(),
      routePoints:
          routePoints.value.map((e) => Coordinate.fromLatLng(e)).toList(),
      routeVideos: cameraGetx.videoPaths.toList(),
      routeAudios: audioGetx.audioPaths.toList(),
      consents: addMediaController.consentsPaths.toList(),
      routeAudiosLength: audioGetx.audioPaths.length.toInt(),
      routeVideosLength: cameraGetx.videoPaths.length.toInt(),
      consentsLength: addMediaController.consentsPaths.length.toInt(),
    );

    await Get.find<HiveDb>().saveProject(newProject);
    addMediaController.consentsPaths.clear();
    cameraGetx.videoPaths.clear();
    audioGetx.audioPaths.clear();
    notes.clear();
    resetFields();
    return newProject;
  }

  void selectProject(Project project) {
    selectedProject = project;
    center.value = project.routePoints!.first.toLatLng();
    type.value = RecordingType.justMapping;
    isPreview.value = true;
    isMapping.value = false;
    routePoints.clear();
    routePoints.addAll(project.routePoints!.map((e) => e.toLatLng()).toList());
    notes.clear();
    notes.value.addAll(project.notes!);
  }

  void triggerRebuild() => rebuild.value = !rebuild.value;

  void resetFields() {
    duration = 0;
    isMapping.value = false;
    routePoints.clear();
    notes.clear();
  }

  void nextNote(int index) =>
      index != notes.length ? _openNote(index + 1) : null;

  void previousNote(int index) => index != 0 ? _openNote(index - 1) : null;

  void _openNote(int index) {
    Get.back();
    Note note = notes[index];
    Get.bottomSheet(
      NoteBottomSheet(note: note, index: index),
      barrierColor: Colors.transparent,
    );
    selectedNoteIndex.value = index;
    mapController.move(
        LatLng(
            note.coordinate!.latitude! - 0.0015, note.coordinate!.longitude!),
        17);
  }

  Future<void> init() async {
    log('Map init');
    duration = 0;
    currentLocation.value = await getCurrentLocation();
    center.value = currentLocation.value;
    locationStream = location.onLocationChanged.asBroadcastStream().listen(
      (LocationData data) {
        var location = LatLng(data.latitude ?? 0, data.longitude ?? 0);
        currentLocation.value = location;

        if (isMapping.value) {
          routePoints.add(location);
          log(location.toString());
        }
      },
    );
  }

  @override
  void dispose() {
    locationStream.cancel();
    Get.delete<MapGetxController>();
    super.dispose();
  }
}

enum RecordingType { justMapping, video, audio }
