part of 'personal_bloc.dart';

abstract class PersonalEvent {}

class FetchParticipatedCourses extends PersonalEvent {
  final bool isLoadingMore;

  final ParticipatedCoursesRequest request;

  FetchParticipatedCourses(this.request, {this.isLoadingMore = false});
}

class FetchUserHomeworks extends PersonalEvent {
  final bool isLoadingMore;

  final UserHomeworksRequest request;

  FetchUserHomeworks(this.request, {this.isLoadingMore = false});
}

// class FetchUserAwards extends PersonalEvent {

//   final UserAwardsRequest request;

//   FetchUserAwards(this.request, {this.isLoadingMore = false});
// }

class FetchUserInterests extends PersonalEvent {
  final bool isLoadingMore;

  final UserInterestsRequest request;

  FetchUserInterests(this.request, {this.isLoadingMore = false});
}

class AddUserInterest extends PersonalEvent {
  final AddOrDeleteInterestRequest request;

  AddUserInterest(this.request);
}

class RemoveUserInterest extends PersonalEvent {
  final AddOrDeleteInterestRequest request;

  RemoveUserInterest(this.request);
}
