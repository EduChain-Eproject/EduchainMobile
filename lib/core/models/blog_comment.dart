import 'user.dart';

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
      id: json['id'] as int?,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      text: json['text'] as String?,
      voteUp: json['voteUp'] as int?,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      blogId: json['blogId'] as int?,
      parentCommentId: json['parentCommentId'] as int?,
      replies: (json['replies'] as List<dynamic>?)
          ?.map((e) => BlogComment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'createdAt': createdAt?.toIso8601String(),
  //     'text': text,
  //     'voteUp': voteUp,
  //     'user': user?.toJson(),
  //     'blogId': blogId,
  //     'parentCommentId': parentCommentId,
  //     'replies': replies?.map((e) => e.toJson()).toList(),
  //   };
  // }
}
