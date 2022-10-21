import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/modules/map/controllers/map_controller.dart';
import 'package:qualnote/app/modules/map/views/widgets/preview_navbar.dart';

import 'recording_navbar.dart';

class NavBar extends StatelessWidget {
  NavBar({
    Key? key,
  }) : super(key: key);

  final mapGetxController = Get.find<MapGetxController>();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 82,
        width: MediaQuery.of(context).size.width > 500
            ? 500
            : MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: AppColors.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: Center(
          child: mapGetxController.isPreview.value || kIsWeb
              ? PreviewNavbar(mapGetxController: mapGetxController)
              : RecordingNavBar(mapGetxController: mapGetxController),
        ),
      ),
    );
  }
}
