import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/config/text_styles.dart';
import 'package:qualnote/app/modules/authentication/login/views/widgets/page_holder.dart';
import 'package:qualnote/app/modules/dialogs/record_method_dialog.dart';
import 'package:qualnote/app/modules/home/views/widgets/add_button.dart';
import 'package:qualnote/app/modules/home/views/widgets/home_search.dart';
import 'package:qualnote/app/modules/home/views/widgets/tab_switch.dart';
import 'package:qualnote/app/routes/app_pages.dart';

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
                FirebaseAuth.instance.signOut();
                Get.toNamed(Routes.LOGIN);
              },
              child: SizedBox(
                width: 100,
                child: Row(
                  children: const [
                    Icon(
                      Icons.keyboard_arrow_left_outlined,
                      color: AppColors.blueText,
                      size: 40,
                    ),
                    Text(
                      'back',
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
              Get.toNamed(Routes.AUDIO_RECORDING);
            },
            title: 'Upload docx pdf to My Files',
          ),
          AddButton(
            onPressed: () {},
            title: 'Open from My Files (below)',
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {},
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.folder_outlined,
                        size: 25,
                        color: AppColors.black,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          'Example map project',
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
          )
        ],
      ),
    );
  }
}
