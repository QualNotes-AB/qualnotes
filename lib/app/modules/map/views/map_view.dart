// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/data/models/note.dart';
import 'package:qualnote/app/modules/audio_recording/views/widgets/audio_recorder.dart';
import 'package:qualnote/app/modules/authentication/login/views/widgets/storage_progress_indicator.dart';
import 'package:qualnote/app/modules/camera/view/camera_window.dart';
import 'package:qualnote/app/modules/map/views/widgets/map_controls.dart';
import 'package:qualnote/app/modules/map/views/widgets/nav_bar.dart';
import 'package:qualnote/app/modules/map/views/widgets/note_markers.dart';
import 'package:qualnote/app/utils/note_type.dart';

import '../controllers/map_controller.dart';

class MapView extends GetView<MapGetxController> {
  const MapView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return Scaffold(
      body: Stack(
        children: [
          Obx(() {
            controller.rebuild.value;
            return controller.currentLocation.value == LatLng(0, 0)
                ? const Center(
                    child: SizedBox(
                      height: 60,
                      width: 60,
                      child: CircularProgressIndicator(
                        color: AppColors.darkGreen,
                      ),
                    ),
                  )
                : FlutterMap(
                    mapController: controller.mapController,
                    options: MapOptions(
                      center: controller.center.value,
                      zoom: controller.zoom,
                      maxZoom: controller.maxZoom,
                      onTap: (tapPosition, point) =>
                          controller.addFileOnPoint(point),
                    ),
                    nonRotatedChildren: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.qualnotes.qualnote',
                        maxZoom: controller.maxZoom,
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
                        //rotate: true,
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
          Obx(() => controller.isMapping.value
              ? controller.type.value == RecordingType.video
                  ? CameraWindow(controller: controller)
                  : controller.type.value == RecordingType.audio
                      ? const AudioMapping()
                      : const SizedBox()
              : const SizedBox()),
          MapControls(controller: controller),
          const NavBar(),
          StorageProgressIndicator(),
        ],
      ),
    );
  }

  List<Marker> get markers {
    List<Marker> markers = [];
    bool isPreview = controller.isPreview.value;
    if (isPreview) {
      markers.add(
        Marker(
          point: controller.routePoints.first,
          builder: (context) => Transform.translate(
            offset: const Offset(0, -10),
            child: const Icon(
              Icons.location_on_rounded,
              color: AppColors.blue,
              size: 30,
            ),
          ),
        ),
      );
    }
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
