import 'package:educhain/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth/blocs/auth_bloc.dart';
import '../auth/blocs/auth_state.dart';

class AuthenticatedWidget extends StatelessWidget {
  final Widget child;

  const AuthenticatedWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.push(context, LoginPage.route());
          return const SizedBox.shrink();
        }

        return child;
      },
    );
  }
}
