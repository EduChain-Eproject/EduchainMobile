import 'dart:io';

import 'package:educhain/core/models/blog_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../bloc/blog_bloc.dart';
import '../models/create_blog_request.dart';

class CreateBlogScreen extends StatefulWidget {
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error fetching categories: ${response.error}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching categories: $error')),
      );
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _photo = image;
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_photo == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a photo')),
        );
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
    return Scaffold(
      appBar: AppBar(title: Text('Create Blog')),
      body: SingleChildScrollView(
        // <--- Wrap with SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<BlogCategory>(
                value: _selectedCategory,
                decoration: InputDecoration(labelText: 'Category'),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(
                      category.categoryName ?? '',
                      style: TextStyle(color: Colors.black),
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
              ),
              TextFormField(
                controller: _textController,
                decoration: InputDecoration(labelText: 'Text'),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the blog text';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Upload Photo'),
              ),
              if (_photo != null) ...[
                SizedBox(height: 16),
                Image.file(File(_photo!.path)),
              ],
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Create Blog'),
              ),
              BlocListener<BlogBloc, BlogState>(
                listener: (context, state) {
                  if (state is BlogSaved) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Blog created successfully')),
                    );
                    Navigator.pop(context);
                  } else if (state is BlogSaveError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${state.errors}')),
                    );
                  }
                },
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _textController.dispose();
    super.dispose();
  }
}
