import 'package:educhain/core/models/award.dart';
import 'package:educhain/core/models/user_homework.dart';

class SubmissionResponse {
  final UserHomework submission;
  final Award award;

  SubmissionResponse({required this.submission, required this.award});

  factory SubmissionResponse.fromJson(Map<String, dynamic> json) {
    return SubmissionResponse(
      submission: UserHomework.fromJson(json['submission']),
      award: Award.fromJson(json['award']),
    );
  }
}
