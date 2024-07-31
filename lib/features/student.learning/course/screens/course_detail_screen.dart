import 'package:educhain/features/student.learning/lesson/screens/lesson_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:educhain/core/widgets/authenticated_widget.dart';
import 'package:educhain/init_dependency.dart';
import '../bloc/course_bloc.dart';

class CourseDetailScreen extends StatelessWidget {
  static Route route(int courseId) => MaterialPageRoute(
      builder: (context) =>
          AuthenticatedWidget(child: CourseDetailScreen(courseId: courseId)));

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
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (state is CourseDetailLoaded) {
          final course = state.courseDetail;

          return Scaffold(
            appBar: AppBar(
              title: Text(course.title ?? 'Course Detail'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Text(
                    course.title ?? '',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    course.description ?? '',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16.0),
                  if (course.price != null)
                    Text(
                      'Price: \$${course.price}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  const SizedBox(height: 16.0),
                  if (course.numberOfEnrolledStudents != null)
                    Text(
                      'Enrolled Students: ${course.numberOfEnrolledStudents}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  const SizedBox(height: 16.0),
                  if (course.teacherDto != null) ...[
                    Text(
                      'Teacher: ${course.teacherDto!.firstName ?? 'Unknown'}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      'Email: ${course.teacherDto!.email ?? 'Unknown'}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 16.0),
                  ],
                  if (course.chapterDtos != null &&
                      course.chapterDtos!.isNotEmpty) ...[
                    Text('Chapters:',
                        style: Theme.of(context).textTheme.titleSmall),
                    ...course.chapterDtos!.map((chapter) => ExpansionTile(
                          title: Text(chapter.chapterTitle ?? 'Untitled'),
                          subtitle: Text(
                              'Lessons: ${chapter.lessonDtos?.length ?? 0}'),
                          children: chapter.lessonDtos
                                  ?.map((lesson) => ListTile(
                                        title: Text(lesson.lessonTitle ??
                                            'Untitled Lesson'),
                                        subtitle: Text(
                                            'Description: ${lesson.description ?? 'No Description'}'),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            LessonDetailScreen.route(
                                                lesson.id!),
                                          );
                                        },
                                      ))
                                  .toList() ??
                              [],
                        )),
                    const SizedBox(height: 16.0),
                  ],
                  if (course.relatedCourseDtos != null &&
                      course.relatedCourseDtos!.isNotEmpty) ...[
                    Text('Related Courses:',
                        style: Theme.of(context).textTheme.bodySmall),
                    ...course.relatedCourseDtos!
                        .map((relatedCourse) => ListTile(
                              title: Text(relatedCourse.title ?? 'No title'),
                              onTap: () {
                                // Navigate to related course detail page
                              },
                            )),
                    const SizedBox(height: 16.0),
                  ],
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
}
