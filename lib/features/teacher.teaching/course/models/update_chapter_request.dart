class UpdateChapterRequest {
  final String chapterTitle;

  UpdateChapterRequest({
    required this.chapterTitle,
  });

  Map<String, dynamic> toJson() => {
        'chapterTitle': chapterTitle,
      };
}
