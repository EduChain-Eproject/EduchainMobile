import 'package:educhain/core/auth/bloc/auth_bloc.dart';
import 'package:educhain/core/models/user.dart';
import 'package:educhain/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProgressSection extends StatelessWidget {
  ProgressSection();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AuthBloc, AuthState, AuthAuthenticated>(
      selector: (state) {
        return state as AuthAuthenticated;
      },
      builder: (context, state) {
        LearningProgress userLearning = state.user.getLearningProgress();
        return Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'My progress',
                    style: TextStyle(
                      color: AppPallete.lightGreyColor,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'On-going courses',
                    style: TextStyle(
                      color: AppPallete.lightGreyColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: userLearning.progress,
                backgroundColor: AppPallete.lightGreyColor.withOpacity(0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
              ),
              const SizedBox(height: 10),
              Text(
                '${userLearning.completed}/${userLearning.total} courses completed',
                // '${progress.completed}/${progress.total} courses completed',
                style: TextStyle(
                  color: AppPallete.lightGreyColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
