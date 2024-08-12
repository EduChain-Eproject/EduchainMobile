import 'package:educhain/core/models/chapter.dart';
import 'package:educhain/features/student.learning/lesson/screens/lesson_detail_screen.dart';
import 'package:flutter/material.dart';

class ChaptersSection extends StatelessWidget {
  final List<Chapter> chapters;
  final void Function(int lessonId) onLessonTap;

  const ChaptersSection({
    Key? key,
    required this.chapters,
    required this.onLessonTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...chapters.map((chapter) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  chapter.chapterTitle ?? 'Untitled',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ...chapter.lessonDtos?.map((lesson) => _buildLessonTile(
                          context: context,
                          lessonTitle: lesson.lessonTitle ?? '',
                          lessonId: lesson.id ?? 0,
                          done: lesson.isCurrentUserFinished ?? false,
                        )) ??
                    [const Text("no lesson for this chapter")],
              ],
            )),
      ],
    );
  }

  Widget _buildLessonTile({
    required BuildContext context,
    required String lessonTitle,
    required int lessonId,
    required bool done,
  }) {
    return ListTile(
      onTap: () {
        Navigator.push(context, LessonDetailScreen.route(lessonId));
      },
      leading: const Icon(
        Icons.school_outlined,
        color: Colors.green,
        size: 30,
      ),
      title: Text(
        lessonId.toString(),
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: done
          ? const Icon(
              Icons.done,
              size: 30,
            )
          : InkWell(
              onTap: () => onLessonTap(lessonId),
              child: const Icon(
                Icons.play_circle_outline,
                size: 30,
              ),
            ),
      subtitle: Text(
        lessonTitle,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
      ),
      dense: true,
      visualDensity: VisualDensity.compact,
    );
  }
}
