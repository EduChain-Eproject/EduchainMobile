class UserHomeworksRequest {
  final bool isSubmitted;
  final int? page;

  UserHomeworksRequest({
    required this.isSubmitted,
    this.page,
  });

  Map<String, dynamic> toJson() {
    return {
      'isSubmitted': isSubmitted,
      'page': page,
    };
  }
}
