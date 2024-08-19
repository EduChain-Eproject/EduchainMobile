import 'package:educhain/core/models/answer.dart';
import 'package:educhain/core/models/homework.dart';
import 'package:educhain/core/models/lesson.dart';
import 'package:educhain/core/models/question.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:educhain/features/teacher.teaching/homework/teacher_homework_service.dart';

import '../models/create_homework_request.dart';
import '../models/create_question_request.dart';
import '../models/update_answer_request.dart';
import '../models/update_homework_request.dart';
import '../models/update_question_request.dart';

part 'teacher_homework_event.dart';
part 'teacher_homework_state.dart';

class TeacherHomeworkBloc
    extends Bloc<TeacherHomeworkEvent, TeacherHomeworkState> {
  final TeacherHomeworkService teacherHomeworkService;

  TeacherHomeworkBloc(this.teacherHomeworkService)
      : super(TeacherHomeworkInitial()) {
    on<TeacherFetchHomeworks>((event, emit) async {
      emit(TeacherHomeworksLoading());
      final response =
          await teacherHomeworkService.fetchHomeworks(event.lessonId);
      await response.on(
        onSuccess: (lesson) => emit(TeacherHomeworksLoaded(lesson)),
        onError: (errors) => emit(TeacherHomeworksError(errors)),
      );
    });

    on<TeacherFetchHomeworkDetail>((event, emit) async {
      emit(TeacherHomeworkDetailLoading(event.homeworkId));
      final response =
          await teacherHomeworkService.getHomeworkDetail(event.homeworkId);
      await response.on(
        onSuccess: (homeworkDetail) {
          emit(TeacherHomeworkDetailLoaded(homeworkDetail));
        },
        onError: (errors) {
          emit(TeacherHomeworkDetailError(errors));
        },
      );
    });

    on<TeacherCreateHomework>((event, emit) async {
      emit(TeacherHomeworkSaving());
      final response =
          await teacherHomeworkService.createHomework(event.request);
      await response.on(
        onSuccess: (homework) {
          emit(TeacherHomeworkSaved(homework, status: "created"));
        },
        onError: (errors) => emit(TeacherHomeworkSaveError(errors)),
      );
    });

    on<TeacherUpdateHomework>((event, emit) async {
      emit(TeacherHomeworkSaving());
      final response = await teacherHomeworkService.updateHomework(
          event.homeworkId, event.request);
      await response.on(
        onSuccess: (homework) {
          emit(TeacherHomeworkSaved(homework, status: "updated"));
        },
        onError: (errors) => emit(TeacherHomeworkSaveError(errors)),
      );
    });

    on<TeacherDeleteHomework>((event, emit) async {
      emit(TeacherHomeworkSaving());
      final response =
          await teacherHomeworkService.deleteHomework(event.homeworkId);
      await response.on(
        onSuccess: (homeworkId) {
          emit(TeacherHomeworkSaved(Homework(id: homeworkId),
              status: 'deleted'));
        },
        onError: (errors) => emit(TeacherHomeworkSaveError(errors)),
      );
    });

    on<TeacherCreateQuestion>((event, emit) async {
      emit(TeacherQuestionSaving());
      final response =
          await teacherHomeworkService.createQuestion(event.request);
      await response.on(
        onSuccess: (question) {
          emit(TeacherQuestionSaved(question, status: "created"));
        },
        onError: (errors) => emit(TeacherQuestionSaveError(errors)),
      );
    });

    on<TeacherUpdateQuestion>((event, emit) async {
      emit(TeacherQuestionSaving());
      final response = await teacherHomeworkService.updateQuestion(
          event.questionId, event.request);
      await response.on(
        onSuccess: (question) {
          emit(TeacherQuestionSaved(question, status: "updated"));
        },
        onError: (errors) => emit(TeacherQuestionSaveError(errors)),
      );
    });

    on<TeacherDeleteQuestion>((event, emit) async {
      emit(TeacherQuestionSaving());
      final response =
          await teacherHomeworkService.deleteQuestion(event.questionId);
      await response.on(
        onSuccess: (questionId) {
          emit(TeacherQuestionSaved(Question(id: questionId),
              status: "deleted"));
        },
        onError: (errors) => emit(TeacherQuestionSaveError(errors)),
      );
    });

    on<TeacherUpdateAnswer>((event, emit) async {
      emit(TeacherAnswerSaving());
      final response = await teacherHomeworkService.updateAnswer(
          event.answerId, event.request);
      await response.on(
        onSuccess: (answer) {
          emit(TeacherAnswerSaved(answer));
        },
        onError: (errors) => emit(TeacherAnswerSaveError(errors)),
      );
    });
  }
}
