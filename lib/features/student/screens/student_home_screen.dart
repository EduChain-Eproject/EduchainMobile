import 'package:educhain/core/auth/bloc/auth_bloc.dart';
import 'package:educhain/core/auth/bloc/auth_event.dart';
import 'package:educhain/core/widgets/authenticated_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentHomeScreen extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) =>
            const AuthenticatedWidget(child: StudentHomeScreen()),
      );
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
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
