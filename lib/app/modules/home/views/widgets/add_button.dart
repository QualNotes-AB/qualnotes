import 'package:flutter/material.dart';

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