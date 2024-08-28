import 'package:educhain/core/api_service.dart';
import 'package:educhain/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'package:educhain/core/models/lesson.dart';
import 'homework_tile.dart';
import 'video_control.dart';

class LessonDetailContent extends StatefulWidget {
  final Lesson lesson;

  const LessonDetailContent({Key? key, required this.lesson}) : super(key: key);

  @override
  _LessonDetailContentState createState() => _LessonDetailContentState();
}

class _LessonDetailContentState extends State<LessonDetailContent> {
  late VideoPlayerController _controller;
  String? _videoError;

  @override
  void initState() {
    super.initState();
    if (widget.lesson.videoURL != null) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(
          '${ApiService.apiUrl}/uploadsVideo/${widget.lesson.videoURL}'))
        ..initialize().then((_) {
          setState(() {});
        }).catchError((error) {
          setState(() {
            _videoError = 'Error initializing video player: $error';
          });
          print('Error initializing video player: $error');
        });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          if (_videoError != null)
            Text(
              _videoError!,
              style: const TextStyle(color: Colors.white),
            ),
          _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(),
          if (_controller.value.isInitialized)
            VideoControls(controller: _controller),
          Text(
            widget.lesson.lessonTitle ?? '',
            style: const TextStyle(
                color: AppPallete.lightPrimaryColor, fontSize: 25),
          ),
          const SizedBox(height: 8.0),
          ListTile(
            title: const Text('Description'),
            subtitle: Text(
              widget.lesson.description ?? '',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 16.0),
          if (widget.lesson.homeworkDtos != null &&
              widget.lesson.homeworkDtos!.isNotEmpty) ...[
            Text(
              'Homework',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            ...widget.lesson.homeworkDtos!.map((homework) => HomeworkTile(
                  homework: homework,
                  isCurrentUserFinished:
                      widget.lesson.isCurrentUserFinished ?? false,
                )),
          ],
        ],
      ),
    );
  }
}
