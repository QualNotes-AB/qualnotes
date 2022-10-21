import 'package:flutter/material.dart';

class BlueOverviewButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function()? onPressed;
  const BlueOverviewButton({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title),
              Icon(
                icon,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}