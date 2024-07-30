import 'package:educhain/core/models/user.dart';
import 'package:flutter/material.dart';

class BestTeacherWidget extends StatelessWidget {
  final User teacher;

  BestTeacherWidget({required this.teacher});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Best Teacher: ${teacher.firstName}'),
        Text('email: ${teacher.email}'),
      ],
    );
  }
}
