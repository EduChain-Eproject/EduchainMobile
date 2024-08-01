import 'package:educhain/core/models/chapter.dart';
import 'package:educhain/core/models/lesson.dart';
import 'package:educhain/features/teacher.teaching/homework/screens/teacher_list_homeworks_by_lesson_screen.dart';
import 'package:flutter/material.dart';

import 'lesson_dialog.dart';

class ChapterTile extends StatefulWidget {
  final Chapter chapter;
  final ValueChanged<Chapter> onChapterUpdated;
  final VoidCallback onEditChapter; // New callback for editing the chapter

  const ChapterTile({
    Key? key,
    required this.chapter,
    required this.onChapterUpdated,
    required this.onEditChapter, // Include the new callback
  }) : super(key: key);

  @override
  _ChapterTileState createState() => _ChapterTileState();
}

class _ChapterTileState extends State<ChapterTile> {
  late List<Lesson> _lessons;

  @override
  void initState() {
    super.initState();
    _lessons = widget.chapter.lessonDtos ?? [];
  }

  void _editLesson(BuildContext context, Lesson lesson) {
    showDialog(
      context: context,
      builder: (context) => LessonDialog(
        initialLesson: lesson,
        chapter: widget.chapter,
        onSave: (updatedLesson) {
          setState(() {
            final index = _lessons.indexOf(lesson);
            _lessons[index] = updatedLesson;
            widget.onChapterUpdated(
                widget.chapter.copyWith(lessonDtos: _lessons));
          });
        },
      ),
    );
  }

  void _addLesson(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => LessonDialog(
        chapter: widget.chapter,
        onSave: (newLesson) {
          setState(() {
            _lessons.add(newLesson);
            widget.onChapterUpdated(
                widget.chapter.copyWith(lessonDtos: _lessons));
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(widget.chapter.chapterTitle ?? ''),
      trailing: IconButton(
        icon: const Icon(Icons.edit),
        onPressed: widget.onEditChapter, // Use the callback here
      ),
      children: [
        ..._lessons.map((lesson) {
          return ListTile(
            title: Text(lesson.lessonTitle ?? ''),
            onTap: () => Navigator.push(context,
                TeacherListHomeworksByLessonScreen.route(lesson.id ?? 0)),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _editLesson(context, lesson),
            ),
          );
        }).toList(),
        ListTile(
          title: const Text('Add Lesson'),
          trailing: const Icon(Icons.add),
          onTap: () => _addLesson(context),
        ),
      ],
    );
  }
}
