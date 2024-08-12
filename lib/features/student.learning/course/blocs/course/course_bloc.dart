import 'package:educhain/core/models/course.dart';
import 'package:educhain/core/types/page.dart';
import 'package:educhain/features/student.learning/course/course_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/course_search_request.dart';

part 'course_event.dart';
part 'course_state.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final CourseService courseService;

  CourseBloc(this.courseService) : super(CourseInitial()) {
    on<SearchCourses>((event, emit) async {
      CoursesLoaded? currentState;
      if (state is CoursesLoaded && event.isLoadingMore) {
        currentState = state as CoursesLoaded;
      } else {
        currentState = null;
      }
      emit(CoursesLoading());

      try {
        final response = await courseService.searchCourses(event.searchRequest);

        await response.on(
          onSuccess: (newCourses) {
            if (currentState != null) {
              final updatedCourses = Page<Course>(
                number: newCourses.number,
                totalElements: newCourses.totalElements,
                totalPages: newCourses.totalPages,
                content: [
                  ...currentState.courses.content,
                  ...newCourses.content
                ],
              );

              emit(CoursesLoaded(updatedCourses));
            } else {
              emit(CoursesLoaded(newCourses));
            }
          },
          onError: (error) => emit(CoursesError(error['message'])),
        );
      } catch (e) {
        emit(CoursesError(e.toString()));
      }
    });

    on<FetchCourseDetail>((event, emit) async {
      emit(CourseDetailLoading());
      final response = await courseService.getCourseDetail(event.courseId);
      await response.on(
        onSuccess: (courseDetail) => emit(CourseDetailLoaded(courseDetail)),
        onError: (error) => emit(CourseDetailError(error['message'])),
      );
    });

    on<EnrollInCourse>((event, emit) async {
      emit(CourseDetailLoading());
      final response = await courseService.enrollInCourse(event.courseId);
      await response.on(
        onSuccess: (userCourse) {
          if (state is CourseDetailLoaded) {
            final currentCourse = (state as CourseDetailLoaded).courseDetail;
            final updatedCourse = currentCourse.copyWith(
              currentUserCourse: userCourse,
            );
            emit(CourseDetailLoaded(updatedCourse));
          } else {
            emit(CourseDetailError('Course detail not loaded'));
          }
        },
        onError: (error) => emit(CourseDetailError(error['message'])),
      );
    });

    on<AddToWishlist>((event, emit) async {
      final response = await courseService.addToWishlist(event.courseId);
      await response.on(
        onSuccess: (_) {
          if (state is CourseDetailLoaded) {
            final currentCourse = (state as CourseDetailLoaded).courseDetail;
            final updatedCourse =
                currentCourse.copyWith(currentUserInterested: true);
            emit(CourseDetailLoaded(updatedCourse));
          } else {
            emit(CourseDetailError('Course detail not loaded'));
          }
        },
        onError: (error) => emit(CourseDetailError(error['message'])),
      );
    });

    on<DeleteFromWishlist>((event, emit) async {
      final response = await courseService.deleteFromWishlist(event.courseId);
      await response.on(
        onSuccess: (isSuccess) {
          if (state is CourseDetailLoaded) {
            final currentCourse = (state as CourseDetailLoaded).courseDetail;
            final updatedCourse =
                currentCourse.copyWith(currentUserInterested: isSuccess);
            emit(CourseDetailLoaded(updatedCourse));
          } else {
            emit(CourseDetailError('Course detail not loaded'));
          }
        },
        onError: (error) => emit(CourseDetailError(error['message'])),
      );
    });
  }
}
