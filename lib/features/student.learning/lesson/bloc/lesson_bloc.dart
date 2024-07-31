import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:educhain/core/models/lesson.dart';
import 'package:educhain/features/student.learning/lesson/lesson_service.dart';

part 'lesson_event.dart';
part 'lesson_state.dart';

class LessonBloc extends Bloc<LessonEvent, LessonState> {
  final LessonService lessonService;

  LessonBloc(this.lessonService) : super(LessonInitial()) {
    on<FetchLessonDetail>((event, emit) async {
      emit(LessonDetailLoading());
      final response = await lessonService.getLessonDetail(event.lessonId);
      await response.on(
        onSuccess: (lessonDetail) => emit(LessonDetailLoaded(lessonDetail)),
        onError: (error) => emit(LessonDetailError(error['message'])),
      );
    });
  }
}
