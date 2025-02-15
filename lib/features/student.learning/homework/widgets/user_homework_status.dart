import 'package:flutter/material.dart';
import 'package:educhain/core/models/user_homework.dart';

class UserHomeworkStatus extends StatelessWidget {
  final UserHomework userHomework;

  const UserHomeworkStatus({Key? key, required this.userHomework})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (userHomework.submissionDate != null)
              ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text(
                  'Submission Date',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                subtitle: Text(
                  userHomework.submissionDate.toString(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ListTile(
              title: Text(
                'Progress',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(
                    value: (userHomework.progress ?? 0) / 100,
                    backgroundColor: Colors.grey[300],
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    '${userHomework.progress?.toStringAsFixed(1) ?? '0.0'}%',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.grade),
              title: Text(
                'Grade',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              subtitle: Text(
                userHomework.grade?.toStringAsFixed(1) ?? 'N/A',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            ListTile(
              leading: Icon(Icons.check_circle),
              title: Text(
                'Submitted',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              subtitle: Text(
                userHomework.isSubmitted == true ? 'Yes' : 'No',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
