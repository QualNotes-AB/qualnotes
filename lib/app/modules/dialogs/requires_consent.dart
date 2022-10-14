import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/modules/dialogs/obtain_consent.dart';
import 'package:qualnote/app/modules/map/controllers/add_media_controller.dart';
import 'package:qualnote/app/utils/note_type.dart';

requiresParticipantDialog({required NoteType noteType}) async {
  final addMediaController = Get.find<AddMediaController>();
  await Get.dialog(
    Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: AppColors.popupGrey,
      child: SizedBox(
        height: 260,
        width: 260,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Will you record a participant?',
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: AppColors.lightGrey,
            ),
            Expanded(
              child: TextButton(
                onPressed: () async {
                  Get.back();
                  await obtainConsent(noteType: noteType);
                },
                child: const Center(
                  child: Text(
                    'YES',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const Divider(height: 1, thickness: 1, color: AppColors.lightGrey),
            Expanded(
              child: TextButton(
                onPressed: () {
                  Get.back();
                  if (noteType == NoteType.audio) {
                    addMediaController.addAudioNote();
                    return;
                  }
                  if (noteType == NoteType.video) {
                    addMediaController.addVideoNote();
                  }
                },
                child: const Center(
                  child: Text(
                    'NO',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: false,
  );
}
