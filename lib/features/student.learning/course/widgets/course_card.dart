import 'package:educhain/core/api_service.dart';
import 'package:educhain/core/models/course.dart';
import 'package:flutter/material.dart';

import '../screens/course_detail_screen.dart';

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final int lessonCount = course.chapterDtos?.fold(
            0, (sum, chapter) => sum! + (chapter.lessonDtos?.length ?? 0)) ??
        0;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        CourseDetailScreen.route(course.id!),
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                '${course.avatarPath}',
                height: 100,
                width: 300,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16),
              Text(
                course.title ?? '',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.person),
                  const SizedBox(width: 8),
                  Text(course.teacherDto?.firstName ?? ""),
                ],
              ),
              const SizedBox(height: 8),
              if (course.currentUserCourse != null)
                LinearProgressIndicator(
                  value: course.currentUserCourse?.progress ?? 0,
                  minHeight: 8,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (course.currentUserCourse != null)
                    Text(
                      'Completed ${(course.currentUserCourse?.progress ?? 0 * 100).toStringAsFixed(1)}%',
                      style: const TextStyle(fontSize: 12),
                    ),
                  Text(
                    '$lessonCount Lessons',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              if (course.price != null) SizedBox(height: 8),
              if (course.price != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${course.price}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
