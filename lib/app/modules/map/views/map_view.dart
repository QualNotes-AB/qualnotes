// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/data/models/note.dart';
import 'package:qualnote/app/modules/audio_recording/views/widgets/audio_recorder.dart';
import 'package:qualnote/app/modules/camera/view/camera_window.dart';
import 'package:qualnote/app/modules/map/controllers/add_media_controller.dart';
import 'package:qualnote/app/modules/map/views/widgets/nav_bar.dart';
import 'package:qualnote/app/modules/map/views/widgets/note_markers.dart';
import 'package:qualnote/app/utils/note_type.dart';

import '../controllers/map_controller.dart';

class MapView extends GetView<MapGetxController> {
  const MapView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    Get.find<AddMediaController>();
    return Scaffold(
      body: Stack(
        children: [
          Obx(() {
            controller.rebuild.value;

            return FlutterMap(
              mapController: controller.mapController,
              options: MapOptions(
                center: controller.center.value,
                zoom: 16.0,
                maxZoom: 19.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.qualnotes.qualnote',
                  maxZoom: 19.0,
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: controller.routePoints.value,
                      strokeWidth: 8,
                      color: AppColors.lineBlue,
                    )
                  ],
                ),
                MarkerLayer(
                  rotate: true,
                  markers: [
                    Marker(
                      point: controller.currentLocation.value,
                      builder: (context) => const Icon(
                        Icons.radio_button_checked,
                        color: AppColors.blue,
                      ),
                    ),
                    ...markers,
                  ],
                ),
              ],
            );
          }),
          Obx(() => controller.type.value == RecordingType.video
              ? CameraWindow(controller: controller)
              : controller.type.value == RecordingType.audio
                  ? const AudioMapping()
                  : const SizedBox()),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
                onPressed: () => controller.recenter(),
                child: const Icon(
                  Icons.my_location_rounded,
                  color: Colors.black,
                )),
          ),
          NavBar(),
        ],
      ),
    );
  }

  List<Marker> get markers {
    List<Marker> markers = [];
    bool isPreview = controller.isPreview.value;
    for (int i = 0; i < controller.notes.length; i++) {
      Note note = controller.notes[i];
      late Marker marker;
      if (note.type == NoteType.text.toString()) {
        marker = textNoteMarker(note: note, isPreview: isPreview, index: i);
      }
      if (note.type == NoteType.photo.toString()) {
        marker = photoMarker(note: note, isPreview: isPreview, index: i);
      }
      if (note.type == NoteType.video.toString()) {
        marker = videoMarker(note: note, isPreview: isPreview, index: i);
      }
      if (note.type == NoteType.audio.toString()) {
        marker = audioMarker(note: note, isPreview: isPreview, index: i);
      }
      if (note.type == NoteType.document.toString()) {
        marker = fileMarker(note: note, isPreview: isPreview, index: i);
      }
      markers.add(marker);
    }

    return markers;
  }
}
