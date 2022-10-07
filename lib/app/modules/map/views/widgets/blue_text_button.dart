import 'package:flutter/material.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/config/text_styles.dart';

class BlueTextButton extends StatelessWidget {
  final String title;
  final Function()? onPressed;
  const BlueTextButton({
    Key? key,
    required this.title,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: 30,
          child: OutlinedButton(
            onPressed: onPressed,
            style: ButtonStyle(
              side: const MaterialStatePropertyAll(
                BorderSide(
                  color: AppColors.blueText,
                ),
              ),
              shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            child: Center(
              child: Text(
                title,
                style: AppTextStyle.regular13Blue,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
