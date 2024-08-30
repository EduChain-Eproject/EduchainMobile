import 'package:educhain/core/models/chapter.dart';
import 'package:educhain/core/models/course.dart';
import 'package:educhain/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/course/teacher_course_bloc.dart';
import '../models/create_chapter_request.dart';
import '../models/update_chapter_request.dart';

class ChapterDialog extends StatefulWidget {
  final Course? course;
  final Chapter? initialChapter;

  const ChapterDialog({
    Key? key,
    this.course,
    this.initialChapter,
  }) : super(key: key);

  @override
  _ChapterDialogState createState() => _ChapterDialogState();
}

class _ChapterDialogState extends State<ChapterDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  Map<String, dynamic>? _errors;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.initialChapter?.chapterTitle);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TeacherCourseBloc, TeacherCourseState>(
      listener: (context, state) {
        if (state is TeacherChapterSaveError) {
          setState(() {
            _errors = state.errors;
          });
        } else if (state is TeacherChapterSaved) {
          Navigator.pop(context);
        }
      },
      child: AlertDialog(
        title: Text(
          widget.initialChapter == null ? 'Add Chapter' : 'Edit Chapter',
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
                    _errors?['message']!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                    labelText: 'Chapter Title',
                    errorText: _errors?['chapterTitle']),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
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
            onPressed: _saveChapter,
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _saveChapter() {
    if (_formKey.currentState?.validate() ?? false) {
      final chapter = Chapter(
        id: widget.initialChapter?.id,
        chapterTitle: _titleController.text,
      );

      context.read<TeacherCourseBloc>().add(
            widget.initialChapter == null
                ? TeacherCreateChapter(
                    CreateChapterRequest(
                      courseId: widget.course?.id! ?? 0,
                      chapterTitle: chapter.chapterTitle!,
                    ),
                  )
                : TeacherUpdateChapter(
                    chapter.id!,
                    UpdateChapterRequest(
                      chapterTitle: chapter.chapterTitle!,
                    ),
                  ),
          );
    }
  }
}
