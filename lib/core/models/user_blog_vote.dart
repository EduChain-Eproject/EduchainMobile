class UserBlogVote {
  final int? id;
  final int? userId;
  final int? blogId;

  UserBlogVote({
    this.id,
    this.userId,
    this.blogId,
  });

  factory UserBlogVote.fromJson(Map<String, dynamic> json) {
    return UserBlogVote(
      id: json['id'] as int?,
      userId: json['userId'] as int?,
      blogId: json['blogId'] as int?,
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'userId': userId,
  //     'blogId': blogId,
  //   };
  // }
}
