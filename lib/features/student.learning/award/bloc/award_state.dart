part of 'award_bloc.dart';

abstract class AwardState {}

class AwardInitial extends AwardState {}

class AwardLoading extends AwardState {}

class AwardLoaded extends AwardState {
  final Award award;

  AwardLoaded(this.award);
}

class AwardError extends AwardState {
  final String message;

  AwardError(this.message);
}
