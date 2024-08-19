import 'package:educhain/core/types/text_field_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:educhain/core/auth/bloc/auth_bloc.dart';
import 'package:educhain/core/auth/models/register_request.dart';
import 'package:educhain/core/widgets/unauthenticated_widget.dart';
import 'verify_code_screen.dart';

class RegisterScreen extends StatefulWidget {
  static MaterialPageRoute route() => MaterialPageRoute(
        builder: (context) =>
            const UnauthenticatedWidget(child: RegisterScreen()),
      );

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final List<TextFieldModel> _textFields;
  String _accountType = 'STUDENT';

  @override
  void initState() {
    super.initState();
    _textFields = [
      TextFieldModel(label: 'First Name'),
      TextFieldModel(label: 'Last Name'),
      TextFieldModel(label: 'Email'),
      TextFieldModel(label: 'Password', obscureText: true),
      TextFieldModel(label: 'Address'),
      TextFieldModel(label: 'Phone'),
    ];
  }

  void _clearError(TextFieldModel field) {
    setState(() {
      field.errorText = null;
    });
  }

  void _onRegisterPressed() {
    final registerRequest = RegisterRequest(
      email: _textFields[2].controller.text, // Email
      password: _textFields[3].controller.text, // Password
      firstName: _textFields[0].controller.text, // First Name
      lastName: _textFields[1].controller.text, // Last Name
      address: _textFields[4].controller.text, // Address
      phone: _textFields[5].controller.text, // Phone
      accountType: _accountType, // Account Type
    );
    context.read<AuthBloc>().add(RegisterRequested(registerRequest));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthRegisterSuccess) {
            Navigator.push(context, VerifyCodeScreen.route(state.email));
          } else if (state is AuthRegisterError && state.type == 'register') {
            setState(() {
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
              children: [
                ..._textFields.map((field) {
                  return field.generateTextField((_) => _clearError(field));
                }).toList(),
                const SizedBox(height: 20),
                Column(
                  children: [
                    RadioListTile<String>(
                      title: const Text('Student'),
                      value: 'STUDENT',
                      groupValue: _accountType,
                      onChanged: (value) {
                        setState(() {
                          _accountType = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('Teacher'),
                      value: 'TEACHER',
                      groupValue: _accountType,
                      onChanged: (value) {
                        setState(() {
                          _accountType = value!;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _onRegisterPressed,
                  child: const Text('Register'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
