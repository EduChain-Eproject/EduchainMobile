import 'package:educhain/core/models/blog.dart';
import 'package:educhain/features/blog/screens/blog_detail_screen.dart';
import 'package:flutter/material.dart';

class BlogCard extends StatelessWidget {
  final Blog blog;

  const BlogCard({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlogDetailScreen(blog: blog),
        ),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image on the left
              blog.photo != null
                  ? Image.network(
                      'http://127.0.0.1:8080/uploads/${blog.photo!}',
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          height: 100,
                          width: 100,
                          child: const Icon(Icons.error),
                        );
                      },
                    )
                  : Container(
                      color: Colors.grey[200],
                      height: 100,
                      width: 100,
                      child: const Icon(Icons.article),
                    ),
              const SizedBox(width: 16),
              // Text information on the right
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      blog.title ?? 'No Title',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.person, size: 16),
                        const SizedBox(width: 8),
                        Text(blog.user?.firstName ?? 'Anonymous'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      blog.blogText ?? 'No Content',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
