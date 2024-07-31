part of 'homework_bloc.dart';

abstract class HomeworkEvent {}

class FetchHomeworkDetail extends HomeworkEvent {
  final int homeworkId;

  FetchHomeworkDetail(this.homeworkId);
}
