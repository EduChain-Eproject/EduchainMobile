import 'package:educhain/core/models/award.dart';
import 'package:educhain/core/models/user_homework.dart';
import 'package:educhain/features/student.learning/award/screens/award_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:educhain/core/models/homework.dart';

import 'question_tile.dart';
import 'user_homework_status.dart';

class HomeworkDetailView extends StatelessWidget {
  final Homework homework;
  final UserHomework? userHomework;
  final Award? award;

  const HomeworkDetailView({
    Key? key,
    required this.homework,
    this.userHomework,
    this.award,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isHomeworkCompleted = award != null;
    final bool allQuestionsAnswered = _checkAllQuestionsAnswered();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Homework Detail'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            homework.title ?? 'No Title',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8.0),
          Text(
            homework.description ?? 'No Description',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16.0),

          // Display user's homework status
          if (userHomework != null) ...[
            Text('Your Homework Status:',
                style: Theme.of(context).textTheme.titleMedium),
            UserHomeworkStatus(userHomework: userHomework!),
          ],

          // Display award status if it exists
          if (award != null) ...[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context, AwardDetailScreen.route(award!.id ?? 0));
              },
              child: const Text('View your award detail'),
            ),
            const SizedBox(height: 16.0),
          ],

          // Display list of questions with answers
          if (homework.questionDtos != null &&
              homework.questionDtos!.isNotEmpty) ...[
            Text('Questions:', style: Theme.of(context).textTheme.titleMedium),
            ...homework.questionDtos!.map((question) => QuestionTile(
                question: question, showCorrectAnswers: isHomeworkCompleted)),
          ],

          // Display submit button if homework is not completed
          if (!isHomeworkCompleted) ...[
            if (allQuestionsAnswered) ...[
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Handle homework submission
                  _submitHomework(context);
                },
                child: const Text('Submit Homework'),
              ),
            ] else ...[
              const SizedBox(height: 16.0),
              Text(
                'Please answer all questions before submitting.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.red),
              ),
            ],
          ],
        ],
      ),
    );
  }

  bool _checkAllQuestionsAnswered() {
    if (homework.questionDtos == null) return false;

    for (var question in homework.questionDtos!) {
      final userAnswer = question.currentUserAnswerDto;
      if (userAnswer == null || userAnswer.answerId == null) {
        return false;
      }
    }
    return true;
  }

  void _submitHomework(BuildContext context) {
    // TODO: Call the HomeworkBloc or equivalent to submit the homework
    // This might look like:
    // context.read<HomeworkBloc>().add(SubmitHomework(homework.id));
  }
}
