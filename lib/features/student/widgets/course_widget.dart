import 'package:educhain/core/models/course.dart';
import 'package:flutter/material.dart';

class CourseWidget extends StatelessWidget {
  final List<Course> courses;

  const CourseWidget({super.key, required this.courses});

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          courses.map((course) => Text(course.description ?? "")).toList(),
    );
  }
}
