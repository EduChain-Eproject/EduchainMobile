import 'package:bloc/bloc.dart';
import 'package:educhain/features/student.learning/lesson/lesson_service.dart';

part 'lesson_event.dart';
part 'lesson_state.dart';

class LessonBloc extends Bloc<LessonEvent, LessonState> {
  final LessonService lessonService;

  LessonBloc(this.lessonService) : super(LessonInitial()) {
    on<LessonEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
