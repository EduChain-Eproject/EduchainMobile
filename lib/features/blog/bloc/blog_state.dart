part of 'blog_bloc.dart';

abstract class BlogState {}

class BlogInitial extends BlogState {}

// BlogCategogry

class BlogCategoriesLoading extends BlogState {}

class BlogCategoriesLoaded extends BlogState {
  final List<BlogCategory> categories;
  BlogCategoriesLoaded(this.categories);
}

class BlogCategoriesError extends BlogState {
  final Map<String, dynamic>? errors;

  BlogCategoriesError(this.errors);
}

//Blogs

class BlogsLoading extends BlogState {}

class BlogsLoaded extends BlogState {
  final Page<Blog> blogs;
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

class BlogSaving extends BlogState {}

class BlogSaved extends BlogState {
  final Blog blog;

  BlogSaved(this.blog);
}

class BlogSaveError extends BlogState {
  final Map<String, dynamic>? errors;

  BlogSaveError(this.errors);
}

class BlogDeleting extends BlogState {}

class BlogDeleted extends BlogState {
  final Blog blog;

  BlogDeleted(this.blog);
}

class BlogDeleteError extends BlogState {
  final String message;

  BlogDeleteError(this.message);
}

class BlogUpdating extends BlogState {}

class BlogUpdated extends BlogState {
  final Blog blog;

  BlogUpdated(this.blog);
}

class BlogUpdateError extends BlogState {
  final Map<String, dynamic>? errors;

  BlogUpdateError(this.errors);
}

// BlogComment

class BlogCommentSaving extends BlogState {}

class BlogCommentSaved extends BlogState {
  final BlogComment blogComment;

  BlogCommentSaved(this.blogComment);
}

class BlogCommentSaveError extends BlogState {
  final Map<String, dynamic>? errors;

  BlogCommentSaveError(this.errors);
}
