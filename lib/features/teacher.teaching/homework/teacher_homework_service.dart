import 'package:educhain/core/api_service.dart';
import 'package:educhain/core/models/answer.dart';
import 'package:educhain/core/models/homework.dart';
import 'package:educhain/core/models/lesson.dart';
import 'package:educhain/core/models/question.dart';
import 'package:educhain/core/types/api_response.dart';

import 'models/create_homework_request.dart';
import 'models/create_question_request.dart';
import 'models/update_answer_request.dart';
import 'models/update_homework_request.dart';
import 'models/update_question_request.dart';

class TeacherHomeworkService extends ApiService {
  ApiResponse<Lesson> fetchHomeworks(int lessonId) {
    return get<Lesson>(
      'TEACHER/api/lesson/detail/$lessonId',
      (json) => Lesson.fromJson(json),
    );
  }

  ApiResponse<Homework> getHomeworkDetail(int homeworkId) {
    return get<Homework>(
      'TEACHER/api/homework/detail/$homeworkId',
      (json) => Homework.fromJson(json),
    );
  }

  ApiResponse<Homework> createHomework(CreateHomeworkRequest request) {
    return post<Homework>(
      'TEACHER/api/homework/create',
      Homework.fromJson,
      request.toJson(),
    );
  }

  ApiResponse<Homework> updateHomework(
      int homeworkId, UpdateHomeworkRequest request) {
    return put<Homework>(
      'TEACHER/api/homework/update/$homeworkId',
      Homework.fromJson,
      request.toJson(),
    );
  }

  ApiResponse<Homework> deleteHomework(int homeworkId) {
    return delete<Homework>(
        'TEACHER/api/homework/delete/$homeworkId', Homework.fromJson, null);
  }

  ApiResponse<Question> createQuestion(CreateQuestionRequest request) {
    return post<Question>(
      'TEACHER/api/question/create',
      Question.fromJson,
      request.toJson(),
    );
  }

  ApiResponse<Question> updateQuestion(
      int questionId, UpdateQuestionRequest request) {
    return put<Question>(
      'TEACHER/api/question/update/$questionId',
      Question.fromJson,
      request.toJson(),
    );
  }

  ApiResponse<Question> deleteQuestion(int questionId) {
    return delete<Question>(
        'TEACHER/api/question/delete/$questionId', Question.fromJson, null);
  }

  ApiResponse<Answer> updateAnswer(int answerId, UpdateAnswerRequest request) {
    return put<Answer>(
      'TEACHER/api/answer/update/$answerId',
      Answer.fromJson,
      request.toJson(),
    );
  }
}
