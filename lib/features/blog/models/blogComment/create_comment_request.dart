class CreateBlogCommentRequest {
  final String text;
  final String? parentCommentId;
  final int blogId;

  CreateBlogCommentRequest({
    required this.text,
    this.parentCommentId,
    required this.blogId,
  });

  Map<String, dynamic> toJson() => {
        'text': text,
        'parentCommentId': parentCommentId,
        'blogId': blogId,
      };
}
