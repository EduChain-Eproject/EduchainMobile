import 'package:educhain/core/models/answer.dart';
import 'package:educhain/core/models/user_answer.dart';
import 'package:educhain/features/student.learning/homework/models/answer_question_request.dart';
import 'package:flutter/material.dart';
import 'package:educhain/core/models/question.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/homework_bloc.dart';

class QuestionTile extends StatelessWidget {
  final Question question;
  final int homeworkId;
  final bool showCorrectAnswers;

  const QuestionTile({
    Key? key,
    required this.question,
    this.showCorrectAnswers = false,
    required this.homeworkId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUserAnswer = question.currentUserAnswerDto;
    final answers = question.answerDtos ?? [];

    return BlocBuilder<HomeworkBloc, HomeworkState>(
      builder: (context, state) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Text(
                question.questionText ?? 'Untitled',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (answers.isNotEmpty)
                ...answers.map((answer) => ListTile(
                      title: Text(answer.answerText ?? 'No Answer Text'),
                      leading: Icon(
                        _getIconForAnswer(answer, currentUserAnswer),
                        color: _getColorForAnswer(answer, currentUserAnswer),
                      ),
                      onTap: showCorrectAnswers
                          ? null
                          : () {
                              context.read<HomeworkBloc>().add(AnswerQuestion(
                                  homeworkId,
                                  AnswerQuestionRequest(
                                      answerId: answer.id ?? 0,
                                      questionId: question.id ?? 0)));
                            },
                    )),
              if (answers.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("No answers available for this question."),
                ),
            ],
          ),
        );
      },
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
    return question.correctAnswerDto?.id == answer.id;
  }
}
