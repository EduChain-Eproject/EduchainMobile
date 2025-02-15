import 'package:educhain/core/models/blog_category.dart';
import 'package:educhain/core/models/blog_comment.dart';
import 'package:educhain/core/models/user.dart';
import 'package:educhain/core/models/user_blog_vote.dart';

class Blog {
  final int? id;
  final DateTime? createdAt;
  final String? title;
  final String? blogText;
  final int? voteUp;
  final String? photo;
  final User? user;
  final BlogCategory? blogCategory;
  final List<BlogComment>? blogComments;
  final List<UserBlogVote>? userBlogVotes;

  Blog({
    this.id,
    this.createdAt,
    this.title,
    this.blogText,
    this.voteUp,
    this.photo,
    this.user,
    this.blogCategory,
    this.blogComments,
    this.userBlogVotes,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      id: json['id'] as int?,
      createdAt: json['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int)
          : null,
      title: json['title'] as String?,
      blogText: json['blogText'] as String?,
      voteUp: json['voteUp'] as int?,
      photo: json['photo'] as String?,
      user: json['user'] != null
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      blogCategory: json['blogCategory'] != null
          ? BlogCategory.fromJson(json['blogCategory'] as Map<String, dynamic>)
          : null,
      blogComments: (json['blogComments'] as List<dynamic>?)
              ?.map(
                  (item) => BlogComment.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      userBlogVotes: (json['userBlogVotes'] as List<dynamic>?)
              ?.map(
                  (item) => UserBlogVote.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Blog copyWith({
    int? id,
    DateTime? createdAt,
    String? title,
    String? blogText,
    int? voteUp,
    String? photo,
    User? user,
    BlogCategory? blogCategory,
    List<BlogComment>? blogComments,
    List<UserBlogVote>? userBlogVotes,
  }) {
    return Blog(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      title: title ?? this.title,
      blogText: blogText ?? this.blogText,
      voteUp: voteUp ?? this.voteUp,
      photo: photo ?? this.photo,
      user: user ?? this.user,
      blogCategory: blogCategory ?? this.blogCategory,
      blogComments: blogComments ?? this.blogComments,
      userBlogVotes: userBlogVotes ?? this.userBlogVotes,
    );
  }
}
