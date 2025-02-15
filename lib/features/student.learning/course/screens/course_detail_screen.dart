import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:educhain/core/widgets/authenticated_widget.dart';
import '../blocs/course/course_bloc.dart';
import '../widgets/course_detail_view.dart';

class CourseDetailScreen extends StatefulWidget {
  static Route route(int courseId) => MaterialPageRoute(
        builder: (context) => AuthenticatedWidget(
          child: CourseDetailScreen(courseId: courseId),
        ),
      );

  final int courseId;

  const CourseDetailScreen({Key? key, required this.courseId})
      : super(key: key);

  @override
  _CourseDetailScreenState createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CourseBloc>().add(FetchCourseDetail(widget.courseId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<CourseBloc, CourseState>(
        listener: (context, state) {
          if (state is CourseDetailError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        child: BlocBuilder<CourseBloc, CourseState>(
          builder: (context, state) {
            if (state is CourseDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CourseDetailLoaded) {
              return CourseDetailView(course: state.courseDetail);
            } else if (state is CourseDetailError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${state.message}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<CourseBloc>()
                            .add(FetchCourseDetail(widget.courseId));
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
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
