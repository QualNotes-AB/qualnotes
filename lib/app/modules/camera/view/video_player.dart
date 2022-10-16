import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:video_player/video_player.dart';

/// Stateful widget to fetch and then display video content.
class VideoPlayerPage extends StatefulWidget {
  final String path;
  const VideoPlayerPage({Key? key, required this.path}) : super(key: key);

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.path))
      ..initialize().then((_) {
        setState(() {});
      });
    _controller.addListener(() {
      _controller.value.isPlaying ? setState(() {}) : setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.removeListener(() {});
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Container(),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'play',
            backgroundColor: AppColors.white,
            onPressed: () {
              setState(() {
                _controller.value.isPlaying
                    ? _controller.pause()
                    : _controller.play();
              });
            },
            child: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              color: AppColors.black,
              size: 35,
            ),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'save',
            backgroundColor: AppColors.white,
            onPressed: () {
              Get.back();
            },
            child: const Icon(
              Icons.check,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}

/// Stateful widget to fetch and then display video content.
class VideoPlayerWidget extends StatefulWidget {
  final String? path;
  const VideoPlayerWidget({Key? key, required this.path}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    if (widget.path == null) {
      return;
    }
    _controller = VideoPlayerController.file(File(widget.path!))
      ..initialize().then((_) {
        setState(() {});
      });
    _controller.addListener(() {
      _controller.value.isPlaying ? setState(() {}) : setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.removeListener(() {});
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.path == null
        ? const Center(child: Text('Video not found'))
        : _controller.value.isInitialized
            ? Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                      });
                    },
                    child: Icon(
                      _controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: AppColors.black,
                      size: 35,
                    ),
                  ),
                ],
              )
            : const Text('Video Unavailable');
  }
}
