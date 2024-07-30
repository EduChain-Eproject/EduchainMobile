part of 'course_bloc.dart';

abstract class CourseEvent {}

class FetchCategories extends CourseEvent {}

class SearchCourses extends CourseEvent {
  final CourseSearchRequest searchRequest;

  SearchCourses(this.searchRequest);
}

class FetchCourseDetail extends CourseEvent {
  final int courseId;

  FetchCourseDetail(this.courseId);
}
