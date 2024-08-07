import 'package:educhain/core/api_service.dart';
import 'package:educhain/core/models/user_answer.dart';
import 'package:educhain/core/types/api_response.dart';

import 'models/answer_question_request.dart';
import 'models/homework_detail_response.dart';
import 'models/submission_response.dart';

class HomeworkService extends ApiService {
  ApiResponse<HomeworkDetailResponse> getHomeworkDetail(int homeworkId) async {
    return get<HomeworkDetailResponse>(
      'STUDENT/api/homework/detail/$homeworkId',
      (json) => HomeworkDetailResponse.fromJson(json),
    );
  }

  ApiResponse<SubmissionResponse> submitHomework(int homeworkId) async {
    return post('STUDENT/api/homework/submit/$homeworkId',
        SubmissionResponse.fromJson, null);
  }

  ApiResponse<UserAnswer> answerQuestion(
      int homeworkId, AnswerQuestionRequest request) async {
    return post('STUDENT/api/homework/answer/$homeworkId', UserAnswer.fromJson,
        request.toJson());
  }
}
