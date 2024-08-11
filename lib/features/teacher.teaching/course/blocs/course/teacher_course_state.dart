part of 'teacher_course_bloc.dart';

abstract class TeacherCourseState {}

class TeacherCourseInitial extends TeacherCourseState {}

class TeacherCoursesLoading extends TeacherCourseState {}

class TeacherCoursesLoaded extends TeacherCourseState {
  final Page<Course> courses;

  TeacherCoursesLoaded(this.courses);
}

class TeacherCoursesError extends TeacherCourseState {
  final Map<String, dynamic>? errors;

  TeacherCoursesError(this.errors);
}

class TeacherCourseDetailLoading extends TeacherCourseState {}

class TeacherCourseDetailLoaded extends TeacherCourseState {
  final Course courseDetail;

  TeacherCourseDetailLoaded(this.courseDetail);
}

class TeacherCourseDetailError extends TeacherCourseState {
  final Map<String, dynamic>? errors;

  TeacherCourseDetailError(this.errors);
}

class TeacherCourseSaving extends TeacherCourseState {}

class TeacherCourseSaved extends TeacherCourseState {
  final Course course;

  TeacherCourseSaved(this.course);
}

class TeacherCourseSaveError extends TeacherCourseState {
  final Map<String, dynamic>? errors;

  TeacherCourseSaveError(this.errors);
}

class TeacherChapterSaving extends TeacherCourseState {}

class TeacherChapterSaved extends TeacherCourseState {
  final Chapter chapter;

  TeacherChapterSaved(this.chapter);
}

class TeacherChapterSaveError extends TeacherCourseState {
  final Map<String, dynamic>? errors;

  TeacherChapterSaveError(this.errors);
}

class TeacherLessonSaving extends TeacherCourseState {}

class TeacherLessonSaved extends TeacherCourseState {
  final Lesson lesson;

  TeacherLessonSaved(this.lesson);
}

class TeacherLessonSaveError extends TeacherCourseState {
  final Map<String, dynamic>? errors;

  TeacherLessonSaveError(this.errors);
}
