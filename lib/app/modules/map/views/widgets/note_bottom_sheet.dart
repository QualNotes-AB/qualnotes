import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/config/text_styles.dart';
import 'package:qualnote/app/data/models/note.dart';
import 'package:qualnote/app/modules/audio_recording/views/widgets/custom_audio_player.dart';
import 'package:qualnote/app/modules/camera/view/video_player.dart';
import 'package:qualnote/app/modules/map/controllers/map_controller.dart';
import 'package:qualnote/app/modules/map/views/widgets/blue_text_button.dart';
import 'package:qualnote/app/utils/note_type.dart';

class NoteBottomSheet extends StatelessWidget {
  final Note note;
  final int index;
  NoteBottomSheet({
    Key? key,
    required this.note,
    required this.index,
  }) : super(key: key);
  final MapGetxController mapGetxController = Get.find<MapGetxController>();
  final date = DateFormat('dd.MM.yyyy');
  @override
  Widget build(BuildContext context) {
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
                    Text(
                      note.title!,
                      style: AppTextStyle.medium22Black,
                    ),
                    Text(
                      'by ${note.author} on ${date.format(mapGetxController.selectedProject.date!)}',
                      style: AppTextStyle.regular12Black,
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
                              onPressed: () =>
                                  mapGetxController.previousNote(index),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                  '${index + 1}/${mapGetxController.notes.length}  '),
                              Visibility(
                                visible:
                                    index != mapGetxController.notes.length - 1,
                                child: BlueTextButton(
                                  title: 'Next',
                                  onPressed: () =>
                                      mapGetxController.nextNote(index),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: note.type == NoteType.photo.toString()
                          ? note.path == null
                              ? const Text('Image not found')
                              : Image.file(File(note.path!))
                          : note.type == NoteType.audio.toString()
                              ? note.path == null
                                  ? const Text('Audio not found')
                                  : CustomAudioPlayer(
                                      path: note.path!, duration: 30)
                              : note.type == NoteType.video.toString()
                                  ? VideoPlayerWidget(path: note.path!)
                                  : note.type == NoteType.document.toString()
                                      ? BlueTextButton(
                                          title: 'Open file',
                                          onPressed: () async {
                                            //For mobile open file
                                            var result =
                                                await OpenFile.open(note.path);
                                            print(note.path);
                                            print(result.message);
                                            //For web download file
                                          },
                                        )
                                      : const SizedBox(),
                    ),
                    RichText(
                        text: TextSpan(children: [
                      const TextSpan(
                          text: 'Notes: ', style: AppTextStyle.semiBold13Black),
                      TextSpan(
                        text: note.description,
                        style: AppTextStyle.regular13BlackHeight,
                      )
                    ])),
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
