import 'package:bloc/bloc.dart';
import 'package:educhain/core/models/category.dart';
import 'package:educhain/core/models/course.dart';
import 'package:educhain/core/types/page.dart';
import 'package:educhain/features/student.learning/course/course_service.dart';

import '../models/course_search_request.dart';

part 'course_event.dart';
part 'course_state.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final CourseService courseService;

  CourseBloc(this.courseService) : super(CourseInitial()) {
    on<FetchCategories>((event, emit) async {
      emit(CategoriesLoading());
      final response = await courseService.fetchCategories();
      response.on(
        onSuccess: (categories) => emit(CategoriesLoaded(categories)),
        onError: (error) => emit(CategoriesError(error['message'])),
      );
    });

    on<SearchCourses>((event, emit) async {
      emit(CoursesLoading());
      final response = await courseService.searchCourses(event.searchRequest);
      response.on(
        onSuccess: (courses) => emit(CoursesLoaded(courses)),
        onError: (error) => emit(CoursesError(error['message'])),
      );
    });

    on<FetchCourseDetail>((event, emit) async {
      emit(CourseDetailLoading());
      final response = await courseService.getCourseDetail(event.courseId);
      response.on(
        onSuccess: (courseDetail) => emit(CourseDetailLoaded(courseDetail)),
        onError: (error) => emit(CourseDetailError(error['message'])),
      );
    });
  }
}
