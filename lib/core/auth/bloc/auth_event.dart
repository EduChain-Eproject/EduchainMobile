import '../models/login_request.dart';
import '../models/register_request.dart';

abstract class AuthEvent {}

class AppStarted extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final LoginRequest request;

  LoginRequested(this.request);
}

class RegisterRequested extends AuthEvent {
  final RegisterRequest request;

  RegisterRequested(this.request);
}

class LogOutRequested extends AuthEvent {}
