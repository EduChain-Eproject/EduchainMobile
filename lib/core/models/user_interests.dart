import 'course.dart';
import 'user.dart';

class UserInterests {
  final int? id;
  final User? userDto;
  final Course? courseDto;

  UserInterests({
    this.id,
    this.userDto,
    this.courseDto,
  });

  factory UserInterests.fromJson(Map<String, dynamic> json) {
    return UserInterests(
      id: json['id'] as int?,
      userDto: json['userDto'] != null
          ? User.fromJson(json['userDto'] as Map<String, dynamic>)
          : null,
      courseDto: json['courseDto'] != null
          ? Course.fromJson(json['courseDto'] as Map<String, dynamic>)
          : null,
    );
  }
}
