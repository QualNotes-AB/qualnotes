import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/data/models/note.dart';
import 'package:qualnote/app/modules/audio_recording/controllers/audio_recording_controller.dart';
import 'package:qualnote/app/modules/audio_recording/views/widgets/audio_details_sheet.dart';
import 'package:qualnote/app/modules/camera/view/video_player.dart';
import 'package:qualnote/app/modules/map/controllers/map_controller.dart';
import 'package:qualnote/app/modules/map/views/widgets/note_bottom_sheet.dart';
import 'package:qualnote/app/modules/map/views/widgets/text_note_sheet.dart';

Marker audioMarker(
    {required Note note, required bool isPreview, required int index}) {
  final controller = Get.find<MapGetxController>();
  return Marker(
    height: 55,
    width: 50,
    point: note.coordinate!.toLatLng(),
    builder: (context) {
      return Obx(
        () => Transform.translate(
          offset: const Offset(0, -10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: controller.selectedNoteIndex.value == index
                  ? const Color.fromARGB(129, 36, 145, 235)
                  : Colors.transparent,
            ),
            child: TextButton(
              onPressed: () {
                Get.find<AudioRecordingController>().selectAudioNote(note);
                isPreview
                    ? Get.bottomSheet(
                        NoteBottomSheet(note: note, index: index),
                        elevation: 0,
                        barrierColor: Colors.transparent,
                      )
                    : Get.bottomSheet(
                        AudioDetailsCard(path: note.path),
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
          ),
        ),
      );
    },
  );
}

Marker videoMarker(
    {required Note note, required bool isPreview, required int index}) {
  final controller = Get.find<MapGetxController>();
  return Marker(
    point: note.coordinate!.toLatLng(),
    builder: (context) {
      return Obx(
        () => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: controller.selectedNoteIndex.value == index
                ? const Color.fromARGB(129, 36, 145, 235)
                : Colors.transparent,
          ),
          child: TextButton(
              onPressed: () {
                isPreview
                    ? Get.bottomSheet(
                        NoteBottomSheet(note: note, index: index),
                        elevation: 0,
                        barrierColor: Colors.transparent,
                        isScrollControlled: true,
                        ignoreSafeArea: false,
                        isDismissible: true,
                      )
                    : Get.to(VideoPlayerPage(path: note.path!));
              },
              child: const Icon(
                Icons.videocam,
                color: AppColors.black,
              )),
        ),
      );
    },
  );
}

Marker photoMarker(
    {required Note note, required bool isPreview, required int index}) {
  final controller = Get.find<MapGetxController>();
  return Marker(
    point: note.coordinate!.toLatLng(),
    height: 200,
    width: 80,
    builder: (context) {
      return Obx(
        () => Transform.translate(
          offset: const Offset(0, -80),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: controller.selectedNoteIndex.value == index
                  ? const Color.fromARGB(129, 36, 145, 235)
                  : Colors.transparent,
            ),
            child: TextButton(
              onPressed: () {
                isPreview
                    ? Get.bottomSheet(
                        NoteBottomSheet(note: note, index: index),
                        elevation: 0,
                        barrierColor: Colors.transparent,
                        isScrollControlled: true,
                        ignoreSafeArea: false,
                        isDismissible: true,
                      )
                    : {
                        //TODO Retake photo
                      };
              },
              child: Column(
                children: [
                  Image.file(
                    File(note.path!),
                    height: 150,
                  ),
                  const Icon(Icons.photo_camera_rounded)
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

Marker textNoteMarker(
    {required Note note, required bool isPreview, required int index}) {
  final controller = Get.find<MapGetxController>();
  return Marker(
    point: note.coordinate!.toLatLng(),
    width: 50,
    height: 50,
    builder: (context) {
      return Obx(
        () => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: controller.selectedNoteIndex.value == index
                ? const Color.fromARGB(129, 36, 145, 235)
                : Colors.transparent,
          ),
          child: TextButton(
            onPressed: () => isPreview
                ? {
                    controller.selectedNoteIndex.value = index,
                    Get.bottomSheet(
                      NoteBottomSheet(note: note, index: index),
                      elevation: 0,
                      barrierColor: Colors.transparent,
                    ),
                  }
                : {
                    controller.selectedNoteIndex.value = index,
                    textNoteSheet(note, index)
                  },
            child: const Center(
              child: Icon(
                Icons.notes_outlined,
                color: Colors.black,
              ),
            ),
          ),
        ),
      );
    },
  );
}

Marker fileMarker(
    {required Note note, required bool isPreview, required int index}) {
  final controller = Get.find<MapGetxController>();
  return Marker(
    point: note.coordinate!.toLatLng(),
    builder: (context) {
      return Obx(
        () => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: controller.selectedNoteIndex.value == index
                ? const Color.fromARGB(129, 36, 145, 235)
                : Colors.transparent,
          ),
          child: TextButton(
              onPressed: () {
                isPreview
                    ? Get.bottomSheet(
                        NoteBottomSheet(note: note, index: index),
                        elevation: 0,
                        barrierColor: Colors.transparent,
                        isDismissible: true,
                      )
                    : null;
              },
              child: const Icon(
                Icons.file_present_rounded,
                color: AppColors.black,
              )),
        ),
      );
    },
  );
}
