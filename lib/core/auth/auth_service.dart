import 'package:educhain/init_dependency.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api_service.dart';
import '../models/user.dart';
import '../types/api_response.dart';
import '../types/jwt_response.dart';
import 'models/login_request.dart';
import 'models/register_request.dart';

class AuthService extends ApiService {
  ApiResponse<User> getUser(String token) async {
    final response =
        await get<User>('COMMON/getUser', (json) => User.fromJson(json));
    if (!response.isSuccess) {
      // removeTokens();
    }
    return response;
  }

  ApiResponse<JwtResponse> signIn(LoginRequest request) async {
    final response = await post<JwtResponse>(
      'Auth/login',
      (json) => JwtResponse.fromJson(json),
      request.toJson(),
    );
    return response;
  }

  ApiResponse<String> signUp(RegisterRequest request) async {
    final response = await post<String>(
      'Auth/register',
      null,
      request.toJson(),
    );

    return response;
  }

  ApiResponse<String> logout() async {
    final response = await post<String>(
      'Auth/logout',
      null,
      null,
    );
    return response;
  }

  Future<void> storeTokens(JwtResponse jwtResponse) async {
    final prefs = getIt<SharedPreferences>();
    await prefs.setString('accessToken', jwtResponse.accessToken);
    await prefs.setString('refreshToken', jwtResponse.refreshToken);
  }

  Future<void> getTokens({
    required Function(String accessToken, String refreshToken) onTokens,
    required Function() onTokensNotFound,
  }) async {
    final prefs = getIt<SharedPreferences>();
    final accessToken = prefs.getString('accessToken');
    final refreshToken = prefs.getString('refreshToken');
    if (accessToken != null && refreshToken != null) {
      await onTokens(accessToken, refreshToken);
    } else {
      onTokensNotFound();
    }
  }

  Future<void> removeTokens() async {
    final prefs = getIt<SharedPreferences>();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
  }
}
