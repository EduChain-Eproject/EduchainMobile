import 'user.dart';
import 'blog_category.dart';
import 'blog_comment.dart';

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
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      id: json['id'] as int?,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      title: json['title'] as String?,
      blogText: json['blogText'] as String?,
      voteUp: json['voteUp'] as int?,
      photo: json['photo'] as String?,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      blogCategory: json['blogCategory'] != null
          ? BlogCategory.fromJson(json['blogCategory'])
          : null,
      blogComments: (json['blogComments'] as List<dynamic>?)
          ?.map((e) => BlogComment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt?.toIso8601String(),
      'title': title,
      'blogText': blogText,
      'voteUp': voteUp,
      'photo': photo,
      'user': user?.toJson(),
      'blogCategory': blogCategory?.toJson(),
      'blogComments': blogComments?.map((e) => e.toJson()).toList(),
    };
  }
}
