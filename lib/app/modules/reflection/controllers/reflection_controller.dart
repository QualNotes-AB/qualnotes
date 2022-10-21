import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/data/models/note.dart';
import 'package:qualnote/app/data/services/firestore_db.dart';
import 'package:qualnote/app/data/services/internet_availability.dart';
import 'package:qualnote/app/data/services/local_db.dart';
import 'package:qualnote/app/modules/overview/controllers/overview_controller.dart';

class ReflectionController extends GetxController {
  final overviewController = Get.find<OverviewController>();
  Timer? timer;
  Rx<DateTime> dateTime = DateTime.now().obs;
  TextEditingController textEditingController = TextEditingController();
  RxList<Note> reflectionNotes = <Note>[].obs;
  String text = '';

  void addReflectionNote() {
    if (text.isEmpty) return;
    reflectionNotes.add(Note(
        description: text,
        date: DateTime.now(),
        author: FirebaseAuth.instance.currentUser == null
            ? 'Anonymous'
            : FirebaseAuth.instance.currentUser!.displayName ?? 'Anonymous'));
    textEditingController.text = '';
    text = '';
  }

  @override
  void onInit() {
    timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      dateTime.value = DateTime.now();
    });
    reflectionNotes.value =
        overviewController.project.value.reflectionNotes ?? [];
    super.onInit();
  }

  @override
  void onClose() {
    if (timer != null) {
      timer!.cancel();
    }
    textEditingController.dispose();
    if (reflectionNotes.isEmpty) return;
    if (overviewController.project.value.reflectionNotes != null &&
        overviewController.project.value.reflectionNotes!.length ==
            reflectionNotes.length) {
      return;
    }
    if (Get.find<InternetAvailability>().isConnected.value &&
        !overviewController.isLocal) {
      Get.find<FirebaseDatabase>().updateReflectionNotes(
        overviewController.project.value.id!,
        reflectionNotes,
      );
    } else {
      Get.find<HiveDb>().saveProject(
          overviewController.project.value..reflectionNotes = reflectionNotes);
    }

    super.onClose();
  }
}
