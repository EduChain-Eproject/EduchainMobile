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
      if (state is TeacherHomeworksLoaded) {
        final currentState = state as TeacherHomeworksLoaded;
        final lesson = currentState.lesson;
        final homeworks = lesson.homeworkDtos?.map((hw) {
          if (hw.id == event.homeworkId) {
            return hw.copyWith(isLoadingDetail: true); // Indicate loading
          }
          return hw;
        }).toList();

        emit(TeacherHomeworksLoaded(lesson.copyWith(homeworkDtos: homeworks)));

        final response =
            await teacherHomeworkService.getHomeworkDetail(event.homeworkId);
        await response.on(
          onSuccess: (homeworkDetail) {
            final updatedHomeworks = lesson.homeworkDtos?.map((hw) {
              if (hw.id == event.homeworkId) {
                return homeworkDetail.copyWith(
                    isLoadingDetail: false); // Clear loading state
              }
              return hw;
            }).toList();

            emit(TeacherHomeworksLoaded(
                lesson.copyWith(homeworkDtos: updatedHomeworks)));
          },
          onError: (error) {
            final homeworksWithError = lesson.homeworkDtos?.map((hw) {
              if (hw.id == event.homeworkId) {
                return hw.copyWith(
                    isLoadingDetail: false); // Clear loading state on error
              }
              return hw;
            }).toList();
            emit(TeacherHomeworksLoaded(
                lesson.copyWith(homeworkDtos: homeworksWithError)));
            emit(TeacherHomeworksError(error['message']));
          },
        );
      }
    });

    on<TeacherCreateHomework>((event, emit) async {
      final response =
          await teacherHomeworkService.createHomework(event.request);
      await response.on(
        onSuccess: (_) => emit(TeacherHomeworksLoading()),
        onError: (errors) => emit(TeacherHomeworksError(errors)),
      );
    });

    on<TeacherUpdateHomework>((event, emit) async {
      final response =
          await teacherHomeworkService.updateHomework(event.request);
      await response.on(
        onSuccess: (_) => emit(TeacherHomeworksLoading()),
        onError: (errors) => emit(TeacherHomeworksError(errors)),
      );
    });

    on<TeacherCreateQuestion>((event, emit) async {
      emit(TeacherQuestionSaving());
      final response =
          await teacherHomeworkService.createQuestion(event.request);
      await response.on(
        onSuccess: (question) => emit(TeacherQuestionSaved(question)),
        onError: (errors) => emit(TeacherQuestionSaveError(errors)),
      );
    });

    on<TeacherUpdateQuestion>((event, emit) async {
      emit(TeacherQuestionSaving());
      final response = await teacherHomeworkService.updateQuestion(
          event.questionId, event.request);
      await response.on(
        onSuccess: (question) => emit(TeacherQuestionSaved(question)),
        onError: (errors) => emit(TeacherQuestionSaveError(errors)),
      );
    });

    on<TeacherUpdateAnswer>((event, emit) async {
      emit(TeacherAnswerSaving());
      final response = await teacherHomeworkService.updateAnswer(
          event.answerId, event.request);
      await response.on(
        onSuccess: (answer) => emit(TeacherAnswerSaved(answer)),
        onError: (errors) => emit(TeacherAnswerSaveError(errors)),
      );
    });
  }
}
