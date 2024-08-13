part of 'blog_bloc.dart';

abstract class BlogState {}

class BlogInitial extends BlogState {}

class BlogCategoriesLoading extends BlogState {}

class BlogCategoriesLoaded extends BlogState {
  final List<BlogCategory> categories; // Adjust type based on actual data
  BlogCategoriesLoaded(this.categories);
}

class BlogCategoriesError extends BlogState {
  final Map<String, dynamic>? errors;

  BlogCategoriesError(this.errors);
}

class BlogsLoading extends BlogState {}

class BlogsLoaded extends BlogState {
  final List<Blog> blogs;
  BlogsLoaded(this.blogs);
}

class BlogsError extends BlogState {
  final Map<String, dynamic>? errors;

  BlogsError(this.errors);
}

class BlogDetailLoading extends BlogState {}

class BlogDetailLoaded extends BlogState {
  final Blog blog;
  BlogDetailLoaded(this.blog);
}

class BlogDetailError extends BlogState {
  final Map<String, dynamic>? errors;

  BlogDetailError(this.errors);
}

class BlogCommentsLoading extends BlogState {}

class BlogCommentsLoaded extends BlogState {
  final List<BlogComment> blogComments;
  BlogCommentsLoaded(this.blogComments);
}

class BlogCommentsError extends BlogState {
  final Map<String, dynamic>? errors;

  BlogCommentsError(this.errors);
}
