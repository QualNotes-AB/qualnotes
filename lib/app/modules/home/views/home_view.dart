// ignore_for_file: invalid_use_of_protected_member

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/config/text_styles.dart';
import 'package:qualnote/app/data/models/project.dart';
import 'package:qualnote/app/data/services/firestore_db.dart';
import 'package:qualnote/app/modules/authentication/login/views/widgets/page_holder.dart';
import 'package:qualnote/app/modules/dialogs/record_method_dialog.dart';
import 'package:qualnote/app/modules/home/views/widgets/add_button.dart';
import 'package:qualnote/app/modules/home/views/widgets/home_search.dart';
import 'package:qualnote/app/modules/home/views/widgets/project_list_tile.dart';
import 'package:qualnote/app/modules/home/views/widgets/tab_switch.dart';
import 'package:qualnote/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  // ignore: use_key_in_widget_constructors
  const HomeView() : super();
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
                  try {
                    FirebaseAuth.instance.signOut();
                  } on Exception catch (e) {
                    log(e.toString());
                  }
                }
                Get.offAllNamed(Routes.LOGIN);
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
          TabSwitch(),
          const AddButton(
            onPressed: recordMethodDialog,
            title: 'New Qual Notes Project',
          ),
          // AddButton(
          //   onPressed: () {},
          //   title: 'Upload docx pdf to My Files',
          // ),
          // AddButton(
          //   onPressed: () {
          //     if (!kIsWeb) {
          //       Get.toNamed(Routes.AUDIO_RECORDING);
          //     }
          //   },
          //   title: 'Open audio recordings',
          // ),
          Obx(
            () => controller.isPublicCatalogue.value || kIsWeb
                ? const SizedBox()
                : Obx(
                    () => ListView(
                      shrinkWrap: true,
                      children: [
                        ...controller.localProjects.value
                            .map(
                              (project) => ProjectListTile(
                                project: project,
                                isLocal: true,
                              ),
                            )
                            .toList(),
                      ],
                    ),
                  ),
          ),
          Obx(() => !controller.isPublicCatalogue.value
              ? StreamBuilder(
                  stream: Get.find<FirebaseDatabase>()
                      .projectsStream
                      .asBroadcastStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data == null) {
                        return const SizedBox();
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final doc = snapshot.data!.docs[index];
                          final project = Project.fromJson(doc.data(), doc.id);

                          return Obx(() {
                            return Visibility(
                              visible:
                                  !controller.localProjects.contains(project),
                              child: ProjectListTile(
                                project: project,
                                isLocal: false,
                              ),
                            );
                          });
                        },
                      );
                    }
                    return const SizedBox();
                  },
                )
              : StreamBuilder(
                  stream: Get.find<FirebaseDatabase>()
                      .collabProjects
                      .asBroadcastStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data == null) {
                        return const SizedBox();
                      }
                      log("collab" + snapshot.data!.docs.length.toString());
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final doc = snapshot.data!.docs[index];
                          final project = Project.fromJson(doc.data(), doc.id);
                          return ProjectListTile(
                            project: project,
                            isLocal: kIsWeb
                                ? false
                                : controller.localProjects.contains(project),
                          );
                        },
                      );
                    }
                    return const CircularProgressIndicator();
                  },
                ))
        ],
      ),
    );
  }
}
