import 'package:educhain/core/auth/bloc/auth_bloc.dart';
import 'package:educhain/core/auth/models/reset_password_request.dart';
import 'package:educhain/core/auth/models/send_code_request.dart';
import 'package:educhain/core/types/text_field_model.dart';
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
                child: const Text("Log in now"),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!_requested) ...[
                  const Text('Please enter your email'),
                  _emailField.generateTextField((_) {
                    setState(() {
                      _emailField.errorText = null;
                    });
                  }),
                  const SizedBox(height: 20),
                  const Text('Please enter your new password'),
                  _passwordField.generateTextField((_) {
                    setState(() {
                      _passwordField.errorText = null;
                    });
                  }),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_validateEmailAndPassword()) {
                        context.read<AuthBloc>().add(SendResetPasswordCode(
                            SendCodeRequest(_emailField.controller.text)));
                      }
                    },
                    child: const Text("Send Code"),
                  ),
                ] else ...[
                  Text(
                      "Hi ${_emailField.controller.text}, enter the code sent to your mailbox!"),
                  _codeField.generateTextField((_) {
                    setState(() {
                      _codeField.errorText = null;
                    });
                  }),
                  const SizedBox(height: 20),
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
                    child: const Text("Reset Password"),
                  ),
                ]
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
