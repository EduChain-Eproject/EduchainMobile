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

class TeacherHomeworkSaving extends TeacherHomeworkState {}

class TeacherHomeworkSaved extends TeacherHomeworkState {
  final Homework homework;
  TeacherHomeworkSaved(this.homework);
}

class TeacherHomeworkSaveError extends TeacherHomeworkState {
  final Map<String, dynamic>? errors;

  TeacherHomeworkSaveError(this.errors);
}

class TeacherHomeworkDeleting extends TeacherHomeworkState {}

class TeacherHomeworkDeleted extends TeacherHomeworkState {
  final int homeworkId;
  TeacherHomeworkDeleted(this.homeworkId);
}

class TeacherHomeworkDeleteError extends TeacherHomeworkState {
  final Map<String, dynamic>? errors;
  TeacherHomeworkDeleteError(this.errors);
}

class TeacherQuestionSaving extends TeacherHomeworkState {}

class TeacherQuestionSaved extends TeacherHomeworkState {
  final Question question;
  TeacherQuestionSaved(this.question);
}

class TeacherQuestionSaveError extends TeacherHomeworkState {
  final Map<String, dynamic>? errors;

  TeacherQuestionSaveError(this.errors);
}

class TeacherQuestionDeleting extends TeacherHomeworkState {}

class TeacherQuestionDeleted extends TeacherHomeworkState {
  final int questionId;
  TeacherQuestionDeleted(this.questionId);
}

class TeacherQuestionDeleteError extends TeacherHomeworkState {
  final Map<String, dynamic>? errors;
  TeacherQuestionDeleteError(this.errors);
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
