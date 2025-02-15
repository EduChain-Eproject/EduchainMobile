import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:educhain/core/models/chapter.dart';
import 'package:educhain/core/models/course.dart';
import 'package:educhain/core/models/lesson.dart';
import 'package:educhain/core/types/page.dart';
import 'package:educhain/features/teacher.teaching/course/teacher_course_service.dart';
import '../../models/course_search_request.dart';
import '../../models/create_chapter_request.dart';
import '../../models/create_course_request.dart';
import '../../models/create_lesson_request.dart';
import '../../models/update_chapter_request.dart';
import '../../models/update_course_request.dart';
import '../../models/update_lesson_request.dart';

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
              totalElements: newCourses.totalElements,
              totalPages: newCourses.totalPages,
              content: [...currentState.courses.content, ...newCourses.content],
            );

            emit(TeacherCoursesLoaded(updatedCourses));
          } else {
            emit(TeacherCoursesLoaded(newCourses));
          }
        },
        onError: (error) => emit(TeacherCoursesError(error)),
      );
    });

    on<FetchCourseDetail>((event, emit) async {
      emit(TeacherCourseDetailLoading());
      final response =
          await teacherCourseService.getCourseDetail(event.courseId);
      await response.on(
        onSuccess: (courseDetail) =>
            emit(TeacherCourseDetailLoaded(courseDetail)),
        onError: (error) => emit(TeacherCourseDetailError(error)),
      );
    });

    on<TeacherCreateCourse>((event, emit) async {
      emit(TeacherCourseSaving());
      final response = await teacherCourseService.createCourse(event.request);
      await response.on(
        onSuccess: (course) {
          emit(TeacherCourseSaved(course));
        },
        onError: (error) => emit(TeacherCourseSaveError(error)),
      );
    });

    on<TeacherUpdateCourse>((event, emit) async {
      emit(TeacherCourseSaving());
      final response = await teacherCourseService.updateCourse(
          event.courseId, event.request);
      await response.on(
        onSuccess: (course) {
          emit(TeacherCourseSaved(course));
        },
        onError: (error) => emit(TeacherCourseSaveError(error)),
      );
    });

    on<TeacherDeactivateCourse>((event, emit) async {
      emit(TeacherCourseSaving());
      final response =
          await teacherCourseService.deactivateCourse(event.courseId);
      await response.on(
        onSuccess: (course) {
          emit(TeacherCourseSaved(course));
        },
        onError: (error) => emit(TeacherCourseSaveError(error)),
      );
    });

    on<TeacherCreateChapter>((event, emit) async {
      emit(TeacherChapterSaving());
      final response = await teacherCourseService.createChapter(event.request);
      await response.on(
        onSuccess: (chapter) {
          emit(TeacherChapterSaved(chapter, status: "created"));
        },
        onError: (error) => emit(TeacherChapterSaveError(error)),
      );
    });

    on<TeacherUpdateChapter>((event, emit) async {
      emit(TeacherChapterSaving());
      final response = await teacherCourseService.updateChapter(
          event.chapterId, event.request);
      await response.on(
        onSuccess: (chapter) {
          emit(TeacherChapterSaved(chapter, status: "updated"));
        },
        onError: (error) => emit(TeacherChapterSaveError(error)),
      );
    });

    on<TeacherDeleteChapter>((event, emit) async {
      emit(TeacherChapterSaving());
      final response =
          await teacherCourseService.deleteChapter(event.chapterId);
      await response.on(
        onSuccess: (chapterId) {
          emit(TeacherChapterSaved(Chapter(id: chapterId), status: "deleted"));
        },
        onError: (error) => emit(TeacherChapterSaveError(error)),
      );
    });

    on<TeacherCreateLesson>((event, emit) async {
      emit(TeacherLessonSaving());
      final response = await teacherCourseService.createLesson(event.request);
      await response.on(
        onSuccess: (lesson) {
          emit(TeacherLessonSaved(lesson, status: "created"));
        },
        onError: (error) => emit(TeacherLessonSaveError(error)),
      );
    });

    on<TeacherUpdateLesson>((event, emit) async {
      emit(TeacherLessonSaving());
      final response = await teacherCourseService.updateLesson(
          event.lessonId, event.request);
      await response.on(
        onSuccess: (lesson) {
          emit(TeacherLessonSaved(lesson, status: "updated"));
        },
        onError: (error) => emit(TeacherLessonSaveError(error)),
      );
    });

    on<TeacherDeleteLesson>((event, emit) async {
      emit(TeacherLessonSaving());
      final response = await teacherCourseService.deleteLesson(event.lessonId);
      await response.on(
        onSuccess: (lessonId) {
          emit(TeacherLessonSaved(Lesson(id: lessonId), status: 'deleted'));
        },
        onError: (error) => emit(TeacherLessonSaveError(error)),
      );
    });
  }
}
