import 'package:flutter/material.dart';
import 'package:educhain/core/models/course.dart';
import 'package:educhain/core/theme/app_pallete.dart';
import 'package:educhain/features/student.learning/lesson/screens/lesson_detail_screen.dart';

import '../widgets/bottom_button.dart';
import '../widgets/chapter_section.dart';
import '../widgets/course_header.dart';
import '../widgets/course_info.dart';
import '../widgets/related_course_section.dart';
import '../widgets/participated_users_section.dart';

class CourseDetailView extends StatefulWidget {
  final Course course;
  const CourseDetailView({Key? key, required this.course}) : super(key: key);

  @override
  State<CourseDetailView> createState() => _CourseDetailViewState();
}

class _CourseDetailViewState extends State<CourseDetailView> {
  String _contentToShow = 'description';

  @override
  Widget build(BuildContext context) {
    final isEnrolled = widget.course.currentUserCourse != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course.title ?? 'Course Detail'),
        leading: const BackButton(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CourseHeader(course: widget.course),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CourseInfo(course: widget.course),
                    const SizedBox(height: 20),
                    _buildContentSwitcher(),
                    if (_contentToShow == 'curriculum')
                      ChaptersSection(
                        chapters: widget.course.chapterDtos ?? [],
                        isEnrolled: isEnrolled,
                        onLessonTap: (lessonId) {
                          if (isEnrolled) {
                            Navigator.push(
                              context,
                              LessonDetailScreen.route(lessonId),
                            );
                          } else {
                            _showEnrollmentPrompt(context);
                          }
                        },
                      ),
                    if (_contentToShow == 'description') ...[
                      Text(widget.course.description ?? ""),
                      ParticipatedUsersSection(
                        userCourses: widget.course.participatedUserDtos ?? [],
                      ),
                      RelatedCoursesSection(
                        relatedCourses: widget.course.relatedCourseDtos ?? [],
                      ),
                    ],
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
          BottomButton(
              isInterested: widget.course.currentUserInterested ?? false,
              isEnrolled: isEnrolled,
              nextLessonToLearn: widget.course.lessonIdTolearn ?? 0,
              courseId: widget.course.id ?? 0,
              showEnrollmentPrompt: () => _showEnrollmentPrompt(context)),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Row _buildContentSwitcher() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _contentToShow = 'description';
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _contentToShow == 'description'
                  ? AppPallete.lightAccentColor
                  : AppPallete.lightBackgroundColor,
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Text(
                'Description',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _contentToShow = 'curriculum';
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _contentToShow == 'curriculum'
                  ? AppPallete.lightAccentColor
                  : AppPallete.lightBackgroundColor,
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Text(
                'Curriculum',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showEnrollmentPrompt(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Enrollment Required',
          style: TextStyle(color: AppPallete.lightErrorColor),
        ),
        content: const Text(
            'You need to enroll in this course to view the lesson details.'),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: handle enrollment
              // context.read<CourseBloc>().add(EnrollInCourse(widget.course.courseId));
              Navigator.of(context).pop();
            },
            child: const Text(
              'Enroll',
              style: TextStyle(color: AppPallete.accentColor),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppPallete.warningColor),
            ),
          ),
        ],
      ),
    );
  }
}
