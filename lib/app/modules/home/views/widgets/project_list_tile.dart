import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/config/text_styles.dart';
import 'package:qualnote/app/data/models/project.dart';
import 'package:qualnote/app/data/services/firestore_db.dart';
import 'package:qualnote/app/data/services/local_db.dart';
import 'package:qualnote/app/modules/home/views/project_overview_view.dart';

class ProjectListTile extends StatelessWidget {
  final String title;
  final String id;
  final bool isLocal;
  const ProjectListTile({
    Key? key,
    required this.title,
    required this.id,
    this.isLocal = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: TextButton(
            onPressed: () async {
              Project? project = await Get.find<HiveDb>().getProject(id);
              if (project != null) {
                if (kDebugMode) {
                  print(project.toJson());
                }
                Get.to(() => ProjectOverviewView(project));
              }
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.folder_outlined,
                  size: 25,
                  color: isLocal ? AppColors.black : AppColors.blue,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    title,
                    style: isLocal
                        ? AppTextStyle.regular17Black
                        : AppTextStyle.regular17Blue,
                  ),
                )
              ],
            ),
          ),
        ),
        isLocal
            ? TextButton(
                onPressed: () {},
                child: const Icon(
                  Icons.more_horiz,
                  color: AppColors.black,
                ),
              )
            : TextButton(
                onPressed: () {
                  Get.find<FirebaseDatabase>().getProject(id);
                },
                child: const Icon(
                  Icons.download,
                  color: AppColors.blue,
                ),
              ),
      ],
    );
  }
}
