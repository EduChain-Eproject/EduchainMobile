part of 'blog_bloc.dart';

abstract class BlogState {}

class BlogInitial extends BlogState {}

class BlogCategoriesLoading extends BlogState {}

class BlogCategoriesLoaded extends BlogState {
  final List<BlogCategory> categories; // Adjust type based on actual data
  BlogCategoriesLoaded(this.categories);
}

class BlogCategoriesError extends BlogState {
  final String message;
  BlogCategoriesError(this.message);
}

class BlogsLoading extends BlogState {}

class BlogsLoaded extends BlogState {
  final List<Blog> blogs;
  BlogsLoaded(this.blogs);
}

class BlogsError extends BlogState {
  final String message;
  BlogsError(this.message);
}

class BlogDetailLoading extends BlogState {}

class BlogDetailLoaded extends BlogState {
  final Blog blog;
  BlogDetailLoaded(this.blog);
}

class BlogDetailError extends BlogState {
  final String message;
  BlogDetailError(this.message);
}

class BlogCommentlLoading extends BlogState {}

class BlogCommentLoaded extends BlogState {
  final List<BlogComment> blogComment;
  BlogCommentLoaded(this.blogComment);
}

class BlogCommentError extends BlogState {
  final String message;
  BlogCommentError(this.message);
}

// class BlogCreating extends BlogState {}

// class BlogCreated extends BlogState {
//   final Blog blog;

//   BlogCreated(this.blog);

//   List<Object> get props => [blog];
// }

// class BlogCreateError extends BlogState {
//   final String message;

//   BlogCreateError(this.message);

//   List<Object> get props => [message];
// }
