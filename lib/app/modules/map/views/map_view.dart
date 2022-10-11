// ignore_for_file: invalid_use_of_protected_member

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/modules/audio_recording/controllers/audio_recording_controller.dart';
import 'package:qualnote/app/modules/audio_recording/views/widgets/audio_details_sheet.dart';
import 'package:qualnote/app/modules/audio_recording/views/widgets/audio_recorder.dart';
import 'package:qualnote/app/modules/camera/view/camera_window.dart';
import 'package:qualnote/app/modules/camera/view/video_bottom_sheet.dart';
import 'package:qualnote/app/modules/map/controllers/add_media_controller.dart';
import 'package:qualnote/app/modules/map/views/widgets/nav_bar.dart';
import 'package:qualnote/app/utils/note_type.dart';

import '../controllers/map_controller.dart';

class MapView extends GetView<MapGetxController> {
  const MapView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    Get.find<AddMediaController>();
    Get.find<AudioRecordingController>();
    return Scaffold(
      body: Stack(
        children: [
          Obx(() {
            controller.rebuild.value;

            return FlutterMap(
              mapController: MapController(),
              options: MapOptions(
                center: controller.currentLocation.value,
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
          NavBar(),
        ],
      ),
    );
  }

  List<Marker> get markers {
    List<Marker> markers = [];

    //create all photo markers
    markers.addAll(controller.notes
        .where((element) => element.type == NoteType.photo.toString())
        .map(
          (element) => Marker(
            point: element.coordinate!.toLatLng(),
            height: 200,
            width: 80,
            builder: (context) {
              return Transform.translate(
                offset: const Offset(0, -80),
                child: Column(
                  children: [
                    Image.file(
                      File(element.path!),
                      height: 150,
                    ),
                    const Icon(Icons.photo_camera_rounded)
                  ],
                ),
              );
            },
          ),
        )
        .toList());
    //create all video markers
    markers.addAll(controller.notes
        .where((element) => element.type == NoteType.video.toString())
        .map(
          (element) => Marker(
            point: element.coordinate!.toLatLng(),
            builder: (context) {
              return TextButton(
                  onPressed: () {
                    Get.bottomSheet(
                      VideoBottomSheet(path: element.path!),
                      isScrollControlled: true,
                      barrierColor: Colors.transparent,
                    );
                  },
                  child: Icon(
                    Icons.videocam,
                    color: element.hasConsent != true
                        ? AppColors.red
                        : AppColors.blue,
                  ));
            },
          ),
        )
        .toList());
    //create all audio markers
    markers.addAll(controller.notes
        .where((element) => element.type == NoteType.audio.toString())
        .map(
          (element) => Marker(
            height: 55,
            width: 50,
            point: element.coordinate!.toLatLng(),
            builder: (context) {
              return Transform.translate(
                offset: const Offset(0, -10),
                child: TextButton(
                  onPressed: () {
                    Get.find<AudioRecordingController>()
                        .selectAudioNote(element);
                    Get.bottomSheet(
                      AudioDetailsCard(path: element.path!),
                      isScrollControlled: true,
                      barrierColor: Colors.transparent,
                    );
                  },
                  style: const ButtonStyle(
                    padding: MaterialStatePropertyAll(
                      EdgeInsets.zero,
                    ),
                    overlayColor: MaterialStatePropertyAll(
                      Color.fromARGB(15, 66, 66, 66),
                    ),
                  ),
                  child: Column(
                    children: [
                      Transform.translate(
                        offset: const Offset(10, 5),
                        child: const Icon(
                          Icons.add_circle,
                        ),
                      ),
                      const Icon(
                        Icons.mic,
                        size: 30,
                        color: AppColors.black,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        )
        .toList());

    return markers;
  }
}
