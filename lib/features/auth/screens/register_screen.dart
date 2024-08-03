import 'package:educhain/core/types/text_field_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:educhain/core/auth/bloc/auth_bloc.dart';
import 'package:educhain/core/auth/models/register_request.dart';
import 'package:educhain/core/widgets/unauthenticated_widget.dart';
import '../../../core/widgets/validated_text_field.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) =>
            const UnauthenticatedWidget(child: RegisterScreen()),
      );
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final List<TextFieldModel> _textFields = [
    'First Name',
    'Last Name',
    'Email',
    'Password',
    'Address',
    'Phone',
  ]
      .map((label) => label == 'Password'
          ? TextFieldModel(label: label, obscureText: true)
          : TextFieldModel(label: label))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthRegisterSuccess) {
            Navigator.push(context,
                LoginScreen.route()); // Navigate back to login or another page
          } else if (state is AuthError) {
            setState(() {
              for (var element in _textFields) {
                element.errorText = state.errors?[element.camelLabel];
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
              children: _textFields.map<Widget>((e) {
                return ValidatedTextField(
                  controller: e.controller,
                  label: e.label,
                  errorText: e.errorText,
                  obscureText: e.obscureText,
                  keyboardType: e.keyboardType,
                  onChanged: (value) {
                    setState(() {
                      e.errorText = null;
                    });
                  },
                );
              }).toList()
                ..add(const SizedBox(
                  height: 20,
                ))
                ..add(
                  ElevatedButton(
                    onPressed: () {
                      final registerRequest = RegisterRequest(
                        email: _textFields[2].controller.text, // Email
                        password: _textFields[3].controller.text, // Password
                        firstName: _textFields[0].controller.text, // First Name
                        lastName: _textFields[1].controller.text, // Last Name
                        address: _textFields[4].controller.text, // Address
                        phone: _textFields[5].controller.text, // Phone
                      );
                      context
                          .read<AuthBloc>()
                          .add(RegisterRequested(registerRequest));
                    },
                    child: const Text('Register'),
                  ),
                ),
            ),
          );
        },
      ),
    );
  }
}
