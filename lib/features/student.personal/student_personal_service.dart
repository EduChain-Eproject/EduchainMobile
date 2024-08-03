import 'package:educhain/core/api_service.dart';
import 'package:educhain/core/models/user_course.dart';
import 'package:educhain/core/models/user_homework.dart';
import 'package:educhain/core/models/user_interests.dart';
import 'package:educhain/core/types/api_response.dart';
import 'package:educhain/core/types/page.dart';

import 'models/participated_courses_request.dart';
import 'models/user_homeworks_request.dart';
import 'models/user_interests_request.dart';

class StudentPersonalService extends ApiService {
  ApiResponse<Page<UserCourse>> getParticipatedCourses(
      ParticipatedCoursesRequest request) async {
    return post<Page<UserCourse>>(
      'STUDENT/all-user-course',
      (json) => Page.fromJson(json, (item) => UserCourse.fromJson(item)),
      request.toJson(),
    );
  }

  ApiResponse<Page<UserHomework>> getUserHomeworks(
      UserHomeworksRequest request) async {
    return post<Page<UserHomework>>(
      'STUDENT/list-homework',
      (json) => Page.fromJson(json, (item) => UserHomework.fromJson(item)),
      request.toJson(),
    );
  }

  ApiResponse<Page<UserInterests>> getUserInterests(
      UserInterestsRequest request) async {
    return post<Page<UserInterests>>(
        'STUDENT/get-user-interest',
        (json) => Page.fromJson(json, (item) => UserInterests.fromJson(item)),
        request.toJson());
  }

  ApiResponse<UserInterests> addUserInterest(
      AddOrDeleteInterestRequest request) async {
    return post<UserInterests>(
        'STUDENT/add-to-wishlist', UserInterests.fromJson, request.toJson());
  }

  ApiResponse<bool> removeUserInterest(
      AddOrDeleteInterestRequest request) async {
    return delete('STUDENT/delete-wishlist', null, request.toJson());
  }
}
