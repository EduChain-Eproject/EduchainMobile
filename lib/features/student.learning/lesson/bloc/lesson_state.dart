part of 'lesson_bloc.dart';

abstract class LessonState {
  @override
  List<Object> get props => [];
}

class LessonInitial extends LessonState {}

class LessonDetailLoading extends LessonState {}

class LessonDetailLoaded extends LessonState {
  final Lesson lessonDetail;
  LessonDetailLoaded(this.lessonDetail);

  @override
  List<Object> get props => [lessonDetail];
}

class LessonDetailError extends LessonState {
  final String message;
  LessonDetailError(this.message);

  @override
  List<Object> get props => [message];
}
