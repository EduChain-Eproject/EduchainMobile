import 'dart:io';

class UpdateLessonRequest {
  final int? chapterId;
  final String? lessonTitle;
  final String? description;
  final String? videoTitle;
  final String? videoURL;
  final File? videoFile;

  UpdateLessonRequest(
      {this.chapterId,
      this.lessonTitle,
      this.description,
      this.videoTitle,
      this.videoURL,
      this.videoFile});

  Map<String, dynamic> toJson() => {
        'chapterId': chapterId,
        'lessonTitle': lessonTitle,
        'description': description,
        'videoTitle': videoTitle,
        'videoURL': videoURL,
      };
}
