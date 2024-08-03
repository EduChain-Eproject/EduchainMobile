import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:educhain/core/models/user.dart';
import '../auth_service.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc(this.authService) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LogOutRequested>(_onLogOutRequested);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<UserUpdated>(_onUserUpdated);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    await authService.getTokens(
        onTokensNotFound: () => emit(AuthUnauthenticated()),
        onTokens: (String accessToken, String refreshToken) async {
          try {
            emit(AuthLoading());
            final user = await authService.getUser(accessToken);
            user.on(
              onError: (error) => emit(AuthError(error)),
              onSuccess: (data) => emit(AuthAuthenticated(data)),
            );
          } catch (e) {
            emit(AuthUnauthenticated());
          }
        });
  }

  Future<void> _onLogOutRequested(
      LogOutRequested event, Emitter<AuthState> emit) async {
    await authService.logout();
    await authService.removeTokens();
    emit(AuthUnauthenticated());
  }

  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final response = await authService.signIn(event.request);
    await response.on(
      onError: (error) async {
        emit(AuthError(error));
      },
      onSuccess: (jwtResponse) async {
        await authService.storeTokens(jwtResponse);
        emit(AuthLoginSuccess());
        try {
          emit(AuthLoading());
          final user = await authService.getUser(jwtResponse.accessToken);
          await user.on(
            onError: (error) async {
              emit(AuthError(error));
            },
            onSuccess: (data) async {
              emit(AuthAuthenticated(data));
            },
          );
        } catch (e) {
          emit(AuthUnauthenticated());
        }
      },
    );
  }

  Future<void> _onRegisterRequested(
      RegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final response = await authService.signUp(event.request);
    response.on(
      onError: (error) => emit(AuthError(error)),
      onSuccess: (user) {
        emit(AuthRegisterSuccess());
      },
    );
  }

  Future<void> _onUserUpdated(
      UserUpdated event, Emitter<AuthState> emit) async {
    emit(AuthAuthenticated(event.user));
  }
}
