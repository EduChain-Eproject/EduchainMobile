import 'package:educhain/core/api_service.dart';
import 'package:educhain/core/models/homework.dart';
import 'package:educhain/core/types/api_response.dart';

import 'models/homework_detail_response.dart';

class HomeworkService extends ApiService {
  ApiResponse<HomeworkDetailResponse> getHomeworkDetail(int homeworkId) async {
    return get<HomeworkDetailResponse>(
      'STUDENT/api/homework/detail/$homeworkId',
      (json) => HomeworkDetailResponse.fromJson(json),
    );
  }
}
