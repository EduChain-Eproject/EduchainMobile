import 'package:image_picker/image_picker.dart';

class CreateCourseRequest {
  final List<int>? categoryIds;
  final String? title;
  final String? description;
  final double? price;
  final XFile? avatarCourse;

  CreateCourseRequest(
      {required this.categoryIds,
      required this.title,
      required this.description,
      required this.price,
      required this.avatarCourse});

  Map<String, dynamic> toJson() => {
        'categoryIds': categoryIds,
        'title': title,
        'description': description,
        'price': price,
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
