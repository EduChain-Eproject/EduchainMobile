import 'package:educhain/core/widgets/loader.dart';
import 'package:educhain/features/auth/screens/login_screen.dart';
import 'package:educhain/features/student/screens/student_home_screen.dart';
import 'package:educhain/features/teacher/screens/teacher_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth/bloc/auth_bloc.dart';
import '../auth/bloc/auth_state.dart';

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
      return StudentHomeScreen.route();
    } else if (state.user.role == 'TEACHER') {
      return TeacherHomeScreen.route();
    }
  } else if (state is AuthUnauthenticated) {
    return LoginScreen.route();
  } else if (state is AuthError) {
    return LoginScreen.route(); // Redirect to LoginScreen on error
  }
  // Default to LoginScreen if state is unknown
  return LoginScreen.route();
}
