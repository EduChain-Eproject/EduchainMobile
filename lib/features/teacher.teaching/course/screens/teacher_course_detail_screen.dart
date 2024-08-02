import 'package:educhain/core/models/chapter.dart';
import 'package:educhain/core/models/course.dart';
import 'package:educhain/core/widgets/authenticated_widget.dart';
import 'package:educhain/features/teacher.teaching/course/models/create_chapter_request.dart';
import 'package:educhain/features/teacher.teaching/course/models/update_chapter_request.dart';
import 'package:educhain/init_dependency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/teacher_course_bloc.dart';
import '../widgets/chapter_dialog.dart';
import '../widgets/chapter_tile.dart';
import 'teacher_course_form_screen.dart';

class TeacherCourseDetailScreen extends StatefulWidget {
  static Route route(int courseId) => MaterialPageRoute(
        builder: (context) => AuthenticatedWidget(
          child: TeacherCourseDetailScreen(
            courseId: courseId,
          ),
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
  late Course _course;

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
      body: BlocBuilder<TeacherCourseBloc, TeacherCourseState>(
        builder: (context, state) {
          if (state is TeacherCourseDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TeacherCourseDetailError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is TeacherCourseDetailLoaded) {
            _course = state.courseDetail;
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Row(
                  children: [
                    Text(_course.title ?? '',
                        style: Theme.of(context).textTheme.headlineMedium),
                    Text(_course.status?.name ?? '',
                        style: Theme.of(context).textTheme.bodySmall),
                    ElevatedButton(
                        onPressed: _updateCourse, child: const Text('Update')),
                    ElevatedButton(
                        onPressed: _deactivateCourse,
                        child: const Text('Deactivate')),
                  ],
                ),
                const SizedBox(height: 16.0),
                Text(_course.description ?? '',
                    style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 16.0),
                ..._course.chapterDtos?.map((chapter) {
                      return ChapterTile(
                        chapter: chapter,
                        onEditChapter: () => _editChapter(context, chapter),
                        onChapterUpdated: _onChapterUpdated,
                        onDeleteChapter: () => _deleteChapter(chapter),
                      );
                    }).toList() ??
                    [],
                ListTile(
                  title: const Text('Add Chapter'),
                  trailing: const Icon(Icons.add),
                  onTap: () => _addChapter(context),
                ),
              ],
            );
          } else {
            return const Center(child: Text('No course details available'));
          }
        },
      ),
    );
  }

  void _fetchCourseDetail() {
    context.read<TeacherCourseBloc>().add(FetchCourseDetail(widget.courseId));
  }

  void _updateCourse() {
    () => Navigator.push(context, TeacherCourseFormScreen.route(null));
  }

  void _deactivateCourse() {
    // TODO
    // context.read<TeacherCourseBloc>().add(DeactivateCourse(_course.id!));
    setState(() {
      _course = _course.copyWith(status: CourseStatus.DEACTIVATED);
    });
  }

  void _onChapterUpdated(Chapter updatedChapter) {
    setState(() {
      final index = _course.chapterDtos
              ?.indexWhere((chapter) => chapter.id == updatedChapter.id) ??
          -1;
      if (index != -1) {
        _course.chapterDtos?[index] = updatedChapter;
      }
    });
  }

  void _deleteChapter(Chapter chapter) {
    // TODO
    // context.read<TeacherCourseBloc>().add(TeacherDeleteChapter(chapter.id!));
    setState(() {
      _course.chapterDtos?.removeWhere((c) => c.id == chapter.id);
    });
  }

  void _editChapter(BuildContext context, Chapter chapter) {
    showDialog(
      context: context,
      builder: (context) => ChapterDialog(
        initialChapter: chapter,
        course: _course,
        onSave: (updatedChapter) {
          // TODO
          // context.read<TeacherCourseBloc>().add(TeacherUpdateChapter(
          //     updatedChapter.id!,
          //     UpdateChapterRequest(
          //         chapterTitle: updatedChapter.chapterTitle!)));
          _onChapterUpdated(updatedChapter);
        },
      ),
    );
  }

  void _addChapter(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ChapterDialog(
        course: _course,
        onSave: (newChapter) {
          // TODO
          // context.read<TeacherCourseBloc>().add(TeacherCreateChapter(
          //     CreateChapterRequest(
          //         courseId: _course.id!,
          //         chapterTitle: newChapter.chapterTitle!)));
          setState(() {
            if (_course.chapterDtos == null) {
              _course = _course.copyWith(chapterDtos: []);
            }
            _course.chapterDtos!.add(newChapter);
          });
        },
      ),
    );
  }
}
