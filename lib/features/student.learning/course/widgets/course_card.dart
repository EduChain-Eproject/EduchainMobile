import 'package:educhain/core/models/course.dart';
import 'package:flutter/material.dart';

import '../screens/course_detail_screen.dart';

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    // final int lessonCount = course.chapterDtos?.fold(
    //         0, (sum, chapter) => sum! + (chapter.lessonDtos?.length ?? 0)) ??
    //     0;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        CourseDetailScreen.route(course.id!),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  course.avatarPath ?? '',
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.broken_image,
                    size: 100,
                  ),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const SizedBox(
                      height: 100,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Text(
                course.title ?? '',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.person, size: 20),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      '${course.teacherDto?.firstName ?? ''} ${course.teacherDto?.lastName ?? ''}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              // const SizedBox(height: 8),
              // if (course.currentUserCourse != null) ...[
              //   LinearProgressIndicator(
              //     value: course.currentUserCourse?.progress ?? 0,
              //     minHeight: 8,
              //     backgroundColor: Colors.grey[300],
              //     valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              //   ),
              //   const SizedBox(height: 4),
              //   Text(
              //     'Completed ${(course.currentUserCourse?.progress ?? 0) * 100}%',
              //     style: const TextStyle(fontSize: 12),
              //   ),
              // ],
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${course.numberOfLessons} Lessons',
                    style: const TextStyle(fontSize: 12),
                  ),
                  if (course.price != null)
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
