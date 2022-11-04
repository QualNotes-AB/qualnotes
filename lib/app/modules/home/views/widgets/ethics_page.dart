import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/config/text_styles.dart';
import 'package:qualnote/app/modules/authentication/login/views/widgets/page_holder.dart';
import 'package:qualnote/app/modules/map/views/consent_view.dart';
import 'package:qualnote/app/utils/note_type.dart';

class EthicsPage extends StatelessWidget {
  const EthicsPage({required this.noteType, super.key});
  final NoteType noteType;

  @override
  Widget build(BuildContext context) {
    return PageHolder(
      child: SafeArea(
        child: Column(
          children: [
            Center(
              child: Image.asset('assets/images/ethics.png'),
            ),
            TextButton(
              onPressed: () => Get.off(() => ConsentView(noteType: noteType)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Continue',
                    style: AppTextStyle.regular17Blue,
                  ),
                  Icon(
                    Icons.keyboard_arrow_right_rounded,
                    size: 30,
                    color: AppColors.blue,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
