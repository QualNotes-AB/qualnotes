import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/config/text_styles.dart';
import 'package:qualnote/app/modules/audio_recording/views/widgets/custom_audio_player.dart';
import 'package:qualnote/app/modules/camera/view/video_player.dart';
import 'package:qualnote/app/modules/map/controllers/map_controller.dart';
import 'package:qualnote/app/modules/map/views/widgets/blue_text_button.dart';

class MainRecordingBottomSheet extends StatelessWidget {
  final bool isAudio;
  final int index;
  final String path;
  MainRecordingBottomSheet({
    Key? key,
    required this.isAudio,
    required this.index,
    required this.path,
  }) : super(key: key);
  final MapGetxController mapGetxController = Get.find<MapGetxController>();
  final date = DateFormat('dd.MM.yyyy');
  @override
  Widget build(BuildContext context) {
    log(path);
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 30),
        decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        child: Column(
          children: [
            Container(
              height: 5,
              width: 120,
              margin: const EdgeInsets.only(top: 5, bottom: 20),
              color: AppColors.grey,
            ),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Route Recording',
                      style: AppTextStyle.medium22Black,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Visibility(
                            visible: index != 0,
                            child: BlueTextButton(
                              title: 'Prev',
                              onPressed: () => mapGetxController.openRecording(
                                  index: index,
                                  isMainRecording: false,
                                  forward: false),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Visibility(
                                visible:
                                    index != mapGetxController.notes.length,
                                child: BlueTextButton(
                                  title: 'Next',
                                  onPressed: () =>
                                      mapGetxController.openRecording(
                                          index: index,
                                          isMainRecording: false,
                                          forward: true),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: isAudio
                          ? CustomAudioPlayer(path: path, duration: 0)
                          : VideoPlayerWidget(path: path),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
