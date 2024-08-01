class CreateLessonRequest {
  final int chapterId;
  final String lessonTitle;
  final String description;
  final String videoTitle;
  final String videoURL;

  CreateLessonRequest({
    required this.chapterId,
    required this.lessonTitle,
    required this.description,
    required this.videoTitle,
    required this.videoURL,
  });

  Map<String, dynamic> toJson() => {
        'chapterId': chapterId,
        'lessonTitle': lessonTitle,
        'description': description,
        'videoTitle': videoTitle,
        'videoURL': videoURL,
      };
}
