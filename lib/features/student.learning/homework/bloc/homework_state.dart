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
  final String message;

  HomeworkError(this.message);
}
