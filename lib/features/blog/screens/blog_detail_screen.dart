import 'package:educhain/core/auth/bloc/auth_bloc.dart';
import 'package:educhain/core/theme/app_pallete.dart';
import 'package:educhain/core/widgets/layouts/student_layout.dart';
import 'package:educhain/core/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:educhain/core/models/blog.dart';
import 'package:educhain/features/blog/bloc/blog_bloc.dart';
import 'package:educhain/features/blog/widgets/blog_comment.dart';
import 'package:educhain/features/blog/screens/update_blog_screen.dart';

class BlogDetailScreen extends StatelessWidget {
  final Blog blog;

  const BlogDetailScreen({Key? key, required this.blog}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AuthBloc, AuthState, AuthAuthenticated>(
      selector: (state) {
        return state as AuthAuthenticated;
      },
      builder: (context, state) {
        return BlocListener<BlogBloc, BlogState>(
          listener: (context, state) {
            if (state is BlogDeleted) {
              Navigator.pop(context);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(blog.title ?? 'Blog Detail'),
              actions: blog.user?.id == state.user.id
                  ? [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  UpdateBlogScreen(blog: blog),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _showDeleteConfirmationDialog(context);
                        },
                      ),
                    ]
                  : [],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (blog.photo != null)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8.0,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Image.network(
                          'http://127.0.0.1:8080/uploads/${blog.photo!}',
                          fit: BoxFit.cover,
                          height: 200,
                          width: double.infinity,
                        ),
                      ),
                    const SizedBox(height: 16.0),
                    Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              blog.title ?? 'No Title',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              blog.blogText ?? 'No Content',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    color: Colors.black87,
                                  ),
                            ),
                            const SizedBox(height: 16.0),
                            if (blog.user != null) ...[
                              Text(
                                'Author: ${blog.user?.firstName ?? 'Unknown'}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: Colors.black54,
                                    ),
                              ),
                              const SizedBox(height: 8.0),
                            ],
                            if (blog.blogCategory != null) ...[
                              Text(
                                'Category: ${blog.blogCategory?.categoryName ?? 'No Category'}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: Colors.black54,
                                    ),
                              ),
                              const SizedBox(height: 8.0),
                            ],
                            if (blog.voteUp != null) ...[
                              Text(
                                'Votes: ${blog.voteUp}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: Colors.black54,
                                    ),
                              ),
                              const SizedBox(height: 16.0),
                            ],
                            if (blog.blogComments != null &&
                                blog.blogComments!.isNotEmpty) ...[
                              CommentSection(
                                  comments: blog.blogComments!,
                                  blogId: blog.id!),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocBuilder<BlogBloc, BlogState>(
          builder: (context, state) {
            return AlertDialog(
              title: const Text(
                'Confirm Delete',
                style: TextStyle(color: AppPallete.lightErrorColor),
              ),
              content: const Text('Are you sure you want to delete this blog?'),
              actions: [
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                if (state is! BlogDeleting)
                  TextButton(
                    child: const Text('Delete'),
                    onPressed: () {
                      _deleteBlog(context);
                      Navigator.of(context).pop();
                    },
                  ),
                if (state is BlogDeleting) const Loader()
              ],
            );
          },
        );
      },
    );
  }

  void _deleteBlog(BuildContext context) {
    context.read<BlogBloc>().add(DeleteBlog(blog.id!));
  }
}
