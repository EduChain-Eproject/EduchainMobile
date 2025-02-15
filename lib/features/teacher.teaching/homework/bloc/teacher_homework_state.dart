part of 'teacher_homework_bloc.dart';

abstract class TeacherHomeworkState {}

class TeacherHomeworkInitial extends TeacherHomeworkState {}

class TeacherHomeworksLoading extends TeacherHomeworkState {}

class TeacherHomeworksLoaded extends TeacherHomeworkState {
  final Lesson lesson;
  TeacherHomeworksLoaded(this.lesson);
}

class TeacherHomeworksError extends TeacherHomeworkState {
  final Map<String, dynamic>? errors;

  TeacherHomeworksError(this.errors);
}

class TeacherHomeworkDetailLoading extends TeacherHomeworkState {
  final int homeworkId;
  TeacherHomeworkDetailLoading(this.homeworkId);
}

class TeacherHomeworkDetailLoaded extends TeacherHomeworkState {
  final Homework homework;
  TeacherHomeworkDetailLoaded(this.homework);
}

class TeacherHomeworkDetailError extends TeacherHomeworkState {
  final Map<String, dynamic>? errors;

  TeacherHomeworkDetailError(this.errors);
}

class TeacherHomeworkSaving extends TeacherHomeworkState {}

class TeacherHomeworkSaved extends TeacherHomeworkState {
  final Homework homework;
  final String? status;

  TeacherHomeworkSaved(this.homework, {this.status});
}

class TeacherHomeworkSaveError extends TeacherHomeworkState {
  final Map<String, dynamic>? errors;

  TeacherHomeworkSaveError(this.errors);
}

class TeacherQuestionSaving extends TeacherHomeworkState {}

class TeacherQuestionSaved extends TeacherHomeworkState {
  final Question question;
  final String? status;

  TeacherQuestionSaved(this.question, {this.status});
}

class TeacherQuestionSaveError extends TeacherHomeworkState {
  final Map<String, dynamic>? errors;

  TeacherQuestionSaveError(this.errors);
}

class TeacherAnswerSaving extends TeacherHomeworkState {}

class TeacherAnswerSaved extends TeacherHomeworkState {
  final Answer answer;
  TeacherAnswerSaved(this.answer);
}

class TeacherAnswerSaveError extends TeacherHomeworkState {
  final Map<String, dynamic>? errors;

  TeacherAnswerSaveError(this.errors);
}
