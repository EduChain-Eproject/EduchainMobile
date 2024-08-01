part of 'teacher_course_bloc.dart';

abstract class TeacherCourseState {}

class TeacherCourseInitial extends TeacherCourseState {}

class TeacherCoursesLoading extends TeacherCourseState {}

class TeacherCoursesLoaded extends TeacherCourseState {
  final Page<Course> courses;

  TeacherCoursesLoaded(this.courses);
}

class TeacherCoursesError extends TeacherCourseState {
  final String message;

  TeacherCoursesError(this.message);
}

class TeacherCourseDetailLoading extends TeacherCourseState {}

class TeacherCourseDetailLoaded extends TeacherCourseState {
  final Course courseDetail;

  TeacherCourseDetailLoaded(this.courseDetail);
}

class TeacherCourseDetailError extends TeacherCourseState {
  final String message;

  TeacherCourseDetailError(this.message);
}

class ChapterSaved extends TeacherCourseState {
  final Chapter chapter;

  ChapterSaved(this.chapter);
}

class LessonSaved extends TeacherCourseState {
  final Lesson lesson;

  LessonSaved(this.lesson);
}
