import 'package:bloc/bloc.dart';
import 'package:educhain/core/models/blog.dart';
import 'package:educhain/core/models/blog_category.dart';
import 'package:educhain/core/models/blog_comment.dart';
import 'package:educhain/core/types/page.dart';
import 'package:educhain/features/blog/blog_service.dart';
import 'package:educhain/features/blog/models/blogComment/create_comment_request.dart';
import 'package:educhain/features/blog/models/create_blog_request.dart';
import 'package:educhain/features/blog/models/filter_blog_request.dart';
import 'package:educhain/features/blog/models/get_list_blogs_request.dart';
import 'package:educhain/features/blog/models/update_blog_request.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final BlogService blogService;

  BlogBloc(this.blogService) : super(BlogInitial()) {
    on<FetchBlogs>((event, emit) async {
      BlogsLoaded? currentState;

      if (state is BlogsLoaded && event.isLoadingMore) {
        currentState = state as BlogsLoaded;
      } else {
        currentState = null;
      }

      emit(BlogsLoading());

      final response = await blogService.fetchBlogs(event.request);
      await response.on(
        onSuccess: (newBlogs) {
          if (currentState != null) {
            final updatedBlogs = Page<Blog>(
              number: newBlogs.number,
              totalElements: newBlogs.totalElements,
              totalPages: newBlogs.totalPages,
              content: [...currentState.blogs.content, ...newBlogs.content],
            );

            emit(BlogsLoaded(updatedBlogs));
          } else {
            emit(BlogsLoaded(newBlogs));
          }
        },
        onError: (error) => emit(BlogsError(error)),
      );
    });

    on<FetchBlogDetail>((event, emit) async {
      emit(BlogDetailLoading());
      final response = await blogService.getBlogDetail(event.blogId);
      await response.on(
        onSuccess: (blogDetail) => emit(BlogDetailLoaded(blogDetail)),
        onError: (error) {
          (error) => emit(BlogDetailError(error['message']));
        },
      );
    });

    on<FilterBlogs>((event, emit) async {
      emit(BlogsLoading());

      final response = await blogService.filterBlogs(event.blogFilterRequest);
      await response.on(
        onSuccess: (filteredBlogs) => emit(BlogsLoaded(filteredBlogs)),
        onError: (error) => emit(BlogsError(error['message'])),
      );
    });

    on<CreateBlog>((event, emit) async {
      emit(BlogSaving());
      final response = await blogService.createBlog(event.request);
      await response.on(
        onSuccess: (blog) {
          emit(BlogSaved(blog));
        },
        onError: (error) => emit(BlogSaveError(error)),
      );
    });

    on<DeleteBlog>((event, emit) async {
      emit(BlogDeleting());
      final response = await blogService.deleteBlog(event.blogId);

      await response.on(
        onSuccess: (deleted) {
          if (deleted) {
            emit(BlogDeleted(Blog(id: event.blogId)));
          }
        },
        onError: (error) => emit(BlogDeleteError(error['message'])),
      );
    });

    on<UpdateBlog>((event, emit) async {
      emit(BlogUpdating());
      final response =
          await blogService.updateBlog(event.blogId, event.request);
      await response.on(
        onSuccess: (blog) {
          emit(BlogUpdated(blog));
        },
        onError: (error) => emit(BlogUpdateError(error)),
      );
    });

    List<BlogComment> _addCommentToList(
      List<BlogComment> comments,
      BlogComment newComment,
      String? parentCommentId,
    ) {
      if (parentCommentId == null) {
        return [...comments, newComment];
      } else {
        return comments.map((comment) {
          if (comment.id == parentCommentId) {
            final updatedReplies = [...?comment.replies, newComment];
            return comment.copyWith(replies: updatedReplies);
          } else if (comment.replies != null) {
            final updatedReplies = _addCommentToList(
                comment.replies!, newComment, parentCommentId);
            return comment.copyWith(replies: updatedReplies);
          } else {
            return comment;
          }
        }).toList();
      }
    }

    on<CreateBlogComment>((event, emit) async {
      emit(BlogCommentSaving());
      final response = await blogService.createComment(event.request);
      await response.on(
        onSuccess: (blogComment) {
          if (state is BlogDetailLoaded) {
            final currentState = state as BlogDetailLoaded;
            final updatedComments = _addCommentToList(
              currentState.blog.blogComments ?? [],
              blogComment,
              event.request.parentCommentId,
            );
            final updatedBlog = currentState.blog.copyWith(
              blogComments: updatedComments,
            );
            emit(BlogDetailLoaded(updatedBlog));
          }
          emit(BlogCommentSaved(blogComment));
        },
        onError: (error) => emit(BlogCommentSaveError(error)),
      );
    });
  }
}
