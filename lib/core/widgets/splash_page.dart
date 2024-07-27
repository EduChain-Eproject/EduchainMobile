import 'package:educhain/core/widgets/loader.dart';
import 'package:educhain/features/auth/screens/login_screen.dart';
import 'package:educhain/features/student/screens/student_home_screen.dart';
import 'package:educhain/features/teacher/screens/teacher_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth/blocs/auth_bloc.dart';
import '../auth/blocs/auth_state.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          if (state.user.role == 'STUDENT') {
            Navigator.push(context, StudentHomeScreen.route());
          } else if (state.user.role == 'TEACHER') {
            Navigator.push(context, TeacherHomeScreen.route());
          }
        } else if (state is AuthUnauthenticated) {
          Navigator.push(context, LoginScreen.route());
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Authentication Error: ${state.errors!['message']}')),
          );
          Navigator.push(context, LoginScreen.route());
        }
      },
      child: const Loader(),
    );
  }
}
