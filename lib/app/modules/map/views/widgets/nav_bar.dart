import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/modules/map/controllers/map_controller.dart';
import 'package:qualnote/app/modules/map/views/widgets/nav_button.dart';
import 'package:qualnote/app/routes/app_pages.dart';

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
        height: 81,
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NavButton(
                onPressed: pausedDialog,
                title: 'Pause',
                icon: const Icon(
                  Icons.pause,
                  size: 34,
                  color: AppColors.white,
                ),
              ),
              NavButton(
                onPressed: finishedDialog,
                title: 'Finish',
                icon: const Icon(
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
              NavButton(
                onPressed: () {},
                title: 'Add',
                icon: const Icon(
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

  finishedDialog() {
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

  pausedDialog() {
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
              const Padding(
                padding: EdgeInsets.only(bottom: 15, top: 15),
                child: Text('All recordings paused.'),
              ),
              const Divider(
                height: 1,
                thickness: 1,
                color: AppColors.lightGrey,
              ),
              TextButton(
                onPressed: () {
                  mapGetxController.resumeMapping();
                  Get.back();
                },
                child: const Center(
                  child: Text('Click here to resume'),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  startRecordingDialog() => Get.dialog(
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
                        'Which method will use?',
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
                Expanded(
                  child: TextButton(
                    onPressed: () {},
                    child: const Center(
                      child: Text(
                        'Record audio',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                const Divider(
                    height: 1, thickness: 1, color: AppColors.lightGrey),
                Expanded(
                  child: TextButton(
                    onPressed: () {},
                    child: const Center(
                      child: Text(
                        'Record video',
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
                      mapGetxController.startMapping();
                      Get.back();
                    },
                    child: const Center(
                      child: Text(
                        'Just mapping',
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
