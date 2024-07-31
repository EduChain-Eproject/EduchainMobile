import 'homework.dart';
import 'user.dart';

class Award {
  final int? id;
  final String? status;
  final DateTime? submissionDate;
  final DateTime? reviewDate;
  final String? comments;
  final Homework? homeworkDto;
  final User? userDto;

  Award({
    this.id,
    this.status,
    this.submissionDate,
    this.reviewDate,
    this.comments,
    this.homeworkDto,
    this.userDto,
  });

  factory Award.fromJson(Map<String, dynamic> json) {
    return Award(
      id: json['id'],
      status: json['status'],
      // submissionDate: json['submissionDate'] != null
      //     ? DateTime.parse(json['submissionDate'])
      //     : null,
      reviewDate: json['reviewDate'] != null
          ? DateTime.parse(json['reviewDate'])
          : null,
      comments: json['comments'],
      homeworkDto: json['homeworkDto'] != null
          ? Homework.fromJson(json['homeworkDto'])
          : null,
      userDto: json['userDto'] != null ? User.fromJson(json['userDto']) : null,
    );
  }
}
