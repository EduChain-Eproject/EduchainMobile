import 'chapter.dart';
import 'homework.dart';

class Lesson {
  final int? id;
  final String? lessonTitle;
  final String? description;
  final String? videoTitle;
  final String? videoURL;
  final Chapter? chapterDto;
  final List<Homework>? homeworkDtos;

  Lesson({
    this.id,
    this.lessonTitle,
    this.description,
    this.videoTitle,
    this.videoURL,
    this.chapterDto,
    this.homeworkDtos,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] as int?,
      lessonTitle: json['lessonTitle'] as String?,
      description: json['description'] as String?,
      videoTitle: json['videoTitle'] as String?,
      videoURL: json['videoURL'] as String?,
      chapterDto: json['chapterDto'] != null
          ? Chapter.fromJson(json['chapterDto'])
          : null,
      homeworkDtos: (json['homeworkDtos'] as List<dynamic>?)
          ?.map((e) => Homework.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lessonTitle': lessonTitle,
      'description': description,
      'videoTitle': videoTitle,
      'videoURL': videoURL,
      'chapterDto': chapterDto?.toJson(),
      'homeworkDtos': homeworkDtos?.map((e) => e.toJson()).toList(),
    };
  }
}
