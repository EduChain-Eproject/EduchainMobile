part of 'teacher_homework_bloc.dart';

abstract class TeacherHomeworkEvent {}

class TeacherFetchHomeworks extends TeacherHomeworkEvent {
  final int lessonId;
  TeacherFetchHomeworks(this.lessonId);
}

class TeacherFetchHomeworkDetail extends TeacherHomeworkEvent {
  final int homeworkId;
  TeacherFetchHomeworkDetail(this.homeworkId);
}

class TeacherCreateHomework extends TeacherHomeworkEvent {
  final CreateHomeworkRequest request;
  TeacherCreateHomework(this.request);
}

class TeacherUpdateHomework extends TeacherHomeworkEvent {
  final int homeworkId;
  final UpdateHomeworkRequest request;
  TeacherUpdateHomework(this.homeworkId, this.request);
}

class TeacherDeleteHomework extends TeacherHomeworkEvent {
  final int homeworkId;
  TeacherDeleteHomework(this.homeworkId);
}

class TeacherCreateQuestion extends TeacherHomeworkEvent {
  final CreateQuestionRequest request;
  TeacherCreateQuestion(this.request);
}

class TeacherUpdateQuestion extends TeacherHomeworkEvent {
  final int questionId;
  final UpdateQuestionRequest request;
  TeacherUpdateQuestion(this.questionId, this.request);
}

class TeacherDeleteQuestion extends TeacherHomeworkEvent {
  final int questionId;
  TeacherDeleteQuestion(this.questionId);
}

class TeacherUpdateAnswer extends TeacherHomeworkEvent {
  final int homeworkId;
  final int questionId;
  final int answerId;
  final UpdateAnswerRequest request;
  TeacherUpdateAnswer(
      this.answerId, this.request, this.homeworkId, this.questionId);
}
