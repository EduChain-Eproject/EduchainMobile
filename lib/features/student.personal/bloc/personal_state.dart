part of 'personal_bloc.dart';

abstract class PersonalState {}

class PersonalInitial extends PersonalState {}

class ParticipatedCoursesLoading extends PersonalState {}

class ParticipatedCoursesLoaded extends PersonalState {
  final Page<UserCourse> courses;

  ParticipatedCoursesLoaded(this.courses);
}

class ParticipatedCoursesError extends PersonalState {
  final Map<String, dynamic>? errors;

  ParticipatedCoursesError(this.errors);
}

class UserHomeworksLoading extends PersonalState {}

class UserHomeworksLoaded extends PersonalState {
  final Page<UserHomework> homeworks;

  UserHomeworksLoaded(this.homeworks);
}

class UserHomeworksError extends PersonalState {
  final Map<String, dynamic>? errors;

  UserHomeworksError(this.errors);
}

// class UserAwardsLoading extends PersonalState {}

// class UserAwardsLoaded extends PersonalState {
//   final Page<Award> awards;

//   UserAwardsLoaded(this.awards);
// }

// class UserAwardsError extends PersonalState {
//   final Map<String, dynamic>? errors;

//   UserAwardsError(this.errors);
// }

class UserInterestsLoading extends PersonalState {}

class UserInterestsLoaded extends PersonalState {
  final Page<UserInterests> interests;

  UserInterestsLoaded(this.interests);
}

class UserInterestsError extends PersonalState {
  final Map<String, dynamic>? errors;

  UserInterestsError(this.errors);
}

class UserInterestSaving extends PersonalState {}

class UserInterestSaved extends PersonalState {
  final UserInterests userInterest;
  final String? status;

  UserInterestSaved(this.userInterest, {this.status});
}

class UserInterestSaveError extends PersonalState {
  final Map<String, dynamic>? errors;

  UserInterestSaveError(this.errors);
}
