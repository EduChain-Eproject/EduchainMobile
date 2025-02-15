part of 'homework_bloc.dart';

abstract class HomeworkEvent {}

class FetchHomeworkDetail extends HomeworkEvent {
  final int homeworkId;

  FetchHomeworkDetail(this.homeworkId);
}

class AnswerQuestion extends HomeworkEvent {
  final int homeworkId;
  final AnswerQuestionRequest request;

  AnswerQuestion(this.homeworkId, this.request);
}

class SubmitHomework extends HomeworkEvent {
  final int homeworkId;

  SubmitHomework(this.homeworkId);
}
