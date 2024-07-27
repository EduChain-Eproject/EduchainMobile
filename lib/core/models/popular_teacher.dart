import 'course.dart';

class PopularTeacher {
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? teacherEmail;
  final String? avatarPath;
  final int? studentParticipating;
  final Course? mostPopularCourse;

  PopularTeacher({
    this.firstName,
    this.lastName,
    this.phone,
    this.teacherEmail,
    this.avatarPath,
    this.studentParticipating,
    this.mostPopularCourse,
  });

  factory PopularTeacher.fromJson(Map<String, dynamic> json) {
    return PopularTeacher(
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      phone: json['phone'] as String?,
      teacherEmail: json['teacherEmail'] as String?,
      avatarPath: json['avatarPath'] as String?,
      studentParticipating: json['studentParticipating'] as int?,
      mostPopularCourse: json['mostPopularCourse'] != null
          ? Course.fromJson(json['mostPopularCourse'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'teacherEmail': teacherEmail,
      'avatarPath': avatarPath,
      'studentParticipating': studentParticipating,
      'mostPopularCourse': mostPopularCourse?.toJson(),
    };
  }
}
