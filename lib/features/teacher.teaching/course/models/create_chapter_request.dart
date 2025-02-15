class CreateChapterRequest {
  final int courseId;
  final String chapterTitle;

  CreateChapterRequest({
    required this.courseId,
    required this.chapterTitle,
  });

  Map<String, dynamic> toJson() => {
        'courseId': courseId,
        'chapterTitle': chapterTitle,
      };
}
