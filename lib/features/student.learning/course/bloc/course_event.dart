part of 'course_bloc.dart';

abstract class CourseEvent {}

class FetchCategories extends CourseEvent {}

class SearchCourses extends CourseEvent {
  final CourseSearchRequest searchRequest;
  final bool isLoadingMore;

  SearchCourses(this.searchRequest, {this.isLoadingMore = false});
}

class FetchCourseDetail extends CourseEvent {
  final int courseId;

  FetchCourseDetail(this.courseId);
}
