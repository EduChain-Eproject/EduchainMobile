import 'answer.dart';
import 'homework.dart';
import 'user_answer.dart';

class Question {
  final int? id;
  final String? questionText;
  final int? homeworkId;
  final Homework? homeworkDto;
  final List<Answer>? answerDtos;
  final List<UserAnswer>? userAnswerDtos;
  final int? correctAnswerId;
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
      id: json['id'],
      questionText: json['questionText'],
      homeworkId: json['homeworkId'],
      correctAnswerId: json['correctAnswerId'],
      homeworkDto: json['homeworkDto'] != null
          ? Homework.fromJson(json['homeworkDto'])
          : null,
      answerDtos: json['answerDtos'] != null
          ? (json['answerDtos'] as List)
              .map((item) => Answer.fromJson(item))
              .toList()
          : null,
      userAnswerDtos: json['userAnswerDtos'] != null
          ? (json['userAnswerDtos'] as List)
              .map((item) => UserAnswer.fromJson(item))
              .toList()
          : null,
      correctAnswerDto: json['correctAnswerDto'] != null
          ? Answer.fromJson(json['correctAnswerDto'])
          : null,
      currentUserAnswerDto: json['currentUserAnswerDto'] != null
          ? UserAnswer.fromJson(json['currentUserAnswerDto'])
          : null,
    );
  }

  Question copyWith({
    int? id,
    String? questionText,
    int? homeworkId,
    int? correctAnswerId,
    Homework? homeworkDto,
    List<Answer>? answerDtos,
    List<UserAnswer>? userAnswerDtos,
    Answer? correctAnswerDto,
    UserAnswer? currentUserAnswerDto,
  }) {
    return Question(
      id: id ?? this.id,
      questionText: questionText ?? this.questionText,
      homeworkId: homeworkId ?? this.homeworkId,
      correctAnswerId: correctAnswerId ?? this.correctAnswerId,
      homeworkDto: homeworkDto ?? this.homeworkDto,
      answerDtos: answerDtos ?? this.answerDtos,
      userAnswerDtos: userAnswerDtos ?? this.userAnswerDtos,
      correctAnswerDto: correctAnswerDto ?? this.correctAnswerDto,
      currentUserAnswerDto: currentUserAnswerDto ?? this.currentUserAnswerDto,
    );
  }
  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'questionText': questionText,
  //     'homeworkId': homeworkId,
  //     'correctAnswerId': correctAnswerId,
  //     'homeworkDto': homeworkDto?.toJson(),
  //     'answerDtos': answerDtos?.map((e) => e.toJson()).toList(),
  //     'userAnswerDtos': userAnswerDtos?.map((e) => e.toJson()).toList(),
  //     'correctAnswerDto': correctAnswerDto?.toJson(),
  //     'currentUserAnswerDto': currentUserAnswerDto?.toJson(),
  //   };
  // }
}
