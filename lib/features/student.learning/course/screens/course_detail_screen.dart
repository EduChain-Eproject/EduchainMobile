import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:educhain/core/widgets/loader.dart';

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
    return BlocBuilder<CourseBloc, CourseState>(
      builder: (context, state) {
        if (state is CourseDetailLoading) {
          return const Loader();
        } else if (state is CourseDetailLoaded) {
          return CourseDetailView(course: state.courseDetail);
        } else if (state is CourseDetailError) {
          return Center(child: Text('Error: ${state.message}'));
        } else {
          return const Center(child: Text('Unknown state'));
        }
      },
    );
  }
}
