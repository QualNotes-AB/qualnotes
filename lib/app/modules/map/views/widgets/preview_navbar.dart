import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/data/services/firestore_db.dart';
import 'package:qualnote/app/modules/map/controllers/map_controller.dart';
import 'package:qualnote/app/modules/map/views/widgets/nav_button.dart';

class PreviewNavbar extends StatelessWidget {
  const PreviewNavbar({
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
        NavButton(
          onPressed: () {
            mapGetxController.previousNote();
            // mapGetxController.openRecording(
            //     index: mapGetxController.selectedNoteIndex.value,
            //     isMainRecording: false,
            //     forward: false);
          },
          title: 'Back',
          icon: const Icon(
            Icons.keyboard_arrow_left_rounded,
            size: 34,
            color: AppColors.white,
          ),
        ),
        NavButton(
          onPressed: () {
            mapGetxController.nextNote();
            // mapGetxController.openRecording(
            //     index: mapGetxController.selectedNoteIndex.value,
            //     isMainRecording: false,
            //     forward: true);
          },
          title: 'Next',
          icon: const Icon(
            Icons.keyboard_arrow_right_rounded,
            size: 34,
            color: AppColors.white,
          ),
        ),
        NavButton(
          onPressed: () {
            mapGetxController.selectedNoteIndex.value < 0
                ? mapGetxController.selectedNoteIndex.value = 0
                : null;
            mapGetxController
                .openNote(mapGetxController.selectedNoteIndex.value);
            // if (mapGetxController.selectedNoteIndex.value != 0) return;
            // if (mapGetxController.type.value == RecordingType.justMapping) {
            //   mapGetxController.openRecording(
            //       index: -1, isMainRecording: false, forward: true);
            //   return;
            // }
            // mapGetxController.openRecording(
            //     index: -1, isMainRecording: true, forward: true);
          },
          title: 'Play',
          icon: const Icon(
            Icons.play_arrow,
            size: 34,
            color: AppColors.white,
          ),
        ),
        NavButton(
          onPressed: () {
            // mapGetxController.getUpdatedProject();
            Get.find<FirebaseDatabase>()
                .updateProject(mapGetxController.getUpdatedProject());

            Get.back();
            mapGetxController.selectedNoteIndex.value = -1;
          },
          title: 'Finish',
          icon: const Icon(
            Icons.stop,
            size: 34,
            color: AppColors.white,
          ),
        ),
        NavButton(
          onPressed: () {
            mapGetxController.isAddFile.value = true;
            Get.showSnackbar(
              const GetSnackBar(
                title: 'Click on the map',
                message: 'where you want your file to be',
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
          },
          title: 'Add',
          icon: const Icon(
            Icons.add_circle_outline_outlined,
            size: 34,
            color: AppColors.white,
          ),
        ),
      ],
    );
  }
}
