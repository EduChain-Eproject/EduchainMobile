import 'package:educhain/core/models/homework.dart';
import 'package:educhain/core/models/question.dart';
import 'package:educhain/features/teacher.teaching/homework/bloc/teacher_homework_bloc.dart';
import 'package:educhain/features/teacher.teaching/homework/models/create_question_request.dart';
import 'package:educhain/features/teacher.teaching/homework/models/update_answer_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  late List<FocusNode> _answerFocusNodes;
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

    _answerFocusNodes = List.generate(
      _answerControllers.length,
      (_) => FocusNode(),
    );

    _correctAnswerIndex = widget.initialQuestion?.answerDtos?.lastIndexWhere(
            (a) =>
                a.id ==
                (widget.initialQuestion?.correctAnswerId ??
                    widget.initialQuestion?.correctAnswerDto?.id)) ??
        -1;

    _setupFocusListeners();
  }

  void _setupFocusListeners() {
    for (var i = 0; i < _answerControllers.length; i++) {
      final controller = _answerControllers[i];
      final focusNode = _answerFocusNodes[i];
      final initialText = controller.text;

      focusNode.addListener(() {
        if (!focusNode.hasFocus && controller.text != initialText) {
          final answerId = widget.initialQuestion?.answerDtos?[i].id ?? 0;
          context.read<TeacherHomeworkBloc>().add(
                TeacherUpdateAnswer(
                  answerId,
                  UpdateAnswerRequest(answerText: controller.text),
                ),
              );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TeacherHomeworkBloc, TeacherHomeworkState>(
      listener: (context, state) {
        if (state is TeacherQuestionSaveError) {
          // Handle error
        } else if (state is TeacherQuestionSaved) {
          Navigator.pop(context);
        }
      },
      child: AlertDialog(
        title: Text(_isUpdating ? 'Edit Question' : 'Add Question'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _questionTextController,
              decoration: const InputDecoration(labelText: 'Question Text'),
            ),
            const SizedBox(height: 10),
            ..._answerControllers.asMap().entries.map((entry) {
              final index = entry.key;
              final controller = entry.value;
              return Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      focusNode: _answerFocusNodes[index],
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
                  ),
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
      ),
    );
  }

  void _saveQuestion() {
    context.read<TeacherHomeworkBloc>().add(_isUpdating
        ? TeacherUpdateQuestion(
            widget.initialQuestion?.id ?? 0,
            UpdateQuestionRequest(
              questionText: _questionTextController.text,
              correctAnswerId: widget.initialQuestion?.answerDtos
                      ?.elementAt(_correctAnswerIndex)
                      .id ??
                  0,
            ))
        : TeacherCreateQuestion(
            CreateQuestionRequest(
              homeworkId: widget.homework.id ?? 0,
              questionText: _questionTextController.text,
              answerTexts: _answerControllers
                  .map((ctrl) => ctrl.text)
                  .where((a) => a != '')
                  .toList(),
              correctAnswerIndex: _correctAnswerIndex,
            ),
          ));
  }

  @override
  void dispose() {
    _questionTextController.dispose();
    for (var controller in _answerControllers) {
      controller.dispose();
    }
    for (var focusNode in _answerFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }
}
