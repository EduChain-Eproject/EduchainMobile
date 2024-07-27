import 'package:educhain/init_dependency.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api_service.dart';
import '../models/user.dart';
import '../types/api_response.dart';
import 'models/login_request.dart';
import 'models/mail_request.dart';
import 'models/verify_code_request.dart';

class AuthService extends ApiService {
  ApiResponse<String> getUserRole(String token) async {
    final response = await get<String>('user/role', null);

    return response;
  }

  ApiResponse<String> signIn(LoginRequest request) async {
    final response = await post<String>(
      'auth/sign-in',
      null,
      request.toJson(),
    );

    return response;
  }

  ApiResponse<User> signUp(User request) async {
    final response = await post<User>(
      'auth/register',
      (json) => User.fromJson(json),
      request.toJson(),
    );

    return response;
  }

  ApiResponse<void> sendVerificationEmail(MailRequest request) async {
    final response = await post<void>(
      'auth/register/send-mail',
      null,
      request.toJson(),
    );

    return response;
  }

  ApiResponse<void> sendVerificationCode(VerifyCodeRequest request) async {
    final response = await post<void>(
      'auth/register/verify',
      (json) => null,
      request.toJson(),
    );

    return response;
  }

  Future<void> storeToken(String token) async {
    final prefs = getIt<SharedPreferences>();
    await prefs.setString('token', token);
  }

  Future<void> getToken({
    required Function(String token) onToken,
    required Function() onTokenNotFound,
  }) async {
    final prefs = getIt<SharedPreferences>();
    final token = prefs.getString('token');
    if (token != null) {
      await onToken(token);
    } else {
      onTokenNotFound();
    }
  }

  Future<void> removeToken() async {
    final prefs = getIt<SharedPreferences>();
    await prefs.remove('token');
  }
}
