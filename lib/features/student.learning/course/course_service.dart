import 'package:educhain/core/api_service.dart';
import 'package:educhain/core/models/category.dart';
import 'package:educhain/core/models/course.dart';
import 'package:educhain/core/types/api_response.dart';
import 'package:educhain/core/types/page.dart';

import 'models/course_search_request.dart';

class CourseService extends ApiService {
  // Fetch popular categories
  ApiResponse<List<Category>> fetchCategories() async {
    return getList<Category>(
      'COMMON/api/category/list',
      (json) => Category.fromJson(json),
    );
  }

  // Fetch courses based on search criteria
  ApiResponse<Page<Course>> searchCourses(
      CourseSearchRequest searchRequest) async {
    return post<Page<Course>>(
      'STUDENT/api/course/list',
      (json) => Page.fromJson(json, (item) => Course.fromJson(item)),
      searchRequest.toJson(),
    );
  }

  // Fetch course details by course ID
  ApiResponse<Course> getCourseDetail(int courseId) async {
    return get<Course>(
      'STUDENT/api/course/detail/$courseId',
      (json) => Course.fromJson(json),
    );
  }
}
