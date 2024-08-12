class BlogFilterRequest {
  final String sortStrategy;
  final String keyword;
  final List<int> categoryIdArray;

  BlogFilterRequest({
    required this.sortStrategy,
    required this.keyword,
    required this.categoryIdArray,
  });

  Map<String, dynamic> toJson() {
    return {
      'sortStrategy': sortStrategy,
      'keyword': keyword,
      'categoryIdArray': categoryIdArray,
    };
  }
}
