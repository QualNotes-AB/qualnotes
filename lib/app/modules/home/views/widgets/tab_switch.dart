import 'package:flutter/material.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/config/text_styles.dart';

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
