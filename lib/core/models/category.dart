import 'course.dart';

class Category {
  final int? id;
  final String? categoryDescription;
  final String? categoryName;
  final List<Course>? courseDtos;

  Category({
    this.id,
    this.categoryDescription,
    this.categoryName,
    this.courseDtos,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int?,
      categoryDescription: json['categoryDescription'] as String?,
      categoryName: json['categoryName'] as String?,
      courseDtos: (json['courseDtos'] as List<dynamic>?)
          ?.map((e) => Course.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'categoryDescription': categoryDescription,
  //     'categoryName': categoryName,
  //     'courseDtos': courseDtos?.map((e) => e.toJson()).toList(),
  //   };
  // }
}
