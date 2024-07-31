import 'package:flutter/material.dart';
import 'package:educhain/core/models/user_homework.dart';

class UserHomeworkStatus extends StatelessWidget {
  final UserHomework userHomework;

  const UserHomeworkStatus({Key? key, required this.userHomework})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Submission Date: ${userHomework.submissionDate}',
            style: Theme.of(context).textTheme.bodyMedium),
        Text('Progress: ${userHomework.progress}',
            style: Theme.of(context).textTheme.bodyMedium),
        Text('Grade: ${userHomework.grade}',
            style: Theme.of(context).textTheme.bodyMedium),
        Text(
            'Submitted: ${userHomework.isSubmitted != null && userHomework.isSubmitted == true ? 'Yes' : 'No'}',
            style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
