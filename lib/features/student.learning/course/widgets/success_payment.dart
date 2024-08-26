import 'package:educhain/features/student.learning/course/screens/course_detail_screen.dart';
import 'package:educhain/features/student.learning/course/widgets/course_detail_view.dart';
import 'package:flutter/material.dart';

class SuccessPage extends StatelessWidget {
  final int courseId;

  const SuccessPage({Key? key, required this.courseId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Successful'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100.0,
            ),
            const SizedBox(height: 20),
            Text(
              'Payment was successful!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  CourseDetailScreen.route(courseId),
                );
              },
              child: const Text('Go to Course Details'),
            ),
          ],
        ),
      ),
    );
  }
}
