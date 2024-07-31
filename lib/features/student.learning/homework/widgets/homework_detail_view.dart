import 'package:flutter/material.dart';
import 'package:educhain/core/models/homework.dart';

import 'award_tile.dart';
import 'question_tile.dart';
import 'user_homework_status.dart';

class HomeworkDetailView extends StatelessWidget {
  final Homework homework;

  const HomeworkDetailView({Key? key, required this.homework})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text(homework.title ?? 'No Title',
            style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8.0),
        Text(homework.description ?? 'No Description',
            style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 16.0),
        if (homework.questionDtos != null &&
            homework.questionDtos!.isNotEmpty) ...[
          Text('Questions:', style: Theme.of(context).textTheme.titleMedium),
          ...homework.questionDtos!
              .map((question) => QuestionTile(question: question)),
        ],
        if (homework.userHomeworkDtos != null &&
            homework.userHomeworkDtos!.isNotEmpty) ...[
          Text('Your Homework Status:',
              style: Theme.of(context).textTheme.titleMedium),
          UserHomeworkStatus(
              userHomework: homework.userHomeworkDtos!
                  .first), // Adjust if multiple user homework entries
        ],
        if (homework.userAwardDtos != null &&
            homework.userAwardDtos!.isNotEmpty) ...[
          Text('Awards:', style: Theme.of(context).textTheme.titleMedium),
          ...homework.userAwardDtos!.map((award) => AwardTile(award: award)),
        ],
      ],
    );
  }
}
