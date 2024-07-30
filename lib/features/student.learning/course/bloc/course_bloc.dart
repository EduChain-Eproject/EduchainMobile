import 'package:bloc/bloc.dart';
import 'package:educhain/features/student.learning/course/course_service.dart';

part 'course_event.dart';
part 'course_state.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final CourseService courseService;

  CourseBloc(this.courseService) : super(CourseInitial()) {
    on<CourseEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
