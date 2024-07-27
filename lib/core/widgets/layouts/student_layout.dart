import 'package:educhain/features/teacher/screens/teacher_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth/blocs/auth_bloc.dart';
import '../../auth/blocs/auth_state.dart';
import '../authenticated_widget.dart';

class StudentLayout extends StatelessWidget {
  const StudentLayout({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated && state.user.role == 'TEACHER') {
          Navigator.push(context, TeacherHomeScreen.route());
          return const SizedBox.shrink();
        }

        return AuthenticatedWidget(child: child); // TODO: add layout here
      },
    );
  }
}
