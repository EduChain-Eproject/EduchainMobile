class ListBlogRequest {
  final int page;
  final String sortBy;

  ListBlogRequest({
    this.page = 0,
    this.sortBy = "createdAt",
  });

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'sortBy': sortBy,
    };
  }
}
