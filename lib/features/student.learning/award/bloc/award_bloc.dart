import 'package:bloc/bloc.dart';
import 'package:educhain/features/student.learning/award/award_service.dart';
import 'package:meta/meta.dart';

part 'award_event.dart';
part 'award_state.dart';

class AwardBloc extends Bloc<AwardEvent, AwardState> {
  final AwardService awardService;

  AwardBloc(this.awardService) : super(AwardInitial()) {
    on<AwardEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
