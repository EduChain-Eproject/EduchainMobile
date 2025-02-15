import 'package:image_picker/image_picker.dart';

class CreateBlogRequest {
  final String title;
  final int blogCategoryId;
  final String blogText;
  final XFile? photo;

  CreateBlogRequest({
    required this.title,
    required this.blogCategoryId,
    required this.blogText,
    required this.photo,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'blogCategoryId': blogCategoryId,
        'blogText': blogText,
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

  XFile? file() => photo;
}
