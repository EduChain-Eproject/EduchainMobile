import 'package:educhain/core/widgets/loader.dart';
import 'package:flutter/material.dart';

import 'package:educhain/core/models/homework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/teacher_homework_bloc.dart';
import '../screens/teacher_homework_form_screen.dart';

class HomeworkTile extends StatefulWidget {
  final Homework homework;
  final int lessonId;

  const HomeworkTile({Key? key, required this.homework, required this.lessonId})
      : super(key: key);

  @override
  _HomeworkTileState createState() => _HomeworkTileState();
}

class _HomeworkTileState extends State<HomeworkTile> {
  bool _showDetail = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        children: [
          ListTile(
            onTap: () {
              if (!_showDetail) {
                context
                    .read<TeacherHomeworkBloc>()
                    .add(TeacherFetchHomeworkDetail(widget.homework.id!));
              }
              setState(() {
                _showDetail = !_showDetail;
              });
            },
            title: Text(widget.homework.title ?? 'Untitled'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      _showDetail = false;
                    });
                    Navigator.push(
                      context,
                      TeacherHomeworkFormScreen.route(
                          widget.homework, widget.lessonId),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    context
                        .read<TeacherHomeworkBloc>()
                        .add(TeacherDeleteHomework(widget.homework.id!));
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
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (state is TeacherHomeworkDetailLoaded) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.homework.description ?? 'No description',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        ...?widget.homework.questionDtos?.map((question) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
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
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Center(child: Text('No details available.')),
                );
              },
            ),
        ],
      ),
    );
  }
}
