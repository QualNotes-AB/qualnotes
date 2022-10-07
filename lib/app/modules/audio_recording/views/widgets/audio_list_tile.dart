import 'package:flutter/material.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/config/text_styles.dart';

class AudioListTile extends StatelessWidget {
  const AudioListTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(
          height: 30,
          thickness: 1,
          color: AppColors.lightGrey,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            'New Recording 35',
            style: AppTextStyle.semiBold16Black,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Tuesday',
                style: AppTextStyle.regular14Grey,
              ),
              Text(
                '00:04',
                style: AppTextStyle.regular14Grey,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
