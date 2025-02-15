import 'package:educhain/core/models/user_course.dart';

class ParticipatedCoursesRequest {
  final int? page;
  final String? titleSearch;
  final CompletionStatus? completionStatus;

  ParticipatedCoursesRequest({
    this.page,
    this.titleSearch,
    this.completionStatus,
  });

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'titleSearch': titleSearch,
      'completionStatus': completionStatus != null
          ? completionStatusToJson(completionStatus!)
          : null,
    };
  }
}
