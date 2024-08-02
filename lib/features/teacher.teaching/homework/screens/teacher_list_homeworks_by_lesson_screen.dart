import 'package:educhain/init_dependency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/teacher_homework_bloc.dart';
import '../widgets/homework_tile.dart';
import 'teacher_homework_form_screen.dart';

class TeacherListHomeworksByLessonScreen extends StatelessWidget {
  static Route route(int lessonId) => MaterialPageRoute(
        builder: (context) => TeacherListHomeworksByLessonScreen(
          lessonId: lessonId,
        ),
      );

  final int lessonId;

  const TeacherListHomeworksByLessonScreen({Key? key, required this.lessonId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => context.read<TeacherHomeworkBloc>()
        ..add(TeacherFetchHomeworks(lessonId)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Homeworks')),
        body: BlocBuilder<TeacherHomeworkBloc, TeacherHomeworkState>(
          builder: (context, state) {
            if (state is TeacherHomeworksLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TeacherHomeworksLoaded) {
              final lesson = state.lesson;
              final homeworks = lesson.homeworkDtos;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lesson.lessonTitle ?? 'No Title',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          lesson.description ?? 'No Description',
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
            } else if (state is TeacherHomeworksError) {
              return Center(child: Text(state.errors?['message']));
            } else {
              return const Center(child: Text('No data available'));
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, TeacherHomeworkFormScreen.route(null));
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
