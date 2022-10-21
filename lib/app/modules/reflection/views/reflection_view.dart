import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/config/text_styles.dart';
import 'package:qualnote/app/modules/authentication/login/views/widgets/page_holder.dart';
import 'package:qualnote/app/modules/reflection/views/widgets/reflection_tile.dart';
import 'package:qualnote/app/routes/app_pages.dart';

import '../controllers/reflection_controller.dart';

final dateFromat = DateFormat('yyyy.M.d');
final timeFormat = DateFormat('h:mm a');

class ReflectionView extends GetView<ReflectionController> {
  const ReflectionView({Key? key}) : super(key: key);
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
                width: 200,
                child: TextButton(
                  onPressed: () => Get.offAllNamed(Routes.HOME),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.keyboard_arrow_left_outlined,
                        size: 30,
                      ),
                      Text('Back to Main Menu'),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: TextButton(
                    onPressed: () => controller.addReflectionNote(),
                    child: const Icon(
                      Icons.add_circle,
                      color: AppColors.blueText,
                      size: 50,
                    ),
                    style: const ButtonStyle(
                        padding: MaterialStatePropertyAll(EdgeInsets.zero)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Obx(
                    () => Text(
                      dateFromat.format(DateTime.now()) +
                          ' at ' +
                          timeFormat.format(controller.dateTime.value),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 65),
              child: SizedBox(
                height: 140,
                width: double.infinity,
                child: TextField(
                  controller: controller.textEditingController,
                  onChanged: (value) => controller.text = value,
                  minLines: 1,
                  maxLines: 6,
                  autocorrect: false,
                  style: AppTextStyle.regular16DarkGrey,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(0)),
                  scrollPadding: EdgeInsets.zero,
                ),
              ),
            ),
            Obx(
              () => ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.reflectionNotes.length,
                  itemBuilder: (context, index) {
                    final note = controller.reflectionNotes[index];
                    return ReflectionNoteTile(
                      author: note.author ?? 'Anonymous',
                      text: note.description ?? '',
                      time: note.date ?? DateTime.now(),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
