import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:educhain/core/models/chapter.dart';
import 'package:educhain/core/models/course.dart';
import 'package:educhain/core/models/lesson.dart';
import 'package:educhain/core/types/page.dart';
import 'package:educhain/features/teacher.teaching/course/teacher_course_service.dart';
import '../models/course_search_request.dart';
import '../models/create_chapter_request.dart';
import '../models/create_course_request.dart';
import '../models/create_lesson_request.dart';
import '../models/update_chapter_request.dart';
import '../models/update_course_request.dart';
import '../models/update_lesson_request.dart';

part 'teacher_course_event.dart';
part 'teacher_course_state.dart';

class TeacherCourseBloc extends Bloc<TeacherCourseEvent, TeacherCourseState> {
  final TeacherCourseService teacherCourseService;

  TeacherCourseBloc(this.teacherCourseService) : super(TeacherCourseInitial()) {
    on<FetchTeacherCourses>((event, emit) async {
      TeacherCoursesLoaded? currentState;
      if (state is TeacherCoursesLoaded && event.isLoadingMore) {
        currentState = state as TeacherCoursesLoaded;
      } else {
        currentState = null;
      }

      emit(TeacherCoursesLoading());
      final response =
          await teacherCourseService.fetchTeacherCourses(event.searchRequest);
      await response.on(
        onSuccess: (newCourses) {
          if (currentState != null) {
            final updatedCourses = Page<Course>(
              number: newCourses.number,
              size: newCourses.size,
              totalElements: newCourses.totalElements,
              totalPages: newCourses.totalPages,
              content: [...currentState.courses.content, ...newCourses.content],
            );

            emit(TeacherCoursesLoaded(updatedCourses));
          } else {
            emit(TeacherCoursesLoaded(newCourses));
          }
        },
        onError: (error) => emit(TeacherCoursesError(error['message'])),
      );
    });

    on<FetchCourseDetail>((event, emit) async {
      emit(TeacherCourseDetailLoading());
      final response =
          await teacherCourseService.getCourseDetail(event.courseId);
      await response.on(
        onSuccess: (courseDetail) =>
            emit(TeacherCourseDetailLoaded(courseDetail)),
        onError: (error) => emit(TeacherCourseDetailError(error['message'])),
      );
    });

    on<TeacherCreateCourse>((event, emit) async {
      emit(TeacherCourseDetailLoading());
      final response = await teacherCourseService.createCourse(event.request);
      await response.on(
        onSuccess: (course) => emit(TeacherCourseDetailLoaded(course)),
        onError: (error) => emit(TeacherCourseDetailError(error['message'])),
      );
    });

    on<TeacherUpdateCourse>((event, emit) async {
      emit(TeacherCourseDetailLoading());
      final response = await teacherCourseService.updateCourse(
          event.courseId, event.request);
      await response.on(
        onSuccess: (course) => emit(TeacherCourseDetailLoaded(course)),
        onError: (error) => emit(TeacherCourseDetailError(error['message'])),
      );
    });

    on<TeacherCreateChapter>((event, emit) async {
      emit(TeacherCourseDetailLoading());
      final response = await teacherCourseService.createChapter(event.request);
      await response.on(
        onSuccess: (chapter) => emit(ChapterSaved(chapter)),
        onError: (error) => emit(TeacherCourseDetailError(error['message'])),
      );
    });

    on<TeacherUpdateChapter>((event, emit) async {
      emit(TeacherCourseDetailLoading());
      final response = await teacherCourseService.updateChapter(
          event.chapterId, event.request);
      await response.on(
        onSuccess: (chapter) => emit(ChapterSaved(chapter)),
        onError: (error) => emit(TeacherCourseDetailError(error['message'])),
      );
    });

    on<TeacherCreateLesson>((event, emit) async {
      emit(TeacherCourseDetailLoading());
      final response = await teacherCourseService.createLesson(event.request);
      await response.on(
        onSuccess: (lesson) => emit(LessonSaved(lesson)),
        onError: (error) => emit(TeacherCourseDetailError(error['message'])),
      );
    });

    on<TeacherUpdateLesson>((event, emit) async {
      emit(TeacherCourseDetailLoading());
      final response = await teacherCourseService.updateLesson(
          event.lessonId, event.request);
      await response.on(
        onSuccess: (lesson) => emit(LessonSaved(lesson)),
        onError: (error) => emit(TeacherCourseDetailError(error['message'])),
      );
    });
  }
}
