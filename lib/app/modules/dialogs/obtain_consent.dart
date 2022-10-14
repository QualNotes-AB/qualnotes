import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/modules/home/views/widgets/ethics_page.dart';
import 'package:qualnote/app/modules/map/views/consent_view.dart';
import 'package:qualnote/app/utils/note_type.dart';

Future<dynamic> obtainConsent({required NoteType noteType}) async {
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
                    'Obtain participant consent',
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
                onPressed: () => Get.to(() => const EthicsPage()),
                child: const Center(
                  child: Text(
                    'Open ethics form from docs',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const Divider(height: 1, thickness: 1, color: AppColors.lightGrey),
            Expanded(
              child: TextButton(
                onPressed: () async {
                  Get.off(() => ConsentView(noteType: noteType));
                },
                child: const Center(
                  child: Text(
                    'Sign consent form',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
