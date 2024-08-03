import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:educhain/core/widgets/layouts/teacher_layout.dart';
import 'package:educhain/features/auth/screens/login_screen.dart';
import '../auth/bloc/auth_bloc.dart';
import 'layouts/student_layout.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Future<MaterialPageRoute> _navigationFuture;

  @override
  void initState() {
    super.initState();
    _navigationFuture = _checkAuthStatus(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MaterialPageRoute>(
      future: _navigationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(context, snapshot.data!);
          });
          return const SizedBox
              .shrink(); // Return empty widget while navigation happens
        }
      },
    );
  }
}

Future<MaterialPageRoute> _checkAuthStatus(BuildContext context) async {
  final authBloc = BlocProvider.of<AuthBloc>(context);
  final state = authBloc.state;

  if (state is AuthAuthenticated) {
    if (state.user.role == 'STUDENT') {
      return StudentLayout.route();
    } else if (state.user.role == 'TEACHER') {
      return TeacherLayout.route();
    }
  } else if (state is AuthUnauthenticated) {
    return LoginScreen.route();
  } else if (state is AuthError) {
    return LoginScreen.route();
  }

  return LoginScreen.route();
}
