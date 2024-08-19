import 'package:educhain/core/models/course.dart';
import 'package:flutter/material.dart';

class CourseHeader extends StatelessWidget {
  final Course course;

  const CourseHeader({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Color(0xFFFFF5F5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Image.network(
            '${course.avatarPath}',
            height: 100,
            width: 300,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 20),
          if (true)
            const Text(
              'BESTSELLER',
              style: TextStyle(
                color: Colors.yellow,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          const SizedBox(height: 10),
          Text(
            course.title ?? '',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
