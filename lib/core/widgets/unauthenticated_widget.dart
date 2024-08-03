import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:educhain/core/widgets/layouts/student_layout.dart';

import '../auth/bloc/auth_bloc.dart';
import 'layouts/teacher_layout.dart';

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
              Navigator.pushReplacement(context, TeacherLayout.route());
            });
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(context, StudentLayout.route());
            });
          }
          return const SizedBox.shrink();
        }

        return child;
      },
    );
  }
}
