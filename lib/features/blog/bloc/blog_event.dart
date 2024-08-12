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

// class CreateBlog extends BlogEvent {
//   final String filePath;
//   final CreateBlogRequest blogCreateRequest;

//   CreateBlog(this.filePath, this.blogCreateRequest);

//   List<Object> get props => [filePath, blogCreateRequest];
// }
