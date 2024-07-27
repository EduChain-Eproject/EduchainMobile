import 'package:flutter_bloc/flutter_bloc.dart';
import '../auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc(this.authService) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LogOutRequested>(_onLogOutRequested);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    await authService.getTokens(
        onTokensNotFound: () => emit(AuthUnauthenticated()),
        onTokens: (String accessToken, String refreshToken) async {
          try {
            emit(AuthLoading());
            final role = await authService.getUser(accessToken);
            role.on(
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
    response.on(
      onError: (error) => emit(AuthError(error)),
      onSuccess: (jwtResponse) async {
        await authService.storeTokens(jwtResponse);
        final role = await authService.getUser(jwtResponse.accessToken);
        role.on(
          onError: (error) => emit(AuthError(error)),
          onSuccess: (data) => emit(AuthAuthenticated(data)),
        );
        emit(AuthLoginSuccess());
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
}
