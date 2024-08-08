import 'package:educhain/core/theme/app_pallete.dart';
import 'package:educhain/features/student.learning/course/blocs/course/course_bloc.dart';
import 'package:educhain/features/student.learning/lesson/screens/lesson_detail_screen.dart';
import 'package:educhain/init_dependency.dart';
import 'package:flutter/material.dart';

class BottomButton extends StatefulWidget {
  final bool isInterested;
  final bool isEnrolled;
  final int nextLessonToLearn;
  final int courseId;

  const BottomButton({
    Key? key,
    required this.isInterested,
    required this.isEnrolled,
    required this.nextLessonToLearn,
    required this.courseId,
  }) : super(key: key);

  @override
  _BottomButtonState createState() => _BottomButtonState();
}

class _BottomButtonState extends State<BottomButton> {
  late bool _isInterested;

  @override
  void initState() {
    super.initState();
    _isInterested = widget.isInterested;
  }

  void _toggleInterest() {
    final courseBloc = getIt<CourseBloc>();
    if (_isInterested) {
      courseBloc.add(DeleteFromWishlist(widget.courseId));
    } else {
      courseBloc.add(AddToWishlist(widget.courseId));
    }
    setState(() {
      _isInterested = !_isInterested;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: _toggleInterest,
            child: Container(
              width: 100,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.red,
                  width: _isInterested ? 2 : 1,
                ),
              ),
              child: Icon(
                Icons.star,
                color: _isInterested ? Colors.red : Colors.red.withOpacity(0.5),
                size: 30,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                if (widget.isEnrolled) {
                  Navigator.push(
                    context,
                    LessonDetailScreen.route(widget.nextLessonToLearn),
                  );
                } else {
                  // TODO: handle enroll
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5E6AFF),
                padding: const EdgeInsets.symmetric(vertical: 15),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Text(
                widget.isEnrolled ? 'Start Learning' : 'Enroll Now',
                style: const TextStyle(color: AppPallete.lightBackgroundColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
