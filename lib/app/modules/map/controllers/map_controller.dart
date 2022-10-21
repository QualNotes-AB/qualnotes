// ignore_for_file: invalid_use_of_protected_member

import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:qualnote/app/data/models/coordinate.dart';
import 'package:qualnote/app/data/models/note.dart';
import 'package:qualnote/app/data/models/project.dart';
import 'package:qualnote/app/data/services/firestore_db.dart';
import 'package:qualnote/app/data/services/local_db.dart';
import 'package:qualnote/app/modules/audio_recording/controllers/audio_recording_controller.dart';
import 'package:qualnote/app/modules/camera/controller/camera_controller.dart';
import 'package:qualnote/app/modules/dialogs/enter_note_number.dart';
import 'package:qualnote/app/modules/map/controllers/add_media_controller.dart';
import 'package:qualnote/app/modules/map/views/widgets/note_bottom_sheet.dart';
import 'package:qualnote/app/utils/distance_helper.dart';
import 'package:qualnote/app/utils/id_generator.dart';

class MapGetxController extends GetxController {
  HiveDb dbController = Get.find<HiveDb>();
  MapController mapController = MapController();
  TickerProvider? vsync;
  double maxZoom = 19;
  double zoom = 16;
  double minZoom = 5;
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
  RxBool isAddFile = false.obs;
  RxBool isFinishing = false.obs;
  Rx<RecordingType> type = RecordingType.justMapping.obs;
  RxList<LatLng> routePoints = <LatLng>[].obs;
  RxList<Note> notes = <Note>[].obs;

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

  void recenter() async => mapController.move(currentLocation.value, 17);

  void zoomIn() {
    final bounds = mapController.bounds!;
    final centerZoom = mapController.centerZoomFitBounds(bounds);
    var zoom = centerZoom.zoom + 1;
    if (zoom > maxZoom) {
      zoom = maxZoom;
    }
    mapController.move(centerZoom.center, zoom);
  }

  void zoomOut() {
    final bounds = mapController.bounds!;
    final centerZoom = mapController.centerZoomFitBounds(bounds);
    var zoom = centerZoom.zoom - 1;
    if (zoom < minZoom) {
      zoom = minZoom;
    }
    mapController.move(centerZoom.center, zoom);
  }

  ///used in add button in the navbar to add a file to specific location
  void addFileOnPoint(LatLng point) async {
    if (!isAddFile.value) return;
    isAddFile.value = false;
    final index = await noteNumberDialog();
    if (index < 0) return;
    Get.find<AddMediaController>()
        .addFileNote(tapCoordinate: point, index: index);
  }

  ///used when updating the project in overview//specificly in preview navbar finish button
  Project getUpdatedProject() {
    selectedProject.notes!.clear();

    selectedProject.notes!.addAll(notes.value);
    return selectedProject;
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
    // audioGetxController.resetRecorder();
    Get.delete<AudioRecordingController>();
    return newProject;
  }

  void selectProject(Project project) {
    currentLocation.value = project.routePoints!.first.toLatLng();
    selectedProject = project;
    center.value = project.routePoints!.first.toLatLng();
    type.value = project.type == RecordingType.justMapping.toString()
        ? RecordingType.justMapping
        : project.type == RecordingType.audio.toString()
            ? RecordingType.audio
            : RecordingType.video;
    isPreview.value = true;
    isMapping.value = false;

    routePoints.clear();
    routePoints.addAll(project.routePoints!.map((e) => e.toLatLng()).toList());
    notes.clear();
    notes.value.addAll(project.notes!);
  }

  getProjectFromUrl() async {
    var data = Get.parameters;
    String? id = data["id"];
    if (id == null) return;
    Project? result;
    if (kIsWeb) {
      result = await Get.find<FirebaseDatabase>().getProjectForWeb(id);
    } else {
      result = (await Get.find<HiveDb>().getProject(id));
    }
    if (kDebugMode) {
      print(result);
    }
    if (result == null) return;
    selectProject(result);
    currentLocation.value = result.routePoints!.first.toLatLng();
    mapController.move(result.routePoints!.first.toLatLng(), 15);
  }

  void triggerRebuild() => rebuild.value = !rebuild.value;

  void resetFields() {
    duration = 0;
    isMapping.value = false;
    type.value == RecordingType.justMapping;
    routePoints.clear();
    notes.clear();
  }

  ///used in navigation bar and main recording and note bottom sheet cards for navigating to next or previous recording
  // void openRecording({
  //   required int index,
  //   required bool isMainRecording,
  //   required bool forward,
  // }) {
  //   //No main recordings
  //   try {
  //     if (selectedProject.type == RecordingType.justMapping.toString()) {
  //       if (!forward && index == 1) Get.back();
  //       index != notes.length
  //           ? _openNote(forward ? index + 1 : index - 1)
  //           : null;
  //       return;
  //     }
  //     //Main recordings
  //     if (selectedProject.type != RecordingType.justMapping.toString()) {
  //       if (isMainRecording) {
  //         final mainList =
  //             selectedProject.type == RecordingType.video.toString()
  //                 ? selectedProject.routeVideos
  //                 : selectedProject.routeAudios;
  //         if (index == 0 && !forward) Get.back();
  //         index != mainList!.length
  //             ? _openMainRecording(
  //                 (forward ? index + 1 : index),
  //                 selectedProject.type == RecordingType.video.toString()
  //                     ? false
  //                     : true,
  //                 mainList[(forward ? index + 1 : index)],
  //               )
  //             : null;
  //         return;
  //       }
  //       if (index == 0 || index == notes.length) Get.back();
  //       index != (forward ? notes.length : notes.length + 1)
  //           ? _openNote((forward ? index : index - 1))
  //           : null;

  //       return;
  //     }
  //   } on Exception catch (e) {
  //     log(e.toString());
  //   }
  // }

  // void _openMainRecording(int index, bool isAudio, String path) {
  //   log(index.toString());
  //   if (index != 0) Get.back();
  //   Get.bottomSheet(
  //     MainRecordingBottomSheet(
  //       isAudio: isAudio,
  //       index: index,
  //       path: path,
  //     ),
  //     // isScrollControlled: !kIsWeb && !isAudio,
  //     barrierColor: Colors.transparent,
  //   );
  // }

  // void _openNote(int index) {
  //   log(index.toString());
  //   if (index != 0) Get.back();
  //   Note note = notes[index];
  //   if (note.type == NoteType.video.toString() ||
  //       note.type == NoteType.photo.toString()) {
  //     Get.bottomSheet(
  //       NoteBottomSheet(note: note, index: index),
  //       barrierColor: Colors.transparent,
  //       // isScrollControlled: !kIsWeb,
  //       // ignoreSafeArea: false,
  //       // isDismissible: true,
  //     );
  //   } else {
  //     Get.bottomSheet(
  //       NoteBottomSheet(note: note, index: index),
  //       barrierColor: Colors.transparent,
  //     );
  //   }
  //   selectedNoteIndex.value = index;
  //   mapController.move(
  //       LatLng(
  //           note.coordinate!.latitude! - 0.0015, note.coordinate!.longitude!),
  //       17);
  // }

  void nextNote() {
    if (selectedNoteIndex.value == notes.length - 1) return;
    final index = ++selectedNoteIndex.value;
    openNote(index);
  }

  void previousNote() {
    if (selectedNoteIndex.value == 0) return;
    final index = --selectedNoteIndex.value;
    openNote(index);
  }

  void openNote(int index) {
    Note note = notes[index];
    Get.bottomSheet(
      NoteBottomSheet(note: note, index: index),
      barrierColor: Colors.transparent,
    );
    // final rotationDeg = mapController.rotation.abs();
    // log(mapController.rotation.toString());
    // double latitude = 0.0015;
    // double longitude = 0.0015;
    // if (rotationDeg >= 0 && rotationDeg <= 90) {
    //   longitude *= rotationDeg / 90;
    //   latitude *= ((90 - rotationDeg) / 90);
    // }
    animatedMapMove(
        LatLng(note.coordinate!.latitude! - 0.0015,
            note.coordinate!.longitude! + 0.0015),
        17,
        vsync!);
    // mapController.move(
    //     LatLng(
    //         note.coordinate!.latitude! - 0.0015, note.coordinate!.longitude!),
    //     17);
  }

  void animatedMapMove(
      LatLng destLocation, double destZoom, TickerProvider vsync) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final latTween = Tween<double>(
        begin: mapController.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: mapController.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    final controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: vsync);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    final Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController.move(
          LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
          zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  void updateNoteTitle(String value, int index) =>
      notes[index].noteTitle = value;

  void updateNoteDescription(String value, int index) =>
      notes[index].description = value;

  Future<LatLng> getCurrentLocation() async {
    Location _location = Location();
    _location.changeSettings(
        accuracy: LocationAccuracy.high, distanceFilter: 10);

    if (await location.hasPermission() == PermissionStatus.granted) {
      LocationData? location;
      location = await Future.any([
        _location.getLocation(),
        Future.delayed(const Duration(seconds: 5), () => null),
      ]);
      location ??= await _location.getLocation();

      log('Got location');
      return LatLng(location.latitude ?? 0, location.longitude ?? 0);
    }
    return LatLng(0, 0); //LatLng(59.3293, 18.0686);
  }

  Future<void> init() async {
    log('Map init');
    duration = 0;
    // if (kIsWeb) {
    //   log('web');
    //   getProjectFromUrl();
    //   return;
    // }

    if (dbController.lastKnownLocation != LatLng(0, 0)) {
      currentLocation.value = dbController.lastKnownLocation;
    } else {
      currentLocation.value = await getCurrentLocation();
    }
    center.value = currentLocation.value;
    locationStream = location.onLocationChanged.asBroadcastStream().listen(
      (LocationData data) {
        var location =
            LatLng(data.latitude ?? 59.3293, data.longitude ?? 18.0686);
        currentLocation.value = location;
        dbController.saveLastKnownLocation(location);
        if (isMapping.value) {
          routePoints.add(location);
          log(location.toString());
        }
      },
    );
  }

  @override
  void onInit() {
    init();
    super.onInit();
  }

  @override
  void dispose() {
    locationStream.cancel();
    Get.delete<MapGetxController>();
    super.dispose();
  }
}

enum RecordingType { justMapping, video, audio }
