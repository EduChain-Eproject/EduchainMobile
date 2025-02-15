class CourseSearchRequest {
  final String search;
  final int page;
  final String sortBy;
  final List<int> categoryIds;

  CourseSearchRequest({
    required this.search,
    this.page = 0,
    this.sortBy = "title",
    required this.categoryIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'search': search,
      'page': page,
      'sortBy': sortBy,
      'categoryIds': categoryIds,
    };
  }
}
