import 'package:educhain/core/widgets/loader.dart';
import 'package:flutter/material.dart';

import 'package:educhain/core/models/homework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/teacher_homework_bloc.dart';
import '../screens/teacher_homework_form_screen.dart';

class HomeworkTile extends StatefulWidget {
  final Homework homework;

  const HomeworkTile({Key? key, required this.homework}) : super(key: key);

  @override
  _HomeworkTileState createState() => _HomeworkTileState();
}

class _HomeworkTileState extends State<HomeworkTile> {
  bool _showDetail = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(widget.homework.title ?? 'Untitled'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    TeacherHomeworkFormScreen.route(widget.homework),
                  );
                },
              ),
              IconButton(
                icon: Icon(_showDetail ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  if (!_showDetail) {
                    context
                        .read<TeacherHomeworkBloc>()
                        .add(TeacherFetchHomeworkDetail(widget.homework.id!));
                  }
                  setState(() {
                    _showDetail = !_showDetail;
                  });
                },
              ),
            ],
          ),
        ),
        if (_showDetail)
          BlocBuilder<TeacherHomeworkBloc, TeacherHomeworkState>(
            builder: (context, state) {
              if (state is TeacherHomeworkDetailLoading &&
                  state.homeworkId == widget.homework.id) {
                return const Loader();
              }
              if (state is TeacherHomeworkDetailLoaded) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.homework.description ?? 'No description'),
                      const SizedBox(height: 8),
                      ...?widget.homework.questionDtos?.map((question) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                question.questionText ?? 'No question text',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              ...?question.answerDtos?.map((answer) {
                                return ListTile(
                                  title: Text(
                                      answer.answerText ?? 'No answer text'),
                                  leading: Icon(
                                    question.correctAnswerDto?.id == answer.id
                                        ? Icons.check_circle
                                        : Icons.circle_outlined,
                                    color: question.correctAnswerDto?.id ==
                                            answer.id
                                        ? Colors.green
                                        : Colors.grey,
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
      ],
    );
  }
}
