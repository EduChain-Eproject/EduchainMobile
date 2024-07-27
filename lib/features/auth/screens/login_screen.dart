import 'package:educhain/core/auth/blocs/auth_bloc.dart';
import 'package:educhain/core/auth/blocs/auth_event.dart';
import 'package:educhain/core/auth/blocs/auth_state.dart';
import 'package:educhain/core/auth/models/login_request.dart';
import 'package:educhain/core/widgets/unauthenticated_widget.dart';
import 'package:educhain/features/auth/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const UnauthenticatedWidget(child: LoginScreen()),
      );
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoginSuccess) {
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errors!['message'])),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 50),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final loginRequest = LoginRequest(
                      email: _emailController.text,
                      password: _passwordController.text,
                    );
                    context.read<AuthBloc>().add(LoginRequested(loginRequest));
                  },
                  child: Text('Login'),
                ),
                ElevatedButton(
                    onPressed: () =>
                        Navigator.push(context, RegisterScreen.route()),
                    child: Text("or register"))
              ],
            ),
          );
        },
      ),
    );
  }
}
