import 'package:bloc/bloc.dart';
import 'package:educhain/features/teacher.teaching/course/teacher_course_service.dart';
import 'package:meta/meta.dart';

part 'teacher_course_event.dart';
part 'teacher_course_state.dart';

class TeacherCourseBloc extends Bloc<TeacherCourseEvent, TeacherCourseState> {
  final TeacherCourseService teacherCourseService;

  TeacherCourseBloc(this.teacherCourseService) : super(TeacherCourseInitial()) {
    on<TeacherCourseEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
