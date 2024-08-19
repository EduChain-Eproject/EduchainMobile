import 'package:educhain/core/models/chapter.dart';
import 'package:educhain/core/models/course.dart';
import 'package:educhain/core/theme/app_pallete.dart';
import 'package:educhain/core/widgets/authenticated_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/course/teacher_course_bloc.dart';
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
          if (state is TeacherCourseSaved) {
            setState(() {
              _course = state.course;
            });
          } else if (state is TeacherCourseDetailLoaded) {
            setState(() {
              _course = state.courseDetail;
            });
          } else if (state is TeacherChapterSaved) {
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
          }
        },
        builder: (context, state) {
          return BlocBuilder<TeacherCourseBloc, TeacherCourseState>(
            builder: (context, state) {
              if (state is TeacherCourseDetailLoading ||
                  state is TeacherCourseSaving ||
                  _course == null) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is TeacherCourseDetailError) {
                return Center(
                    child: Text('Error: ${state.errors?['message']}'));
              } else {
                return _buildCourseDetail();
              }
            },
          );
        },
      ),
    );
  }

  void _fetchCourseDetail() {
    context.read<TeacherCourseBloc>().add(FetchCourseDetail(widget.courseId));
  }

  Widget _buildCourseDetail() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildCourseHeader(),
        const SizedBox(height: 16.0),
        _buildCourseDescription(),
        const SizedBox(height: 16.0),
        ..._buildChapterTiles(),
        _buildAddChapterTile(),
      ],
    );
  }

  Widget _buildCourseHeader() {
    return Column(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(_course?.avatarPath ?? ""),
        ),
        Text(
          _course?.title ?? '',
          style: const TextStyle(
              fontSize: 15, color: AppPallete.lightPrimaryColor),
        ),
        Text(
          _course?.status?.name ?? '',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Row(
          children: [
            ElevatedButton(
              onPressed: _updateCourse,
              child: const Text('Update'),
            ),
            const SizedBox(width: 2),
            if (_course?.status == CourseStatus.APPROVED)
              ElevatedButton(
                onPressed: _deactivateCourse,
                child: const Text('Deactivate'),
              ),
          ],
        )
      ],
    );
  }

  Widget _buildCourseDescription() {
    return Column(children: [
      Text(_course?.status?.name ?? ""),
      Text(
        _course?.description ?? '',
        style: const TextStyle(color: AppPallete.lightGreyColor, fontSize: 12),
      ),
    ]);
  }

  List<Widget> _buildChapterTiles() {
    return _course?.chapterDtos?.map((chapter) {
          return ChapterTile(
            chapter: chapter,
            onEditChapter: () => _editChapter(context, chapter),
            onDeleteChapter: () => _deleteChapter(chapter),
          );
        }).toList() ??
        [];
  }

  Widget _buildAddChapterTile() {
    return ListTile(
      title: const Text('Add Chapter'),
      trailing: const Icon(Icons.add),
      onTap: () => _addChapter(context),
    );
  }

  void _updateCourse() {
    Navigator.push(
      context,
      TeacherCourseFormScreen.route(_course),
    );
  }

  void _deactivateCourse() {
    context.read<TeacherCourseBloc>().add(
          TeacherDeactivateCourse(_course?.id ?? 0),
        );
  }

  void _editChapter(BuildContext context, Chapter chapter) {
    showDialog(
      context: context,
      builder: (context) => ChapterDialog(
        initialChapter: chapter,
        course: _course,
      ),
    );
  }

  void _addChapter(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ChapterDialog(
        course: _course,
      ),
    );
  }

  void _deleteChapter(Chapter chapter) {
    context.read<TeacherCourseBloc>().add(
          TeacherDeleteChapter(chapter.id!),
        );
  }
}
