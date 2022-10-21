import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/config/text_styles.dart';
import 'package:qualnote/app/data/models/note.dart';
import 'package:qualnote/app/modules/audio_recording/views/widgets/custom_audio_player.dart';
import 'package:qualnote/app/modules/camera/view/video_player.dart';
import 'package:qualnote/app/modules/map/controllers/map_controller.dart';
import 'package:qualnote/app/modules/map/views/widgets/blue_text_button.dart';
import 'package:qualnote/app/utils/note_type.dart';
import 'package:qualnote/app/utils/open_file/open_file_interface.dart';

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
    log(note.path ?? 'null');
    return SafeArea(
      child: Container(
        margin: kIsWeb
            ? EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 4)
            : EdgeInsets.zero,
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
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
                    TextField(
                      controller: TextEditingController(
                          text: note.noteTitle ?? 'Note title'),
                      onChanged: (value) =>
                          mapGetxController.updateNoteTitle(value, index),
                      maxLines: 2,
                      autocorrect: false,
                      style: AppTextStyle.medium22Black,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(0)),
                      scrollPadding: EdgeInsets.zero,
                    ),
                    // Text(
                    //   note.title!,
                    //   style: AppTextStyle.medium22Black,
                    // ),
                    Text(
                      'by ${note.author} on ${date.format(mapGetxController.selectedProject.date ?? DateTime.now())}',
                      style: AppTextStyle.regular12Black,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Visibility(
                            visible: true,
                            child: BlueTextButton(
                              title: 'Prev',
                              onPressed: () => mapGetxController.openRecording(
                                  index: index,
                                  isMainRecording: true,
                                  forward: false),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              note.type != NoteType.text.toString()
                                  ? Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: BlueTextButton(
                                        title: 'Open file',
                                        onPressed: () async {
                                          if (note.path != null) {
                                            OpenFileUtil().openFile(note.path!);
                                          }
                                        },
                                      ),
                                    )
                                  : const SizedBox(),
                              Text(
                                  '${index + 1}/${mapGetxController.notes.length}  '),
                              Visibility(
                                visible:
                                    index != mapGetxController.notes.length,
                                child: BlueTextButton(
                                  title: 'Next',
                                  onPressed: () =>
                                      mapGetxController.openRecording(
                                          index: index,
                                          isMainRecording: true,
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
                      child: displayMedia(),
                    ),
                    const Text('Notes:', style: AppTextStyle.semiBold13Black),
                    TextField(
                      controller: TextEditingController(text: note.description),
                      minLines: 3,
                      maxLines: 10,
                      autocorrect: false,
                      onChanged: (value) =>
                          mapGetxController.updateNoteDescription(value, index),
                      style: AppTextStyle.regular13BlackHeight,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
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

  Widget displayMedia() {
    if (note.type == NoteType.text.toString()) {
      return const SizedBox();
    }
    if (note.path == null) {
      return const Center(
        child: Text('File unavailable'),
      );
    }
    if (note.type == NoteType.photo.toString()) {
      return kIsWeb ? Image.network(note.path!) : Image.file(File(note.path!));
    }
    if (kIsWeb) {
      return const SizedBox();
    }
    if (note.type == NoteType.document.toString() || kIsWeb) {}
    if (note.type == NoteType.video.toString()) {
      return VideoPlayerWidget(path: note.path!);
    }
    if (note.type == NoteType.audio.toString()) {
      return CustomAudioPlayer(path: note.path!, duration: 30);
    }
    return const SizedBox();
  }
}
