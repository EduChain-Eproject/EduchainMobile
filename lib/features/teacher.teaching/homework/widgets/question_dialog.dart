import 'package:educhain/core/models/homework.dart';
import 'package:educhain/core/models/question.dart';
import 'package:educhain/core/theme/app_pallete.dart';
import 'package:educhain/core/widgets/loader.dart';
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
  Map<String, dynamic>? _errors;

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
    return BlocConsumer<TeacherHomeworkBloc, TeacherHomeworkState>(
      listener: (context, state) {
        if (state is TeacherQuestionSaveError) {
          setState(() {
            _errors = state.errors;
          });
        } else if (state is TeacherQuestionSaved) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return AlertDialog(
          title: Text(
            _isUpdating ? 'Edit Question' : 'Add Question',
            style: const TextStyle(color: AppPallete.accentColor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _questionTextController,
                decoration: InputDecoration(
                    labelText: 'Question Text',
                    errorText: _errors?['questionText']),
              ),
              const SizedBox(height: 10),
              ..._answerControllers.asMap().entries.map((entry) {
                final index = entry.key;
                final controller = entry.value;
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller,
                            focusNode: _answerFocusNodes[index],
                            decoration: InputDecoration(
                                labelText: 'Answer ${index + 1}'),
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
                    ),
                    const SizedBox(
                      height: 10,
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
            if (_errors?['answerTexts'] != null)
              Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  _errors?['answerTexts'],
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ElevatedButton(
              onPressed: _saveQuestion,
              child: state is TeacherQuestionSaving
                  ? const Loader()
                  : const Text('Save'),
            )
          ],
        );
      },
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
