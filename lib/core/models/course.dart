import 'blog.dart';
import 'chapter.dart';

class Course {
  final int? id;
  final String? courseName;
  final String? description;
  final List<Chapter>? chapterDtos;
  final List<Blog>? blogDtos;

  Course({
    this.id,
    this.courseName,
    this.description,
    this.chapterDtos,
    this.blogDtos,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as int?,
      courseName: json['courseName'] as String?,
      description: json['description'] as String?,
      chapterDtos: (json['chapterDtos'] as List<dynamic>?)
          ?.map((e) => Chapter.fromJson(e as Map<String, dynamic>))
          .toList(),
      blogDtos: (json['blogDtos'] as List<dynamic>?)
          ?.map((e) => Blog.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseName': courseName,
      'description': description,
      'chapterDtos': chapterDtos?.map((e) => e.toJson()).toList(),
      'blogDtos': blogDtos?.map((e) => e.toJson()).toList(),
    };
  }
}
