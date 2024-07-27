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
      id: json['id'] as int?,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      categoryName: json['categoryName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt?.toIso8601String(),
      'categoryName': categoryName,
    };
  }
}
