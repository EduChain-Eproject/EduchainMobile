class BlogCategory {
  final int? id;
  final DateTime? createdAt;
  final String? categoryName;

  BlogCategory({
    this.id,
    this.createdAt,
    this.categoryName,
  });

  factory BlogCategory.fromJson(Map<String, dynamic> json) {
    return BlogCategory(
      id: json['id'],
      createdAt: json['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['createdAt'])
          : null,
      categoryName: json['categoryName'],
    );
  }

  BlogCategory copyWith({
    int? id,
    DateTime? createdAt,
    String? categoryName,
  }) {
    return BlogCategory(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      categoryName: categoryName ?? this.categoryName,
    );
  }
}
