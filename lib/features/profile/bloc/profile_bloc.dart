import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:educhain/core/auth/bloc/auth_bloc.dart';
import 'package:educhain/core/models/user.dart';
import '../profile_service.dart';
import '../models/update_user_request.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileService profileService;
  final AuthBloc authBloc;

  ProfileBloc(this.profileService, this.authBloc) : super(ProfileInitial()) {
    on<GetProfile>(_onGetProfile);
    on<UpdateProfile>(_onUpdateProfile);
  }

  Future<void> _onGetProfile(
      GetProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    final response = await profileService.getUserProfile();
    response.on(
      onSuccess: (user) => emit(ProfileLoaded(user)),
      onError: (error) => emit(ProfileError(error)),
    );
  }

  Future<void> _onUpdateProfile(
      UpdateProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileUpdating());
    final response = await profileService.updateUserProfile(event.request);
    response.on(
      onSuccess: (user) {
        emit(ProfileUpdated(user));
        authBloc.add(UserUpdated(user));
      },
      onError: (error) => emit(ProfileUpdateError(error)),
    );
  }
}
