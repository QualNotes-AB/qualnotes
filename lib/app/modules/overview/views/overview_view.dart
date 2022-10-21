import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/config/text_styles.dart';
import 'package:qualnote/app/data/models/note.dart';
import 'package:qualnote/app/data/models/project.dart';
import 'package:qualnote/app/data/services/firestore_db.dart';
import 'package:qualnote/app/data/services/internet_availability.dart';
import 'package:qualnote/app/modules/authentication/login/views/widgets/page_holder.dart';
import 'package:qualnote/app/modules/dialogs/delete.dart';
import 'package:qualnote/app/modules/map/controllers/map_controller.dart';
import 'package:qualnote/app/modules/map/views/map_view.dart';
import 'package:qualnote/app/modules/overview/views/widgets/blue_overview_button.dart';
import 'package:qualnote/app/modules/overview/views/widgets/share_bottom_sheet.dart';
import 'package:qualnote/app/routes/app_pages.dart';
import 'package:qualnote/app/utils/datetime_helper.dart';
import 'package:qualnote/app/utils/distance_helper.dart';
import 'package:qualnote/app/utils/note_type.dart';

import '../controllers/overview_controller.dart';

final overviewDate = DateFormat('MMMM dd');
final standardDate = DateFormat('yyyy M d');

class OverviewView extends GetView<OverviewController> {
  const OverviewView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      Project project = controller.project.value;
      bool isLocal = controller.isLocal;
      return controller.loaded.value
          ? PageHolder(
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Transform.translate(
                      offset: const Offset(-20, 0),
                      child: SizedBox(
                        width: 160,
                        child: TextButton(
                            onPressed: () => Get.offNamed(Routes.HOME),
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.keyboard_arrow_left_outlined,
                                  size: 30,
                                ),
                                Text('To Main Menu'),
                              ],
                            )),
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(-20, 0),
                      child: SizedBox(
                        width: 100,
                        child: TextButton(
                            onPressed: () {
                              Get.back();
                            }, //=>
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.keyboard_arrow_left_outlined,
                                  size: 30,
                                ),
                                Text('Back'),
                              ],
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          getFirstPhoto(project),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10, top: 20),
                              child: Text(
                                project.title ?? 'No title',
                                style: AppTextStyle.bold32Black,
                                softWrap: true,
                                maxLines: 3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Text(
                      '${overviewDate.format(project.date!)} - ${(project.totalTime! / 60).floor()} MIN',
                      style: AppTextStyle.bold12Grey,
                    ),
                    TextField(
                      controller: controller.textEditingController,
                      onChanged: (value) => project.description = value,
                      minLines: 1,
                      maxLines: 6,
                      autocorrect: false,
                      style: AppTextStyle.regular14BlackHeight,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(0)),
                      scrollPadding: EdgeInsets.zero,
                    ),
                    //Text(project.description ?? 'No description'),
                    Wrap(
                      runSpacing: 10,
                      children: [
                        Visibility(
                          visible: isLocal || kIsWeb,
                          child: BlueOverviewButton(
                            title: 'Play',
                            icon: Icons.play_arrow_rounded,
                            onPressed: () {
                              //open map

                              isLocal
                                  ? {
                                      Get.find<MapGetxController>()
                                          .selectProject(project),
                                      Get.to(() => const MapView()),
                                    }
                                  : {
                                      Get.toNamed(
                                          "${Routes.MAP}?id=${project.id}"),
                                      Get.find<MapGetxController>()
                                          .getProjectFromUrl()
                                    };
                            },
                          ),
                        ),
                        Visibility(
                          visible: isLocal,
                          child: Obx(
                            () => BlueOverviewButton(
                              title: 'Upload',
                              icon: Icons.upload,
                              onPressed: Get.find<InternetAvailability>()
                                      .isConnected
                                      .value
                                  ? () {
                                      var file = project.notes!.first;
                                      if (kDebugMode) {
                                        print(file.toJson());
                                      }
                                      Get.find<FirebaseDatabase>()
                                          .uploadProject(project);
                                    }
                                  : null,
                            ),
                          ),
                        ),
                        BlueOverviewButton(
                          title: 'Delete',
                          icon: Icons.delete_outline,
                          onPressed: () async => await deleteDialog(project),
                        ),
                        BlueOverviewButton(
                          title: 'Share',
                          icon: Icons.share_outlined,
                          onPressed:
                              Get.find<InternetAvailability>().isConnected.value
                                  ? () {
                                      Get.bottomSheet(
                                        ShareBottomSheet(project: project),
                                        elevation: 3,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                      );
                                    }
                                  : null,
                        ),
                        BlueOverviewButton(
                          title: 'Add final reflection note',
                          icon: Icons.note_add_outlined,
                          onPressed: () => Get.toNamed(Routes.REFLECTION),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        'More about',
                        style: AppTextStyle.semiBold16Black,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: AppTextStyle.regular16Black,
                        children: [
                          TextSpan(
                              text:
                                  'Distance: ${getDistanceAsString(project.distance!)}\n'),
                          TextSpan(
                              text:
                                  'Total time: ${formatTotalTime(project.totalTime!)}\n'),
                          TextSpan(text: 'Notes: ${project.notes!.length}\n'),
                          TextSpan(
                              text: 'Audio: ${project.routeAudiosLength}\n'),
                          TextSpan(
                              text: 'Video: ${project.routeVideosLength}\n'),
                          TextSpan(
                              text: 'Type: ${formatType(project.type!)}\n'),
                          TextSpan(text: 'Author: ${project.author}\n'),
                          TextSpan(
                              text:
                                  'Date: ${standardDate.format(project.date!)}\n'),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          : const Center(
              child: SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(
                  color: AppColors.darkGreen,
                ),
              ),
            );
    });
  }

  Widget getFirstPhoto(Project project) {
    if (project.notes == null) return const SizedBox();
    Note? note = project.notes!.firstWhereOrNull(
        (element) => element.type == NoteType.photo.toString());
    if (note == null || note.path == null) {
      return const SizedBox();
    }
    if (kIsWeb) {
      log(note.path!);

      return Image.network(
        note.path!,
        fit: BoxFit.cover,
        height: 170,
        width: 150,
      );
    }
    return Image.file(
      File(note.path!),
      fit: BoxFit.cover,
      height: 170,
      width: 150,
    );
  }
}

String formatType(String type) {
  if (type == RecordingType.justMapping.toString()) {
    return 'Only maping';
  }
  if (type == RecordingType.audio.toString()) {
    return 'Audio project';
  }

  return 'Video project';
}
