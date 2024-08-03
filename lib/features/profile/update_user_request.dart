import 'dart:typed_data';

class UpdateUserRequest {
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final String address;
  final MultipartFile? avatarFile;
  final String? avatarPath;

  UpdateUserRequest({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.address,
    this.avatarFile,
    this.avatarPath,
  });

  factory UpdateUserRequest.fromJson(Map<String, dynamic> json) {
    return UpdateUserRequest(
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      avatarFile: json['avatarFile'] != null
          ? MultipartFile.fromJson(json['avatarFile'] as Map<String, dynamic>)
          : null,
      avatarPath: json['avatarPath'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'address': address,
      'avatarFile': avatarFile?.toJson(),
      'avatarPath': avatarPath,
    };
  }
}

class MultipartFile {
  final String fileName;
  final String fileType;
  final Uint8List fileData;

  MultipartFile({
    required this.fileName,
    required this.fileType,
    required this.fileData,
  });

  factory MultipartFile.fromJson(Map<String, dynamic> json) {
    return MultipartFile(
      fileName: json['fileName'] as String,
      fileType: json['fileType'] as String,
      fileData: Uint8List.fromList(List<int>.from(json['fileData'])),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fileName': fileName,
      'fileType': fileType,
      'fileData': fileData,
    };
  }
}
