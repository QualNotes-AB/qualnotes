import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/modules/map/controllers/add_media_controller.dart';

addTextNoteDialog() {
  var mediaController = Get.find<AddMediaController>();
  String? text;

  Get.dialog(
    Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: AppColors.popupGrey,
      child: SizedBox(
        height: 160,
        width: 180,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15, right: 15),
              child: TextField(
                onChanged: (value) => text = value,
                maxLines: 5,
                autocorrect: false,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 20),
                  hintText: 'Enter text',
                ),
              ),
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: AppColors.lightGrey,
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Center(
                      child: Text('Go back'),
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  width: 1,
                  color: AppColors.lightGrey,
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      if (text == null || text!.isEmpty) {
                        Get.snackbar(
                            'Sorry', 'Please enter the title of the route');
                      } else {
                        Get.back();
                        mediaController.addTextNote(text!);
                      }
                    },
                    child: const Center(
                      child: Text('Add Note'),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}
