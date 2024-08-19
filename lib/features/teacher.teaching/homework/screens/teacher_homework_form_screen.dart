import 'package:educhain/core/models/homework.dart';
import 'package:educhain/core/models/question.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/teacher_homework_bloc.dart';
import '../models/create_homework_request.dart';
import '../models/update_homework_request.dart';
import '../widgets/question_dialog.dart';

class TeacherHomeworkFormScreen extends StatefulWidget {
  static Route route(Homework? homework) => MaterialPageRoute(
        builder: (context) => TeacherHomeworkFormScreen(
          homework: homework,
        ),
      );

  final Homework? homework;

  const TeacherHomeworkFormScreen({Key? key, this.homework}) : super(key: key);

  @override
  _TeacherHomeworkFormScreenState createState() =>
      _TeacherHomeworkFormScreenState();
}

class _TeacherHomeworkFormScreenState extends State<TeacherHomeworkFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late bool _isUpdating;
  late List<Question> _questions;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.homework?.title);
    _descriptionController =
        TextEditingController(text: widget.homework?.description);
    _isUpdating = widget.homework != null;
    _questions = widget.homework?.questionDtos ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeacherHomeworkBloc, TeacherHomeworkState>(
      listener: (context, state) {
        if (state is TeacherHomeworkSaved && state.status == 'created') {
          Navigator.pushReplacement(
              context, TeacherHomeworkFormScreen.route(state.homework));
        } else if (state is TeacherQuestionSaved) {
          switch (state.status) {
            case 'created':
              _questions = [state.question, ..._questions];
              break;

            case 'updated':
              _questions = _questions
                  .map((q) => q.id == state.question.id ? state.question : q)
                  .toList();
              break;

            case 'deleted':
              _questions =
                  _questions.where((q) => q.id != state.question.id).toList();
              break;
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(_isUpdating ? 'Edit Homework' : 'Create Homework'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveHomework,
                    child: Text(
                        _isUpdating ? 'Update Homework' : 'Create Homework'),
                  ),
                  if (_isUpdating) ...[
                    const SizedBox(height: 20),
                    Text('Questions',
                        style: Theme.of(context).textTheme.headlineSmall),
                    ..._questions.map((question) => ListTile(
                          title:
                              Text(question.questionText ?? 'No question text'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () =>
                                    _editQuestion(context, question),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _deleteQuestion(question),
                              ),
                            ],
                          ),
                        )),
                    ListTile(
                      title: const Text('Add Question'),
                      trailing: const Icon(Icons.add),
                      onTap: () => _addQuestion(context),
                    ),
                  ]
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _saveHomework() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_isUpdating) {
        final request = UpdateHomeworkRequest(
          title: _titleController.text,
          description: _descriptionController.text,
        );
        context
            .read<TeacherHomeworkBloc>()
            .add(TeacherUpdateHomework(widget.homework!.id!, request));
        Navigator.pop(context);
      } else {
        final request = CreateHomeworkRequest(
          lessonId: widget.homework?.lessonId ?? 0,
          title: _titleController.text,
          description: _descriptionController.text,
        );
        context.read<TeacherHomeworkBloc>().add(TeacherCreateHomework(request));
      }
    }
  }

  void _addQuestion(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => QuestionDialog(
        homework: widget.homework ?? Homework(),
      ),
    );
  }

  void _editQuestion(BuildContext context, Question question) {
    showDialog(
      context: context,
      builder: (context) => QuestionDialog(
        initialQuestion: question,
        homework: widget.homework ?? Homework(),
      ),
    );
  }

  void _deleteQuestion(Question question) {
    context
        .read<TeacherHomeworkBloc>()
        .add(TeacherDeleteQuestion(question.id ?? 0));
  }
}
