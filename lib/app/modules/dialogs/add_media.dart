import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/modules/dialogs/add_text_note.dart';
import 'package:qualnote/app/modules/dialogs/requires_consent.dart';
import 'package:qualnote/app/modules/map/controllers/add_media_controller.dart';
import 'package:qualnote/app/modules/map/controllers/map_controller.dart';
import 'package:qualnote/app/utils/note_type.dart';

addMediaDialog() {
  var mapController = Get.find<MapGetxController>();
  mapController.isMapping.value
      ? Get.dialog(
          Dialog(
            insetPadding: EdgeInsets.zero,
            backgroundColor: AppColors.popupGrey,
            child: SizedBox(
              height: 260,
              width: 260,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'What do we add?',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.lightGrey,
                  ),
                  Visibility(
                    visible: !kIsWeb,
                    child: Expanded(
                      child: TextButton(
                        onPressed: () {
                          Get.find<AddMediaController>().addPhotoNote();

                          //cameraAlertDialog(noteType: NoteType.photo);
                        },
                        child: const Center(
                          child: Text(
                            'Photo',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Divider(
                      height: 1, thickness: 1, color: AppColors.lightGrey),
                  Visibility(
                    visible: !kIsWeb,
                    child: Expanded(
                      child: TextButton(
                        onPressed: () {
                          if (kIsWeb) return;
                          Get.back();
                          requiresParticipantDialog(noteType: NoteType.video);
                          //  cameraAlertDialog(noteType: NoteType.video);
                        },
                        child: const Center(
                          child: Text(
                            'Video',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Divider(
                      height: 1, thickness: 1, color: AppColors.lightGrey),
                  Visibility(
                    visible: !kIsWeb,
                    child: Expanded(
                      child: TextButton(
                        onPressed: () async {
                          Get.back();
                          // cameraAlertDialog(noteType: NoteType.audio);
                          requiresParticipantDialog(noteType: NoteType.audio);
                        },
                        child: const Center(
                          child: Text(
                            'Audio',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Divider(
                      height: 1, thickness: 1, color: AppColors.lightGrey),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Get.back();
                        addTextNoteDialog();
                      },
                      child: const Center(
                        child: Text(
                          'Note (Text)',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  const Divider(
                      height: 1, thickness: 1, color: AppColors.lightGrey),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Get.find<AddMediaController>().addFileNote();
                        Get.back();
                      },
                      child: const Center(
                        child: Text(
                          'Note (File)',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      : Get.snackbar('Not recording',
          'Please select recording method and then you can add notes',
          duration: const Duration(seconds: 5));
}
