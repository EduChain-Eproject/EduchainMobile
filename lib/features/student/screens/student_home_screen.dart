import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:educhain/features/student/bloc/student_home_bloc.dart';
import 'package:educhain/init_dependency.dart';

import '../widgets/best_teacher_widget.dart';
import '../widgets/category_widget.dart';
import '../widgets/course_widget.dart';
import '../widgets/header_widget.dart';
import '../widgets/progress.dart';
import '../widgets/statistics_widget.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<StudentHomeBloc>()..add(FetchStudentHomeData()),
      child: Scaffold(
        body: BlocBuilder<StudentHomeBloc, StudentHomeState>(
          builder: (context, state) {
            if (state is StudentHomeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is StudentHomeLoaded) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0), // Add horizontal padding
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const HeaderWidget(),
                      const SizedBox(height: 20),
                      ProgressSection(),
                      const SizedBox(height: 20),
                      CategoryWidget(categories: state.categories),
                      const SizedBox(height: 20),
                      CourseWidget(courses: state.courses),
                      const SizedBox(height: 20),
                      BestTeacherWidget(teacher: state.bestTeacher),
                      const SizedBox(height: 20),
                      StatisticsWidget(statistics: state.statistics),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            } else if (state is StudentHomeError) {
              return Center(child: Text(state.message));
            }
            return Container();
          },
        ),
      ),
    );
  }
}
