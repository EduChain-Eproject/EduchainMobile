import 'package:educhain/core/api_service.dart';
import 'package:educhain/core/models/user.dart';
import 'package:educhain/core/types/api_response.dart';

import 'update_user_request.dart';

class ProfileService extends ApiService {
  ApiResponse<User> getUserProfile() async {
    return await get<User>('COMMON/getUser', User.fromJson);
  }

  ApiResponse<User> updateUserProfile(UpdateUserRequest request) async {
    return await put('COMMON/updateProfile', User.fromJson, request.toJson());
  }
}
