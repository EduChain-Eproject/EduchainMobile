import 'package:educhain/core/models/course.dart';
import 'package:flutter/material.dart';

class CourseHeader extends StatelessWidget {
  final Course? course;
  final VoidCallback onUpdate;
  final VoidCallback onDeactivate;

  const CourseHeader({
    Key? key,
    required this.course,
    required this.onUpdate,
    required this.onDeactivate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: NetworkImage(course?.avatarPath ?? ""),
        ),
        const SizedBox(height: 8.0),
        Text(
          course?.title ?? '',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        if (course?.status == CourseStatus.DEACTIVATED)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Your course is deactivated!',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Colors.redAccent,
                  ),
            ),
          ),
        const SizedBox(height: 16.0),
        Row(
          children: [
            ElevatedButton(
              onPressed: onUpdate,
              child: const Text('Update'),
            ),
            const SizedBox(width: 8),
            if (course?.status == CourseStatus.APPROVED)
              ElevatedButton(
                onPressed: onDeactivate,
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                child: const Text('Deactivate'),
              ),
          ],
        ),
      ],
    );
  }
}
