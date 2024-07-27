import 'homework.dart';
import 'user.dart';
import 'user_answer.dart';

class UserHomework {
  final int? id;
  final int? userId;
  final int? homeworkId;
  final User? userDto;
  final Homework? homeworkDto;
  final DateTime? submissionDate;
  final List<UserAnswer>? userAnswerDtos;

  UserHomework({
    this.id,
    this.userId,
    this.homeworkId,
    this.userDto,
    this.homeworkDto,
    this.submissionDate,
    this.userAnswerDtos,
  });

  factory UserHomework.fromJson(Map<String, dynamic> json) {
    return UserHomework(
      id: json['id'] as int?,
      userId: json['userId'] as int?,
      homeworkId: json['homeworkId'] as int?,
      userDto: json['userDto'] != null ? User.fromJson(json['userDto']) : null,
      homeworkDto: json['homeworkDto'] != null
          ? Homework.fromJson(json['homeworkDto'])
          : null,
      submissionDate: json['submissionDate'] != null
          ? DateTime.parse(json['submissionDate'])
          : null,
      userAnswerDtos: (json['userAnswerDtos'] as List<dynamic>?)
          ?.map((e) => UserAnswer.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'homeworkId': homeworkId,
      'userDto': userDto?.toJson(),
      'homeworkDto': homeworkDto?.toJson(),
      'submissionDate': submissionDate?.toIso8601String(),
      'userAnswerDtos': userAnswerDtos?.map((e) => e.toJson()).toList(),
    };
  }
}
