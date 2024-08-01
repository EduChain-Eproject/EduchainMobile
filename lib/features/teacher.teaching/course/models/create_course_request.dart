class CreateCourseRequest {
  final List<int> categoryIds;
  final String title;
  final String description;
  final double price;

  CreateCourseRequest({
    required this.categoryIds,
    required this.title,
    required this.description,
    required this.price,
  });

  Map<String, dynamic> toJson() => {
        'categoryIds': categoryIds,
        'title': title,
        'description': description,
        'price': price,
      };
}
