import 'package:educhain/core/models/chapter.dart';
import 'package:educhain/core/models/course.dart';
import 'package:educhain/core/widgets/authenticated_widget.dart';
import 'package:educhain/init_dependency.dart';
import 'package:flutter/material.dart';

import '../bloc/teacher_course_bloc.dart';
import '../models/create_course_request.dart';
import '../models/update_course_request.dart';
import '../widgets/chapter_dialog.dart';
import '../widgets/chapter_tile.dart';

class TeacherCourseFormScreen extends StatefulWidget {
  static Route route(Course? course) => MaterialPageRoute(
        builder: (context) => AuthenticatedWidget(
          child: TeacherCourseFormScreen(
            course: course,
          ),
        ),
      );

  final Course? course;

  const TeacherCourseFormScreen({Key? key, this.course}) : super(key: key);

  @override
  _CourseFormScreenState createState() => _CourseFormScreenState();
}

class _CourseFormScreenState extends State<TeacherCourseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late List<Chapter> _chapters;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.course?.title);
    _descriptionController =
        TextEditingController(text: widget.course?.description);
    _priceController =
        TextEditingController(text: widget.course?.price?.toString());
    _chapters = widget.course?.chapterDtos ?? [];
  }

  void _updateChapter(Chapter updatedChapter) {
    setState(() {
      final index =
          _chapters.indexWhere((chapter) => chapter.id == updatedChapter.id);
      if (index != -1) {
        _chapters[index] = updatedChapter;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course == null ? 'Create Course' : 'Edit Course'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Course Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration:
                    const InputDecoration(labelText: 'Course Description'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null ||
                      double.parse(value) <= 0) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _selectAvatar,
                child: const Text('Select Avatar'),
              ),
              const SizedBox(height: 16.0),
              ..._chapters.map((chapter) {
                return ChapterTile(
                  chapter: chapter,
                  onEditChapter: () => _editChapter(context, chapter),
                  onChapterUpdated: _updateChapter,
                );
              }).toList(),
              ListTile(
                title: const Text('Add Chapter'),
                trailing: const Icon(Icons.add),
                onTap: () => _addChapter(context),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _saveCourse,
                child: const Text('Save Course'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectAvatar() {
    // Implement avatar selection logic here
  }

  void _addChapter(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ChapterDialog(
        onSave: (newChapter) {
          setState(() {
            _chapters.add(newChapter);
          });
        },
      ),
    );
  }

  void _editChapter(BuildContext context, Chapter chapter) {
    showDialog(
      context: context,
      builder: (context) => ChapterDialog(
        initialChapter: chapter,
        course: widget.course,
        onSave: (updatedChapter) {
          _updateChapter(updatedChapter);
        },
      ),
    );
  }

  void _saveCourse() {
    if (_formKey.currentState?.validate() ?? false) {
      final courseId = widget.course?.id;
      final courseRequest = courseId == null
          ? CreateCourseRequest(
              categoryIds: [], // Populate this based on your form data
              title: _titleController.text,
              description: _descriptionController.text,
              price: double.parse(_priceController.text),
            )
          : UpdateCourseRequest(
              title: _titleController.text,
              description: _descriptionController.text,
              price: double.parse(_priceController.text),
            );

      if (courseId == null) {
        getIt<TeacherCourseBloc>()
            .add(TeacherCreateCourse(courseRequest as CreateCourseRequest));
      } else {
        getIt<TeacherCourseBloc>().add(TeacherUpdateCourse(
            courseId, courseRequest as UpdateCourseRequest));
      }

      Navigator.pop(context);
    }
  }
}
