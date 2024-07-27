import 'package:educhain/core/widgets/loader.dart';
import 'package:educhain/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth/blocs/auth_bloc.dart';
import '../auth/blocs/auth_state.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          if (state.role == 'STUDENT') {
            Navigator.pushReplacementNamed(context, '/student_home');
          } else if (state.role == 'TEACHER') {
            Navigator.pushReplacementNamed(context, '/teacher_home');
          }
        } else if (state is AuthUnauthenticated) {
          Navigator.pushReplacementNamed(context, LoginPage.route());
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Authentication Error: ${state.message}')),
          );
          Navigator.pushReplacementNamed(context, LoginPage.route());
        }
      },
      child: const Loader(),
    );
  }
}
