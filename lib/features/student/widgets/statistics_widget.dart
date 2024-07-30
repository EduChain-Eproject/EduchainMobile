import 'package:educhain/features/student/models/statistics.dart';
import 'package:flutter/material.dart';

class StatisticsWidget extends StatelessWidget {
  final Statistics statistics;

  const StatisticsWidget({super.key, required this.statistics});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (statistics.numberOfEnrollments != null)
          Text('Enrollments: ${statistics.numberOfEnrollments}'),
        if (statistics.certificationsMade != null)
          Text('Certifications: ${statistics.certificationsMade}'),
        if (statistics.satisfactionRate != null)
          Text('Satisfaction Rate: ${statistics.satisfactionRate}%'),
        if (statistics.bestFeedbacks != null &&
            statistics.bestFeedbacks!.isNotEmpty)
          ...statistics.bestFeedbacks!.map((feedback) {
            return Text(feedback.message ?? "No feedback message");
          }).toList(),
      ],
    );
  }
}
