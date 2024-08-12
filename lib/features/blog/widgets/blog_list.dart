import 'package:educhain/features/blog/screens/blog_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:educhain/core/models/blog.dart';

class BlogList extends StatelessWidget {
  final List<Blog> blogs;

  const BlogList({Key? key, required this.blogs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: blogs.length,
      itemBuilder: (context, index) {
        final blog = blogs[index];
        return ListTile(
          title: Text(blog.title ?? 'No Title'),
          subtitle: Text(blog.blogText ?? 'No Content'),
          leading: blog.photo != null
              ? Image.network(
                  'http://127.0.0.1:8080/uploads/${blog.photo!}',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error);
                  },
                )
              : null,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlogDetailScreen(blog: blog),
              ),
            );
          },
        );
      },
    );
  }
}
