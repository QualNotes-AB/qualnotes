import 'package:flutter/material.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/config/text_styles.dart';

class CustomCheckboxTile extends StatelessWidget {
  final String title;
  final Function() onPressed;
  final Function(bool?) onCheckbox;
  final bool value;
  const CustomCheckboxTile({
    Key? key,
    required this.title,
    required this.onPressed,
    required this.onCheckbox,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: TextButton(
        onPressed: onPressed,
        style: const ButtonStyle(
            padding: MaterialStatePropertyAll(EdgeInsets.zero)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
              width: 30,
              child: Checkbox(
                value: value,
                onChanged: onCheckbox,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                side: BorderSide(
                  color: value ? AppColors.blueText : AppColors.red,
                ),
              ),
            ),
            Text(
              title,
              style: AppTextStyle.regular14GreyHeight,
            ),
          ],
        ),
      ),
    );
  }
}
