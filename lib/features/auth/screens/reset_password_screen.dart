import 'package:educhain/core/auth/bloc/auth_bloc.dart';
import 'package:educhain/core/auth/models/reset_password_request.dart';
import 'package:educhain/core/auth/models/send_code_request.dart';
import 'package:educhain/core/theme/app_pallete.dart';
import 'package:educhain/core/types/text_field_model.dart';
import 'package:educhain/core/widgets/loader.dart';
import 'package:educhain/core/widgets/unauthenticated_widget.dart';
import 'package:educhain/features/auth/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordScreen extends StatefulWidget {
  static MaterialPageRoute route() => MaterialPageRoute(
        builder: (context) =>
            const UnauthenticatedWidget(child: ResetPasswordScreen()),
      );

  const ResetPasswordScreen({super.key});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextFieldModel _emailField = TextFieldModel(label: 'Email');
  final TextFieldModel _passwordField =
      TextFieldModel(label: 'Password', obscureText: true);
  final TextFieldModel _codeField = TextFieldModel(label: 'Code');
  String? errorMessage;
  bool _requested = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSendResetCodeSuccess) {
            setState(() {
              _requested = true;
            });
          } else if (state is AuthResetPasswordError) {
            setState(() {
              if (state.type == 'reset') {
                errorMessage = state.errors?['message'];
                _emailField.errorText = state.errors?['email'];
                _passwordField.errorText = state.errors?['password'];
                _codeField.errorText = state.errors?['code'];
              }
            });
          }
        },
        builder: (context, state) {
          if (state is AuthResetSuccess) {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      LoginScreen.route(email: _emailField.controller.text));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppPallete.lightPrimaryColor,
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 32.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  "Log in now",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Reset your password',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                if (!_requested) ...[
                  const Text(
                    'Enter your email address and your new password then we will send you a code to reset your password.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 30),
                  _emailField.generateTextField((_) {
                    setState(() {
                      _emailField.errorText = null;
                    });
                  }),
                  const SizedBox(height: 20),
                  _passwordField.generateTextField((_) {
                    setState(() {
                      _passwordField.errorText = null;
                    });
                  }),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      if (_validateEmailAndPassword()) {
                        context.read<AuthBloc>().add(SendResetPasswordCode(
                            SendCodeRequest(_emailField.controller.text)));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppPallete.lightPrimaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: state is AuthLoading
                        ? const Loader()
                        : const Text(
                            "Send Code",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppPallete.lightBackgroundColor),
                          ),
                  ),
                ] else ...[
                  Text(
                    "Hi ${_emailField.controller.text}, enter the code sent to your mailbox!",
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  _codeField.generateTextField((_) {
                    setState(() {
                      _codeField.errorText = null;
                    });
                  }),
                  const SizedBox(height: 20),
                  if (errorMessage != null)
                    Column(
                      children: [
                        Text(
                          errorMessage!,
                          style: const TextStyle(
                              color: AppPallete.lightErrorColor),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ElevatedButton(
                    onPressed: () {
                      if (_validateCode()) {
                        context.read<AuthBloc>().add(ResetPassword(
                            ResetPasswordRequest(
                                _emailField.controller.text,
                                _passwordField.controller.text,
                                int.parse(_codeField.controller.text))));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppPallete.lightPrimaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: state is AuthLoading
                        ? const Loader()
                        : const Text(
                            "Reset Password",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppPallete.lightBackgroundColor),
                          ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  bool _validateEmailAndPassword() {
    setState(() {
      _emailField.errorText =
          _emailField.controller.text.isEmpty ? 'Email is required' : null;
      _passwordField.errorText = _passwordField.controller.text.isEmpty
          ? 'Password is required'
          : null;
    });
    return _emailField.errorText == null && _passwordField.errorText == null;
  }

  bool _validateCode() {
    setState(() {
      _codeField.errorText =
          _codeField.controller.text.isEmpty ? 'Code is required' : null;
    });
    return _codeField.errorText == null;
  }
}
