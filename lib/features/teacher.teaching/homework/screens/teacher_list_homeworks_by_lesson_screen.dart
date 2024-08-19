import 'package:educhain/core/models/lesson.dart';
import 'package:educhain/init_dependency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/teacher_homework_bloc.dart';
import '../widgets/homework_tile.dart';
import 'teacher_homework_form_screen.dart';

class TeacherListHomeworksByLessonScreen extends StatefulWidget {
  static Route route(int lessonId) => MaterialPageRoute(
        builder: (context) => TeacherListHomeworksByLessonScreen(
          lessonId: lessonId,
        ),
      );

  final int lessonId;

  const TeacherListHomeworksByLessonScreen({Key? key, required this.lessonId})
      : super(key: key);
  @override
  State<TeacherListHomeworksByLessonScreen> createState() =>
      _TeacherListHomeworksByLessonScreenState();
}

class _TeacherListHomeworksByLessonScreenState
    extends State<TeacherListHomeworksByLessonScreen> {
  Lesson? lesson;
  @override
  void initState() {
    super.initState();
    context
        .read<TeacherHomeworkBloc>()
        .add(TeacherFetchHomeworks(widget.lessonId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Homeworks')),
      body: BlocConsumer<TeacherHomeworkBloc, TeacherHomeworkState>(
        listener: (BuildContext context, TeacherHomeworkState state) {
          if (state is TeacherHomeworkDetailLoaded) {
            lesson = lesson?.copyWith(
                homeworkDtos: lesson?.homeworkDtos
                    ?.map((hw) =>
                        hw.id == state.homework.id ? state.homework : hw)
                    .toList());
          } else if (state is TeacherHomeworkSaved) {
            switch (state.status) {
              case "created":
                lesson = lesson?.copyWith(
                    homeworkDtos: [state.homework, ...?lesson?.homeworkDtos]);
                break;
              case "updated":
                lesson = lesson?.copyWith(
                    homeworkDtos: lesson?.homeworkDtos
                        ?.map((hw) =>
                            hw.id == state.homework.id ? state.homework : hw)
                        .toList());
                break;
              case "deleted":
                lesson = lesson?.copyWith(
                    homeworkDtos: lesson?.homeworkDtos
                        ?.where((hw) => hw.id != state.homework.id)
                        .toList());
                break;
            }
          }
        },
        builder: (context, state) {
          if (state is TeacherHomeworksLoading || lesson == null) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TeacherHomeworksError) {
            return Center(child: Text(state.errors?['message']));
          } else {
            final homeworks = lesson?.homeworkDtos;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lesson?.lessonTitle ?? 'No Title',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        lesson?.description ?? 'No Description',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: homeworks?.length ?? 0,
                    itemBuilder: (context, index) {
                      final homework = homeworks?[index];
                      return HomeworkTile(homework: homework!);
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, TeacherHomeworkFormScreen.route(null));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
