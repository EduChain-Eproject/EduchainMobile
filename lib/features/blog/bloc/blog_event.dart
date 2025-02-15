part of 'blog_bloc.dart';

abstract class BlogEvent {}

// BlogCategory

class FetchBlogCategories extends BlogEvent {}

// Blog

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

class CreateBlog extends BlogEvent {
  final CreateBlogRequest request;

  CreateBlog(this.request);
}

class UpdateBlog extends BlogEvent {
  final int blogId;
  final UpdateBlogRequest request;

  UpdateBlog(this.blogId, this.request);
}

class DeleteBlog extends BlogEvent {
  final int blogId;

  DeleteBlog(this.blogId);
}

// BlogComment

class CreateBlogComment extends BlogEvent {
  final CreateBlogCommentRequest request;

  CreateBlogComment(this.request);
}
