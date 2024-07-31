import 'package:educhain/core/api_service.dart';
import 'package:educhain/core/models/lesson.dart';
import 'package:educhain/core/types/api_response.dart';

class LessonService extends ApiService {
  // Fetch lesson details by lesson ID
  ApiResponse<Lesson> getLessonDetail(int lessonId) async {
    return get<Lesson>(
      'STUDENT/api/lesson/detail/$lessonId',
      (json) => Lesson.fromJson(json),
    );
  }
}
