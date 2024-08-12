class CreateBlogRequest {
  final String title;
  final int userId;
  final int blogCategoryId;
  final String blogText;
  final String? photo;

  CreateBlogRequest({
    required this.title,
    required this.userId,
    required this.blogCategoryId,
    required this.blogText,
    this.photo,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'userId': userId,
        'blogCategoryId': blogCategoryId,
        'blogText': blogText,
        'photo': photo,
      };
}
