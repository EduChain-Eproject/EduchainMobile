part of 'course_bloc.dart';

abstract class CourseState {}

class CourseInitial extends CourseState {}

class CategoriesLoading extends CourseState {}

class CategoriesLoaded extends CourseState {
  final List<Category> categories; // Adjust type based on actual data
  CategoriesLoaded(this.categories);
}

class CategoriesError extends CourseState {
  final String message;
  CategoriesError(this.message);
}

class CoursesLoading extends CourseState {}

class CoursesLoaded extends CourseState {
  final Page<Course> courses;
  CoursesLoaded(this.courses);
}

class CoursesError extends CourseState {
  final String message;
  CoursesError(this.message);
}

class CourseDetailLoading extends CourseState {}

class CourseDetailLoaded extends CourseState {
  final Course courseDetail;
  CourseDetailLoaded(this.courseDetail);
}

class CourseDetailError extends CourseState {
  final String message;
  CourseDetailError(this.message);
}
