import 'package:bloc/bloc.dart';
import 'package:educhain/core/models/blog.dart';
import 'package:educhain/core/models/blog_category.dart';
import 'package:educhain/core/models/blog_comment.dart';
import 'package:educhain/features/blog/blog_service.dart';
import 'package:educhain/features/blog/models/create_blog_request.dart';
import 'package:educhain/features/blog/models/filter_blog_request.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final BlogService blogService;

  BlogBloc(this.blogService) : super(BlogInitial()) {
    on<FetchBlogs>((event, emit) async {
      emit(BlogsLoading());
      final response = await blogService.fetchBlogs();
      await response.on(
        onError: (error) {
          final errorMessage = error['message']?.toString() ?? 'Unknown error';
          emit(BlogsError(errorMessage));
        },
        onSuccess: (blogs) => emit(BlogsLoaded(blogs)),
      );
    });

    on<FetchBlogCategories>((event, emit) async {
      emit(BlogCategoriesLoading());
      final response = await blogService.fetchBlogCategories();
      await response.on(
        onError: (error) {
          final errorMessage = error['message']?.toString() ?? 'Unknown error';
          emit(BlogCategoriesError(errorMessage));
        },
        onSuccess: (blogCategories) =>
            emit(BlogCategoriesLoaded(blogCategories)),
      );
    });

    on<FetchBlogDetail>((event, emit) async {
      emit(BlogDetailLoading());
      final response = await blogService.getBlogDetail(event.blogId);
      await response.on(
        onSuccess: (blogDetail) => emit(BlogDetailLoaded(blogDetail)),
        onError: (error) => emit(BlogDetailError(error['message'])),
      );
    });

    on<FilterBlogs>((event, emit) async {
      emit(BlogsLoading());
      try {
        final response = await blogService.filterBlogs(event.blogFilterRequest);
        await response.on(
          onSuccess: (filteredBlogs) => emit(BlogsLoaded(filteredBlogs)),
          onError: (error) => emit(BlogsError(error['message'])),
        );
      } catch (e) {
        emit(BlogsError(e.toString()));
      }
    });

    // on<CreateBlog>((event, emit) async {
    //   emit(BlogCreating());
    //   try {
    //     final response = await blogService.createBlog(
    //       event.filePath,
    //       event.blogCreateRequest,
    //     );
    //     await response.on(
    //       onSuccess: (createdBlog) => emit(BlogCreated(createdBlog)),
    //       onError: (error) => emit(BlogCreateError(error['message'])),
    //     );
    //   } catch (e) {
    //     emit(BlogCreateError(e.toString()));
    //   }
    // });
  }
}
