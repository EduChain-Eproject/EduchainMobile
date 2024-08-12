import 'package:educhain/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class ProgressSection extends StatelessWidget {
  ProgressSection();

  @override
  Widget build(BuildContext context) {
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
            value: 0.6,
            backgroundColor: AppPallete.lightGreyColor.withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
          ),
          const SizedBox(height: 10),
          const Text(
            '3/5 courses completed',
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
  }
}
