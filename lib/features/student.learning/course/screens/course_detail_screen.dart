import 'package:educhain/features/student.learning/lesson/screens/lesson_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:educhain/core/widgets/authenticated_widget.dart';
import 'package:educhain/init_dependency.dart';
import '../bloc/course_bloc.dart';
import '../widgets/chapter_section.dart';
import '../widgets/course_info.dart';
import '../widgets/related_course_section.dart';

class CourseDetailScreen extends StatelessWidget {
  static Route route(int courseId) => MaterialPageRoute(
        builder: (context) => AuthenticatedWidget(
          child: CourseDetailScreen(courseId: courseId),
        ),
      );

  final int courseId;

  const CourseDetailScreen({Key? key, required this.courseId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CourseBloc>(),
      child: CourseDetailView(courseId: courseId),
    );
  }
}

class CourseDetailView extends StatefulWidget {
  final int courseId;

  const CourseDetailView({Key? key, required this.courseId}) : super(key: key);

  @override
  _CourseDetailViewState createState() => _CourseDetailViewState();
}

class _CourseDetailViewState extends State<CourseDetailView> {
  @override
  void initState() {
    super.initState();
    context.read<CourseBloc>().add(FetchCourseDetail(widget.courseId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseBloc, CourseState>(
      builder: (context, state) {
        if (state is CourseDetailLoading) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Course Detail'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (state is CourseDetailLoaded) {
          final course = state.courseDetail;
          final isEnrolled = course.currentUserCourse != null;

          return Scaffold(
            appBar: AppBar(
              title: Text(course.title ?? 'Course Detail'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  CourseInfo(course: course),
                  const SizedBox(height: 16.0),
                  ChaptersSection(
                    chapters: course.chapterDtos ?? [],
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
                  const SizedBox(height: 16.0),
                  RelatedCoursesSection(
                    relatedCourses: course.relatedCourseDtos ?? [],
                  ),
                ],
              ),
            ),
          );
        } else if (state is CourseDetailError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Course Detail')),
            body: Center(child: Text('Error: ${state.message}')),
          );
        } else {
          return Scaffold(
            appBar: AppBar(title: const Text('Course Detail')),
            body: const Center(child: Text('Unknown state')),
          );
        }
      },
    );
  }

  void _showEnrollmentPrompt(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enrollment Required'),
        content: const Text(
            'You need to enroll in this course to view the lesson details.'),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: Navigate to the enrollment page or handle enrollment
              Navigator.of(context).pop();
            },
            child: const Text('Enroll'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
