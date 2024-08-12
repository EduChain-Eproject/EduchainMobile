import 'package:image_picker/image_picker.dart';

class CreateLessonRequest {
  final int? chapterId;
  final String? lessonTitle;
  final String? description;
  final String? videoTitle;
  final String? videoURL;
  final XFile? videoFile;

  CreateLessonRequest({
    required this.chapterId,
    required this.lessonTitle,
    required this.description,
    required this.videoTitle,
    required this.videoURL,
    required this.videoFile,
  });

  Map<String, dynamic> toJson() => {
        'chapterId': chapterId,
        'lessonTitle': lessonTitle,
        'description': description,
        'videoTitle': videoTitle,
        'videoURL': videoURL,
        'videoFile': videoFile
      };
}
