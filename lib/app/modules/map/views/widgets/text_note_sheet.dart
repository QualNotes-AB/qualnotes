import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/config/text_styles.dart';
import 'package:qualnote/app/data/models/note.dart';
import 'package:qualnote/app/modules/map/controllers/map_controller.dart';
import 'package:qualnote/app/modules/map/views/widgets/blue_text_button.dart';
import 'package:qualnote/app/utils/distance_helper.dart';

Future<dynamic> textNoteSheet(Note element, int index) {
  String text = '';
  return Get.bottomSheet(
    SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: TextEditingController(text: element.description),
              onChanged: (value) => text = value,
              minLines: 1,
              maxLines: 5,
              autocorrect: false,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(0),
                  hintText: element.description,
                  hintStyle: AppTextStyle.regular16Black),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      'Author: ${FirebaseAuth.instance.currentUser!.displayName}'),
                  Text(
                      'GPS: ${convertLocation(element.coordinate!.toLatLng())}')
                ],
              ),
            ),
            BlueTextButton(
              title: 'Save',
              onPressed: () {
                text.isNotEmpty
                    ? Get.find<MapGetxController>().notes[index].description =
                        text
                    : null;
                Get.back();
              },
            )
          ],
        ),
      ),
    ),
  );
}
