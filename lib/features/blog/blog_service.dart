import 'dart:io';

import 'package:educhain/core/api_service.dart';
import 'package:educhain/core/models/blog.dart';
import 'package:educhain/core/models/blog_category.dart';
import 'package:educhain/core/types/api_response.dart';
import 'package:educhain/features/blog/models/filter_blog_request.dart';

class BlogService extends ApiService {
  ApiResponse<List<Blog>> fetchBlogs() async {
    return getList<Blog>(
      'api/blog',
      (json) => Blog.fromJson(json),
    );
  }

  ApiResponse<Blog> getBlogDetail(int blogId) async {
    return get<Blog>(
      'api/blog/$blogId',
      (json) => Blog.fromJson(json),
    );
  }

  ApiResponse<List<Blog>> filterBlogs(
      BlogFilterRequest blogFilterRequest) async {
    return postList<Blog>(
      'api/blog/filter',
      Blog.fromJson, // Convert JSON map to Blog object
      blogFilterRequest.toJson(), // Request body
    );
  }

  ApiResponse<List<BlogCategory>> fetchBlogCategories() async {
    return getList<BlogCategory>(
      'api/blog_category',
      (json) => BlogCategory.fromJson(json),
    );
  }
}
