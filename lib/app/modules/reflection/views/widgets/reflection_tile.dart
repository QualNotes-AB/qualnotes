import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/config/text_styles.dart';

final dateFromat = DateFormat('yyyy.M.d');
final timeFormat = DateFormat('h:mm a');

class ReflectionNoteTile extends StatelessWidget {
  final String text;
  final DateTime time;
  final String author;
  const ReflectionNoteTile({
    Key? key,
    required this.text,
    required this.time,
    required this.author,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      padding: const EdgeInsets.only(top: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                author,
                style: AppTextStyle.bold12Grey,
              ),
              Text(
                dateFromat.format(time) + ' at ' + timeFormat.format(time),
                style: AppTextStyle.bold12Grey,
              ),
            ],
          ),
          const Divider(
            color: AppColors.blueText,
            thickness: 1,
          ),
          Text(
            text,
            style: AppTextStyle.regular14BlackHeight,
            textAlign: TextAlign.end,
          )
        ],
      ),
    );
  }
}
