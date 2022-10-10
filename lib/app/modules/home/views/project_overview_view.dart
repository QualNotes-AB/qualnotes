import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qualnote/app/config/text_styles.dart';
import 'package:qualnote/app/data/models/project_model.dart';
import 'package:qualnote/app/modules/authentication/login/views/widgets/page_holder.dart';
import 'package:qualnote/app/modules/map/controllers/map_controller.dart';
import 'package:qualnote/app/routes/app_pages.dart';
import 'package:qualnote/app/utils/distance_helper.dart';

final overviewDate = DateFormat('MMMM dd');
final standardDate = DateFormat('yyyy M d');

class ProjectOverviewView extends GetView {
  final Project project;
  const ProjectOverviewView(this.project, {Key? key}) : super(key: key);
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
                    onPressed: () => Get.back(),
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
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // children: [project.notes!.firstWhere((element) =>
                  //               element.type == NoteType.photo.toString()).path ;
                  //   project.notes!.isNotEmpty
                  //       ? Image.file(
                  //           File(),
                  //           width: 150,
                  //         )
                  //       : const SizedBox(),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 20),
                    child: Text(
                      project.title ?? 'No title',
                      style: AppTextStyle.bold32Black,
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
                ElevatedButton(
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
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)))),
                  onPressed: () {},
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
            Text('Notes: ${project.routeAudios!.length}'),
            Text('Notes: ${project.routeVideos!.length}'),
            Text('Type: ${project.type}'),
            Text('Author: ${project.author}'),
            Text('Date: ${standardDate.format(project.date!)}'),
          ],
        ),
      ),
    );
  }

  String formatTotalTime(int seconds) {
    return '${(seconds / 60).floor()} min ${(seconds % 60)} sec';
  }
}
