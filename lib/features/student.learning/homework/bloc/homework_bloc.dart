import 'package:educhain/core/models/award.dart';
import 'package:educhain/core/models/user_answer.dart';
import 'package:educhain/core/models/user_homework.dart';
import 'package:educhain/features/student.learning/homework/models/answer_question_request.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:educhain/core/models/homework.dart';
import 'package:educhain/features/student.learning/homework/homework_service.dart';

import '../models/submission_response.dart';

part 'homework_event.dart';
part 'homework_state.dart';

class HomeworkBloc extends Bloc<HomeworkEvent, HomeworkState> {
  final HomeworkService homeworkService;

  HomeworkBloc(this.homeworkService) : super(HomeworkInitial()) {
    on<FetchHomeworkDetail>((event, emit) async {
      emit(HomeworkLoading());
      final response =
          await homeworkService.getHomeworkDetail(event.homeworkId);
      await response.on(
        onSuccess: (res) => emit(
            HomeworkLoaded(res.homeworkDto, res.userHomeworkDto, res.awardDto)),
        onError: (error) => emit(HomeworkError(error)),
      );
    });

    on<AnswerQuestion>((event, emit) async {
      HomeworkLoaded? currentState = _getCurrentState();

      emit(HomeworkQuestionAnswering());

      final response =
          await homeworkService.answerQuestion(event.homeworkId, event.request);

      await response.on(
        onSuccess: (res) {
          if (currentState != null) {
            // Update the user answer in the homework questions
            final updatedQuestions =
                currentState.homework.questionDtos?.map((q) {
              if (q.id == event.request.questionId) {
                return q.copyWith(currentUserAnswerDto: res);
              }
              return q;
            }).toList();

            // Emit the new state with the updated homework and userHomework
            emit(HomeworkLoaded(
              currentState.homework.copyWith(questionDtos: updatedQuestions),
              currentState.userHomework,
              currentState.award,
            ));
          } else {
            emit(HomeworkQuestionAnswerError(
                {"message": "Unable to answer the question"}));
          }
        },
        onError: (error) => emit(HomeworkQuestionAnswerError(error)),
      );
    });

    on<SubmitHomework>((event, emit) async {
      HomeworkLoaded? currentState = _getCurrentState();
      emit(HomeworkSubmitting());
      final response = await homeworkService.submitHomework(event.homeworkId);
      await response.on(
        onSuccess: (res) {
          if (currentState != null) {
            emit(HomeworkLoaded(
                currentState.homework, res.submission, res.award));
          } else {
            emit(HomeworkSubmitError(
                {"message": "Unable to submit the homework"}));
          }
        },
        onError: (error) => emit(HomeworkSubmitError(error)),
      );
    });
  }

  HomeworkLoaded? _getCurrentState() {
    if (state is HomeworkLoaded) {
      return state as HomeworkLoaded;
    } else {
      return null;
    }
  }
}
