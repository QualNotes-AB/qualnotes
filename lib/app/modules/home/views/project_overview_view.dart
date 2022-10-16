import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qualnote/app/config/text_styles.dart';
import 'package:qualnote/app/data/models/note.dart';
import 'package:qualnote/app/data/models/project.dart';
import 'package:qualnote/app/data/services/firestore_db.dart';
import 'package:qualnote/app/data/services/internet_availability.dart';
import 'package:qualnote/app/modules/authentication/login/views/widgets/page_holder.dart';
import 'package:qualnote/app/modules/dialogs/delete.dart';
import 'package:qualnote/app/modules/map/controllers/map_controller.dart';
import 'package:qualnote/app/routes/app_pages.dart';
import 'package:qualnote/app/utils/datetime_helper.dart';
import 'package:qualnote/app/utils/distance_helper.dart';
import 'package:qualnote/app/utils/note_type.dart';

final overviewDate = DateFormat('MMMM dd');
final standardDate = DateFormat('yyyy M d');

class ProjectOverviewView extends GetView {
  final Project project;
  final bool isLocal;
  const ProjectOverviewView(this.project, this.isLocal, {Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return PageHolder(
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
                    onPressed: () {}, //=> Get.back(),
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
                  getFirstPhoto(),
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
            Text(project.description ?? 'No description'),
            Row(
              children: [
                Visibility(
                  visible: isLocal,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)))),
                    onPressed: () {
                      //open map
                      Get.find<MapGetxController>().selectProject(project);
                      Get.toNamed(Routes.MAP);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text('Play'),
                          Icon(Icons.play_arrow_rounded),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Obx(
                  () => ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)))),
                    onPressed: Get.find<InternetAvailability>()
                            .isConnected
                            .value
                        ? () {
                            var file = project.notes!.first;
                            if (kDebugMode) {
                              print(file.toJson());
                            }
                            Get.find<FirebaseDatabase>().uploadProject(project);
                          }
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text('Upload'),
                          Icon(Icons.upload),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                  ),
                  onPressed: () async => await deleteDialog(project),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text('Delete'),
                        Icon(Icons.delete_outline),
                      ],
                    ),
                  ),
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
            Text('Distance: ${getDistanceAsString(project.distance!)}'),
            Text('Total time: ${formatTotalTime(project.totalTime!)}'),
            Text('Notes: ${project.notes!.length}'),
            // Text('Audio: ${project.routeAudiosLength}'),
            // Text('Video: ${project.routeVideosLength}'),
            Text('Type: ${project.type}'),
            Text('Author: ${project.author}'),
            Text('Date: ${standardDate.format(project.date!)}'),
          ],
        ),
      ),
    );
  }

  Widget getFirstPhoto() {
    if (project.notes == null) return const SizedBox();
    Note? note = project.notes!.firstWhereOrNull(
        (element) => element.type == NoteType.photo.toString());
    if (note == null || note.path == null) {
      return const SizedBox();
    }

    return Image.file(
      File(note.path!),
      fit: BoxFit.cover,
      height: 170,
      width: 150,
    );
  }
}
