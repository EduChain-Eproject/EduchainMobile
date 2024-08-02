import 'package:educhain/core/models/user_homework.dart';

import 'award.dart';
import 'course.dart';
import 'user_course.dart';
import 'user_interests.dart';

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
  final List<UserCourse>? courseDtosParticipated;
  final List<UserInterests>? userInterestDtos;
  final int? numberOfStudents;
  final Course? mostPopularCourse;

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
    this.courseDtosParticipated,
    this.userInterestDtos,
    this.numberOfStudents,
    this.mostPopularCourse,
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
      courseDtosParticipated: (json['courseDtosParticipated'] as List<dynamic>?)
          ?.map((item) => UserCourse.fromJson(item as Map<String, dynamic>))
          .toList(),
      userInterestDtos: (json['userInterestDtos'] as List<dynamic>?)
          ?.map((item) => UserInterests.fromJson(item as Map<String, dynamic>))
          .toList(),
      numberOfStudents: json['numberOfStudents'] as int?,
      mostPopularCourse: json['mostPopularCourse'] != null
          ? Course.fromJson(json['mostPopularCourse'] as Map<String, dynamic>)
          : null,
    );
  }
}
