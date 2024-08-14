import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:educhain/core/models/blog.dart';
import 'package:educhain/features/blog/bloc/blog_bloc.dart';
import 'package:educhain/features/blog/widgets/blog_comment.dart';

class BlogDetailScreen extends StatelessWidget {
  final Blog blog;

  const BlogDetailScreen({Key? key, required this.blog}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(blog.title ?? 'Blog Detail'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _showDeleteConfirmationDialog(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (blog.photo != null)
                Image.network(
                  'http://127.0.0.1:8080/uploads/${blog.photo!}',
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                ),
              SizedBox(height: 16.0),
              Text(
                blog.title ?? 'No Title',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(height: 8.0),
              Text(
                blog.blogText ?? 'No Content',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 16.0),
              if (blog.user != null) ...[
                Text(
                  'Author: ${blog.user?.firstName ?? 'Unknown'}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 8.0),
              ],
              if (blog.blogCategory != null) ...[
                Text(
                  'Category: ${blog.blogCategory?.categoryName ?? 'No Category'}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 8.0),
              ],
              if (blog.voteUp != null) ...[
                Text(
                  'Votes: ${blog.voteUp}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 16.0),
              ],
              if (blog.blogComments != null &&
                  blog.blogComments!.isNotEmpty) ...[
                CommentSection(comments: blog.blogComments!),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this blog?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _deleteBlog(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteBlog(BuildContext context) {
    context.read<BlogBloc>().add(DeleteBlog(blog.id!));

    // Listen for the BlogDeleted state and navigate back
    BlocListener<BlogBloc, BlogState>(
      listener: (context, state) {
        if (state is BlogDeleted) {
          Navigator.of(context).pop(); // Navigate back to the previous screen
        } else if (state is BlogDeleteError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete blog: ${state.message}')),
          );
        }
      },
      child: Container(),
    );
  }
}
