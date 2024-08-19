import 'dart:io';
import 'package:educhain/core/theme/app_pallete.dart';
import 'package:educhain/core/widgets/layouts/student_layout.dart';
import 'package:educhain/core/widgets/layouts/teacher_layout.dart';
import 'package:educhain/features/teacher.teaching/course/screens/teacher_course_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:educhain/core/models/chapter.dart';
import 'package:educhain/core/models/course.dart';
import 'package:educhain/core/widgets/authenticated_widget.dart';

import '../blocs/course/teacher_course_bloc.dart';
import '../models/create_course_request.dart';
import '../models/update_course_request.dart';
import '../widgets/chapter_dialog.dart';
import '../widgets/chapter_tile.dart';
import '../widgets/category_selector.dart';

class TeacherCourseFormScreen extends StatefulWidget {
  static Route route(Course? course) => MaterialPageRoute(
        builder: (context) => AuthenticatedWidget(
          child: TeacherCourseFormScreen(course: course),
        ),
      );

  final Course? course;

  const TeacherCourseFormScreen({Key? key, this.course}) : super(key: key);

  @override
  _TeacherCourseFormScreenState createState() =>
      _TeacherCourseFormScreenState();
}

class _TeacherCourseFormScreenState extends State<TeacherCourseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late bool isUpdating;

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late List<Chapter> _chapters;
  XFile? _selectedAvatar;
  late List<int> _selectedCategoryIds;

  final Map<String, dynamic> _errors = {};

  @override
  void initState() {
    super.initState();
    isUpdating = widget.course != null ? true : false;

    _titleController = TextEditingController(text: widget.course?.title);
    _descriptionController =
        TextEditingController(text: widget.course?.description);
    _priceController =
        TextEditingController(text: widget.course?.price?.toString());
    _chapters = widget.course?.chapterDtos ?? [];
    _selectedCategoryIds =
        widget.course?.categoryDtos?.map((c) => c.id ?? 0).toList() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeacherCourseBloc, TeacherCourseState>(
      listener: (context, state) {
        if (state is TeacherCourseSaved) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Course saved successfully!')),
          );
          if (isUpdating) {
            Navigator.pushReplacement(
                context, TeacherCourseDetailScreen.route(state.course.id ?? 0));
          } else {
            Navigator.pushReplacement(
                context, TeacherCourseFormScreen.route(state.course));
          }
        } else if (state is TeacherCourseSaveError) {
          _handleErrors(state.errors);
        } else if (state is TeacherChapterSaved) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Chapter saved successfully!')),
          );
          setState(() {
            _chapters.add(state.chapter);
          });
        } else if (state is TeacherChapterSaveError) {
          _handleErrors(state.errors);
        }
      },
      builder: (context, state) {
        if (state is TeacherCoursesLoading ||
            state is TeacherCourseSaving ||
            state is TeacherChapterSaving) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          appBar: AppBar(
            title:
                Text(widget.course == null ? 'Create Course' : 'Edit Course'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration:
                        const InputDecoration(labelText: 'Course Title'),
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
                  if (_selectedAvatar != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Image.file(
                        File(_selectedAvatar!.path),
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  if (_selectedAvatar == null &&
                      widget.course?.avatarPath != null)
                    CircleAvatar(
                      backgroundImage:
                          NetworkImage(widget.course?.avatarPath ?? ""),
                    ),
                  if (_errors['avt'] != null)
                    Text(
                      _errors['avt'],
                      style: const TextStyle(color: AppPallete.lightErrorColor),
                    ),
                  const SizedBox(height: 16.0),
                  CategorySelector(
                    selectedCategoryIds: _selectedCategoryIds,
                    onCategorySelected: (ids) {
                      setState(() {
                        _selectedCategoryIds = ids;
                        if (ids.length != 0) {
                          _errors['categories'] = null;
                        }
                      });
                    },
                  ),
                  if (_errors['categories'] != null)
                    Text(
                      _errors['categories'],
                      style: const TextStyle(color: AppPallete.lightErrorColor),
                    ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _saveCourse,
                    child: const Text('Save Course'),
                  ),
                  const SizedBox(height: 16.0),
                  ..._chapters.map((chapter) {
                    return ChapterTile(
                      chapter: chapter,
                      onEditChapter: () => _editChapter(context, chapter),
                      onDeleteChapter: () => _deleteChapter(chapter),
                    );
                  }).toList(),
                  if (widget.course?.id != null && widget.course?.id != 0)
                    ListTile(
                      title: const Text('Add Chapter'),
                      trailing: const Icon(Icons.add),
                      tileColor:
                          widget.course?.id == null ? Colors.grey[300] : null,
                      onTap: () => _addChapter(context),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectAvatar() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedAvatar = pickedFile;
        _errors['avt'] = null;
      });
    }
  }

  void _deleteChapter(Chapter chapter) {
    context.read<TeacherCourseBloc>().add(TeacherDeleteChapter(chapter.id!));
    setState(() {
      _chapters.removeWhere((c) => c.id == chapter.id);
    });
  }

  void _addChapter(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const ChapterDialog(),
    );
  }

  void _editChapter(BuildContext context, Chapter chapter) {
    showDialog(
      context: context,
      builder: (context) => ChapterDialog(
        initialChapter: chapter,
        course: widget.course,
      ),
    );
  }

  void _saveCourse() {
    if (_formKey.currentState?.validate() ?? false) {
      if (!isUpdating && _selectedAvatar == null) {
        setState(() {
          _errors['avt'] = 'Avatar file is required!';
        });
        return;
      }
      if (_selectedCategoryIds.isEmpty) {
        setState(() {
          _errors['categories'] =
              'Please choose at least one category for the course!';
        });
        return;
      }
      final courseId = widget.course?.id;
      final courseRequest = courseId == null
          ? CreateCourseRequest(
              categoryIds: _selectedCategoryIds,
              title: _titleController.text,
              description: _descriptionController.text,
              price: double.parse(_priceController.text),
              avatarCourse: _selectedAvatar,
            )
          : UpdateCourseRequest(
              categoryIds: _selectedCategoryIds,
              title: _titleController.text,
              description: _descriptionController.text,
              price: double.parse(_priceController.text),
            );

      if (courseId == null) {
        context
            .read<TeacherCourseBloc>()
            .add(TeacherCreateCourse(courseRequest as CreateCourseRequest));
      } else {
        context.read<TeacherCourseBloc>().add(TeacherUpdateCourse(
            courseId, courseRequest as UpdateCourseRequest));
      }
    }
  }

  void _handleErrors(Map<String, dynamic>? errors) {
    if (errors != null) {
      errors.forEach((field, error) {
        if (field != 'message') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$field: $error')),
          );
        }
      });
      final message = errors['message'];
      if (message != null && errors.length == 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    }
  }
}
