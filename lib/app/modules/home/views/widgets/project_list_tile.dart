import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/config/text_styles.dart';
import 'package:qualnote/app/data/models/project.dart';
import 'package:qualnote/app/data/services/firestore_db.dart';
import 'package:qualnote/app/modules/overview/controllers/overview_controller.dart';
import 'package:qualnote/app/routes/app_pages.dart';

class ProjectListTile extends StatelessWidget {
  final Project project;
  final bool isLocal;
  const ProjectListTile({
    Key? key,
    required this.project,
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
            onPressed: () {
              int local = isLocal ? 1 : 0;
              if (!kIsWeb && !isLocal) return;
              Get.toNamed("${Routes.OVERVIEW}?id=${project.id}&local=$local");
              Get.find<OverviewController>().getProjectFromUrl();
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
                    project.title!,
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
            : Visibility(
                visible: !kIsWeb,
                child: TextButton(
                  onPressed: () {
                    Get.find<FirebaseDatabase>().getProject(project.id!);
                  },
                  child: const Icon(
                    Icons.download,
                    color: AppColors.blue,
                  ),
                ),
              ),
      ],
    );
  }
}
