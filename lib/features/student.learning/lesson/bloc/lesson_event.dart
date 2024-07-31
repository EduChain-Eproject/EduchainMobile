part of 'lesson_bloc.dart';

abstract class LessonEvent {
  List<Object> get props => [];
}

class FetchLessonDetail extends LessonEvent {
  final int lessonId;

  FetchLessonDetail(this.lessonId);

  @override
  List<Object> get props => [lessonId];
}
