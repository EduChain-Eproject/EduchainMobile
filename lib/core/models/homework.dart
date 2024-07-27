import 'question.dart';
import 'user_answer.dart';

class Homework {
  final int? id;
  final String? description;
  final DateTime? dueDate;
  final Question? questionDto;
  final List<UserAnswer>? userAnswerDtos;

  Homework({
    this.id,
    this.description,
    this.dueDate,
    this.questionDto,
    this.userAnswerDtos,
  });

  factory Homework.fromJson(Map<String, dynamic> json) {
    return Homework(
      id: json['id'] as int?,
      description: json['description'] as String?,
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      questionDto: json['questionDto'] != null
          ? Question.fromJson(json['questionDto'])
          : null,
      userAnswerDtos: (json['userAnswerDtos'] as List<dynamic>?)
          ?.map((e) => UserAnswer.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'dueDate': dueDate?.toIso8601String(),
      'questionDto': questionDto?.toJson(),
      'userAnswerDtos': userAnswerDtos?.map((e) => e.toJson()).toList(),
    };
  }
}
