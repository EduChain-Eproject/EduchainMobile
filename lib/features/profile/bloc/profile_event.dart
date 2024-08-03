part of 'profile_bloc.dart';

abstract class ProfileEvent {}

class GetProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final UpdateUserRequest request;

  UpdateProfile(this.request);
}
