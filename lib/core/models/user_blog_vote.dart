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
      id: json['id'],
      userId: json['userId'],
      blogId: json['blogId'],
    );
  }

  UserBlogVote copyWith({
    int? id,
    int? userId,
    int? blogId,
  }) {
    return UserBlogVote(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      blogId: blogId ?? this.blogId,
    );
  }
}
