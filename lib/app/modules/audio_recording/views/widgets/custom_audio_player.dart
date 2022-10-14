import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';

import '../../../../config/colors.dart';

class CustomAudioPlayer extends StatefulWidget {
  final String path;
  final int duration;
  const CustomAudioPlayer(
      {super.key, required this.path, required this.duration});

  @override
  State<CustomAudioPlayer> createState() => _CustomAudioPlayerState();
}

class _CustomAudioPlayerState extends State<CustomAudioPlayer> {
  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
  bool _isPlaying = false;
  bool _mPlayerIsInited = false;
  double volume = 0.5;
  StreamSubscription? _mPlayerSubscription;
  int _mSubscriptionDuration = 0;
  int pos = 0;
  @override
  void initState() {
    _mPlayer!.openPlayer().then((value) {
      setState(() {
        _mPlayerIsInited = true;
      });
      _mPlayerSubscription = _mPlayer!.onProgress!.listen((e) {
        setState(() {
          _mSubscriptionDuration = e.duration.inMilliseconds;
          pos = e.position.inMilliseconds;
        });
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _mPlayer!.closePlayer();
    _mPlayer = null;
    if (_mPlayerSubscription != null) {
      _mPlayerSubscription!.cancel();
      _mPlayerSubscription = null;
    }
    super.dispose();
  }

  void play() {
    // assert(_mPlayerIsInited);
    setState(() {
      _isPlaying = true;
      pos = 0;
    });

    if (!_mPlayer!.isPaused) {
      _mPlayer!
          .startPlayer(
              fromURI: widget.path,
              //codec: kIsWeb ? Codec.opusWebM : Codec.aacADTS,
              whenFinished: () {
                setState(() {
                  _isPlaying = false;
                });
              })
          .then((value) {
        // setState(() {
        //   _isPlaying = false;
        // });
      });
    } else {
      _mPlayer!.resumePlayer().then((value) {
        setState(() {});
      });
    }
  }

  void stopPlayer() {
    _isPlaying = false;
    _mPlayer!.stopPlayer().then((value) {
      setState(() {
        pos = 0;
        _isPlaying = false;
      });
    });
  }

  void pausePlayer() {
    _isPlaying = false;
    _mPlayer!.pausePlayer().then((value) {
      setState(() {});
    });
  }

  void setVolume(double value) {
    if (_mPlayerIsInited && _mPlayer != null) {
      _mPlayer!.setVolume(value);
      volume = value;
      setState(() {});
    }
  }

  void forward10Seconds() {
    if (_mPlayer == null) {
      return;
    }
    if (!_isPlaying) {
      return;
    }
    if (pos + 10000 > _mSubscriptionDuration) {
      stopPlayer();
      return;
    }
    _mPlayer!.seekToPlayer(Duration(milliseconds: (pos + 10000)));
    log(pos.toString());
  }

  void back10Seconds() {
    if (_mPlayer == null) {
      return;
    }
    if (!_isPlaying) {
      return;
    }
    if (pos - 10000 < 0) {
      _mPlayer!.seekToPlayer(const Duration(milliseconds: 0));
      pos = 0;
      return;
    }
    _mPlayer!.seekToPlayer(Duration(milliseconds: (pos - 10000)));
    log(pos.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                onPressed: back10Seconds,
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(3.142),
                  child: const Icon(
                    Icons.forward_10_rounded,
                    size: 35,
                    color: Colors.black,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _isPlaying ? pausePlayer() : play();
                },
                child: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                  size: 60,
                ),
              ),
              TextButton(
                onPressed: forward10Seconds,
                child: const Icon(
                  Icons.forward_10_rounded,
                  size: 35,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            SizedBox(
              width: 40,
              child: TextButton(
                onPressed: () => setVolume(0),
                child: const Icon(
                  Icons.volume_mute,
                  color: AppColors.grey,
                ),
              ),
            ),
            Expanded(
              child: Slider(
                value: volume,
                onChanged: (value) => setVolume(value),
                activeColor: AppColors.grey,
                inactiveColor: AppColors.lightGrey,
                thumbColor: AppColors.white,
              ),
            ),
            SizedBox(
              width: 40,
              child: TextButton(
                onPressed: () => setVolume(1.0),
                child: const Icon(
                  Icons.volume_up,
                  color: AppColors.grey,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
