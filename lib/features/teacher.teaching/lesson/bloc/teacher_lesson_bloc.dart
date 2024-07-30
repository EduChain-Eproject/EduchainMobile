import 'package:bloc/bloc.dart';
import 'package:educhain/features/teacher.teaching/lesson/teacher_lesson_service.dart';

part 'teacher_lesson_event.dart';
part 'teacher_lesson_state.dart';

class TeacherLessonBloc extends Bloc<TeacherLessonEvent, TeacherLessonState> {
  final TeacherLessonService teacherLessonService;

  TeacherLessonBloc(this.teacherLessonService) : super(TeacherLessonInitial()) {
    on<TeacherLessonEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
