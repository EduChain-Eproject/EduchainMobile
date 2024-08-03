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

class UserInterestsLoading extends PersonalState {}

class UserInterestsLoaded extends PersonalState {
  final Page<UserInterests> interests;

  UserInterestsLoaded(this.interests);
}

class UserInterestsError extends PersonalState {
  final Map<String, dynamic>? errors;

  UserInterestsError(this.errors);
}

class UserInterestAdding extends PersonalState {}

class UserInterestAdded extends PersonalState {
  final int userId;
  final int courseId;

  UserInterestAdded(this.userId, this.courseId);
}

class UserInterestAddError extends PersonalState {
  final Map<String, dynamic>? errors;

  UserInterestAddError(this.errors);
}

class UserInterestRemoving extends PersonalState {}

class UserInterestRemoved extends PersonalState {
  final int userId;
  final int courseId;

  UserInterestRemoved(this.userId, this.courseId);
}

class UserInterestRemoveError extends PersonalState {
  final Map<String, dynamic>? errors;

  UserInterestRemoveError(this.errors);
}
