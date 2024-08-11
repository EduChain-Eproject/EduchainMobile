import 'package:educhain/core/models/chapter.dart';
import 'package:educhain/core/models/lesson.dart';
import 'package:educhain/features/teacher.teaching/course/blocs/course/teacher_course_bloc.dart';
import 'package:educhain/features/teacher.teaching/homework/screens/teacher_list_homeworks_by_lesson_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'lesson_dialog.dart';

class ChapterTile extends StatefulWidget {
  final Chapter chapter;
  final VoidCallback onEditChapter;
  final VoidCallback onDeleteChapter;

  const ChapterTile({
    Key? key,
    required this.chapter,
    required this.onEditChapter,
    required this.onDeleteChapter,
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
      ),
    );
  }

  void _deleteLesson(Lesson lesson) {
    context.read<TeacherCourseBloc>().add(TeacherDeleteLesson(lesson.id!));
  }

  void _addLesson(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => LessonDialog(
        chapter: widget.chapter,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(widget.chapter.chapterTitle ?? ''),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: widget.onEditChapter,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: widget.onDeleteChapter,
          ),
        ],
      ),
      children: [
        ..._lessons.map((lesson) {
          return ListTile(
            title: Text(lesson.lessonTitle ?? ''),
            onTap: () => Navigator.push(
              context,
              TeacherListHomeworksByLessonScreen.route(lesson.id ?? 0),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editLesson(context, lesson),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteLesson(lesson),
                ),
              ],
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
