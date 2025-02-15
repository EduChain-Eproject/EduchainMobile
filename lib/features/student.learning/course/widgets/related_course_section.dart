import 'package:flutter/material.dart';

import 'package:educhain/core/models/course.dart';
import 'course_card.dart';

class RelatedCoursesSection extends StatelessWidget {
  final List<Course> relatedCourses;

  const RelatedCoursesSection({Key? key, required this.relatedCourses})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return relatedCourses.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Related Courses:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ...relatedCourses.map((relatedCourse) => CourseCard(
                    course: relatedCourse,
                  )),
            ],
          )
        : const Text('No related courses available.');
  }
}
