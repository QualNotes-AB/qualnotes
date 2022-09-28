import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/config/text_styles.dart';
import 'package:qualnote/app/modules/authentication/login/views/widgets/page_holder.dart';
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
          AddButton(
            onPressed: () => Get.dialog(Dialog(
              insetPadding: EdgeInsets.zero,
              backgroundColor: AppColors.popupGrey,
              child: SizedBox(
                height: 260,
                width: 260,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20, left: 15),
                      child: Row(
                        children: const [
                          Text(
                            'Which method will use?',
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.lightGrey,
                    ),
                    TextButton(
                      onPressed: () {
                        Get.back();
                        Get.toNamed(Routes.MAP);
                      },
                      child: const Center(
                        child: Text(
                          'New Mobile Mapping',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const Divider(
                        height: 1, thickness: 1, color: AppColors.lightGrey),
                    TextButton(
                      onPressed: () {},
                      child: const Center(
                        child: Text(
                          'New Interview / Focus Gorup\n(coming soon..)',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const Divider(
                        height: 1, thickness: 1, color: AppColors.lightGrey),
                    TextButton(
                      onPressed: () {},
                      child: const Center(
                        child: Text(
                          'New Participant Observation / Autoethnography\n(coming soon..)',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
            title: 'New Qual Notes Project',
          ),
          AddButton(
            onPressed: () {},
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

class AddButton extends StatelessWidget {
  final String title;
  final Function() onPressed;

  const AddButton({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: TextButton(
        onPressed: onPressed,
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.add_circle_outline,
                size: 22,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 2),
                child: Text(title),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeSearch extends StatelessWidget {
  const HomeSearch({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.grey30,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Icon(
              Icons.search,
              color: AppColors.grey,
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search',
                  contentPadding: EdgeInsets.only(bottom: 12, left: 5),
                ),
                style: AppTextStyle.regular16DarkGrey,
              ),
            ),
            Icon(
              Icons.mic,
              color: AppColors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

class TabSwitch extends StatelessWidget {
  const TabSwitch({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      margin: const EdgeInsets.only(top: 15, bottom: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.blueText, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  bottomLeft: Radius.circular(4),
                ),
                border: Border.all(color: AppColors.blueText, width: 1),
                color: AppColors.blueText,
              ),
              child: const Center(
                child: Text(
                  'Show all My Files',
                  style: AppTextStyle.regular13White,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
                border: Border.all(color: AppColors.blueText, width: 1),
                color: AppColors.white,
              ),
              child: const Center(
                child: Text(
                  'Show Public Catalogue',
                  style: AppTextStyle.regular13Blue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
