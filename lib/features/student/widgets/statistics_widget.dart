import 'package:educhain/features/student/models/statistics.dart';
import 'package:flutter/material.dart';

class StatisticsWidget extends StatelessWidget {
  final Statistics statistics;

  StatisticsWidget({required this.statistics});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildStatisticCard(
            label: 'Enrollments',
            value: statistics.numberOfEnrollments ?? 0,
            icon: Icons.people,
            color: Colors.blueAccent,
          ),
          _buildStatisticCard(
            label: 'Certifications',
            value: statistics.certificationsMade ?? 0,
            icon: Icons.person,
            color: Colors.green,
          ),
          _buildStatisticCard(
            label: 'Satisfactions',
            value: statistics.satisfactionRate ?? 0,
            icon: Icons.book,
            color: Colors.purpleAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticCard({
    required String label,
    required int value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 8),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
