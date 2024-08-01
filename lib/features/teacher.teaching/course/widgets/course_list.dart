import 'package:educhain/core/models/course.dart';
import 'package:flutter/material.dart';

import '../screens/teacher_course_detail_screen.dart';

class CourseList extends StatelessWidget {
  final List<Course> courses;

  const CourseList({Key? key, required this.courses}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return ListTile(
          title: Text(course.title ?? ""),
          subtitle: Text(course.description ?? ""),
          onTap: () {
            if (course.id != null) {
              Navigator.push(
                context,
                TeacherCourseDetailScreen.route(course.id!),
              );
            }
          },
        );
      },
    );
  }
}
