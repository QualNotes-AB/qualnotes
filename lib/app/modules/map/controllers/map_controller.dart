// ignore_for_file: invalid_use_of_protected_member

import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:qualnote/app/data/models/project_model.dart';
import 'package:qualnote/app/data/services/local_db.dart';
import 'package:qualnote/app/modules/audio_recording/controllers/audio_recording_controller.dart';
import 'package:qualnote/app/modules/map/controllers/camera_controller.dart';
import 'package:qualnote/app/utils/distance_helper.dart';

class MapGetxController extends GetxController {
  MapController mapController = MapController();

  Location location = Location();
  late StreamSubscription locationStream;
  late Timer timer;
  int duration = 0;
  Rx<LatLng> currentLocation = LatLng(0, 0).obs;
  RxBool isMapping = false.obs;
  RxBool isPreview = false.obs;
  RxBool rebuild = false.obs;
  Rx<RecordingType> type = RecordingType.justMapping.obs;
  RxList<LatLng> routePoints = <LatLng>[].obs;
  RxList<CameraMedia> photoNotes = <CameraMedia>[].obs;
  RxList<CameraMedia> videoNotes = <CameraMedia>[].obs;
  RxList<AudioMedia> audioNotes = <AudioMedia>[].obs;

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

  void saveRouteLocaly(String title) async {
    final cameraGetx = Get.find<CameraGetxController>();
    final audioGetx = Get.find<AudioRecordingController>();
    final recordingType = type.value == RecordingType.audio
        ? 'Audio recording'
        : type.value == RecordingType.video
            ? 'Video recording'
            : 'Map only';
    Project route = Project(
      title: title,
      description: '',
      totalTime: duration,
      type: recordingType,
      author: FirebaseAuth.instance.currentUser!.displayName ?? 'No username',
      date: DateTime.now(),
      distance: calculateRouteDistance(routePoints.value),
      photos: photoNotes.value,
      videos: videoNotes.value,
      audios: audioNotes.value,
      routePoints: routePoints.value,
      routeVideos: cameraGetx.videoPaths,
      routeAudios: audioGetx.audioPaths,
    );
    await Get.find<HiveDb>().saveProject(route);
    cameraGetx.videoPaths.clear();
    audioGetx.audioPaths.clear();
    resetFields();
  }

  void selectProject(Project project) {
    type.value = RecordingType.justMapping;
    isPreview.value = true;
    isMapping.value = false;
    routePoints.clear();
    routePoints.addAll(project.routePoints!);
    photoNotes.clear();
    photoNotes.addAll(project.photos!);
    videoNotes.clear();
    videoNotes.addAll(project.videos!);
    audioNotes.clear();
    audioNotes.addAll(project.audios!);
  }

  void triggerRebuild() => rebuild.value = !rebuild.value;

  void resetFields() {
    duration = 0;
    isMapping.value = false;
    routePoints.clear();
    photoNotes.clear();
    videoNotes.clear();
    audioNotes.clear();
  }

  Future<void> init() async {
    log('Map init');
    duration = 0;
    currentLocation.value = await getCurrentLocation();
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
