import 'package:image_picker/image_picker.dart';

class UpdateLessonRequest {
  final int? chapterId;
  final String? lessonTitle;
  final String? description;
  final String? videoTitle;
  final XFile? videoFile;

  UpdateLessonRequest(
      {this.chapterId,
      this.lessonTitle,
      this.description,
      this.videoTitle,
      this.videoFile});

  Map<String, dynamic> toJson() => {
        'chapterId': chapterId,
        'lessonTitle': lessonTitle,
        'description': description,
        'videoTitle': videoTitle,
      };

  Map<String, String> toFormFields() {
    final jsonData = toJson();
    final fields = <String, String>{};

    jsonData.forEach((key, value) {
      if (value is List<int>) {
        for (int i = 0; i < value.length; i++) {
          fields['${key}[$i]'] = value[i].toString();
        }
      } else {
        fields[key] = value.toString();
      }
    });

    return fields;
  }

  XFile? file() => videoFile;
}
