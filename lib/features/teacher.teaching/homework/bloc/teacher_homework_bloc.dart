import 'package:bloc/bloc.dart';
import 'package:educhain/features/teacher.teaching/homework/teacher_homework_service.dart';

part 'teacher_homework_event.dart';
part 'teacher_homework_state.dart';

class TeacherHomeworkBloc
    extends Bloc<TeacherHomeworkEvent, TeacherHomeworkState> {
  final TeacherHomeworkService teacherHomeworkService;

  TeacherHomeworkBloc(this.teacherHomeworkService)
      : super(TeacherHomeworkInitial()) {
    on<TeacherHomeworkEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
