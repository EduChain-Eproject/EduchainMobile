import 'package:educhain/core/theme/app_pallete.dart';
import 'package:educhain/core/types/text_field_model.dart';
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
import '../widgets/avatar_selector.dart';
import '../widgets/chapter_dialog.dart';
import '../widgets/chapter_list.dart';
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

  late TextFieldModel _titleField;
  late TextFieldModel _descriptionField;
  late TextFieldModel _priceField;
  late List<Chapter> _chapters;
  XFile? _selectedAvatar;
  late List<int> _selectedCategoryIds;

  final Map<String, dynamic> _errors = {};

  @override
  void initState() {
    super.initState();
    isUpdating = widget.course != null;

    _titleField =
        TextFieldModel(label: 'Title', initText: widget.course?.title);

    _descriptionField = TextFieldModel(
        label: 'Description', initText: widget.course?.description);

    _priceField = TextFieldModel(
        label: 'Price',
        keyboardType: TextInputType.number,
        initText: widget.course?.price?.toString());

    _chapters = widget.course?.chapterDtos ?? [];
    _selectedCategoryIds =
        widget.course?.categoryDtos?.map((c) => c.id ?? 0).toList() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeacherCourseBloc, TeacherCourseState>(
      listener: (context, state) {
        _handleStateChanges(context, state);
      },
      builder: (context, state) {
        if (state is TeacherCoursesLoading ||
            state is TeacherCourseSaving ||
            state is TeacherChapterSaving) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(isUpdating ? 'Edit Course' : 'Create Course'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  _buildCourseFormFields(),
                  AvatarSelector(
                    selectedAvatar: _selectedAvatar,
                    onSelectAvatar: _selectAvatar,
                    courseAvatarPath: widget.course?.avatarPath,
                    errors: _errors['avt'],
                  ),
                  CategorySelector(
                    selectedCategoryIds: _selectedCategoryIds,
                    onCategorySelected: (ids) {
                      setState(() {
                        _selectedCategoryIds = ids;
                        if (ids.isNotEmpty) _errors['categories'] = null;
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
                  ChapterList(
                    showCreateButton:
                        widget.course?.id != null && widget.course?.id != 0,
                    chapters: _chapters,
                    courseId: widget.course?.id,
                    onEditChapter: (chapter) => _editChapter(context, chapter),
                    onDeleteChapter: _deleteChapter,
                    onAddChapter: () => _addChapter(context),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleStateChanges(BuildContext context, TeacherCourseState state) {
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
              title: _titleField.controller.text,
              description: _descriptionField.controller.text,
              price: double.parse(_priceField.controller.text),
              avatarCourse: _selectedAvatar,
            )
          : UpdateCourseRequest(
              categoryIds: _selectedCategoryIds,
              title: _titleField.controller.text,
              description: _descriptionField.controller.text,
              price: double.parse(_priceField.controller.text),
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

  Widget _buildCourseFormFields() {
    return Column(
      children: [
        _titleField.generateTextField((value) {
          setState(() {
            if (value.isNotEmpty) _errors['title'] = null;
          });
        }),
        _descriptionField.generateTextField((value) {
          setState(() {
            if (value.isNotEmpty) _errors['description'] = null;
          });
        }),
        _priceField.generateTextField((value) {
          setState(() {
            if (value.isNotEmpty &&
                double.tryParse(value) != null &&
                double.parse(value) > 0) {
              _errors['price'] = null;
            }
          });
        }),
      ],
    );
  }
}
