import 'answer.dart';
import 'homework.dart';
import 'user_answer.dart';

class Question {
  final int? id;
  final String? questionText;
  final int? homeworkId;
  final int? correctAnswerId;
  final Homework? homeworkDto;
  final List<Answer>? answerDtos;
  final List<UserAnswer>? userAnswerDtos;
  final Answer? correctAnswerDto;
  final UserAnswer? currentUserAnswerDto;

  Question({
    this.id,
    this.questionText,
    this.homeworkId,
    this.correctAnswerId,
    this.homeworkDto,
    this.answerDtos,
    this.userAnswerDtos,
    this.correctAnswerDto,
    this.currentUserAnswerDto,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as int?,
      questionText: json['questionText'] as String?,
      homeworkId: json['homeworkId'] as int?,
      correctAnswerId: json['correctAnswerId'] as int?,
      homeworkDto: json['homeworkDto'] != null
          ? Homework.fromJson(json['homeworkDto'])
          : null,
      answerDtos: (json['answerDtos'] as List<dynamic>?)
          ?.map((e) => Answer.fromJson(e as Map<String, dynamic>))
          .toList(),
      userAnswerDtos: (json['userAnswerDtos'] as List<dynamic>?)
          ?.map((e) => UserAnswer.fromJson(e as Map<String, dynamic>))
          .toList(),
      correctAnswerDto: json['correctAnswerDto'] != null
          ? Answer.fromJson(json['correctAnswerDto'])
          : null,
      currentUserAnswerDto: json['currentUserAnswerDto'] != null
          ? UserAnswer.fromJson(json['currentUserAnswerDto'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'questionText': questionText,
      'homeworkId': homeworkId,
      'correctAnswerId': correctAnswerId,
      'homeworkDto': homeworkDto?.toJson(),
      'answerDtos': answerDtos?.map((e) => e.toJson()).toList(),
      'userAnswerDtos': userAnswerDtos?.map((e) => e.toJson()).toList(),
      'correctAnswerDto': correctAnswerDto?.toJson(),
      'currentUserAnswerDto': currentUserAnswerDto?.toJson(),
    };
  }
}
