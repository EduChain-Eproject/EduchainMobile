import '../../models/user.dart';

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

class AuthRegisterSuccess extends AuthState {}
