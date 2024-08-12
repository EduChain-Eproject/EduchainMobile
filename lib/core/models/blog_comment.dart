import 'package:educhain/core/models/user.dart';

class BlogComment {
  final int? id;
  final DateTime? createdAt;
  final String? text;
  final int? voteUp;
  final User? user;
  final int? blogId;
  final int? parentCommentId;
  final List<BlogComment>? replies;

  BlogComment({
    this.id,
    this.createdAt,
    this.text,
    this.voteUp,
    this.user,
    this.blogId,
    this.parentCommentId,
    this.replies,
  });

  factory BlogComment.fromJson(Map<String, dynamic> json) {
    return BlogComment(
      id: json['id'],
      createdAt: json['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['createdAt'])
          : null,
      text: json['text'],
      voteUp: json['voteUp'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      blogId: json['blogId'],
      parentCommentId: json['parentCommentId'],
      replies: json['replies'] != null
          ? (json['replies'] as List)
              .map((item) => BlogComment.fromJson(item))
              .toList()
          : null,
    );
  }

  BlogComment copyWith({
    int? id,
    DateTime? createdAt,
    String? text,
    int? voteUp,
    User? user,
    int? blogId,
    int? parentCommentId,
    List<BlogComment>? replies,
  }) {
    return BlogComment(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      text: text ?? this.text,
      voteUp: voteUp ?? this.voteUp,
      user: user ?? this.user,
      blogId: blogId ?? this.blogId,
      parentCommentId: parentCommentId ?? this.parentCommentId,
      replies: replies ?? this.replies,
    );
  }
}
