part of 'auth_bloc.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;

  AuthAuthenticated(this.user);
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final Map<String, dynamic>? errors;

  AuthError(this.errors);
}

class AuthLoginSuccess extends AuthState {}

class AuthRegisterSuccess extends AuthState {
  final String email;

  AuthRegisterSuccess(this.email);
}

class AuthVerifyCodeSuccess extends AuthState {
  AuthVerifyCodeSuccess();
}

class AuthSendResetCodeSuccess extends AuthState {
  final String email;

  AuthSendResetCodeSuccess(this.email);
}

class AuthResetSuccess extends AuthState {
  AuthResetSuccess();
}

class AuthRegisterError extends AuthState {
  final Map<String, dynamic>? errors;
  final String? type;

  AuthRegisterError(this.errors, {this.type});
}

class AuthResetPasswordError extends AuthState {
  final Map<String, dynamic>? errors;
  final String? type;

  AuthResetPasswordError(this.errors, {this.type});
}
