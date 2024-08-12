part of 'homework_bloc.dart';

abstract class HomeworkState {}

class HomeworkInitial extends HomeworkState {}

class HomeworkLoading extends HomeworkState {}

class HomeworkLoaded extends HomeworkState {
  final Homework homework;
  final UserHomework userHomework;
  final Award? award;

  HomeworkLoaded(this.homework, this.userHomework, this.award);
}

class HomeworkError extends HomeworkState {
  final Map<String, dynamic> message;

  HomeworkError(this.message);
}

class HomeworkQuestionAnswering extends HomeworkState {}

class HomeworkQuestionAnswered extends HomeworkState {
  final UserAnswer userAnswer;

  HomeworkQuestionAnswered(this.userAnswer);
}

class HomeworkQuestionAnswerError extends HomeworkState {
  final Map<String, dynamic> message;

  HomeworkQuestionAnswerError(this.message);
}

class HomeworkSubmitting extends HomeworkState {}

class HomeworkSubmited extends HomeworkState {
  final SubmissionResponse response;

  HomeworkSubmited(this.response);
}

class HomeworkSubmitError extends HomeworkState {
  final Map<String, dynamic> message;

  HomeworkSubmitError(this.message);
}
