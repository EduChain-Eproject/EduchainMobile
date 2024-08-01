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
  final UpdateHomeworkRequest request;
  TeacherUpdateHomework(this.request);
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

class TeacherUpdateAnswer extends TeacherHomeworkEvent {
  final int answerId;
  final UpdateAnswerRequest request;
  TeacherUpdateAnswer(this.answerId, this.request);
}
