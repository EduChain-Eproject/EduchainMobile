import 'package:educhain/core/api_service.dart';
import 'package:educhain/core/models/award.dart';
import 'package:educhain/core/types/api_response.dart';

class AwardService extends ApiService {
  ApiResponse<Award> getAwardDetail(int awardId) async {
    return get<Award>(
      'SHARED/api/award/detail/$awardId',
      (json) => Award.fromJson(json),
    );
  }
}
