import 'package:educhain/core/models/homework.dart';
import 'package:educhain/features/student.learning/homework/screens/homework_detail_screen.dart';
import 'package:flutter/material.dart';

class HomeworkTile extends StatelessWidget {
  final Homework homework;
  final bool isCurrentUserFinished;

  const HomeworkTile({
    Key? key,
    required this.homework,
    required this.isCurrentUserFinished,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(12.0),
        title: Text(
          homework.title ?? 'No title',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(homework.description ?? 'No description'),
        trailing: Icon(
          isCurrentUserFinished ? Icons.check_circle : Icons.play_circle,
          color: isCurrentUserFinished ? Colors.green : Colors.grey,
        ),
        onTap: () {
          Navigator.push(
            context,
            HomeworkDetailScreen.route(homework.id!),
          );
        },
      ),
    );
  }
}
