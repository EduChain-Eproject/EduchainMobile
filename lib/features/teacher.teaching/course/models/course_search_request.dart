class CourseSearchRequest {
  final String search;
  final int page;
  final String sortBy;

  CourseSearchRequest({
    required this.search,
    this.page = 0,
    this.sortBy = "title",
  });

  Map<String, dynamic> toJson() {
    return {
      'search': search,
      'page': page,
      'sortBy': sortBy,
    };
  }
}
