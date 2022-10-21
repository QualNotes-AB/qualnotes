import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/data/models/note.dart';
import 'package:qualnote/app/modules/audio_recording/controllers/audio_recording_controller.dart';
import 'package:qualnote/app/modules/map/controllers/map_controller.dart';

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
                controller.selectedNoteIndex.value = index;
                Get.find<AudioRecordingController>().selectAudioNote(note);
                controller.openNote(index);
                // isPreview
                //     ? Get.bottomSheet(
                //         NoteBottomSheet(note: note, index: index),
                //         elevation: 0,
                //         ignoreSafeArea: true,
                //         barrierColor: Colors.transparent,
                //       )
                //     : Get.bottomSheet(
                //         AudioDetailsCard(path: note.path),
                //         // isScrollControlled: true,
                //         ignoreSafeArea: true,
                //         barrierColor: Colors.transparent,
                //       );
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
                  Icon(
                    Icons.mic,
                    size: 30,
                    color: controller.selectedNoteIndex.value == index
                        ? AppColors.white
                        : AppColors.black,
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
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: controller.selectedNoteIndex.value == index
                ? const Color.fromARGB(129, 36, 145, 235)
                : Colors.transparent,
          ),
          child: TextButton(
              onPressed: () {
                controller.selectedNoteIndex.value = index;
                controller.openNote(index);
                // Get.bottomSheet(
                //   NoteBottomSheet(note: note, index: index),
                //   elevation: 0,
                //   ignoreSafeArea: true,
                //   barrierColor: Colors.transparent,
                // );
              },
              style: const ButtonStyle(
                  padding: MaterialStatePropertyAll(EdgeInsets.zero)),
              child: Icon(
                Icons.videocam,
                color: controller.selectedNoteIndex.value == index
                    ? AppColors.white
                    : AppColors.black,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              note.path == null
                  ? const SizedBox()
                  : kIsWeb
                      ? Image.network(
                          note.path!,
                          fit: BoxFit.cover,
                          width: 150,
                        )
                      : Image.file(
                          File(note.path!),
                          width: 150,
                        ),
              Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: controller.selectedNoteIndex.value == index
                        ? const Color.fromARGB(129, 36, 145, 235)
                        : Colors.transparent,
                  ),
                  child: TextButton(
                    onPressed: () {
                      controller.selectedNoteIndex.value = index;
                      controller.openNote(index);
                      // Get.bottomSheet(
                      //   NoteBottomSheet(note: note, index: index),
                      //   elevation: 0,
                      //   ignoreSafeArea: true,
                      //   barrierColor: Colors.transparent,
                      // );
                    },
                    style: const ButtonStyle(
                        padding: MaterialStatePropertyAll(EdgeInsets.zero)),
                    child: Icon(
                      Icons.photo_camera_rounded,
                      color: controller.selectedNoteIndex.value == index
                          ? AppColors.white
                          : AppColors.black,
                    ),
                  ))
            ],
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
            onPressed: () {
              controller.selectedNoteIndex.value = index;
              controller.openNote(index);
              // Get.bottomSheet(
              //   NoteBottomSheet(note: note, index: index),
              //   elevation: 0,
              //   ignoreSafeArea: true,
              //   barrierColor: Colors.transparent,
              // );
            },
            style: const ButtonStyle(
                padding: MaterialStatePropertyAll(EdgeInsets.zero)),
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: controller.selectedNoteIndex.value == index
                    ? const Color.fromARGB(129, 36, 145, 235)
                    : Colors.transparent,
              ),
              child: Center(
                child: Icon(
                  Icons.notes_outlined,
                  color: controller.selectedNoteIndex.value == index
                      ? AppColors.white
                      : AppColors.black,
                ),
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
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: controller.selectedNoteIndex.value == index
                ? const Color.fromARGB(129, 36, 145, 235)
                : Colors.transparent,
          ),
          child: TextButton(
              onPressed: () {
                controller.selectedNoteIndex.value = index;
                controller.openNote(index);
                // Get.bottomSheet(
                //   NoteBottomSheet(note: note, index: index),
                //   elevation: 0,
                //   ignoreSafeArea: true,
                //   barrierColor: Colors.transparent,
                // );
              },
              style: const ButtonStyle(
                  padding: MaterialStatePropertyAll(EdgeInsets.zero)),
              child: Icon(
                Icons.file_present_rounded,
                color: controller.selectedNoteIndex.value == index
                    ? AppColors.white
                    : AppColors.black,
              )),
        ),
      );
    },
  );
}
