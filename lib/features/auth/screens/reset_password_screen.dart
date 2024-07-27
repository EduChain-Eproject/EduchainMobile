import 'package:educhain/core/widgets/unauthenticated_widget.dart';
import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) =>
            const UnauthenticatedWidget(child: ResetPasswordScreen()),
      );
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
