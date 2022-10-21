import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/config/text_styles.dart';
import 'package:qualnote/app/modules/home/controllers/home_controller.dart';

class TabSwitch extends StatelessWidget {
  TabSwitch({
    Key? key,
  }) : super(key: key);
  final homeController = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      margin: const EdgeInsets.only(top: 15, bottom: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.blueText, width: 1),
      ),
      child: Obx(
        () => Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => homeController.togglePublicCatalogue(false),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      bottomLeft: Radius.circular(4),
                    ),
                    border: Border.all(color: AppColors.blueText, width: 1),
                    color: homeController.isPublicCatalogue.value
                        ? AppColors.white
                        : AppColors.blueText,
                  ),
                  child: Center(
                    child: Text(
                      'Show all My Files',
                      style: !homeController.isPublicCatalogue.value
                          ? AppTextStyle.regular13White
                          : AppTextStyle.regular13Blue,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => homeController.togglePublicCatalogue(true),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(4),
                      bottomRight: Radius.circular(4),
                    ),
                    border: Border.all(color: AppColors.blueText, width: 1),
                    color: !homeController.isPublicCatalogue.value
                        ? AppColors.white
                        : AppColors.blueText,
                  ),
                  child: Center(
                    child: Text(
                      'Show Public Catalogue',
                      style: homeController.isPublicCatalogue.value
                          ? AppTextStyle.regular13White
                          : AppTextStyle.regular13Blue,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
