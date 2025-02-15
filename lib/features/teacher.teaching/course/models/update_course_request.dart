import 'package:image_picker/image_picker.dart';

import 'package:educhain/core/models/course.dart';

class UpdateCourseRequest {
  final List<int>? categoryIds;
  final String? title;
  final String? description;
  final double? price;
  final XFile? avatarCourse;
  final CourseStatus? status;

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

  XFile? file() => avatarCourse;
}
