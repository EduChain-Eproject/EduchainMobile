import 'package:educhain/core/api_service.dart';
import 'package:educhain/core/models/category.dart';
import 'package:educhain/core/models/course.dart';
import 'package:educhain/core/models/user.dart';
import 'package:educhain/core/types/api_response.dart';
import 'package:educhain/features/student/models/statistics.dart';

class StudentHomeService extends ApiService {
  ApiResponse<List<Category>> getPopularCategories() async {
    final response = await getList<Category>(
        'HOME/api/best-categories', (json) => Category.fromJson(json));

    return response;
  }

  ApiResponse<List<Course>> getBestCourses() async {
    final response = await getList<Course>(
        'HOME/api/signature-courses', (json) => Course.fromJson(json));

    return response;
  }

  ApiResponse<Statistics> getStatistics() async {
    final response = await get<Statistics>(
        'HOME/api/statistics', (json) => Statistics.fromJson(json));

    return response;
  }

  ApiResponse<User> getBestTeacher() async {
    final response = await get<User>(
        'HOME/api/most-popular-teacher', (json) => User.fromJson(json));

    return response;
  }
}
