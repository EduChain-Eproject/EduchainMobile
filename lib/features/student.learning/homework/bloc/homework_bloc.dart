import 'package:bloc/bloc.dart';
import 'package:educhain/features/student.learning/homework/homework_service.dart';
import 'package:meta/meta.dart';

part 'homework_event.dart';
part 'homework_state.dart';

class HomeworkBloc extends Bloc<HomeworkEvent, HomeworkState> {
  final HomeworkService homeworkService;

  HomeworkBloc(this.homeworkService) : super(HomeworkInitial()) {
    on<HomeworkEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
