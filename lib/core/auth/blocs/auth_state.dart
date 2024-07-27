abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String role;

  AuthAuthenticated(this.role);
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final Map<String, dynamic>? message;

  AuthError(this.message);
}
