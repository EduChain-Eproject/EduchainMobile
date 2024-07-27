import 'course.dart';
import 'user.dart';

class CourseFeedback {
  final String? message;
  final double? rating;
  final User? userDto;
  final Course? courseDto;

  CourseFeedback({
    this.message,
    this.rating,
    this.userDto,
    this.courseDto,
  });

  factory CourseFeedback.fromJson(Map<String, dynamic> json) {
    return CourseFeedback(
      message: json['message'] as String?,
      rating: json['rating'] as double?,
      userDto: json['userDto'] != null ? User.fromJson(json['userDto']) : null,
      courseDto:
          json['courseDto'] != null ? Course.fromJson(json['courseDto']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'rating': rating,
      'userDto': userDto?.toJson(),
      'courseDto': courseDto?.toJson(),
    };
  }
}
