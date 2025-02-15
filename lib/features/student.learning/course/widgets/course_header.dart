import 'package:educhain/core/models/course.dart';
import 'package:flutter/material.dart';

class CourseHeader extends StatelessWidget {
  final Course course;

  const CourseHeader({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              course.avatarPath ?? '',
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[200],
                child: const Icon(Icons.image, size: 160, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            course.title ?? '',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 26,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
