import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/modules/dialogs/add_media.dart';
import 'package:qualnote/app/modules/dialogs/finish_mapping.dart';
import 'package:qualnote/app/modules/dialogs/pause.dart';
import 'package:qualnote/app/modules/dialogs/start_recording.dart';
import 'package:qualnote/app/modules/map/controllers/map_controller.dart';
import 'package:qualnote/app/modules/map/views/widgets/nav_button.dart';

class NavBar extends StatelessWidget {
  NavBar({
    Key? key,
  }) : super(key: key);

  final mapGetxController = Get.find<MapGetxController>();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 82,
        width: MediaQuery.of(context).size.width > 500
            ? 500
            : MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: AppColors.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: Center(
          child: mapGetxController.isPreview.value
              ? NavButton(
                  onPressed: () => Get.back(),
                  title: 'Return',
                  icon: const Icon(
                    Icons.exit_to_app_rounded,
                    size: 34,
                    color: AppColors.white,
                  ),
                )
              : Row(
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
                              onPressed: () => Get.back(),
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
                      onPressed: () {},
                      title: 'My Files',
                      icon: const Icon(
                        Icons.file_copy_outlined,
                        size: 32,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
