import 'question.dart';
import 'user_answer.dart';

class Answer {
  final int? id;
  final int? questionId;
  final String? answerText;
  final Question? questionDto;
  final UserAnswer? userAnswerDtos;

  Answer({
    this.id,
    this.questionId,
    this.answerText,
    this.questionDto,
    this.userAnswerDtos,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'],
      questionId: json['questionId'],
      answerText: json['answerText'],
      questionDto: json['questionDto'] != null
          ? Question.fromJson(json['questionDto'])
          : null,
      userAnswerDtos: json['userAnswerDtos'] != null
          ? UserAnswer.fromJson(json['userAnswerDtos'])
          : null,
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'questionId': questionId,
  //     'answerText': answerText,
  //     'questionDto': questionDto?.toJson(),
  //     'userAnswerDtos': userAnswerDtos?.toJson(),
  //   };
  // }
}
