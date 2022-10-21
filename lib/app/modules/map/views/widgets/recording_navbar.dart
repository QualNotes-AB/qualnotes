import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/modules/dialogs/add_media.dart';
import 'package:qualnote/app/modules/dialogs/finish_mapping.dart';
import 'package:qualnote/app/modules/dialogs/pause.dart';
import 'package:qualnote/app/modules/dialogs/start_recording.dart';
import 'package:qualnote/app/modules/map/controllers/add_media_controller.dart';
import 'package:qualnote/app/modules/map/controllers/map_controller.dart';
import 'package:qualnote/app/modules/map/views/widgets/nav_button.dart';
import 'package:qualnote/app/routes/app_pages.dart';

class RecordingNavBar extends StatelessWidget {
  const RecordingNavBar({
    Key? key,
    required this.mapGetxController,
  }) : super(key: key);

  final MapGetxController mapGetxController;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Obx(
          () => mapGetxController.isMapping.value
              ? const NavButton(
                  onPressed: pausedDialog,
                  title: 'Pause',
                  icon: Icon(
                    Icons.pause,
                    size: 34,
                    color: AppColors.white,
                  ),
                )
              : NavButton(
                  onPressed: () => Get.offAllNamed(Routes.HOME),
                  title: 'Back',
                  icon: const Icon(
                    Icons.keyboard_arrow_left_rounded,
                    size: 34,
                    color: AppColors.white,
                  ),
                ),
        ),
        const NavButton(
          onPressed: finishedDialog,
          title: 'Finish',
          icon: Icon(
            Icons.stop,
            size: 34,
            color: AppColors.white,
          ),
        ),
        NavButton(
          onPressed: startRecordingDialog,
          title: 'REC',
          icon: Stack(
            alignment: Alignment.center,
            children: const [
              Icon(
                Icons.fiber_manual_record_outlined,
                color: AppColors.white,
                size: 40,
              ),
              Icon(
                Icons.fiber_manual_record,
                color: AppColors.white,
                size: 22,
              ),
            ],
          ),
        ),
        const NavButton(
          onPressed: addMediaDialog,
          title: 'Add',
          icon: Icon(
            Icons.add_circle_outline,
            size: 34,
            color: AppColors.white,
          ),
        ),
        NavButton(
          onPressed: () => Get.find<AddMediaController>().addFileNote(),
          title: 'My Files',
          icon: const Icon(
            Icons.file_copy_outlined,
            size: 32,
            color: AppColors.white,
          ),
        ),
      ],
    );
  }
}
