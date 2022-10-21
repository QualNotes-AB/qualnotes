import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/config/text_styles.dart';
import 'package:qualnote/app/modules/map/controllers/map_controller.dart';

Future<int> noteNumberDialog() async {
  String? index;
  final mapController = Get.find<MapGetxController>();
  await Get.dialog(
      Dialog(
        alignment: Alignment.bottomCenter,
        insetPadding: EdgeInsets.zero,
        backgroundColor: AppColors.popupGrey,
        child: Container(
          width: 300,
          height: 180,
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'In which position will this note be in sequence?\n(first, second, third,...)',
                style: AppTextStyle.semiBold13Black,
              ),
              Expanded(
                child: TextFormField(
                  onChanged: (value) => index = value,
                  autocorrect: false,
                  validator: (value) {
                    if (int.parse(value!) <= mapController.notes.length + 1) {
                      return null;
                    }
                    return '';
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 20),
                    hintText: 'Enter the positon',
                  ),
                ),
              ),
              const Divider(
                height: 1,
                thickness: 1,
                color: AppColors.lightGrey,
              ),
              Expanded(
                child: TextButton(
                  onPressed: () async {
                    Get.back();
                  },
                  child: const Center(
                    child: Text('Add note'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierColor: Colors.transparent,
      barrierDismissible: false);
  //if the element is n-th the index will be n-1
  return int.parse(index ?? '0') - 1;
}
