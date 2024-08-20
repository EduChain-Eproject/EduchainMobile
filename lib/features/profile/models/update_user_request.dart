import 'package:image_picker/image_picker.dart';

class UpdateUserRequest {
  final String firstName;
  final String lastName;
  final String phone;
  final String address;
  final XFile? avatarFile;

  UpdateUserRequest({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.address,
    this.avatarFile,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'address': address,
    };
  }

  Map<String, String> toFormFields() {
    final jsonData = toJson();
    final fields = <String, String>{};

    jsonData.forEach((key, value) {
      fields[key] = value.toString();
    });

    return fields;
  }

  XFile? file() => avatarFile;
}
