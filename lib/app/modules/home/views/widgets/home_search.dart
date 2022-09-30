import 'package:flutter/material.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/config/text_styles.dart';

class HomeSearch extends StatelessWidget {
  const HomeSearch({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.grey30,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Icon(
              Icons.search,
              color: AppColors.grey,
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search',
                  contentPadding: EdgeInsets.only(bottom: 12, left: 5),
                ),
                style: AppTextStyle.regular16DarkGrey,
              ),
            ),
            Icon(
              Icons.mic,
              color: AppColors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
