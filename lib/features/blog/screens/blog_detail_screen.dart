import 'package:educhain/features/blog/widgets/blog_comment.dart';
import 'package:flutter/material.dart';
import 'package:educhain/core/models/blog.dart';

class BlogDetailScreen extends StatelessWidget {
  final Blog blog;

  const BlogDetailScreen({Key? key, required this.blog}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(blog.title ?? 'Blog Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display blog photo
              if (blog.photo != null)
                Image.network(
                  'http://127.0.0.1:8080/uploads/${blog.photo!}',
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                ),
              SizedBox(height: 16.0),

              // Display blog title
              Text(
                blog.title ?? 'No Title',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(height: 8.0),

              // Display blog text
              Text(
                blog.blogText ?? 'No Content',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 16.0),

              // Display user information
              if (blog.user != null) ...[
                Text(
                  'Author: ${blog.user?.firstName ?? 'Unknown'}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 8.0),
              ],

              // Display blog category
              if (blog.blogCategory != null) ...[
                Text(
                  'Category: ${blog.blogCategory?.categoryName ?? 'No Category'}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 8.0),
              ],

              // Display vote count
              if (blog.voteUp != null) ...[
                Text(
                  'Votes: ${blog.voteUp}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 16.0),
              ],

              // Display comments using CommentSection widget
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
}
