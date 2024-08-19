class BlogFilterRequest {
  final int page;
  final String sortStrategy;
  final String keyword;
  final List<int>? categoryIds;

  BlogFilterRequest({
    required this.page,
    required this.sortStrategy,
    required this.keyword,
    this.categoryIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'sortStrategy': sortStrategy,
      'keyword': keyword,
      'categoryIds': categoryIds,
    };
  }
}
