import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/config/text_styles.dart';
import 'package:qualnote/app/modules/audio_recording/controllers/audio_recording_controller.dart';
import 'package:qualnote/app/modules/map/controllers/add_media_controller.dart';
import 'package:qualnote/app/modules/map/views/widgets/blue_text_button.dart';
import 'package:qualnote/app/routes/app_pages.dart';
import 'package:qualnote/app/utils/note_type.dart';
import 'package:screenshot/screenshot.dart';
import 'package:signature/signature.dart';

/// example widget showing how to use signature widget
class ConsentView extends StatefulWidget {
  final NoteType noteType;
  const ConsentView({super.key, required this.noteType});

  @override
  _ConsentViewState createState() => _ConsentViewState();
}

class _ConsentViewState extends State<ConsentView> {
  bool isContinue = false;
  bool audioConsent = false;
  final addMediaController = Get.find<AddMediaController>();
  final ScreenshotController _screenshotController = ScreenshotController();
  final SignatureController _controllerParticipant = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.blue[900]!,
    exportBackgroundColor: Colors.white,
    exportPenColor: Colors.blue[900],
  );
  final SignatureController _controllerResearcher = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.blue[900]!,
    exportBackgroundColor: Colors.white,
    exportPenColor: Colors.blue[900],
  );

  Future<void> exportImage(BuildContext context) async {
    if (audioConsent) {
      Get.back();
      if (widget.noteType == NoteType.audio) {
        addMediaController.addAudioNote();
        return;
      }
      if (widget.noteType == NoteType.video) {
        addMediaController.addVideoNote();
      }
      return;
    }
    setState(() {
      isContinue = true;
    });
    await Future.delayed(const Duration(milliseconds: 150));
    final data = await _screenshotController.capture();
    await addMediaController.savePhotoConsent(data);
    Get.back();
    if (widget.noteType == NoteType.audio) {
      addMediaController.addAudioNote();
      return;
    }
    if (widget.noteType == NoteType.video) {
      addMediaController.addVideoNote();
    }
  }

  @override
  void dispose() {
    _controllerResearcher.dispose();
    _controllerParticipant.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Stack(
              children: [
                Screenshot(
                    controller: _screenshotController,
                    child: buildConsentDocument()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column buildConsentDocument() {
    return Column(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.grey[350]!,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                const Text(
                  'I understand that I am providing consent to participte in this study.',
                  style: AppTextStyle.semiBold16Black,
                ),
                const Text(
                  'I have been informed about the purpose of the research.',
                  style: AppTextStyle.semiBold16Black,
                ),
                const Text(
                  'I agree that my participation is audio/video recorded.',
                  style: AppTextStyle.semiBold16Black,
                ),
                const Text(
                  'Signature of participant',
                  style: AppTextStyle.semiBold16Black,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Signature(
                            controller: _controllerParticipant,
                            height: 100,
                            backgroundColor: Colors.grey[350]!,
                          ),
                        ),
                        Visibility(
                          visible: !isContinue,
                          child: IconButton(
                            icon: const Icon(Icons.delete_outline_rounded),
                            color: Colors.red,
                            onPressed: () {
                              setState(() => _controllerParticipant.clear());
                            },
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Divider(
                        height: 2,
                        thickness: 1,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const Text(
                  'Signature of researcher',
                  style: AppTextStyle.semiBold16Black,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Signature(
                            controller: _controllerResearcher,
                            height: 100,
                            backgroundColor: Colors.grey[350]!,
                          ),
                        ),
                        Visibility(
                          visible: !isContinue,
                          child: IconButton(
                            icon: const Icon(Icons.delete_outline_rounded),
                            color: Colors.red,
                            onPressed: () {
                              setState(() => _controllerResearcher.clear());
                            },
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Divider(
                        height: 2,
                        thickness: 1,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const Text(
                  'DATE / CITY',
                  style: AppTextStyle.semiBold16Black,
                ),
                const TextField(),
              ],
            ),
          ),
        ),
        buildBottomButtons()
      ],
    );
  }

  Padding buildBottomButtons() {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          BlueTextButton(
            title: 'RECORD ORAL CONSENT',
            onPressed: () {
              Get.find<AudioRecordingController>().isConsent = true;
              setState(() {
                audioConsent = true;
              });
              Get.toNamed(Routes.AUDIO_RECORDING);
            },
          ),
          BlueTextButton(
            title: 'CONTINUE',
            onPressed: () => exportImage(context),
          ),
        ],
      ),
    );
  }
}
