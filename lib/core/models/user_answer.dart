import 'answer.dart';
import 'user.dart';
import 'question.dart';
import 'user_homework.dart';

class UserAnswer {
  final int? id;
  final bool? isCorrect;
  final int? userHomeworkId;
  final int? questionId;
  final int? answerId;
  final User? userDto;
  final UserHomework? userHomeworkDto;
  final Question? questionDto;
  final Answer? answerDto;

  UserAnswer({
    this.id,
    this.isCorrect,
    this.userHomeworkId,
    this.questionId,
    this.answerId,
    this.userDto,
    this.userHomeworkDto,
    this.questionDto,
    this.answerDto,
  });

  factory UserAnswer.fromJson(Map<String, dynamic> json) {
    return UserAnswer(
      id: json['id'] as int?,
      isCorrect: json['isCorrect'] as bool?,
      userHomeworkId: json['userHomeworkId'] as int?,
      questionId: json['questionId'] as int?,
      answerId: json['answerId'] as int?,
      userDto: json['userDto'] != null ? User.fromJson(json['userDto']) : null,
      userHomeworkDto: json['userHomeworkDto'] != null
          ? UserHomework.fromJson(json['userHomeworkDto'])
          : null,
      questionDto: json['questionDto'] != null
          ? Question.fromJson(json['questionDto'])
          : null,
      answerDto:
          json['answerDto'] != null ? Answer.fromJson(json['answerDto']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isCorrect': isCorrect,
      'userHomeworkId': userHomeworkId,
      'questionId': questionId,
      'answerId': answerId,
      'userDto': userDto?.toJson(),
      'userHomeworkDto': userHomeworkDto?.toJson(),
      'questionDto': questionDto?.toJson(),
      'answerDto': answerDto?.toJson(),
    };
  }
}
