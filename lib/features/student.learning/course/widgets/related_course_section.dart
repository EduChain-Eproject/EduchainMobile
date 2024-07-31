import 'package:educhain/core/models/course.dart';
import 'package:flutter/material.dart';

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
              Text('Related Courses:',
                  style: Theme.of(context).textTheme.bodyMedium),
              ...relatedCourses.map((relatedCourse) => ListTile(
                    title: Text(relatedCourse.title ?? 'No title'),
                    onTap: () {
                      // TODO: Navigate to related course detail page
                    },
                  )),
            ],
          )
        : const Text('No related courses available.');
  }
}
