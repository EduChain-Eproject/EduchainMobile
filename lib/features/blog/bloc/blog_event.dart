part of 'blog_bloc.dart';

abstract class BlogEvent {}

class FetchBlogs extends BlogEvent {
  final ListBlogRequest request;
  final bool isLoadingMore;

  FetchBlogs(this.request, {this.isLoadingMore = false});
}

class FetchBlogDetail extends BlogEvent {
  final int blogId;

  FetchBlogDetail(this.blogId);
}

class FilterBlogs extends BlogEvent {
  final BlogFilterRequest blogFilterRequest;

  FilterBlogs(this.blogFilterRequest);
}

class FetchBlogCategories extends BlogEvent {}

class CreateBlog extends BlogEvent {
  final CreateBlogRequest request;

  CreateBlog(this.request);
}

class DeleteBlog extends BlogEvent {
  final int blogId;

  DeleteBlog(this.blogId);
}
