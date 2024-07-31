import 'package:educhain/core/models/user_homework.dart';

import 'award.dart';

class User {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? avatarPath;
  final String? phone;
  final String? address;
  final String? role;
  final String? email;
  final List<Award>? userAwardDtos;
  final List<UserHomework>? userHomeworkDtos;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.avatarPath,
    this.phone,
    this.address,
    this.role,
    this.email,
    this.userAwardDtos,
    this.userHomeworkDtos,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      avatarPath: json['avatarPath'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      role: json['role'] as String?,
      email: json['email'] as String?,
      userAwardDtos: (json['userAwardDtos'] as List<dynamic>?)
          ?.map((item) => Award.fromJson(item as Map<String, dynamic>))
          .toList(),
      userHomeworkDtos: (json['userHomeworkDtos'] as List<dynamic>?)
          ?.map((item) => UserHomework.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'firstName': firstName,
  //     'lastName': lastName,
  //     'avatarPath': avatarPath,
  //     'phone': phone,
  //     'address': address,
  //     'role': role,
  //     'email': email,
  //     'userAwardDtos': userAwardDtos?.map((item) => item.toJson()).toList(),
  //     'userHomeworkDtos':
  //         userHomeworkDtos?.map((item) => item.toJson()).toList(),
  //   };
  // }
}
