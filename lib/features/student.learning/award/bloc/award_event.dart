part of 'award_bloc.dart';

abstract class AwardEvent {}

class FetchAwardDetail extends AwardEvent {
  final int awardId;

  FetchAwardDetail(this.awardId);
}

class ReceiveAward extends AwardEvent {
  final int homeworkId;

  ReceiveAward(this.homeworkId);
}
