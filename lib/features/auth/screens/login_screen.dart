import 'package:educhain/core/auth/bloc/auth_bloc.dart';
import 'package:educhain/core/auth/models/login_request.dart';
import 'package:educhain/core/theme/app_pallete.dart';
import 'package:educhain/core/types/text_field_model.dart';
import 'package:educhain/core/widgets/unauthenticated_widget.dart';
import 'package:educhain/features/auth/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/widgets/validated_text_field.dart';

class LoginScreen extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const UnauthenticatedWidget(child: LoginScreen()),
      );
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final List<TextFieldModel> _textFields = [
    'Email',
    'Password',
  ]
      .map((label) => label == 'Password'
          ? TextFieldModel(label: label, obscureText: true)
          : TextFieldModel(label: label))
      .toList();

  String message = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            setState(() {
              message = state.errors?['message'];
              for (var field in _textFields) {
                field.errorText = state.errors?[field.camelLabel];
              }
            });
          } else if (state is AuthLoginSuccess) {
            // Handle successful login if needed
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              const SizedBox(height: 150),
              Text(
                message,
                style: const TextStyle(color: AppPallete.lightErrorColor),
              ),
              ..._textFields.map<Widget>((field) {
                return ValidatedTextField(
                  controller: field.controller,
                  label: field.label,
                  errorText: field.errorText,
                  obscureText: field.obscureText,
                  keyboardType: field.keyboardType,
                  onChanged: (value) {
                    setState(() {
                      field.errorText = null;
                    });
                  },
                );
              }).toList()
                ..add(const SizedBox(height: 20))
                ..add(
                  ElevatedButton(
                    onPressed: () {
                      final loginRequest = LoginRequest(
                        email: _textFields[0].controller.text, // Email
                        password: _textFields[1].controller.text, // Password
                      );
                      context
                          .read<AuthBloc>()
                          .add(LoginRequested(loginRequest));
                    },
                    child: const Text('Login'),
                  ),
                )
                ..add(
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.push(context, RegisterScreen.route()),
                    child: const Text("or register"),
                  ),
                ),
            ]),
          );
        },
      ),
    );
  }
}
