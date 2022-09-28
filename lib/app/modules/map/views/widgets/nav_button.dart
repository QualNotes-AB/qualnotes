import 'package:flutter/material.dart';
import 'package:qualnote/app/config/text_styles.dart';

class NavButton extends StatelessWidget {
  final Function() onPressed;
  final String title;
  final Widget icon;
  const NavButton({
    Key? key,
    required this.onPressed,
    required this.title,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            icon,
            Text(
              title,
              style: AppTextStyle.regular16White,
            ),
          ],
        ),
      ),
    );
  }
}
