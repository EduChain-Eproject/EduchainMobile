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

class TeacherSaveCourse extends TeacherCourseEvent {
  final Course course;

  TeacherSaveCourse(this.course);
}

class TeacherSaveChapter extends TeacherCourseEvent {
  final Chapter chapter;

  TeacherSaveChapter(this.chapter);
}

class TeacherSaveLesson extends TeacherCourseEvent {
  final Lesson lesson;

  TeacherSaveLesson(this.lesson);
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

class TeacherCreateChapter extends TeacherCourseEvent {
  final CreateChapterRequest request;

  TeacherCreateChapter(this.request);
}

class TeacherUpdateChapter extends TeacherCourseEvent {
  final int chapterId;
  final UpdateChapterRequest request;

  TeacherUpdateChapter(this.chapterId, this.request);
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
