part of 'profile_bloc.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final User user;

  ProfileLoaded(this.user);
}

class ProfileError extends ProfileState {
  final Map<String, dynamic>? error;

  ProfileError(this.error);
}

class ProfileUpdating extends ProfileState {}

class ProfileUpdated extends ProfileState {
  final User user;

  ProfileUpdated(this.user);
}

class ProfileUpdateError extends ProfileState {
  final Map<String, dynamic>? error;

  ProfileUpdateError(this.error);
}
