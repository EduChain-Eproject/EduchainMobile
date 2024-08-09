import 'package:educhain/core/widgets/authenticated_widget.dart';
import 'package:educhain/core/widgets/loader.dart';
import 'package:educhain/init_dependency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/homework_bloc.dart';
import '../widgets/homework_detail_view.dart';

class HomeworkDetailScreen extends StatelessWidget {
  static Route route(int homeworkId) => MaterialPageRoute(
      builder: (context) => AuthenticatedWidget(
          child: HomeworkDetailScreen(homeworkId: homeworkId)));

  final int homeworkId;

  const HomeworkDetailScreen({Key? key, required this.homeworkId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<HomeworkBloc>()..add(FetchHomeworkDetail(homeworkId)),
      child: Scaffold(
        body: BlocBuilder<HomeworkBloc, HomeworkState>(
          builder: (context, state) {
            if (state is HomeworkLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HomeworkLoaded) {
              return HomeworkDetailView(
                homework: state.homework,
                userHomework: state.userHomework,
                award: state.award,
              );
            } else if (state is HomeworkError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is HomeworkQuestionAnswering) {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [Text("Answering question..."), Loader()],
              );
            } else if (state is HomeworkSubmitting) {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [Text("Submitting homework..."), Loader()],
              );
            } else {
              return const Center(child: Text('Unknown state'));
            }
          },
        ),
      ),
    );
  }
}
