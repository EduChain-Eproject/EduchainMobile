class UserInterestsRequest {
  final int userId;
  final int page;
  final String titleSearch;

  UserInterestsRequest(this.page, this.titleSearch, this.userId);

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'page': page,
      'titleSearch': titleSearch,
    };
  }
}

class AddOrDeleteInterestRequest {
  final int userId;
  final int courseId;

  AddOrDeleteInterestRequest(this.userId, this.courseId);

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'course_id': courseId,
    };
  }
}
