import 'package:educhain/core/api_service.dart';
import 'package:educhain/core/models/chapter.dart';
import 'package:educhain/core/models/course.dart';
import 'package:educhain/core/models/lesson.dart';
import 'package:educhain/core/types/api_response.dart';
import 'package:educhain/core/types/page.dart';

import 'models/course_search_request.dart';
import 'models/create_chapter_request.dart';
import 'models/create_course_request.dart';
import 'models/create_lesson_request.dart';
import 'models/update_chapter_request.dart';
import 'models/update_course_request.dart';
import 'models/update_lesson_request.dart';

class TeacherCourseService extends ApiService {
  ApiResponse<Page<Course>> fetchTeacherCourses(
      CourseSearchRequest searchRequest) async {
    return post<Page<Course>>(
      'TEACHER/api/course/list',
      (json) => Page.fromJson(json, (item) => Course.fromJson(item)),
      searchRequest.toJson(),
    );
  }

  ApiResponse<Course> getCourseDetail(int courseId) async {
    return get<Course>(
      'TEACHER/api/course/detail/$courseId',
      (json) => Course.fromJson(json),
    );
  }

  ApiResponse<Course> createCourse(CreateCourseRequest request) async {
    return post<Course>(
      'TEACHER/api/course/create',
      (json) => Course.fromJson(json),
      request.toJson(),
    );
  }

  ApiResponse<Course> updateCourse(
      int courseId, UpdateCourseRequest request) async {
    return put<Course>(
      'TEACHER/api/course/update/$courseId',
      (json) => Course.fromJson(json),
      request.toJson(),
    );
  }

  ApiResponse<Chapter> createChapter(CreateChapterRequest request) async {
    return post<Chapter>(
      'TEACHER/api/chapter/create',
      (json) => Chapter.fromJson(json),
      request.toJson(),
    );
  }

  ApiResponse<Chapter> updateChapter(
      int chapterId, UpdateChapterRequest request) async {
    return put<Chapter>(
      'TEACHER/api/chapter/update/$chapterId',
      (json) => Chapter.fromJson(json),
      request.toJson(),
    );
  }

  ApiResponse<Lesson> createLesson(CreateLessonRequest request) async {
    return post<Lesson>(
      'TEACHER/api/lesson/create',
      (json) => Lesson.fromJson(json),
      request.toJson(),
    );
  }

  ApiResponse<Lesson> updateLesson(
      int lessonId, UpdateLessonRequest request) async {
    return put<Lesson>(
      'TEACHER/api/lesson/update/$lessonId',
      (json) => Lesson.fromJson(json),
      request.toJson(),
    );
  }
}
