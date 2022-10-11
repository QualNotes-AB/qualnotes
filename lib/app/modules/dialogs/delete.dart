import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/data/models/project.dart';
import 'package:qualnote/app/data/services/firestore_db.dart';
import 'package:qualnote/app/data/services/local_db.dart';
import 'package:qualnote/app/modules/home/views/home_view.dart';

snackbar() => Get.snackbar(
      'Success',
      'Project has been deleted!',
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );

deleteDialog(Project project) async {
  Get.dialog(
    Dialog(
      child: Container(
        width: 250,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange,
                    size: 50,
                  ),
                ),
                Text(
                  'Are you sure you want to\ndelete this project?',
                  style: TextStyle(color: Colors.orange, fontSize: 16),
                ),
              ],
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: Colors.orange,
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () async {
                  Get.off(() => const HomeView());
                  await Get.find<FirebaseDatabase>().deleteProject(project);
                  snackbar();
                },
                child: const Text(
                  'Delete from Cloud',
                  style: TextStyle(color: Colors.orange),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () async {
                  Get.off(() => const HomeView());
                  await Get.find<HiveDb>().deleteProjectLocaly(project.id!);
                  snackbar();
                },
                child: const Text(
                  'Delete localy',
                  style: TextStyle(color: Colors.orange),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () async {
                  Get.off(() => const HomeView());
                  await Get.find<HiveDb>().deleteProjectLocaly(project.id!);
                  await Get.find<FirebaseDatabase>().deleteProject(project);
                  snackbar();
                },
                child: const Text(
                  'Delete all',
                  style: TextStyle(color: Colors.orange),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text(
                  'Cancel',
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
