import 'package:educhain/core/models/award.dart';
import 'package:educhain/core/models/user_homework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:educhain/core/models/homework.dart';
import 'package:educhain/features/student.learning/homework/homework_service.dart';

part 'homework_event.dart';
part 'homework_state.dart';

class HomeworkBloc extends Bloc<HomeworkEvent, HomeworkState> {
  final HomeworkService homeworkService;

  HomeworkBloc(this.homeworkService) : super(HomeworkInitial()) {
    on<FetchHomeworkDetail>((event, emit) async {
      emit(HomeworkLoading());
      final response =
          await homeworkService.getHomeworkDetail(event.homeworkId);
      response.on(
        onSuccess: (res) => emit(
            HomeworkLoaded(res.homeworkDto, res.userHomeworkDto, res.awardDto)),
        onError: (error) => emit(HomeworkError(error['message'])),
      );
    });
  }
}
