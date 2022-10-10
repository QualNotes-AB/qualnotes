import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/config/text_styles.dart';
import 'package:qualnote/app/modules/audio_recording/views/widgets/audio_list_tile.dart';
import 'package:qualnote/app/modules/audio_recording/views/widgets/audio_recorder.dart';
import 'package:qualnote/app/modules/home/views/widgets/home_search.dart';

import '../controllers/audio_recording_controller.dart';

class AudioRecordingView extends GetView<AudioRecordingController> {
  const AudioRecordingView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Transform.translate(
                        offset: const Offset(-10, 0),
                        child: SizedBox(
                          width: 50,
                          child: TextButton(
                            onPressed: () => Get.back(),
                            style: const ButtonStyle(
                              padding: MaterialStatePropertyAll(
                                EdgeInsets.only(right: 15),
                              ),
                            ),
                            child: const Icon(
                              Icons.keyboard_arrow_left_rounded,
                              size: 40,
                              color: AppColors.blueText,
                            ),
                          ),
                        ),
                      ),
                      const Text(
                        'Edit',
                        style: AppTextStyle.regular17Blue,
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      'All Recordings',
                      style: AppTextStyle.bold32Black,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: HomeSearch(),
                  ),
                  ListView(
                    shrinkWrap: true,
                    children: const [AudioListTile()],
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 70,
                color: AppColors.lightGrey,
                child: const Center(
                  child: SimpleRecorder(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
