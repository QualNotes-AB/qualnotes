import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/config/text_styles.dart';
import 'package:qualnote/app/data/models/project_model.dart';
import 'package:qualnote/app/data/services/local_db.dart';
import 'package:qualnote/app/modules/home/views/project_overview_view.dart';

class ProjectListTile extends StatelessWidget {
  final String title;
  final String id;
  const ProjectListTile({
    Key? key,
    required this.title,
    required this.id,
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
                Get.to(() => ProjectOverviewView(project));
              }
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.folder_outlined,
                  size: 25,
                  color: AppColors.black,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    title,
                    style: AppTextStyle.regular17Black,
                  ),
                )
              ],
            ),
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Icon(
            Icons.more_horiz,
            color: AppColors.black,
          ),
        ),
      ],
    );
  }
}
