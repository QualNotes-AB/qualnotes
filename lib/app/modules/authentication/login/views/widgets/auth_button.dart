import 'package:flutter/material.dart';
import 'package:qualnote/app/config/text_styles.dart';

class AuthButton extends StatelessWidget {
  final String title;
  final Color color;
  final EdgeInsets? padding;
  final Function() onPress;
  final Widget? icon;

  const AuthButton({
    Key? key,
    required this.title,
    required this.color,
    this.padding,
    this.icon,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(top: 20, bottom: 15),
      child: SizedBox(
        height: 52,
        child: ElevatedButton(
          onPressed: onPress,
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(color),
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            elevation: const MaterialStatePropertyAll(0),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon ?? const SizedBox(),
                Text(
                  title,
                  style: AppTextStyle.semiBold16White,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
