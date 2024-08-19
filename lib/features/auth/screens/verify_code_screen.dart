import 'package:educhain/core/auth/bloc/auth_bloc.dart';
import 'package:educhain/core/auth/models/verify_register_code_request.dart';
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
          } else if (state is AuthError) {
            setState(() {
              _errorText = state.errors?['code'];
            });
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Welcome, ${widget.email}",
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _codeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Verification Code',
                    errorText: _errorText,
                  ),
                  onChanged: (_) {
                    setState(() {
                      _errorText = null;
                    });
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_codeController.text.isNotEmpty) {
                      context.read<AuthBloc>().add(VerifyRegisterCode(
                          VerifyRegisterCodeRequest(
                              widget.email, int.parse(_codeController.text))));
                    } else {
                      setState(() {
                        _errorText = "Please enter the verification code.";
                      });
                    }
                  },
                  child: const Text('Verify'),
                ),
                if (state is AuthLoading)
                  const Center(child: CircularProgressIndicator()),
              ],
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
