import 'package:educhain/core/models/course.dart';

class UpdateCourseRequest {
  final List<int>? categoryIds;
  final String? title;
  final String? description;
  final double? price;
  final CourseStatus? status;

  UpdateCourseRequest({
    this.categoryIds,
    this.title,
    this.description,
    this.price,
    this.status,
  });

  Map<String, dynamic> toJson() => {
        'categoryIds': categoryIds,
        'title': title,
        'description': description,
        'price': price,
        'status': status?.toString().split('.').last,
      };
}
