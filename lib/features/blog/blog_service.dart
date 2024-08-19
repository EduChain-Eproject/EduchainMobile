import 'dart:io';

import 'package:educhain/core/api_service.dart';
import 'package:educhain/core/models/blog.dart';
import 'package:educhain/core/models/blog_category.dart';
import 'package:educhain/core/models/blog_comment.dart';
import 'package:educhain/core/types/api_response.dart';
import 'package:educhain/core/types/page.dart';
import 'package:educhain/features/blog/models/blogComment/create_comment_request.dart';
import 'package:educhain/features/blog/models/create_blog_request.dart';
import 'package:educhain/features/blog/models/filter_blog_request.dart';
import 'package:educhain/features/blog/models/get_list_blogs_request.dart';
import 'package:educhain/features/blog/models/update_blog_request.dart';

class BlogService extends ApiService {
  ApiResponse<Page<Blog>> fetchBlogs(ListBlogRequest rq) async {
    return post<Page<Blog>>(
        'api/blog',
        (json) => Page.fromJson(json, (item) => Blog.fromJson(item)),
        rq.toJson());
  }

  ApiResponse<Blog> getBlogDetail(int blogId) async {
    return get<Blog>(
      'api/blog/$blogId',
      (json) => Blog.fromJson(json),
    );
  }

  ApiResponse<Page<Blog>> filterBlogs(
      BlogFilterRequest blogFilterRequest) async {
    return post<Page<Blog>>(
      'api/blog/filter',
      (json) => Page.fromJson(json, (item) => Blog.fromJson(item)),
      blogFilterRequest.toJson(), // Request body
    );
  }

  ApiResponse<List<BlogCategory>> fetchBlogCategories() async {
    return getList<BlogCategory>(
      'api/blog_category',
      (json) => BlogCategory.fromJson(json),
    );
  }

  ApiResponse<Blog> createBlog(CreateBlogRequest request) async {
    return postMultipart<Blog>(
      'api/blog/create',
      (json) => Blog.fromJson(json),
      request.toFormFields(),
      request.file(),
      'photo',
    );
  }

  ApiResponse<Blog> deleteBlog(int chapterId) async {
    return delete<Blog>(
        'api/blog/$chapterId', (json) => Blog.fromJson(json), null);
  }

  ApiResponse<Blog> updateBlog(int blogId, UpdateBlogRequest request) async {
    return postMultipart<Blog>(
      'api/blog/$blogId',
      (json) => Blog.fromJson(json),
      request.toFormFields(),
      request.file(),
      "photo",
      method: "PUT",
    );
  }

  ApiResponse<BlogComment> createComment(
      CreateBlogCommentRequest request) async {
    return post<BlogComment>(
      'api/blog_comment/create',
      (json) => BlogComment.fromJson(json),
      request.toJson(),
    );
  }
}
