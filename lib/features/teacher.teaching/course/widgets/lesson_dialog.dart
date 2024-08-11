import 'package:educhain/core/models/chapter.dart';
import 'package:educhain/core/models/lesson.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

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
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _videoUrlController;
  Map<String, dynamic>? _errors;

  final ImagePicker _picker = ImagePicker();
  XFile? _videoFile;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.initialLesson?.lessonTitle);
    _descriptionController =
        TextEditingController(text: widget.initialLesson?.description);
    _videoUrlController =
        TextEditingController(text: widget.initialLesson?.videoURL);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialLesson == null ? 'Add Lesson' : 'Edit Lesson'),
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
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _videoFile == null
                        ? 'No video selected'
                        : 'Video selected: ${_videoFile!.name}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                ElevatedButton(
                  onPressed: _pickVideo,
                  child: const Text('Pick Video'),
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
          child: const Text('Save'),
        ),
      ],
    );
  }

  void _saveLesson() {
    if (_formKey.currentState?.validate() ?? false) {
      final lesson = Lesson(
        id: widget.initialLesson?.id,
        lessonTitle: _titleController.text,
        description: _descriptionController.text,
        videoURL: _videoUrlController.text,
      );

      // Dispatch save event
      context.read<TeacherCourseBloc>().add(
            widget.initialLesson == null
                ? TeacherCreateLesson(
                    CreateLessonRequest(
                      chapterId: widget.chapter.id!,
                      lessonTitle: lesson.lessonTitle!,
                      description: lesson.description!,
                      videoTitle: lesson.videoTitle!,
                      videoURL: lesson.videoURL!,
                      videoFile: _videoFile,
                    ),
                  )
                : TeacherUpdateLesson(
                    lesson.id!,
                    UpdateLessonRequest(
                      chapterId: widget.chapter.id!,
                      lessonTitle: lesson.lessonTitle!,
                      description: lesson.description!,
                      videoTitle: lesson.videoTitle!,
                      videoURL: lesson.videoURL!,
                    ),
                  ),
          );

      // Listen to the bloc state for errors
      context.read<TeacherCourseBloc>().stream.listen((state) {
        if (state is TeacherLessonSaveError) {
          setState(() {
            _errors = state.errors;
          });
        } else if (state is TeacherLessonSaved) {
          Navigator.pop(context);
        }
      });
    }
  }

  Future<void> _pickVideo() async {
    try {
      final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        setState(() {
          _videoFile = video;
          _errors?.remove('videoFile'); // Clear any previous video error
        });
      }
    } catch (e) {
      setState(() {
        _errors = {'videoFile': 'Failed to pick video: $e'};
      });
    }
  }
}
