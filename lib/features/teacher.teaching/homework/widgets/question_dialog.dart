import 'package:educhain/core/models/answer.dart';
import 'package:educhain/core/models/question.dart';
import 'package:flutter/material.dart';

class QuestionDialog extends StatefulWidget {
  final Question? initialQuestion;
  final Function(Question) onSave;

  const QuestionDialog({Key? key, this.initialQuestion, required this.onSave})
      : super(key: key);

  @override
  _QuestionDialogState createState() => _QuestionDialogState();
}

class _QuestionDialogState extends State<QuestionDialog> {
  late TextEditingController _questionTextController;
  late List<TextEditingController> _answerControllers;
  late int _correctAnswerIndex;

  @override
  void initState() {
    super.initState();
    _questionTextController =
        TextEditingController(text: widget.initialQuestion?.questionText);
    _answerControllers = widget.initialQuestion?.answerDtos
            ?.map((answer) => TextEditingController(text: answer.answerText))
            .toList() ??
        List.generate(4, (_) => TextEditingController());
    _correctAnswerIndex = widget.initialQuestion?.correctAnswerId ?? -1;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          widget.initialQuestion == null ? 'Add Question' : 'Edit Question'),
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
    final questionText = _questionTextController.text;
    final answerTexts =
        _answerControllers.map((controller) => controller.text).toList();
    final question = Question(
      id: widget.initialQuestion?.id,
      questionText: questionText,
      homeworkId: widget.initialQuestion?.homeworkId ?? -1,
      correctAnswerId: _correctAnswerIndex,
      answerDtos: answerTexts.map((text) => Answer(answerText: text)).toList(),
    );

    widget.onSave(question);
    Navigator.pop(context);
  }
}
