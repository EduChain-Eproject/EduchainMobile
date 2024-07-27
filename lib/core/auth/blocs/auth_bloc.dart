import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc(this.authService) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoggedIn>(_onLoggedIn);
    on<LoggedOut>(_onLoggedOut);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    await authService.getToken(
        onTokenNotFound: () => emit(AuthUnauthenticated()),
        onToken: (String token) async {
          try {
            emit(AuthLoading());
            final role = await authService.getUserRole(token);
            role.on(
              onError: (error) => emit(AuthError(error)),
              onSuccess: (data) => emit(AuthAuthenticated(data)),
            );
          } catch (e) {
            emit(AuthUnauthenticated());
          }
        });
  }

  Future<void> _onLoggedIn(LoggedIn event, Emitter<AuthState> emit) async {
    await authService.storeToken(event.token);
    final role = await authService.getUserRole(event.token);
    role.on(
      onError: (error) => emit(AuthError(error)),
      onSuccess: (data) => emit(AuthAuthenticated(data)),
    );
  }

  Future<void> _onLoggedOut(LoggedOut event, Emitter<AuthState> emit) async {
    await authService.removeToken();
    emit(AuthUnauthenticated());
  }
}
