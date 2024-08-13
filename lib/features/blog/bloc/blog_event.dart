part of 'blog_bloc.dart';

abstract class BlogEvent {}

class FetchBlogs extends BlogEvent {}

class FetchBlogDetail extends BlogEvent {
  final int blogId;

  FetchBlogDetail(this.blogId);
}

class FilterBlogs extends BlogEvent {
  final BlogFilterRequest blogFilterRequest;

  FilterBlogs(this.blogFilterRequest);
}

class FetchBlogCategories extends BlogEvent {}
