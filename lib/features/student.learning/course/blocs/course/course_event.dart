part of 'course_bloc.dart';

abstract class CourseEvent {}

class SearchCourses extends CourseEvent {
  final CourseSearchRequest searchRequest;
  final bool isLoadingMore;

  SearchCourses(this.searchRequest, {this.isLoadingMore = false});
}

class FetchCourseDetail extends CourseEvent {
  final int courseId;

  FetchCourseDetail(this.courseId);
}

class EnrollInCourse extends CourseEvent {
  final int courseId;

  EnrollInCourse(this.courseId);
}

class AddToWishlist extends CourseEvent {
  final int courseId;

  AddToWishlist(this.courseId);
}

class DeleteFromWishlist extends CourseEvent {
  final int courseId;

  DeleteFromWishlist(this.courseId);
}
