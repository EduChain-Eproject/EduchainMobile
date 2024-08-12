import 'package:educhain/features/student/models/statistics.dart';
import 'package:flutter/material.dart';

class StatisticsWidget extends StatelessWidget {
  final Statistics statistics;

  StatisticsWidget({required this.statistics});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildStatisticCard(
            label: 'Enrollments',
            value: statistics.numberOfEnrollments ?? 0,
            icon: Icons.people,
          ),
          _buildStatisticCard(
            label: 'Certifications',
            value: statistics.certificationsMade ?? 0,
            icon: Icons.person,
          ),
          _buildStatisticCard(
            label: 'Satisfactions',
            value: statistics.satisfactionRate ?? 0,
            icon: Icons.book,
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticCard({
    required String label,
    required int value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Icon(icon, color: Colors.grey, size: 30),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
