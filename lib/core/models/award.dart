import 'homework.dart';
import 'user.dart';

class Award {
  final int id;
  final String status;
  final DateTime? submissionDate;
  final DateTime? reviewDate;
  final String comments;
  final int homeworkDtoId;
  final User userDto;
  final Homework homeworkDto;

  Award({
    required this.id,
    required this.status,
    this.submissionDate,
    this.reviewDate,
    required this.comments,
    required this.homeworkDtoId,
    required this.userDto,
    required this.homeworkDto,
  });

  factory Award.fromJson(Map<String, dynamic> json) {
    return Award(
      id: json['id'] as int,
      status: json['status'] as String,
      submissionDate: json.containsKey('submissionDate')
          ? DateTime.parse(json['submissionDate'])
          : null,
      reviewDate: json.containsKey('reviewDate')
          ? DateTime.parse(json['reviewDate'])
          : null,
      comments: json['comments'] as String,
      homeworkDtoId: json['homeworkDtoId'] as int,
      userDto: User.fromJson(json['userDto'] as Map<String, dynamic>),
      homeworkDto:
          Homework.fromJson(json['homeworkDto'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'submissionDate': submissionDate?.toIso8601String(),
      'reviewDate': reviewDate?.toIso8601String(),
      'comments': comments,
      'homeworkDtoId': homeworkDtoId,
      'userDto': userDto.toJson(),
      'homeworkDto': homeworkDto.toJson(),
    };
  }
}
