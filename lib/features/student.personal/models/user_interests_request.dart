class UserInterestsRequest {
  final int? page;
  final String? titleSearch;

  UserInterestsRequest({
    this.page,
    this.titleSearch,
  });

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'titleSearch': titleSearch,
    };
  }
}

class AddOrDeleteInterestRequest {
  final int courseId;

  AddOrDeleteInterestRequest(this.courseId);

  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
    };
  }
}
