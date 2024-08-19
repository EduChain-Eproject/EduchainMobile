import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:educhain/core/models/user.dart';
import '../auth_service.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../models/reset_password_request.dart';
import '../models/send_code_request.dart';
import '../models/verify_register_code_request.dart';

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
    on<VerifyRegisterCode>(_onVerifyRegisterCode);
    on<SendResetPasswordCode>(_onSendResetPasswordCode);
    on<ResetPassword>(_onResetPassword);
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
      onError: (error) => emit(AuthRegisterError(error, type: "register")),
      onSuccess: (_) {
        emit(AuthRegisterSuccess(event.request.email));
      },
    );
  }

  Future<void> _onVerifyRegisterCode(
      VerifyRegisterCode event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final response = await authService.verifyCode(event.request);
    response.on(
      onError: (error) => emit(AuthRegisterError(error, type: "verify")),
      onSuccess: (_) {
        emit(AuthVerifyCodeSuccess());
      },
    );
  }

  Future<void> _onSendResetPasswordCode(
      SendResetPasswordCode event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final response = await authService.sendResetPasswordCode(event.request);
    response.on(
      onError: (error) => emit(AuthResetPasswordError(error, type: "send")),
      onSuccess: (_) {
        emit(AuthSendResetCodeSuccess(event.request.email));
      },
    );
  }

  Future<void> _onResetPassword(
      ResetPassword event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final response = await authService.resetPassword(event.request);
    response.on(
      onError: (error) => emit(AuthResetPasswordError(error, type: "reset")),
      onSuccess: (_) {
        emit(AuthResetSuccess());
      },
    );
  }

  Future<void> _onUserUpdated(
      UserUpdated event, Emitter<AuthState> emit) async {
    emit(AuthAuthenticated(event.user));
  }
}
