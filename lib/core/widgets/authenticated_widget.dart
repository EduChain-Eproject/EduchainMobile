import 'package:educhain/features/auth/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth/bloc/auth_bloc.dart';

class AuthenticatedWidget extends StatelessWidget {
  final Widget child;

  const AuthenticatedWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthUnauthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(context, LoginScreen.route());
          });
          return const SizedBox.shrink();
        }

        return child;
      },
    );
  }
}
