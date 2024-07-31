import 'package:educhain/core/models/chapter.dart';
import 'package:flutter/material.dart';

class ChaptersSection extends StatelessWidget {
  final List<Chapter> chapters;
  final void Function(int lessonId) onLessonTap;

  const ChaptersSection(
      {Key? key, required this.chapters, required this.onLessonTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return chapters.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Chapters:', style: Theme.of(context).textTheme.titleMedium),
              ...chapters.map((chapter) => ExpansionTile(
                    title: Text(chapter.chapterTitle ?? 'Untitled'),
                    subtitle:
                        Text('Lessons: ${chapter.lessonDtos?.length ?? 0}'),
                    children: chapter.lessonDtos
                            ?.map((lesson) => ListTile(
                                  title: Text(
                                      lesson.lessonTitle ?? 'Untitled Lesson'),
                                  subtitle: Text(
                                      'Description: ${lesson.description ?? 'No Description'}'),
                                  onTap: () => onLessonTap(lesson.id!),
                                ))
                            .toList() ??
                        [],
                  )),
            ],
          )
        : const Text('No chapters available.');
  }
}
