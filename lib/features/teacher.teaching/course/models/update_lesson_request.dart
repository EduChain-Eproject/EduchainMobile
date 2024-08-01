class UpdateLessonRequest {
  final int? chapterId;
  final String? lessonTitle;
  final String? description;
  final String? videoTitle;
  final String? videoURL;

  UpdateLessonRequest({
    this.chapterId,
    this.lessonTitle,
    this.description,
    this.videoTitle,
    this.videoURL,
  });

  Map<String, dynamic> toJson() => {
        'chapterId': chapterId,
        'lessonTitle': lessonTitle,
        'description': description,
        'videoTitle': videoTitle,
        'videoURL': videoURL,
      };
}
