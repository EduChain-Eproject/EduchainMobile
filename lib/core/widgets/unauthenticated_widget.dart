import 'package:educhain/features/student/screens/student_home_screen.dart';
import 'package:educhain/features/teacher/screens/teacher_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth/bloc/auth_bloc.dart';
import '../auth/bloc/auth_state.dart';

class UnauthenticatedWidget extends StatelessWidget {
  final Widget child;

  const UnauthenticatedWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          if (state.user.role == 'TEACHER') {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(context, TeacherHomeScreen.route());
            });
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(context, StudentHomeScreen.route());
            });
          }
          return const SizedBox.shrink();
        }

        return child;
      },
    );
  }
}
