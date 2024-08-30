import 'package:educhain/core/api_service.dart';
import 'package:educhain/core/models/chapter.dart';
import 'package:educhain/core/models/lesson.dart';
import 'package:educhain/core/theme/app_pallete.dart';
import 'package:educhain/core/widgets/loader.dart';
import 'package:educhain/features/student.learning/lesson/widgets/video_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../blocs/course/teacher_course_bloc.dart';
import '../models/create_lesson_request.dart';
import '../models/update_lesson_request.dart';

class LessonDialog extends StatefulWidget {
  final Chapter chapter;
  final Lesson? initialLesson;

  const LessonDialog({
    Key? key,
    required this.chapter,
    this.initialLesson,
  }) : super(key: key);

  @override
  _LessonDialogState createState() => _LessonDialogState();
}

class _LessonDialogState extends State<LessonDialog> {
  final _formKey = GlobalKey<FormState>();
  late bool isUpdating;

  late VideoPlayerController _controller;
  String? _videoError;

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  Map<String, dynamic>? _errors;

  final ImagePicker _picker = ImagePicker();
  XFile? _videoFile;

  @override
  void initState() {
    super.initState();
    isUpdating = widget.initialLesson != null ? true : false;
    if (widget.initialLesson?.videoURL != null) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(
          "${ApiService.apiUrl}/uploadsVideo/${widget.initialLesson!.videoURL}"))
        ..initialize().then((_) {
          setState(() {});
        }).catchError((error) {
          setState(() {
            _videoError = 'Error initializing video player: $error';
          });
        });
    } else {
      _controller = VideoPlayerController.networkUrl(Uri.parse(""));
    }
    _titleController =
        TextEditingController(text: widget.initialLesson?.lessonTitle);
    _descriptionController =
        TextEditingController(text: widget.initialLesson?.description);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeacherCourseBloc, TeacherCourseState>(
      listener: (context, state) {
        if (state is TeacherLessonSaveError) {
          setState(() {
            _errors = state.errors;
          });
        } else if (state is TeacherLessonSaved) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return AlertDialog(
          title: Text(
            widget.initialLesson == null ? 'Add Lesson' : 'Edit Lesson',
            style: const TextStyle(color: AppPallete.accentColor),
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_errors?['message'] != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      _errors!['message'],
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                if (_videoError != null)
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    color: Colors.redAccent,
                    child: Text(
                      _videoError!,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                _controller.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      )
                    : Container(),
                if (_controller.value.isInitialized)
                  VideoControls(controller: _controller),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                      labelText: 'Lesson Title', errorText: _errors?['title']),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                      labelText: 'Lesson Description',
                      errorText: _errors?['description']),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    if (_videoFile != null)
                      const Text(
                        'Video selected!',
                        style: TextStyle(fontSize: 16),
                      ),
                    ElevatedButton(
                      onPressed: _pickVideo,
                      child: Text(
                          'Pick ${(_videoFile != null) ? "Another" : "Video"}'),
                    ),
                  ],
                ),
                if (_errors?['videoFile'] != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _errors!['videoFile']!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _saveLesson,
              child: state is TeacherLessonSaving
                  ? const Loader()
                  : const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _saveLesson() {
    if (_formKey.currentState?.validate() ?? false) {
      if (!isUpdating && _videoFile == null) {
        setState(() {
          _errors = {'videoFile': 'Video file is required! '};
        });
        return;
      }
      context.read<TeacherCourseBloc>().add(
            widget.initialLesson == null
                ? TeacherCreateLesson(
                    CreateLessonRequest(
                      chapterId: widget.chapter.id!,
                      lessonTitle: _titleController.text,
                      description: _descriptionController.text,
                      videoFile: _videoFile,
                    ),
                  )
                : TeacherUpdateLesson(
                    widget.initialLesson?.id ?? 0,
                    UpdateLessonRequest(
                      chapterId: widget.chapter.id!,
                      lessonTitle: _titleController.text,
                      description: _descriptionController.text,
                      videoFile: _videoFile,
                    ),
                  ),
          );
    }
  }

  Future<void> _pickVideo() async {
    try {
      final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        setState(() {
          _videoFile = video;
          _errors?.remove('videoFile');
        });
      }
    } catch (e) {
      setState(() {
        _errors = {'videoFile': 'Failed to pick video: $e'};
      });
    }
  }
}
