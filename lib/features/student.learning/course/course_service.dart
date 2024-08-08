import 'package:educhain/core/api_service.dart';
import 'package:educhain/core/models/category.dart';
import 'package:educhain/core/models/course.dart';
import 'package:educhain/core/models/user_course.dart';
import 'package:educhain/core/models/user_interests.dart';
import 'package:educhain/core/types/api_response.dart';
import 'package:educhain/core/types/page.dart';

import 'models/course_search_request.dart';

class CourseService extends ApiService {
  ApiResponse<List<Category>> fetchCategories() async {
    return getList<Category>(
      'COMMON/api/category/list',
      (json) => Category.fromJson(json),
    );
  }

  ApiResponse<Page<Course>> searchCourses(
      CourseSearchRequest searchRequest) async {
    return post<Page<Course>>(
      'STUDENT/api/course/list',
      (json) => Page.fromJson(json, (item) => Course.fromJson(item)),
      searchRequest.toJson(),
    );
  }

  ApiResponse<Course> getCourseDetail(int courseId) async {
    return get<Course>(
      'STUDENT/api/course/detail/$courseId',
      (json) => Course.fromJson(json),
    );
  }

  ApiResponse<UserCourse> enrollInCourse(int courseId) async {
    return post<UserCourse>(
      'STUDENT/api/course/enroll-in-a-course/$courseId',
      UserCourse.fromJson,
      null,
    );
  }

  ApiResponse<UserInterests> addToWishlist(int courseId) async {
    return post<UserInterests>(
      'STUDENT/add-to-wishlist/$courseId',
      UserInterests.fromJson,
      null,
    );
  }

  ApiResponse<bool> deleteFromWishlist(int courseId) async {
    return delete<bool>(
      'STUDENT/delete-wishlist/$courseId',
      null,
      null,
    );
  }
}
