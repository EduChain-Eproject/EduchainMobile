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

        emit(TeacherHomeworkDetailLoading(event.homeworkId));

        final lesson = currentState.lesson;
        final homeworks = lesson.homeworkDtos?.map((hw) {
          if (hw.id == event.homeworkId) {
            return hw.copyWith(isLoadingDetail: true);
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
                return homeworkDetail.copyWith(isLoadingDetail: false);
              }
              return hw;
            }).toList();

            emit(TeacherHomeworksLoaded(
                lesson.copyWith(homeworkDtos: updatedHomeworks)));
          },
          onError: (error) {
            final homeworksWithError = lesson.homeworkDtos?.map((hw) {
              if (hw.id == event.homeworkId) {
                return hw.copyWith(isLoadingDetail: false);
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
      emit(TeacherHomeworkSaving());
      final response =
          await teacherHomeworkService.createHomework(event.request);
      await response.on(
        onSuccess: (homework) {
          if (state is TeacherHomeworksLoaded) {
            final currentState = state as TeacherHomeworksLoaded;
            final updatedHomeworks =
                List<Homework>.from(currentState.lesson.homeworkDtos ?? [])
                  ..add(homework);
            emit(TeacherHomeworksLoaded(
                currentState.lesson.copyWith(homeworkDtos: updatedHomeworks)));
          }
          emit(TeacherHomeworkSaved(homework));
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
          if (state is TeacherHomeworksLoaded) {
            final currentState = state as TeacherHomeworksLoaded;
            final updatedHomeworks =
                currentState.lesson.homeworkDtos?.map((hw) {
              if (hw.id == event.homeworkId) {
                return homework;
              }
              return hw;
            }).toList();
            emit(TeacherHomeworksLoaded(
                currentState.lesson.copyWith(homeworkDtos: updatedHomeworks)));
          }
          emit(TeacherHomeworkSaved(homework));
        },
        onError: (errors) => emit(TeacherHomeworkSaveError(errors)),
      );
    });

    on<TeacherDeleteHomework>((event, emit) async {
      emit(TeacherHomeworkDeleting());
      final response =
          await teacherHomeworkService.deleteHomework(event.homeworkId);
      await response.on(
        onSuccess: (_) {
          if (state is TeacherHomeworksLoaded) {
            final currentState = state as TeacherHomeworksLoaded;
            final updatedHomeworks = currentState.lesson.homeworkDtos
                ?.where((hw) => hw.id != event.homeworkId)
                .toList();
            emit(TeacherHomeworksLoaded(
                currentState.lesson.copyWith(homeworkDtos: updatedHomeworks)));
          }
          emit(TeacherHomeworkDeleted(event.homeworkId));
        },
        onError: (errors) => emit(TeacherHomeworkDeleteError(errors)),
      );
    });

    on<TeacherCreateQuestion>((event, emit) async {
      emit(TeacherQuestionSaving());
      final response =
          await teacherHomeworkService.createQuestion(event.request);
      await response.on(
        onSuccess: (question) {
          if (state is TeacherHomeworksLoaded) {
            final currentState = state as TeacherHomeworksLoaded;
            final updatedHomeworks =
                currentState.lesson.homeworkDtos?.map((hw) {
              if (hw.id == event.homeworkId) {
                final updatedQuestions = [question, ...?hw.questionDtos];
                return hw.copyWith(questionDtos: updatedQuestions);
              }
              return hw;
            }).toList();
            emit(TeacherHomeworksLoaded(
                currentState.lesson.copyWith(homeworkDtos: updatedHomeworks)));
          }
          emit(TeacherQuestionSaved(question));
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
          if (state is TeacherHomeworksLoaded) {
            final currentState = state as TeacherHomeworksLoaded;
            final updatedHomeworks =
                currentState.lesson.homeworkDtos?.map((hw) {
              if (hw.id == event.homeworkId) {
                final updatedQuestions = hw.questionDtos?.map((q) {
                  if (q.id == event.questionId) {
                    return question;
                  }
                  return q;
                }).toList();
                return hw.copyWith(questionDtos: updatedQuestions);
              }
              return hw;
            }).toList();
            emit(TeacherHomeworksLoaded(
                currentState.lesson.copyWith(homeworkDtos: updatedHomeworks)));
          }
          emit(TeacherQuestionSaved(question));
        },
        onError: (errors) => emit(TeacherQuestionSaveError(errors)),
      );
    });

    on<TeacherDeleteQuestion>((event, emit) async {
      emit(TeacherQuestionDeleting());
      final response =
          await teacherHomeworkService.deleteQuestion(event.questionId);
      await response.on(
        onSuccess: (_) {
          if (state is TeacherHomeworksLoaded) {
            final currentState = state as TeacherHomeworksLoaded;
            final updatedHomeworks =
                currentState.lesson.homeworkDtos?.map((hw) {
              if (hw.id == event.homeworkId) {
                final updatedQuestions = hw.questionDtos
                    ?.where((q) => q.id != event.questionId)
                    .toList();
                return hw.copyWith(questionDtos: updatedQuestions);
              }
              return hw;
            }).toList();
            emit(TeacherHomeworksLoaded(
                currentState.lesson.copyWith(homeworkDtos: updatedHomeworks)));
          }
          emit(TeacherQuestionDeleted(event.questionId));
        },
        onError: (errors) => emit(TeacherQuestionDeleteError(errors)),
      );
    });

    on<TeacherUpdateAnswer>((event, emit) async {
      emit(TeacherAnswerSaving());
      final response = await teacherHomeworkService.updateAnswer(
          event.answerId, event.request);
      await response.on(
        onSuccess: (answer) {
          if (state is TeacherHomeworksLoaded) {
            final currentState = state as TeacherHomeworksLoaded;
            final updatedHomeworks =
                currentState.lesson.homeworkDtos?.map((hw) {
              if (hw.id == event.homeworkId) {
                final updatedQuestions = hw.questionDtos?.map((q) {
                  if (q.id == event.questionId) {
                    final updatedAnswers = q.answerDtos?.map((a) {
                      if (a.id == event.answerId) {
                        return answer;
                      }
                      return a;
                    }).toList();
                    return q.copyWith(answerDtos: updatedAnswers);
                  }
                  return q;
                }).toList();
                return hw.copyWith(questionDtos: updatedQuestions);
              }
              return hw;
            }).toList();
            emit(TeacherHomeworksLoaded(
                currentState.lesson.copyWith(homeworkDtos: updatedHomeworks)));
          }
          emit(TeacherAnswerSaved(answer));
        },
        onError: (errors) => emit(TeacherAnswerSaveError(errors)),
      );
    });
  }
}
