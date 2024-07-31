import 'package:educhain/core/models/course.dart';
import 'package:flutter/material.dart';

class CourseInfo extends StatelessWidget {
  final Course course;

  const CourseInfo({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(course.title ?? '',
            style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8.0),
        Text(course.description ?? '',
            style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 16.0),
        if (course.price != null)
          Text('Price: \$${course.price}',
              style: Theme.of(context).textTheme.bodyMedium),
        if (course.numberOfEnrolledStudents != null)
          Text('Enrolled Students: ${course.numberOfEnrolledStudents}',
              style: Theme.of(context).textTheme.bodyMedium),
        if (course.teacherDto != null) ...[
          const SizedBox(height: 16.0),
          Text('Teacher: ${course.teacherDto!.firstName ?? 'Unknown'}',
              style: Theme.of(context).textTheme.bodyMedium),
          Text('Email: ${course.teacherDto!.email ?? 'Unknown'}',
              style: Theme.of(context).textTheme.bodyMedium),
        ],
      ],
    );
  }
}
