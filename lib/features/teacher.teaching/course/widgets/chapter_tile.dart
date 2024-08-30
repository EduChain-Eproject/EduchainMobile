import 'package:educhain/core/models/chapter.dart';
import 'package:educhain/core/models/lesson.dart';
import 'package:educhain/features/teacher.teaching/course/blocs/course/teacher_course_bloc.dart';
import 'package:educhain/features/teacher.teaching/homework/screens/teacher_list_homeworks_by_lesson_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'lesson_dialog.dart';

class ChapterTile extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildChapterHeader(),
            const SizedBox(height: 8.0),
            _buildLessonList(context),
            _buildAddLessonButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildChapterHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            chapter.chapterTitle ?? '',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            overflow:
                TextOverflow.ellipsis, // Handles overflow by truncating text
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEditChapter,
              iconSize: 20, // Adjust icon size if needed
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDeleteChapter,
              iconSize: 20, // Adjust icon size if needed
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLessonList(BuildContext context) {
    final lessons = chapter.lessonDtos ?? [];

    if (lessons.isEmpty) {
      return const Center(child: Text('No lessons added yet.'));
    }

    return Column(
      children: lessons.map((lesson) {
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
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => _editLesson(context, lesson),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteLesson(context, lesson),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAddLessonButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.add),
        label: const Text('Add Lesson'),
        onPressed: () => _addLesson(context),
      ),
    );
  }

  void _editLesson(BuildContext context, Lesson lesson) {
    showDialog(
      context: context,
      builder: (context) => LessonDialog(
        initialLesson: lesson,
        chapter: chapter,
      ),
    );
  }

  void _addLesson(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => LessonDialog(
        chapter: chapter,
      ),
    );
  }

  void _deleteLesson(BuildContext context, Lesson lesson) {
    context.read<TeacherCourseBloc>().add(
          TeacherDeleteLesson(lesson.id!),
        );
  }
}
