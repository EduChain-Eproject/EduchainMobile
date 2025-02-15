import 'award.dart';
import 'homework.dart';
import 'user.dart';
import 'user_answer.dart';

class UserHomework {
  final int? id;
  final DateTime? submissionDate;
  final double? progress;
  final double? grade;
  final bool? isSubmitted;
  final Homework? homeworkDto;
  final User? userDto;
  final List<UserAnswer>? userAnswerDtos;
  final Award? userAwardDto;

  UserHomework({
    this.id,
    this.submissionDate,
    this.progress,
    this.grade,
    this.isSubmitted,
    this.homeworkDto,
    this.userDto,
    this.userAnswerDtos,
    this.userAwardDto,
  });

  factory UserHomework.fromJson(Map<String, dynamic> json) {
    return UserHomework(
      id: json['id'],
      submissionDate: json['submissionDate'] != null
          ? DateTime.parse(json['submissionDate'])
          : null,
      progress: json['progress']?.toDouble(),
      grade: json['grade']?.toDouble(),
      isSubmitted: json['isSubmitted'],
      homeworkDto: json['homeworkDto'] != null
          ? Homework.fromJson(json['homeworkDto'])
          : null,
      userDto: json['userDto'] != null ? User.fromJson(json['userDto']) : null,
      userAnswerDtos: json['userAnswerDtos'] != null
          ? (json['userAnswerDtos'] as List)
              .map((item) => UserAnswer.fromJson(item))
              .toList()
          : null,
      userAwardDto: json['userAwardDto'] != null
          ? Award.fromJson(json['userAwardDto'])
          : null,
    );
  }

  UserHomework copyWith({
    int? id,
    DateTime? submissionDate,
    double? progress,
    double? grade,
    bool? isSubmitted,
    Homework? homeworkDto,
    User? userDto,
    List<UserAnswer>? userAnswerDtos,
    Award? userAwardDto,
  }) {
    return UserHomework(
      id: id ?? this.id,
      submissionDate: submissionDate ?? this.submissionDate,
      progress: progress ?? this.progress,
      grade: grade ?? this.grade,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      homeworkDto: homeworkDto ?? this.homeworkDto,
      userDto: userDto ?? this.userDto,
      userAnswerDtos: userAnswerDtos ?? this.userAnswerDtos,
      userAwardDto: userAwardDto ?? this.userAwardDto,
    );
  }
}
