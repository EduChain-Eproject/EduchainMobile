import 'course.dart';
import 'lesson.dart';

class Chapter {
  final int? id;
  final String? chapterTitle;
  final Course? courseDto;
  final List<Lesson>? lessonDtos;

  Chapter({
    this.id,
    this.chapterTitle,
    this.courseDto,
    this.lessonDtos,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'] as int?,
      chapterTitle: json['chapterTitle'] as String?,
      courseDto:
          json['courseDto'] != null ? Course.fromJson(json['courseDto']) : null,
      lessonDtos: (json['lessonDtos'] as List<dynamic>?)
          ?.map((e) => Lesson.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Chapter copyWith({
    int? id,
    String? chapterTitle,
    List<Lesson>? lessonDtos,
  }) {
    return Chapter(
      id: id ?? this.id,
      chapterTitle: chapterTitle ?? this.chapterTitle,
      lessonDtos: lessonDtos ?? this.lessonDtos,
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'chapterTitle': chapterTitle,
  //     'courseDto': courseDto?.toJson(),
  //     'lessonDtos': lessonDtos?.map((e) => e.toJson()).toList(),
  //   };
  // }
}
