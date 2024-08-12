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
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${course.numberOfEnrolledStudents} students enrolled - ${course.numberOfLessons} lessons',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              if (course.price != null)
                Text('\$${course.price}',
                    style: Theme.of(context).textTheme.bodyMedium),
            ]),
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
