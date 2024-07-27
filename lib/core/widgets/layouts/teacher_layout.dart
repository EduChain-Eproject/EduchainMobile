import 'package:educhain/features/student/screens/student_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth/blocs/auth_bloc.dart';
import '../../auth/blocs/auth_state.dart';
import '../authenticated_widget.dart';

class TeacherLayout extends StatelessWidget {
  const TeacherLayout({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated && state.user.role == 'STUDENT') {
          Navigator.push(context, StudentHomeScreen.route());
          return const SizedBox.shrink();
        }

        return AuthenticatedWidget(child: child); // TODO: add layout here
      },
    );
  }
}
