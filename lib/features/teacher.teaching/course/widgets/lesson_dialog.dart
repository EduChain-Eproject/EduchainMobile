import 'package:educhain/core/models/chapter.dart';
import 'package:educhain/core/models/lesson.dart';
import 'package:flutter/material.dart';

class LessonDialog extends StatefulWidget {
  final Chapter chapter;
  final Lesson? initialLesson;
  final ValueChanged<Lesson>? onSave;

  const LessonDialog(
      {Key? key, required this.chapter, this.initialLesson, this.onSave})
      : super(key: key);

  @override
  _LessonDialogState createState() => _LessonDialogState();
}

class _LessonDialogState extends State<LessonDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _videoUrlController;

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
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Lesson Title'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _descriptionController,
              decoration:
                  const InputDecoration(labelText: 'Lesson Description'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _videoUrlController,
              decoration: const InputDecoration(labelText: 'Video URL'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a video URL';
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
      // TODO:

      widget.onSave?.call(lesson);

      Navigator.pop(context);
    }
  }
}
