import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/config/colors.dart';
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
            mapGetxController
                .previousNote(mapGetxController.selectedNoteIndex.value);
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
            mapGetxController
                .nextNote(mapGetxController.selectedNoteIndex.value);
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
            //TODO play
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
            Get.back();
            //TODO update db
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
            //TODO Add file notes
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
