class CreateHomeworkRequest {
  final int lessonId;
  final String title;
  final String description;

  CreateHomeworkRequest({
    required this.lessonId,
    required this.title,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'lessonId': lessonId,
      'title': title,
      'description': description,
    };
  }
}
