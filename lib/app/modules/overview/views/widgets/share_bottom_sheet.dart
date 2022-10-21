import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/config/text_styles.dart';
import 'package:qualnote/app/data/models/project.dart';
import 'package:qualnote/app/data/services/firestore_db.dart';
import 'package:qualnote/app/data/services/internet_availability.dart';
import 'package:qualnote/app/modules/overview/controllers/overview_controller.dart';

final standardDate = DateFormat('yyyy.M.d');

class ShareBottomSheet extends StatefulWidget {
  const ShareBottomSheet({
    Key? key,
    required this.project,
  }) : super(key: key);

  final Project project;

  @override
  State<ShareBottomSheet> createState() => _ShareBottomSheetState();
}

class _ShareBottomSheetState extends State<ShareBottomSheet> {
  final controller = Get.find<OverviewController>();
  String email = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: kIsWeb
          ? EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 4)
          : EdgeInsets.zero,
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
      decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 5,
                width: 120,
                margin: const EdgeInsets.only(top: 5, bottom: 20),
                color: AppColors.grey,
              ),
            ],
          ),
          Text(
            widget.project.title!,
            style: AppTextStyle.regular20Black,
          ),
          Text(
            "by ${widget.project.author!} on ${standardDate.format(widget.project.date!)}",
            style: AppTextStyle.regular14BlackHeight,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              'Send to',
              style: AppTextStyle.semiBold13Black,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value) => email = value,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.grey)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.grey)),
                    hintText: 'Email',
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                  if (email.isEmpty || !email.isEmail) return;
                  if (!Get.find<InternetAvailability>().isConnected.value) {
                    Get.snackbar(
                      'Something went wrong',
                      "Check you internet connection",
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                  try {
                    List<String> emails = widget.project.collaborators ??= [];
                    emails.add(email);
                    Get.find<FirebaseDatabase>()
                        .addCollaborator(widget.project.id!, emails);

                    Get.snackbar(
                      'Hooray!',
                      'Project sent to $email',
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                  } on Exception catch (e) {
                    log(e.toString());
                    Get.snackbar(
                      'Failed!',
                      'Something went wrong, first upload the project then share it',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                },
                child: const Text('Send'),
              )
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'Or share a link',
              style: AppTextStyle.semiBold13Black,
            ),
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 20),
                child: Icon(Icons.link),
              ),
              Expanded(
                child: Obx(
                  () => SelectableText(controller.link.isEmpty
                      ? 'No link created yet'
                      : controller.link.value),
                ),
              ),
              TextButton(
                onPressed: () => controller.createShareLink(),
                child: const Text('Create a link'),
              )
            ],
          ),
        ],
      ),
    );
  }
}
