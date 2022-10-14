import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qualnote/app/data/models/note.dart';
import 'package:qualnote/app/modules/audio_recording/views/widgets/audio_recorder.dart';
import 'package:qualnote/app/modules/map/controllers/add_media_controller.dart';
import 'package:qualnote/app/modules/map/controllers/map_controller.dart';
import 'package:qualnote/app/utils/note_type.dart';

class AudioRecordingController extends GetxController {
  final AddMediaController mediaController = Get.find<AddMediaController>();
  RxString audioPath = ''.obs;
  RxString title = ''.obs;
  RxString description = ''.obs;
  LatLng location = LatLng(0, 0);
  RxInt duration = 0.obs;
  RxInt mainDuration = 0.obs;
  Timer _timer = Timer(const Duration(days: 1), () {});
  Codec _codec = Codec.aacMP4;
  String _mainPath = '';
  FlutterSoundRecorder? mRecorder = FlutterSoundRecorder();
  bool mRecorderIsInited = false;
  RxBool isRecording = false.obs;
  bool isConsent = false;
  bool isRetake = false;
  List<String> audioPaths = [];
  late Directory appDocDir;

  Future<void> saveAudioPath(File file, int duration) async {
    if (file.path != audioPath.value) {
      await mediaController.addNote(
        newNote: Note(
          title: title.value,
          path: file.path,
          duration: duration,
          type: NoteType.audio.toString(),
        ),
      );
      return;
    }
    mediaController.updateNote(title.value, description.value, duration);
  }

  void saveAudioDetails() {
    if (description.isEmpty) {
      Get.back();
      return;
    }
    mediaController.updateNote(title.value, description.value, duration.value);
    resetFields();
    Get.back();
  }

  void selectAudioNote(Note audioNote) {
    audioPath.value = audioNote.path!;
    title.value = audioNote.title!;
    description.value = audioNote.description ?? '';
    location = audioNote.coordinate!.toLatLng();
    duration.value = audioNote.duration!;
    // hasConsent.value = audioNote.hasConsent!;
  }

  void resetFields() {
    audioPath.value = '';
    title.value = '';
    description.value = '';
    location = LatLng(0, 0);
    duration.value = 0;
  }

  void pause() async {
    if (mRecorder != null && mRecorder!.isRecording) {
      await mRecorder!.pauseRecorder();
      _timer.cancel();
    }
  }

  void resume() async {
    if (mRecorder != null && mRecorder!.isPaused) {
      await mRecorder!.resumeRecorder();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        mainDuration.value++;
      });
    }
  }

  void startRecorder({bool isMainRecording = false}) {
    if (!mRecorderIsInited) {
      return;
    }
    if (isMainRecording) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        mainDuration.value++;
      });
    } else {
      duration.value = 0;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        duration.value++;
      });
      isRecording.value = true;
    }
    if (!isRetake) {
      title.value = 'audio${dateFormat.format(DateTime.now())}';
      _mainPath = '${appDocDir.path}/${title.value}.mp4'.removeAllWhitespace;
    }
    mRecorder!.startRecorder(
      toFile: _mainPath,
      codec: _codec,
      audioSource: theSource,
    );
    isRetake = false;
  }

  Future<void> stopRecorder({bool isFinish = false}) async {
    if (Get.find<MapGetxController>().type.value == RecordingType.audio) {
      return;
    }
    if (mRecorder != null) {
      _timer.cancel();
      isRecording.value = false;
      await mRecorder!.stopRecorder().then((value) async {
        log(_mainPath);
        if (isConsent) {
          mediaController.saveAudioConsent(_mainPath);
          _timer.cancel();
          isConsent = false;
          Get.back();
          return;
        }
        if (isFinish) {
          _timer.cancel();
          audioPaths.add(_mainPath);
          return;
        }
        await saveAudioPath(File(_mainPath), duration.value);
        Get.back();
        if (Get.find<MapGetxController>().type.value == RecordingType.audio) {
          startRecorder(isMainRecording: true);
        }
      });
    }
  }

  void resetRecorder() {
    mainDuration.value = 0;
    _timer.cancel();
  }

  Future<void> openTheRecorder() async {
    appDocDir = await getApplicationDocumentsDirectory();
    title.value = 'audio${dateFormat.format(DateTime.now())}';
    _mainPath = audioPath.isEmpty
        ? '${appDocDir.path}/audio/${title.value}.mp4'.removeAllWhitespace
        : audioPath.value;
    mRecorder = FlutterSoundRecorder();
    await mRecorder!.openRecorder();
    if (!await mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
      _codec = Codec.opusWebM;
      if (!await mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
        mRecorderIsInited = true;
        return;
      }
    }
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.allowBluetooth |
              AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
          AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));

    mRecorderIsInited = true;
  }

  @override
  void onClose() {
    mRecorderIsInited = false;
    isRecording.value = false;
    _timer.cancel();
    super.onClose();
  }
}
