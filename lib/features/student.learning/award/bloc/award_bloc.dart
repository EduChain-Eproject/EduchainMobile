import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:educhain/core/models/award.dart';
import 'package:educhain/features/student.learning/award/award_service.dart';

part 'award_event.dart';
part 'award_state.dart';

class AwardBloc extends Bloc<AwardEvent, AwardState> {
  final AwardService _awardService;

  AwardBloc(this._awardService) : super(AwardInitial()) {
    on<FetchAwardDetail>((event, emit) async {
      emit(AwardLoading());
      final response = await _awardService.getAwardDetail(event.awardId);
      response.on(
        onSuccess: (res) => emit(AwardLoaded(res)),
        onError: (error) => emit(AwardError(error['message'])),
      );
    });
  }
}
