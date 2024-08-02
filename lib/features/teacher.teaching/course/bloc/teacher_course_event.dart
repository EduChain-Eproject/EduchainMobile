part of 'teacher_course_bloc.dart';

abstract class TeacherCourseEvent {}

class FetchTeacherCourses extends TeacherCourseEvent {
  final CourseSearchRequest searchRequest;
  final bool isLoadingMore;

  FetchTeacherCourses(this.searchRequest, {this.isLoadingMore = false});
}

class FetchCourseDetail extends TeacherCourseEvent {
  final int courseId;

  FetchCourseDetail(this.courseId);
}

class TeacherCreateCourse extends TeacherCourseEvent {
  final CreateCourseRequest request;

  TeacherCreateCourse(this.request);
}

class TeacherUpdateCourse extends TeacherCourseEvent {
  final int courseId;
  final UpdateCourseRequest request;

  TeacherUpdateCourse(this.courseId, this.request);
}

class TeacherDeactivateCourse extends TeacherCourseEvent {
  final int courseId;

  TeacherDeactivateCourse(this.courseId);
}

class TeacherCreateChapter extends TeacherCourseEvent {
  final CreateChapterRequest request;

  TeacherCreateChapter(this.request);
}

class TeacherUpdateChapter extends TeacherCourseEvent {
  final int chapterId;
  final UpdateChapterRequest request;

  TeacherUpdateChapter(this.chapterId, this.request);
}

class TeacherDeleteChapter extends TeacherCourseEvent {
  final int chapterId;

  TeacherDeleteChapter(this.chapterId);
}

class TeacherCreateLesson extends TeacherCourseEvent {
  final CreateLessonRequest request;

  TeacherCreateLesson(this.request);
}

class TeacherUpdateLesson extends TeacherCourseEvent {
  final int lessonId;
  final UpdateLessonRequest request;

  TeacherUpdateLesson(this.lessonId, this.request);
}

class TeacherDeleteLesson extends TeacherCourseEvent {
  final int lessonId;

  TeacherDeleteLesson(this.lessonId);
}
