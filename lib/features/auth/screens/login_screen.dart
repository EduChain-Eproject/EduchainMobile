import 'package:educhain/core/auth/bloc/auth_bloc.dart';
import 'package:educhain/core/auth/models/login_request.dart';
import 'package:educhain/core/theme/app_pallete.dart';
import 'package:educhain/core/types/text_field_model.dart';
import 'package:educhain/core/widgets/unauthenticated_widget.dart';
import 'package:educhain/features/auth/screens/register_screen.dart';
import 'package:educhain/features/auth/screens/reset_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  static MaterialPageRoute route({String? email}) => MaterialPageRoute(
        builder: (context) =>
            UnauthenticatedWidget(child: LoginScreen(email: email)),
      );

  final String? email;

  const LoginScreen({super.key, this.email});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final List<TextFieldModel> _textFields;
  String message = '';

  @override
  void initState() {
    super.initState();
    _textFields = [
      TextFieldModel(
        label: 'Email',
      ),
      TextFieldModel(label: 'Password', obscureText: true),
    ];
    if (widget.email != null) {
      _textFields[0].controller.text = widget.email!;
    }
  }

  void _clearError(TextFieldModel field) {
    setState(() {
      field.errorText = null;
    });
  }

  void _onLoginPressed() {
    final loginRequest = LoginRequest(
      email: _textFields[0].controller.text,
      password: _textFields[1].controller.text,
    );
    context.read<AuthBloc>().add(LoginRequested(loginRequest));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            setState(() {
              // message = state.errors?['message'] ?? 'An error occurred';
              for (var field in _textFields) {
                field.errorText = state.errors?[field.camelLabel];
              }
            });
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (message.isNotEmpty)
                  Text(
                    message,
                    style: const TextStyle(color: AppPallete.lightErrorColor),
                  ),
                ..._textFields.map((field) {
                  return field.generateTextField((_) => _clearError(field));
                }).toList(),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _onLoginPressed,
                  child: const Text('Login'),
                ),
                ElevatedButton(
                  onPressed: () =>
                      Navigator.push(context, RegisterScreen.route()),
                  child: const Text("or register"),
                ),
                ElevatedButton(
                  onPressed: () =>
                      Navigator.push(context, ResetPasswordScreen.route()),
                  child: const Text("Forgot password?"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
