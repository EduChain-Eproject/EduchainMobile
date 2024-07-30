import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:educhain/core/auth/bloc/auth_bloc.dart';
import 'package:educhain/core/auth/bloc/auth_event.dart';
import 'package:educhain/features/student/bloc/student_home_bloc.dart';
import 'package:educhain/init_dependency.dart';

import '../widgets/best_teacher_widget.dart';
import '../widgets/category_widget.dart';
import '../widgets/course_widget.dart';
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
        appBar: AppBar(
          title: Text('Student Home'),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                context.read<AuthBloc>().add(LogOutRequested());
              },
            ),
          ],
        ),
        body: BlocBuilder<StudentHomeBloc, StudentHomeState>(
          builder: (context, state) {
            if (state is StudentHomeLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is StudentHomeLoaded) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    CategoryWidget(categories: state.categories),
                    CourseWidget(courses: state.courses),
                    StatisticsWidget(statistics: state.statistics),
                    BestTeacherWidget(teacher: state.bestTeacher),
                  ],
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
