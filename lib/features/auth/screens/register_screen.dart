import 'package:educhain/core/theme/app_pallete.dart';
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
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ..._textFields.map((field) {
                  return field.generateTextField((_) => _clearError(field));
                }).toList(),
                Row(
                  children: [
                    Flexible(
                      child: RadioListTile<String>(
                        title: const Text('Student'),
                        value: 'STUDENT',
                        groupValue: _accountType,
                        onChanged: (value) {
                          setState(() {
                            _accountType = value!;
                          });
                        },
                      ),
                    ),
                    Flexible(
                      child: RadioListTile<String>(
                        title: const Text('Teacher'),
                        value: 'TEACHER',
                        groupValue: _accountType,
                        onChanged: (value) {
                          setState(() {
                            _accountType = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onRegisterPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppPallete.lightPrimaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppPallete.lightBackgroundColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          );
        },
      ),
    );
  }
}
