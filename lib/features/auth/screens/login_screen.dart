import 'package:educhain/core/auth/bloc/auth_bloc.dart';
import 'package:educhain/core/auth/models/login_request.dart';
import 'package:educhain/core/theme/app_pallete.dart';
import 'package:educhain/core/types/text_field_model.dart';
import 'package:educhain/core/widgets/loader.dart';
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
      TextFieldModel(label: 'Email'),
      TextFieldModel(label: 'Password', obscureText: true),
    ];
    if (widget.email != null) {
      _textFields[0].controller.text = widget.email!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            setState(() {
              message = state.errors?['message'] ?? 'An error occurred';
              for (var field in _textFields) {
                field.errorText = state.errors?[field.camelLabel];
              }
            });
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 10),
                ..._textFields.map((field) {
                  return field.generateTextField((_) => _clearError(field));
                }).toList(),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onLoginPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          AppPallete.lightPrimaryColor, // Use primary color
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0), // Larger padding for a bigger button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            8.0), // Rounded corners for modern look
                      ),
                    ),
                    child: state is AuthLoading
                        ? const Loader()
                        : const Text(
                            'Login',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppPallete
                                    .lightBackgroundColor), // Larger text and bold
                          ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () =>
                        Navigator.push(context, RegisterScreen.route()),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: const BorderSide(
                            color:
                                AppPallete.lightPrimaryColor), // Border color
                      ),
                      foregroundColor:
                          Theme.of(context).primaryColor, // Text color
                    ),
                    child: const Text(
                      'Or register',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () =>
                        Navigator.push(context, ResetPasswordScreen.route()),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      foregroundColor:
                          Colors.grey, // Subtle color for less emphasis
                    ),
                    child: const Text(
                      'Forgot password?',
                      style:
                          TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
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
}
