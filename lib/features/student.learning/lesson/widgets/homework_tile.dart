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
    return ListTile(
      title: Text(
        homework.title ?? 'No title ',
        style: TextStyle(fontSize: 18),
      ),
      subtitle: Text(homework.description ?? 'No description '),
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
    );
  }
}
