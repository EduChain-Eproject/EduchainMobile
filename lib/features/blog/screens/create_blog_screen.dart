import 'dart:io';

import 'package:educhain/core/models/blog_category.dart';
import 'package:educhain/core/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../bloc/blog_bloc.dart';
import '../models/create_blog_request.dart';

class CreateBlogScreen extends StatefulWidget {
  const CreateBlogScreen({super.key});

  @override
  _CreateBlogScreenState createState() => _CreateBlogScreenState();
}

class _CreateBlogScreenState extends State<CreateBlogScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _textController = TextEditingController();
  BlogCategory? _selectedCategory;
  XFile? _photo;
  late BlogBloc _blogBloc;
  List<BlogCategory> _categories = [];

  @override
  void initState() {
    super.initState();
    _blogBloc = BlocProvider.of<BlogBloc>(context);
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final response = await _blogBloc.blogService.fetchBlogCategories();
      if (response.isSuccess) {
        setState(() {
          _categories = response.data!;
        });
      } else {
        _showSnackBar('Error fetching categories: ${response.error}');
      }
    } catch (error) {
      _showSnackBar('Error fetching categories: $error');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _photo = image;
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_photo == null) {
        _showSnackBar('Please select a photo');
        return;
      }

      final request = CreateBlogRequest(
        title: _titleController.text,
        blogCategoryId: _selectedCategory!.id!,
        blogText: _textController.text,
        photo: _photo,
      );

      _blogBloc.add(CreateBlog(request));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BlogBloc, BlogState>(
      listener: (context, state) {
        if (state is BlogSaved) {
          _showSnackBar('Blog created successfully');
          Navigator.pop(context);
        } else if (state is BlogSaveError) {
          _showSnackBar('Error: ${state.errors}');
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Create Blog')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitleField(),
                    const SizedBox(height: 16),
                    _buildCategoryDropdown(),
                    const SizedBox(height: 16),
                    _buildTextField(),
                    const SizedBox(height: 16),
                    _buildUploadButton(),
                    const SizedBox(height: 16),
                    if (_photo != null) _buildPhotoPreview(),
                    const SizedBox(height: 16),
                    _buildCreateBlogButton(state),
                    if (state is BlogSaving) const Loader(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      decoration: const InputDecoration(
        labelText: 'Title',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a title';
        }
        return null;
      },
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<BlogCategory>(
      value: _selectedCategory,
      decoration: const InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      ),
      items: _categories.map((category) {
        return DropdownMenuItem(
          value: category,
          child: Text(
            category.categoryName ?? '',
            style: const TextStyle(color: Colors.black),
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedCategory = value;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Please select a category';
        }
        return null;
      },
      style: const TextStyle(color: Colors.black),
    );
  }

  Widget _buildTextField() {
    return TextFormField(
      controller: _textController,
      decoration: const InputDecoration(
        labelText: 'Text',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      ),
      maxLines: 5,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the blog text';
        }
        return null;
      },
    );
  }

  Widget _buildUploadButton() {
    return ElevatedButton.icon(
      onPressed: _pickImage,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      ),
      icon: const Icon(Icons.upload_file),
      label: const Text('Upload Photo'),
    );
  }

  Widget _buildPhotoPreview() {
    return Container(
      margin: const EdgeInsets.only(top: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.file(
          File(_photo!.path),
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildCreateBlogButton(BlogState state) {
    return ElevatedButton(
      onPressed: state is! BlogSaving ? _submitForm : null,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      ),
      child: const Text('Create Blog'),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _textController.dispose();
    super.dispose();
  }
}
