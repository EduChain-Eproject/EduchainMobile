import 'package:educhain/core/models/course.dart';
import 'package:educhain/features/student.learning/course/screens/course_detail_screen.dart';
import 'package:flutter/material.dart';

class CourseWidget extends StatelessWidget {
  final List<Course> courses;

  CourseWidget({required this.courses});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            'Popular Courses',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          ...courses
              .map((course) => _buildCourseCard(context, course))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildCourseCard(BuildContext context, Course course) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, CourseDetailScreen.route(course.id!));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent.withOpacity(0.7), Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      course.title ?? "",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      course.description ?? "",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          "\$ ${course.price}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          '${course.participatedUserDtos?.length ?? 0} Enrollments',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[200],
                  child: course.avatarPath != null
                      ? Image.network(course.avatarPath!, fit: BoxFit.cover)
                      : const Icon(Icons.image_not_supported,
                          color: Colors.grey, size: 40),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
