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
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16.0),
            leading: CircleAvatar(
              backgroundImage: course.avatarPath != null &&
                      course.avatarPath!.isNotEmpty
                  ? NetworkImage(course.avatarPath!)
                  : const AssetImage('assets/images/placeholder.png')
                      as ImageProvider, // Replace with your placeholder image
              radius: 30,
            ),
            title: Text(
              course.title ?? "",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            subtitle: Text(
              course.description ?? "",
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              if (course.id != null) {
                Navigator.push(
                  context,
                  TeacherCourseDetailScreen.route(course.id!),
                );
              }
            },
          ),
        );
      },
    );
  }
}
