import 'package:image_picker/image_picker.dart';

import 'package:educhain/core/models/course.dart';

class UpdateCourseRequest {
  final List<int>? categoryIds;
  final String? title;
  final String? description;
  final double? price;
  final CourseStatus? status;
  final XFile? avatarCourse;

  UpdateCourseRequest({
    this.categoryIds,
    this.title,
    this.description,
    this.price,
    this.status,
    this.avatarCourse,
  });

  Map<String, dynamic> toJson() => {
        'categoryIds': categoryIds,
        'title': title,
        'description': description,
        'price': price,
        'status': status?.toString().split('.').last,
        'avatarCourse': avatarCourse
      };
}
