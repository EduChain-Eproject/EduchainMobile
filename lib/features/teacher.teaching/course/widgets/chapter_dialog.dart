import 'package:educhain/core/models/chapter.dart';
import 'package:educhain/core/models/course.dart';
import 'package:flutter/material.dart';

class ChapterDialog extends StatefulWidget {
  final Course? course;
  final Chapter? initialChapter;
  final ValueChanged<Chapter>? onSave;

  const ChapterDialog({Key? key, this.course, this.initialChapter, this.onSave})
      : super(key: key);

  @override
  _ChapterDialogState createState() => _ChapterDialogState();
}

class _ChapterDialogState extends State<ChapterDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.initialChapter?.chapterTitle);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:
          Text(widget.initialChapter == null ? 'Add Chapter' : 'Edit Chapter'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _titleController,
          decoration: const InputDecoration(labelText: 'Chapter Title'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a title';
            }
            return null;
          },
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
    );
  }

  void _saveChapter() {
    if (_formKey.currentState?.validate() ?? false) {
      final chapter = Chapter(
        id: widget.initialChapter?.id,
        chapterTitle: _titleController.text,
      );
      // TODO:

      widget.onSave?.call(chapter);

      Navigator.pop(context);
    }
  }
}
