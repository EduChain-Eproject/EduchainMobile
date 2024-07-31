import 'package:educhain/core/models/award.dart';
import 'package:educhain/core/models/homework.dart';
import 'package:educhain/core/models/user_homework.dart';

class HomeworkDetailResponse {
  final Homework homeworkDto;
  final UserHomework userHomeworkDto;
  final Award? awardDto;

  HomeworkDetailResponse({
    required this.homeworkDto,
    required this.userHomeworkDto,
    this.awardDto,
  });

  factory HomeworkDetailResponse.fromJson(Map<String, dynamic> json) {
    return HomeworkDetailResponse(
      homeworkDto: Homework.fromJson(json['homeworkDto']),
      userHomeworkDto: UserHomework.fromJson(json['userHomeworkDto']),
      awardDto:
          json['awardDto'] != null ? Award.fromJson(json['awardDto']) : null,
    );
  }
}
