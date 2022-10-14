import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/modules/dialogs/requires_consent.dart';
import 'package:qualnote/app/modules/map/controllers/add_media_controller.dart';
import 'package:qualnote/app/utils/note_type.dart';

cameraAlertDialog({required NoteType noteType}) async {
  Get.dialog(
    Dialog(
      child: Container(
        width: 250,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange,
                    size: 50,
                  ),
                ),
                Text(
                  'Main recordings are paused\nwhile you record your note!',
                  style: TextStyle(color: Colors.orange, fontSize: 14),
                ),
              ],
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: Colors.orange,
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () async {
                  Get.back();
                  if (noteType == NoteType.audio ||
                      noteType == NoteType.video) {
                    requiresParticipantDialog(noteType: noteType);
                  } else {
                    Get.find<AddMediaController>().addPhotoNote();
                  }
                },
                child: const Text(
                  'Continue',
                  style: TextStyle(color: Colors.orange),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
