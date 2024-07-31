import 'award.dart';
import 'lesson.dart';
import 'question.dart';
import 'user.dart';
import 'user_homework.dart';

class Homework {
  final int? id;
  final String? title;
  final String? description;
  final int? userId;
  final int? lessonId;
  final User? userDto;
  final Lesson? lessonDto;
  final List<Question>? questionDtos;
  final List<UserHomework>? userHomeworkDtos;
  final List<Award>? userAwardDtos;

  Homework({
    this.id,
    this.title,
    this.description,
    this.userId,
    this.lessonId,
    this.userDto,
    this.lessonDto,
    this.questionDtos,
    this.userHomeworkDtos,
    this.userAwardDtos,
  });

  factory Homework.fromJson(Map<String, dynamic> json) {
    return Homework(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      userId: json['userID'],
      lessonId: json['lessonID'],
      userDto: json['userDto'] != null ? User.fromJson(json['userDto']) : null,
      lessonDto:
          json['lessonDto'] != null ? Lesson.fromJson(json['lessonDto']) : null,
      questionDtos: json['questionDtos'] != null
          ? (json['questionDtos'] as List)
              .map((item) => Question.fromJson(item))
              .toList()
          : null,
      userHomeworkDtos: json['userHomeworkDtos'] != null
          ? (json['userHomeworkDtos'] as List)
              .map((item) => UserHomework.fromJson(item))
              .toList()
          : null,
      userAwardDtos: json['userAwardDtos'] != null
          ? (json['userAwardDtos'] as List)
              .map((item) => Award.fromJson(item))
              .toList()
          : null,
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'description': description,
  //     'dueDate': dueDate?.toIso8601String(),
  //     'questionDto': questionDto?.toJson(),
  //     'userAnswerDtos': userAnswerDtos?.map((e) => e.toJson()).toList(),
  //   };
  // }
}
