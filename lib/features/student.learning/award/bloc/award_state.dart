part of 'award_bloc.dart';

abstract class AwardState {}

class AwardInitial extends AwardState {}

class AwardLoading extends AwardState {}

class AwardLoaded extends AwardState {
  final Award award;

  AwardLoaded(this.award);
}

class AwardError extends AwardState {
  final Map<String, dynamic> message;

  AwardError(this.message);
}

class AwardReceiving extends AwardState {}

class AwardReceived extends AwardState {
  final Award award;

  AwardReceived(this.award);
}

class AwardReceiveError extends AwardState {
  final Map<String, dynamic> message;

  AwardReceiveError(this.message);
}
