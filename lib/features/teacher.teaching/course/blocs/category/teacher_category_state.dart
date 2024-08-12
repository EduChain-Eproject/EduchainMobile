part of 'teacher_category_bloc.dart';

abstract class TeacherCategoryState {}

class TeacherCategoryInitial extends TeacherCategoryState {}

class TeacherCategoryLoading extends TeacherCategoryState {}

class TeacherCategoryLoaded extends TeacherCategoryState {
  final List<Category> categories;

  TeacherCategoryLoaded(this.categories);
}

class TeacherCategoryError extends TeacherCategoryState {
  final String message;
  TeacherCategoryError(this.message);
}
