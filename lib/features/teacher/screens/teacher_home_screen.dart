import 'package:educhain/core/auth/blocs/auth_bloc.dart';
import 'package:educhain/core/auth/blocs/auth_event.dart';
import 'package:educhain/core/widgets/authenticated_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherHomeScreen extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) =>
            const AuthenticatedWidget(child: TeacherHomeScreen()),
      );
  const TeacherHomeScreen({super.key});

  @override
  State<TeacherHomeScreen> createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teacher'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(LogOutRequested());
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Welcome to the home page!'),
      ),
    );
  }
}
