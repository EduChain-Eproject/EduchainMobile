import 'package:educhain/features/blog/bloc/blog_bloc.dart';
import 'package:educhain/features/blog/blog_service.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/auth/auth_service.dart';
import 'core/auth/bloc/auth_bloc.dart';
import 'package:educhain/features/profile/profile_service.dart';
import 'package:educhain/features/profile/bloc/profile_bloc.dart';
import 'package:educhain/features/student/student_home_service.dart';
import 'package:educhain/features/student/bloc/student_home_bloc.dart';
import 'package:educhain/features/student.learning/award/award_service.dart';
import 'package:educhain/features/student.learning/award/bloc/award_bloc.dart';
import 'package:educhain/features/student.learning/course/blocs/course/course_bloc.dart';
import 'package:educhain/features/student.learning/course/course_service.dart';
import 'package:educhain/features/student.learning/course/blocs/category/category_bloc.dart';
import 'package:educhain/features/student.learning/homework/bloc/homework_bloc.dart';
import 'package:educhain/features/student.learning/homework/homework_service.dart';
import 'package:educhain/features/student.learning/lesson/bloc/lesson_bloc.dart';
import 'package:educhain/features/student.learning/lesson/lesson_service.dart';
import 'package:educhain/features/teacher.teaching/course/blocs/course/teacher_course_bloc.dart';
import 'package:educhain/features/teacher.teaching/course/blocs/category/teacher_category_bloc.dart';
import 'package:educhain/features/teacher.teaching/course/teacher_course_service.dart';
import 'package:educhain/features/teacher.teaching/homework/bloc/teacher_homework_bloc.dart';
import 'package:educhain/features/teacher.teaching/homework/teacher_homework_service.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  getIt.registerSingleton<AuthService>(AuthService());
  getIt.registerFactory<AuthBloc>(() => AuthBloc(getIt<AuthService>()));

  getIt.registerSingleton<ProfileService>(ProfileService());
  getIt.registerFactory<ProfileBloc>(() => ProfileBloc(
        getIt<ProfileService>(),
        getIt<AuthBloc>(),
      ));

  getIt.registerSingleton<StudentHomeService>(StudentHomeService());
  getIt.registerFactory<StudentHomeBloc>(
      () => StudentHomeBloc(getIt<StudentHomeService>()));

  getIt.registerSingleton<CourseService>(CourseService());
  getIt.registerFactory<CategoriesBloc>(
      () => CategoriesBloc(getIt<CourseService>()));
  getIt.registerFactory<CourseBloc>(() => CourseBloc(getIt<CourseService>()));

  getIt.registerSingleton<LessonService>(LessonService());
  getIt.registerFactory<LessonBloc>(() => LessonBloc(getIt<LessonService>()));

  getIt.registerSingleton<HomeworkService>(HomeworkService());
  getIt.registerFactory<HomeworkBloc>(
      () => HomeworkBloc(getIt<HomeworkService>()));

  getIt.registerSingleton<AwardService>(AwardService());
  getIt.registerFactory<AwardBloc>(() => AwardBloc(getIt<AwardService>()));

  getIt.registerSingleton<TeacherCourseService>(TeacherCourseService());
  getIt.registerFactory<TeacherCategoryBloc>(
      () => TeacherCategoryBloc(getIt<TeacherCourseService>()));
  getIt.registerFactory<TeacherCourseBloc>(
      () => TeacherCourseBloc(getIt<TeacherCourseService>()));

  getIt.registerSingleton<TeacherHomeworkService>(TeacherHomeworkService());
  getIt.registerFactory<TeacherHomeworkBloc>(
      () => TeacherHomeworkBloc(getIt<TeacherHomeworkService>()));

  getIt.registerSingleton<BlogService>(BlogService());
  getIt.registerFactory<BlogBloc>(() => BlogBloc(getIt<BlogService>()));
}
