// ignore_for_file: invalid_use_of_protected_member

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/config/text_styles.dart';
import 'package:qualnote/app/modules/authentication/login/views/widgets/page_holder.dart';
import 'package:qualnote/app/modules/dialogs/record_method_dialog.dart';
import 'package:qualnote/app/modules/home/views/widgets/add_button.dart';
import 'package:qualnote/app/modules/home/views/widgets/home_search.dart';
import 'package:qualnote/app/modules/home/views/widgets/project_list_tile.dart';
import 'package:qualnote/app/modules/home/views/widgets/tab_switch.dart';
import 'package:qualnote/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return PageHolder(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Transform.translate(
            offset: const Offset(-15, 0),
            child: TextButton(
              onPressed: () {
                if (FirebaseAuth.instance.currentUser != null) {
                  FirebaseAuth.instance.signOut();
                }
                Get.toNamed(Routes.LOGIN);
              },
              child: SizedBox(
                width: 110,
                child: Row(
                  children: const [
                    Icon(
                      Icons.keyboard_arrow_left_outlined,
                      color: AppColors.blueText,
                      size: 40,
                    ),
                    Text(
                      'Sign out',
                      style: AppTextStyle.regular17Blue,
                    )
                  ],
                ),
              ),
            ),
          ),
          const HomeSearch(),
          const TabSwitch(),
          const AddButton(
            onPressed: recordMethodDialog,
            title: 'New Qual Notes Project',
          ),
          AddButton(
            onPressed: () {},
            title: 'Upload docx pdf to My Files',
          ),
          AddButton(
            onPressed: () {
              Get.toNamed(Routes.AUDIO_RECORDING);
            },
            title: 'Open audio recordings',
          ),
          Obx(
            () => ListView(
              shrinkWrap: true,
              children: [
                ...controller.localProjects.value
                    .map((project) => Visibility(
                          visible:
                              !controller.cloudProjects.value.contains(project),
                          child: ProjectListTile(
                            title: project.title!,
                            id: project.id!,
                            isLocal: true,
                          ),
                        ))
                    .toList(),
              ],
            ),
          ),
          Obx(
            () => ListView(
              shrinkWrap: true,
              children: [
                ...controller.cloudProjects.value
                    .map((project) => ProjectListTile(
                          title: project.title!,
                          id: project.id!,
                          isLocal:
                              controller.localProjects.value.contains(project),
                        ))
                    .toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
