import 'package:educhain/core/models/category.dart';
import 'package:educhain/features/teacher.teaching/course/teacher_course_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'teacher_category_state.dart';
part 'teacher_category_event.dart';

class TeacherCategoryBloc
    extends Bloc<TeacherCategoryEvent, TeacherCategoryState> {
  final TeacherCourseService teacherCourseService;

  TeacherCategoryBloc(this.teacherCourseService)
      : super(TeacherCategoryInitial()) {
    on<FetchTeacherCategory>((event, emit) async {
      emit(TeacherCategoryLoading());
      try {
        final response = await teacherCourseService.fetchCategories();
        await response.on(
          onSuccess: (TeacherCategory) =>
              emit(TeacherCategoryLoaded(TeacherCategory)),
          onError: (error) => emit(TeacherCategoryError(error['message'])),
        );
      } catch (e) {
        emit(TeacherCategoryError(e.toString()));
      }
    });
  }
}
