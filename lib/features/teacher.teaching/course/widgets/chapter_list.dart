import 'package:educhain/core/models/chapter.dart';
import 'package:flutter/material.dart';

import 'chapter_tile.dart';

class ChapterList extends StatelessWidget {
  final bool showCreateButton;
  final List<Chapter> chapters;
  final int? courseId;
  final Function(Chapter) onEditChapter;
  final Function(Chapter) onDeleteChapter;
  final Function onAddChapter;

  const ChapterList({
    Key? key,
    required this.chapters,
    this.courseId,
    required this.onEditChapter,
    required this.onDeleteChapter,
    required this.onAddChapter,
    required this.showCreateButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showCreateButton)
          ElevatedButton(
            onPressed: () => onAddChapter(),
            child: const Text('Create Chapter'),
          ),
        const SizedBox(height: 16.0),
        if (chapters.isEmpty)
          const Center(child: Text('No chapters added yet.')),
        if (chapters.isNotEmpty)
          for (var chapter in chapters)
            ChapterTile(
              chapter: chapter,
              onEditChapter: () => onEditChapter(chapter),
              onDeleteChapter: () => onDeleteChapter(chapter),
            ),
      ],
    );
  }
}
