import 'package:educhain/core/widgets/authenticated_widget.dart';
import 'package:educhain/features/student.learning/homework/screens/homework_detail_screen.dart';
import 'package:educhain/init_dependency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/lesson_bloc.dart';
import '../widgets/lesson_detail_content.dart';

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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocBuilder<LessonBloc, LessonState>(
        builder: (context, state) {
          if (state is LessonDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LessonDetailLoaded) {
            return LessonDetailContent(lesson: state.lessonDetail);
          } else if (state is LessonDetailError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const Center(child: Text('Unknown state'));
          }
        },
      ),
    );
  }
}
