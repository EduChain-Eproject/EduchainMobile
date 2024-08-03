import 'package:educhain/features/profile/bloc/profile_bloc.dart';
import 'package:educhain/features/student/bloc/student_home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'init_dependency.dart';
import 'core/widgets/splash_page.dart';
import 'core/theme/theme.dart';
import 'core/auth/bloc/auth_bloc.dart';
import 'features/student.learning/award/bloc/award_bloc.dart';
import 'features/student.learning/course/bloc/course_bloc.dart';
import 'features/student.learning/homework/bloc/homework_bloc.dart';
import 'features/student.learning/lesson/bloc/lesson_bloc.dart';
import 'features/teacher.teaching/course/bloc/teacher_course_bloc.dart';
import 'features/teacher.teaching/homework/bloc/teacher_homework_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final authBloc = getIt<AuthBloc>();
            authBloc.add(AppStarted());
            return authBloc;
          },
        ),
        BlocProvider(
          create: (context) => getIt<ProfileBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt<StudentHomeBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt<CourseBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt<LessonBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt<HomeworkBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt<AwardBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt<TeacherCourseBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt<TeacherHomeworkBloc>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Blog App',
        theme: AppTheme.darkThemeMode,
        home: const SplashScreen(),
      ),
    );
  }
}
