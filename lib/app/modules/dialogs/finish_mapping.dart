import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/modules/map/controllers/map_controller.dart';
import 'package:qualnote/app/routes/app_pages.dart';

finishedDialog() {
  var mapGetxController = Get.find<MapGetxController>();
  mapGetxController.stopMapping();
  Get.dialog(
    Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: AppColors.popupGrey,
      child: SizedBox(
        height: 100,
        width: 180,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: TextField(
                onChanged: (value) {},
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 20),
                  hintText: 'Enter map title',
                ),
              ),
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: AppColors.lightGrey,
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        mapGetxController.resumeMapping();
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
                      onPressed: () {
                        // mapGetxController.resumeMapping();
                        // Get.back();
                        //TODO SAVE ROUTE
                        Get.toNamed(Routes.HOME);
                      },
                      child: const Center(
                        child: Text('Save'),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}
