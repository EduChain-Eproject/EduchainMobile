import 'package:educhain/core/auth/bloc/auth_bloc.dart';
import 'package:educhain/core/auth/models/verify_register_code_request.dart';
import 'package:educhain/core/theme/app_pallete.dart';
import 'package:educhain/core/widgets/loader.dart';
import 'package:educhain/core/widgets/unauthenticated_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_screen.dart';

class VerifyCodeScreen extends StatefulWidget {
  static Route route(String email) => MaterialPageRoute(
        builder: (context) =>
            UnauthenticatedWidget(child: VerifyCodeScreen(email: email)),
      );

  final String email;

  const VerifyCodeScreen({super.key, required this.email});

  @override
  _VerifyCodeScreenState createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final TextEditingController _codeController = TextEditingController();
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Code')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthVerifyCodeSuccess) {
            Navigator.push(context, LoginScreen.route(email: widget.email));
          } else if (state is AuthRegisterError) {
            setState(() {
              _errorText = state.errors?['message'];
            });
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Welcome, ${widget.email}",
                      style: const TextStyle(
                          color: AppPallete.lightAccentColor, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Please enter the verification code sent to your email address.",
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      controller: _codeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Verification Code',
                        errorText: _errorText,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (_) {
                        setState(() {
                          _errorText = null;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: (state is! AuthLoading &&
                              _codeController.text.isNotEmpty)
                          ? () {
                              if (_codeController.text.isNotEmpty) {
                                context.read<AuthBloc>().add(
                                      VerifyRegisterCode(
                                        VerifyRegisterCodeRequest(
                                          widget.email,
                                          int.parse(_codeController.text),
                                        ),
                                      ),
                                    );
                              } else {
                                setState(() {
                                  _errorText =
                                      "Please enter the verification code.";
                                });
                              }
                            }
                          : null, // Disable button when loading or input is empty
                      child: state is AuthLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.0,
                              ),
                            )
                          : state is AuthLoading
                              ? const Loader()
                              : const Text('Verify'),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }
}
