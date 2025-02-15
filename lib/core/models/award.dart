import 'homework.dart';
import 'user.dart';

class Award {
  final int? id;
  final AwardStatus status;
  final DateTime? submissionDate;
  final DateTime? reviewDate;
  final String? comments;
  final int? homeworkDtoId;
  final User? userDto;
  final Homework? homeworkDto;

  const Award({
    this.id,
    required this.status,
    this.submissionDate,
    this.reviewDate,
    this.comments,
    this.homeworkDtoId,
    this.userDto,
    this.homeworkDto,
  });

  List<Object?> get props => [
        id,
        status,
        submissionDate,
        reviewDate,
        comments,
        homeworkDtoId,
        userDto,
        homeworkDto,
      ];

  factory Award.fromJson(Map<String, dynamic> json) {
    return Award(
      id: json['id'] as int?,
      status: AwardStatus.values.firstWhere(
        (e) => e.toString() == 'AwardStatus.${json['status']}',
      ),
      // submissionDate: json.containsKey('submissionDate')
      //     ? DateTime.parse(json['submissionDate'])
      //     : null,
      // reviewDate: json.containsKey('reviewDate')
      //     ? DateTime.parse(json['reviewDate'])
      //     : null,
      comments: json['comments'] as String?,
      homeworkDtoId: json['homeworkDtoId'] as int?,
      userDto: json['userDto'] != null ? User.fromJson(json['userDto']) : null,
      homeworkDto: json['homeworkDto'] != null
          ? Homework.fromJson(json['homeworkDto'])
          : null,
    );
  }
}

enum AwardStatus {
  PENDING,
  APPROVED,
  REJECTED,
  RECEIVED,
}
