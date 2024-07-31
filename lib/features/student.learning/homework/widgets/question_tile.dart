import 'package:educhain/core/models/answer.dart';
import 'package:educhain/core/models/user_answer.dart';
import 'package:flutter/material.dart';
import 'package:educhain/core/models/question.dart';

class QuestionTile extends StatelessWidget {
  final Question question;
  final bool showCorrectAnswers;

  const QuestionTile(
      {Key? key, required this.question, this.showCorrectAnswers = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUserAnswer = question.currentUserAnswerDto;
    final answers = question.answerDtos ?? [];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ExpansionTile(
        title: Text(question.questionText ?? 'No Question Text'),
        children: [
          if (answers.isNotEmpty) ...[
            for (var answer in answers)
              ListTile(
                title: Text(answer.answerText ?? 'No Answer Text'),
                leading: Icon(
                  _getIconForAnswer(answer, currentUserAnswer),
                  color: _getColorForAnswer(answer, currentUserAnswer),
                ),
                onTap: () {
                  // TODO: Handle answer selection if necessary
                },
              ),
          ] else
            const ListTile(
              title: Text('No answers available'),
            ),
        ],
      ),
    );
  }

  IconData _getIconForAnswer(Answer answer, UserAnswer? currentUserAnswer) {
    if (showCorrectAnswers) {
      if (currentUserAnswer != null &&
          currentUserAnswer.answerId == answer.id) {
        return answerIsCorrect(answer) ? Icons.check_circle : Icons.error;
      }
      return answerIsCorrect(answer)
          ? Icons.check_circle
          : Icons.radio_button_unchecked;
    } else {
      if (currentUserAnswer != null &&
          currentUserAnswer.answerId == answer.id) {
        return Icons.radio_button_checked;
      }
      return Icons.radio_button_unchecked;
    }
  }

  Color _getColorForAnswer(Answer answer, UserAnswer? currentUserAnswer) {
    if (showCorrectAnswers) {
      if (currentUserAnswer != null &&
          currentUserAnswer.answerId == answer.id) {
        return answerIsCorrect(answer) ? Colors.green : Colors.red;
      }
      return answerIsCorrect(answer) ? Colors.green : Colors.grey;
    } else {
      return currentUserAnswer != null &&
              currentUserAnswer.answerId == answer.id
          ? Colors.blue
          : Colors.grey;
    }
  }

  bool answerIsCorrect(Answer answer) {
    return question.correctAnswerId == answer.id;
  }
}
