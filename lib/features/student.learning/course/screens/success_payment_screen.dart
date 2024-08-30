import 'package:educhain/features/student.learning/course/screens/course_detail_screen.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class SuccessPaymentScreen extends StatelessWidget {
  final int courseId;

  const SuccessPaymentScreen({Key? key, required this.courseId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Successful'),
      ),
      body: _buildSuccessContent(context),
    );
  }

  Widget _buildSuccessContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildSuccessIcon(),
          const SizedBox(height: 20),
          _buildSuccessMessage(context),
          const SizedBox(height: 20),
          _buildCourseDetailButton(context),
        ],
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return AnimatedScale(
      scale: 1.0,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      child: const Icon(
        Icons.check_circle,
        color: Colors.green,
        size: 100.0,
      ),
    );
  }

  Widget _buildSuccessMessage(BuildContext context) {
    return Text(
      'Payment was successful!',
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildCourseDetailButton(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.arrow_forward),
      label: const Text('Go to Course Details'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: const TextStyle(fontSize: 18),
      ),
      onPressed: () => _navigateToCourseDetails(context),
    );
  }

  void _navigateToCourseDetails(BuildContext context) {
    Navigator.pushReplacement(
      context,
      CourseDetailScreen.route(courseId),
    );
  }
}
