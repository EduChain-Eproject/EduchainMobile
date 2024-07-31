import 'package:educhain/core/widgets/authenticated_widget.dart';
import 'package:educhain/features/student.learning/homework/screens/homework_detail_screen.dart';
import 'package:educhain/init_dependency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/lesson_bloc.dart';

class LessonDetailScreen extends StatelessWidget {
  static Route route(int lessonId) => MaterialPageRoute(
      builder: (context) =>
          AuthenticatedWidget(child: LessonDetailScreen(lessonId: lessonId)));

  final int lessonId;

  const LessonDetailScreen({Key? key, required this.lessonId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LessonBloc>(),
      child: LessonDetailView(lessonId: lessonId),
    );
  }
}

class LessonDetailView extends StatefulWidget {
  final int lessonId;

  const LessonDetailView({Key? key, required this.lessonId}) : super(key: key);

  @override
  _LessonDetailViewState createState() => _LessonDetailViewState();
}

class _LessonDetailViewState extends State<LessonDetailView> {
  @override
  void initState() {
    super.initState();
    context.read<LessonBloc>().add(FetchLessonDetail(widget.lessonId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LessonBloc, LessonState>(
      builder: (context, state) {
        if (state is LessonDetailLoading) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Lesson Detail'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (state is LessonDetailLoaded) {
          final lesson = state.lessonDetail;

          return Scaffold(
            appBar: AppBar(
              title: Text(lesson.lessonTitle ?? 'Lesson Detail'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Text(
                    lesson.lessonTitle ?? '',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    lesson.description ?? '',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16.0),
                  if (lesson.homeworkDtos != null &&
                      lesson.homeworkDtos!.isNotEmpty) ...[
                    Text('Homework:',
                        style: Theme.of(context).textTheme.titleSmall),
                    ...lesson.homeworkDtos!.map((homework) => ListTile(
                          title: Text(homework.description ?? 'No description'),
                          subtitle:
                              Text('Due: ${homework.title ?? 'No title'}'),
                          onTap: () {
                            Navigator.push(
                              context,
                              HomeworkDetailScreen.route(homework.id!),
                            );
                          },
                        )),
                  ],
                ],
              ),
            ),
          );
        } else if (state is LessonDetailError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Lesson Detail')),
            body: Center(child: Text('Error: ${state.message}')),
          );
        } else {
          return Scaffold(
            appBar: AppBar(title: const Text('Lesson Detail')),
            body: const Center(child: Text('Unknown state')),
          );
        }
      },
    );
  }
}
