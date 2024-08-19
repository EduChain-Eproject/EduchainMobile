import 'package:educhain/core/models/answer.dart';
import 'package:educhain/core/models/homework.dart';
import 'package:educhain/core/models/question.dart';
import 'package:educhain/features/teacher.teaching/homework/bloc/teacher_homework_bloc.dart';
import 'package:educhain/features/teacher.teaching/homework/models/create_question_request.dart';
import 'package:educhain/init_dependency.dart';
import 'package:flutter/material.dart';

import '../models/update_question_request.dart';

class QuestionDialog extends StatefulWidget {
  final Homework homework;
  final Question? initialQuestion;

  const QuestionDialog({Key? key, this.initialQuestion, required this.homework})
      : super(key: key);

  @override
  _QuestionDialogState createState() => _QuestionDialogState();
}

class _QuestionDialogState extends State<QuestionDialog> {
  late TextEditingController _questionTextController;
  late List<TextEditingController> _answerControllers;
  late int _correctAnswerIndex;
  late bool _isUpdating;

  @override
  void initState() {
    super.initState();
    _isUpdating = widget.initialQuestion != null;
    _questionTextController =
        TextEditingController(text: widget.initialQuestion?.questionText);
    _answerControllers = widget.initialQuestion?.answerDtos
            ?.map((answer) => TextEditingController(text: answer.answerText))
            .toList() ??
        List.generate(4, (_) => TextEditingController());
    _correctAnswerIndex = widget.initialQuestion?.answerDtos?.lastIndexWhere(
            (a) => a.id == widget.initialQuestion?.correctAnswerId) ??
        -1;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isUpdating ? 'Edit Question' : 'Add Question'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _questionTextController,
            decoration: InputDecoration(labelText: 'Question Text'),
          ),
          const SizedBox(height: 10),
          ..._answerControllers.asMap().entries.map((entry) {
            final index = entry.key;
            final controller = entry.value;
            return Row(
              children: [
                // TODO: allow update answer text
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration:
                        InputDecoration(labelText: 'Answer ${index + 1}'),
                  ),
                ),
                Radio<int>(
                  value: index,
                  groupValue: _correctAnswerIndex,
                  onChanged: (value) {
                    setState(() {
                      _correctAnswerIndex = value!;
                    });
                  },
                )
              ],
            );
          }),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveQuestion,
          child: const Text('Save'),
        ),
      ],
    );
  }

  void _saveQuestion() {
    getIt<TeacherHomeworkBloc>().add(_isUpdating
        ? TeacherUpdateQuestion(
            widget.initialQuestion?.id ?? 0,
            UpdateQuestionRequest(
                questionText: _questionTextController.text,
                correctAnswerId: widget.initialQuestion?.answerDtos
                        ?.elementAt(_correctAnswerIndex)
                        .id ??
                    0))
        : TeacherCreateQuestion(
            CreateQuestionRequest(
                homeworkId: widget.homework.id ?? 0,
                questionText: _questionTextController.text,
                answerTexts:
                    _answerControllers.map((ctrl) => ctrl.text).toList(),
                correctAnswerIndex: _correctAnswerIndex),
          ));
    getIt<TeacherHomeworkBloc>().stream.listen((state) {
      if (state is TeacherQuestionSaveError) {
        // TODO handle error
      } else {
        Navigator.pop(context);
      }
    });
  }
}
