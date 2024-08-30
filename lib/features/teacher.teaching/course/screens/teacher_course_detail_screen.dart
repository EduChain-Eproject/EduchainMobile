import 'package:educhain/core/models/chapter.dart';
import 'package:educhain/core/models/course.dart';
import 'package:educhain/core/theme/app_pallete.dart';
import 'package:educhain/core/widgets/authenticated_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/course/teacher_course_bloc.dart';
import '../widgets/chapter_dialog.dart';
import '../widgets/chapter_list.dart';
import '../widgets/course_header.dart';
import 'teacher_course_form_screen.dart';

class TeacherCourseDetailScreen extends StatefulWidget {
  static Route route(int courseId) => MaterialPageRoute(
        builder: (context) => AuthenticatedWidget(
          child: TeacherCourseDetailScreen(courseId: courseId),
        ),
      );

  final int courseId;

  const TeacherCourseDetailScreen({Key? key, required this.courseId})
      : super(key: key);

  @override
  _TeacherCourseDetailScreenState createState() =>
      _TeacherCourseDetailScreenState();
}

class _TeacherCourseDetailScreenState extends State<TeacherCourseDetailScreen> {
  Course? _course;

  @override
  void initState() {
    super.initState();
    _fetchCourseDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Detail'),
      ),
      body: BlocConsumer<TeacherCourseBloc, TeacherCourseState>(
        listener: (context, state) {
          if (state is TeacherCourseDetailLoaded) {
            _course = state.courseDetail;
          } else if (state is TeacherCourseSaved) {
            _course = state.course;
          } else if (state is TeacherChapterSaved) {
            _updateChapterState(state);
          } else if (state is TeacherCourseDetailError) {
            _showErrorDialog(
                context, state.errors?['message'] ?? 'An error occurred');
          }
        },
        builder: (context, state) {
          if (state is TeacherCourseDetailLoading ||
              state is TeacherCourseSaving ||
              _course == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return _buildCourseDetail();
          }
        },
      ),
    );
  }

  void _fetchCourseDetail() {
    context.read<TeacherCourseBloc>().add(FetchCourseDetail(widget.courseId));
  }

  void _updateChapterState(TeacherChapterSaved state) {
    setState(() {
      switch (state.status) {
        case 'created':
          _course = _course?.copyWith(
            chapterDtos: [...?_course?.chapterDtos, state.chapter],
          );
          break;
        case 'updated':
          _course = _course?.copyWith(
            chapterDtos: _course?.chapterDtos?.map((c) {
              return c.id == state.chapter.id ? state.chapter : c;
            }).toList(),
          );
          break;
        case 'deleted':
          _course = _course?.copyWith(
            chapterDtos: _course?.chapterDtos?.where((c) {
              return c.id != state.chapter.id;
            }).toList(),
          );
          break;
      }
    });
  }

  Widget _buildCourseDetail() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          CourseHeader(
            course: _course,
            onUpdate: _updateCourse,
            onDeactivate: _showDeactivateConfirmation,
          ),
          const Divider(height: 40),
          Text(
            _course?.description ?? '',
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 16.0),
          ChapterList(
            showCreateButton: true,
            chapters: _course?.chapterDtos ?? [],
            onEditChapter: _editChapter,
            onDeleteChapter: _deleteChapter,
            onAddChapter: _addChapter,
          ),
        ],
      ),
    );
  }

  void _updateCourse() {
    Navigator.push(
      context,
      TeacherCourseFormScreen.route(_course),
    );
  }

  void _showDeactivateConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Confirm Deactivation',
            style: TextStyle(color: AppPallete.lightErrorColor),
          ),
          content:
              const Text('Are you sure you want to deactivate this course?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deactivateCourse();
              },
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _deactivateCourse() {
    context
        .read<TeacherCourseBloc>()
        .add(TeacherDeactivateCourse(_course?.id ?? 0));
  }

  void _editChapter(Chapter chapter) {
    showDialog(
      context: context,
      builder: (context) => ChapterDialog(
        initialChapter: chapter,
        course: _course,
      ),
    );
  }

  void _addChapter() {
    showDialog(
      context: context,
      builder: (context) => ChapterDialog(
        course: _course,
      ),
    );
  }

  void _deleteChapter(Chapter chapter) {
    context.read<TeacherCourseBloc>().add(TeacherDeleteChapter(chapter.id!));
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
