import 'category.dart';

class UserInterests {
  final int? studentId;
  final int? courseId;
  final String? description;
  final String? title;
  final double? price;
  final String? teacherName;
  final List<Category>? categoryList;

  UserInterests({
    this.studentId,
    this.courseId,
    this.description,
    this.title,
    this.price,
    this.teacherName,
    this.categoryList,
  });

  factory UserInterests.fromJson(Map<String, dynamic> json) {
    return UserInterests(
      studentId: json['student_id'] as int?,
      courseId: json['course_id'] as int?,
      description: json['description'] as String?,
      title: json['title'] as String?,
      price: json['price'] as double?,
      teacherName: json['teacherName'] as String?,
      categoryList: (json['categoryList'] as List<dynamic>?)
          ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'course_id': courseId,
      'description': description,
      'title': title,
      'price': price,
      'teacherName': teacherName,
      'categoryList': categoryList?.map((e) => e.toJson()).toList(),
    };
  }
}
