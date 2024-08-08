import 'package:educhain/core/models/user_course.dart';
import 'package:flutter/material.dart';

import 'package:educhain/core/models/user.dart';

class ParticipatedUsersSection extends StatelessWidget {
  final List<UserCourse> userCourses;

  const ParticipatedUsersSection({Key? key, required this.userCourses})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          'Participated Users',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        if (userCourses.isNotEmpty)
          ...userCourses.map((uc) => ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(uc.userDto?.avatarPath ?? ''),
                ),
                title: Text('${uc.userDto?.firstName} ${uc.userDto?.lastName}'),
                subtitle: Text(uc.userDto?.email ?? ""),
              ))
        else
          const Text('No students enrolled!'),
      ],
    );
  }
}
