part of 'student_home_bloc.dart';

abstract class StudentHomeState {}

class StudentHomeInitial extends StudentHomeState {}

class StudentHomeLoading extends StudentHomeState {}

class StudentHomeLoaded extends StudentHomeState {
  final List<Category> categories;
  final List<Course> courses;
  final Statistics statistics;
  final User bestTeacher;

  StudentHomeLoaded({
    required this.categories,
    required this.courses,
    required this.statistics,
    required this.bestTeacher,
  });
}

class StudentHomeError extends StudentHomeState {
  final String message;

  StudentHomeError(this.message);
}
