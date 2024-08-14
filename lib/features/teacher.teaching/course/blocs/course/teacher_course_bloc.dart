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
          if (state is TeacherCourseDetailLoaded) {
            final currentState = state as TeacherCourseDetailLoaded;
            final updatedCourse = currentState.courseDetail.copyWith(
              chapterDtos: [...?currentState.courseDetail.chapterDtos, chapter],
            );
            emit(TeacherCourseDetailLoaded(updatedCourse));
          }
          emit(TeacherChapterSaved(chapter));
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
          if (state is TeacherCourseDetailLoaded) {
            final currentState = state as TeacherCourseDetailLoaded;
            final updatedChapters =
                currentState.courseDetail.chapterDtos?.map((c) {
              return c.id == chapter.id ? chapter : c;
            }).toList();
            final updatedCourse = currentState.courseDetail.copyWith(
              chapterDtos: updatedChapters,
            );
            emit(TeacherCourseDetailLoaded(updatedCourse));
          }
          emit(TeacherChapterSaved(chapter));
        },
        onError: (error) => emit(TeacherChapterSaveError(error)),
      );
    });

    on<TeacherDeleteChapter>((event, emit) async {
      emit(TeacherChapterSaving());
      final response =
          await teacherCourseService.deleteChapter(event.chapterId);
      await response.on(
        onSuccess: (chapter) {
          if (state is TeacherCourseDetailLoaded) {
            final currentState = state as TeacherCourseDetailLoaded;
            final updatedChapters =
                currentState.courseDetail.chapterDtos?.where((c) {
              return c.id != chapter.id;
            }).toList();
            final updatedCourse = currentState.courseDetail.copyWith(
              chapterDtos: updatedChapters,
            );
            emit(TeacherCourseDetailLoaded(updatedCourse));
          }
          emit(TeacherChapterSaved(chapter));
        },
        onError: (error) => emit(TeacherChapterSaveError(error)),
      );
    });

    on<TeacherCreateLesson>((event, emit) async {
      emit(TeacherLessonSaving());
      final response = await teacherCourseService.createLesson(event.request);
      await response.on(
        onSuccess: (lesson) {
          if (state is TeacherCourseDetailLoaded) {
            final currentState = state as TeacherCourseDetailLoaded;
            final updatedChapters =
                currentState.courseDetail.chapterDtos?.map((c) {
              if (c.id == lesson.chapterDto?.id) {
                return c.copyWith(lessonDtos: [...?c.lessonDtos, lesson]);
              }
              return c;
            }).toList();
            final updatedCourse = currentState.courseDetail.copyWith(
              chapterDtos: updatedChapters,
            );
            emit(TeacherCourseDetailLoaded(updatedCourse));
          }
          emit(TeacherLessonSaved(lesson));
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
          if (state is TeacherCourseDetailLoaded) {
            final currentState = state as TeacherCourseDetailLoaded;
            final updatedChapters =
                currentState.courseDetail.chapterDtos?.map((c) {
              final updatedLessons = c.lessonDtos?.map((l) {
                return l.id == lesson.id ? lesson : l;
              }).toList();
              return c.copyWith(lessonDtos: updatedLessons);
            }).toList();
            final updatedCourse = currentState.courseDetail.copyWith(
              chapterDtos: updatedChapters,
            );
            emit(TeacherCourseDetailLoaded(updatedCourse));
          }
          emit(TeacherLessonSaved(lesson));
        },
        onError: (error) => emit(TeacherLessonSaveError(error)),
      );
    });

    on<TeacherDeleteLesson>((event, emit) async {
      emit(TeacherLessonSaving());
      final response = await teacherCourseService.deleteLesson(event.lessonId);
      await response.on(
        onSuccess: (lesson) {
          if (state is TeacherCourseDetailLoaded) {
            final currentState = state as TeacherCourseDetailLoaded;
            final updatedChapters =
                currentState.courseDetail.chapterDtos?.map((c) {
              final updatedLessons = c.lessonDtos?.where((l) {
                return l.id != lesson.id;
              }).toList();
              return c.copyWith(lessonDtos: updatedLessons);
            }).toList();
            final updatedCourse = currentState.courseDetail.copyWith(
              chapterDtos: updatedChapters,
            );
            emit(TeacherCourseDetailLoaded(updatedCourse));
          }
          emit(TeacherLessonSaved(lesson));
        },
        onError: (error) => emit(TeacherLessonSaveError(error)),
      );
    });
  }
}
