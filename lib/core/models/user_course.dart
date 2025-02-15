import 'course.dart';
import 'user.dart';

class UserCourse {
  final int? id;
  final User? userDto;
  final Course? courseDto;
  final DateTime? createdAt;
  final CompletionStatus? completionStatus;
  final double? progress;

  UserCourse({
    this.id,
    this.userDto,
    this.courseDto,
    this.createdAt,
    this.completionStatus,
    this.progress,
  });

  factory UserCourse.fromJson(Map<String, dynamic> json) {
    return UserCourse(
      id: json['id'] as int?,
      userDto: json['userDto'] != null
          ? User.fromJson(json['userDto'] as Map<String, dynamic>)
          : null,
      courseDto: json['courseDto'] != null
          ? Course.fromJson(json['courseDto'] as Map<String, dynamic>)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int)
          : null,
      completionStatus: json['completionStatus'] != null
          ? completionStatusFromJson(json['completionStatus'] as String)
          : null,
      progress: (json['progress'] as num?)?.toDouble(),
    );
  }

  UserCourse copyWith({
    int? id,
    User? userDto,
    Course? courseDto,
    DateTime? createdAt,
    CompletionStatus? completionStatus,
    double? progress,
  }) {
    return UserCourse(
      id: id ?? this.id,
      userDto: userDto ?? this.userDto,
      courseDto: courseDto ?? this.courseDto,
      createdAt: createdAt ?? this.createdAt,
      completionStatus: completionStatus ?? this.completionStatus,
      progress: progress ?? this.progress,
    );
  }
}

enum CompletionStatus { NOT_STARTED, IN_PROGRESS, COMPLETED }

CompletionStatus completionStatusFromJson(String status) {
  switch (status) {
    case 'NOT_STARTED':
      return CompletionStatus.NOT_STARTED;
    case 'IN_PROGRESS':
      return CompletionStatus.IN_PROGRESS;
    case 'COMPLETED':
      return CompletionStatus.COMPLETED;
    default:
      throw ArgumentError('Unknown CompletionStatus: $status');
  }
}

String completionStatusToJson(CompletionStatus status) {
  switch (status) {
    case CompletionStatus.NOT_STARTED:
      return 'NOT_STARTED';
    case CompletionStatus.IN_PROGRESS:
      return 'IN_PROGRESS';
    case CompletionStatus.COMPLETED:
      return 'COMPLETED';
    default:
      throw ArgumentError('Unknown CompletionStatus: $status');
  }
}
