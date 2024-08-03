class UserHomeworksRequest {
  final bool? isSubmitted;
  final int page;

  UserHomeworksRequest({
    this.isSubmitted,
    required this.page,
  });

  Map<String, dynamic> toJson() {
    return {
      'isSubmitted': isSubmitted,
      'page': page,
    };
  }
}
