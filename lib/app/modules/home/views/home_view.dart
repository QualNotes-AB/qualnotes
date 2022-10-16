// ignore_for_file: invalid_use_of_protected_member

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/config/text_styles.dart';
import 'package:qualnote/app/data/models/note.dart';
import 'package:qualnote/app/modules/authentication/login/views/widgets/page_holder.dart';
import 'package:qualnote/app/modules/dialogs/record_method_dialog.dart';
import 'package:qualnote/app/modules/home/views/widgets/add_button.dart';
import 'package:qualnote/app/modules/home/views/widgets/home_search.dart';
import 'package:qualnote/app/modules/home/views/widgets/project_list_tile.dart';
import 'package:qualnote/app/modules/home/views/widgets/tab_switch.dart';
import 'package:qualnote/app/modules/map/views/widgets/note_bottom_sheet.dart';
import 'package:qualnote/app/routes/app_pages.dart';
import 'package:qualnote/app/utils/note_type.dart';

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
            onPressed: () {
              Get.bottomSheet(
                NoteBottomSheet(
                  note: Note(
                    description:
                        'Here we can read additional information if the user added to the map before. This street is example of narrow street where cars cannot come in, it is what we calll a blue zone space that has no noise from cars. We observe the impact of thii in commerce and the neighbourhood. then we talk to....',
                    title: 'This is a demo title',
                    author: 'Stage Coding',
                    type: NoteType.audio.toString(),
                  ),
                  index: 1,
                ),
                isScrollControlled: true,
                barrierColor: Colors.transparent,
              );
            },
            title: 'Upload docx pdf to My Files',
          ),
          AddButton(
            onPressed: () {
              if (!kIsWeb) {
                Get.toNamed(Routes.AUDIO_RECORDING);
              }
            },
            title: 'Open audio recordings',
          ),
          kIsWeb
              ? const SizedBox()
              : Obx(
                  () => ListView(
                    shrinkWrap: true,
                    children: [
                      ...controller.localProjects.value
                          .map((project) => Visibility(
                                visible: !controller.cloudProjects.value
                                    .contains(project),
                                child: ProjectListTile(
                                  project: project,
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
                          project: project,
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
