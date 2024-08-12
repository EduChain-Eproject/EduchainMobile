import 'package:educhain/core/models/award.dart';
import 'package:educhain/core/models/user_homework.dart';
import 'package:educhain/core/theme/app_pallete.dart';
import 'package:educhain/features/student.learning/award/screens/award_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:educhain/core/models/homework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/homework_bloc.dart';
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
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    homework.title ?? 'No Title',
                    style: const TextStyle(
                        fontSize: 24, color: AppPallete.lightPrimaryColor),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    homework.description ?? 'No Description',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          if (userHomework != null) ...[
            UserHomeworkStatus(userHomework: userHomework!),
            const Divider(height: 32.0),
          ],
          if (award != null) ...[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context, AwardDetailScreen.route(award!.id ?? 0));
              },
              child: const Text('View your award'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
          ],
          if (homework.questionDtos != null &&
              homework.questionDtos!.isNotEmpty) ...[
            const Text('Questions:',
                style: TextStyle(
                    color: AppPallete.lightPrimaryColor, fontSize: 20)),
            ...homework.questionDtos!.map((question) => QuestionTile(
                homeworkId: homework.id ?? 0,
                question: question,
                showCorrectAnswers: isHomeworkCompleted)),
          ],
          if (!isHomeworkCompleted) ...[
            if (allQuestionsAnswered) ...[
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  _submitHomework(context);
                },
                child: const Text('Submit Homework'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
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
    context.read<HomeworkBloc>().add(SubmitHomework(homework.id ?? 0));
  }
}
