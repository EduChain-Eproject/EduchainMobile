import 'dart:io';
import 'package:educhain/core/models/blog.dart';
import 'package:educhain/core/models/blog_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../bloc/blog_bloc.dart';
import '../models/update_blog_request.dart';

class UpdateBlogScreen extends StatefulWidget {
  final Blog blog;

  const UpdateBlogScreen({Key? key, required this.blog}) : super(key: key);

  @override
  _UpdateBlogScreenState createState() => _UpdateBlogScreenState();
}

class _UpdateBlogScreenState extends State<UpdateBlogScreen> {
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
    _titleController.text = widget.blog.title ?? '';
    _textController.text = widget.blog.blogText ?? '';
    _selectedCategory = widget.blog.blogCategory;
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
      final request = UpdateBlogRequest(
        title: _titleController.text,
        blogCategoryId: _selectedCategory!.id!,
        blogText: _textController.text,
        photo: _photo,
      );

      _blogBloc.add(UpdateBlog(widget.blog.id!, request));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Blog')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display the old image if it exists
              if (widget.blog.photo != null && _photo == null)
                Column(
                  children: [
                    Image.network(
                      'http://127.0.0.1:8080/uploads/${widget.blog.photo!}',
                      fit: BoxFit.cover,
                      height: 200,
                      width: double.infinity,
                    ),
                    SizedBox(height: 16),
                  ],
                ),
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
                value: _categories.isNotEmpty
                    ? _categories.firstWhere(
                        (category) => category.id == _selectedCategory?.id,
                        orElse: () => _categories.first)
                    : null,
                decoration: InputDecoration(labelText: 'Category'),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category.categoryName ?? ''),
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
                child: Text('Upload New Photo'),
              ),
              if (_photo != null) ...[
                SizedBox(height: 16),
                Image.file(File(_photo!.path)),
              ],
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Update Blog'),
              ),
              BlocListener<BlogBloc, BlogState>(
                listener: (context, state) {
                  if (state is BlogUpdated) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Blog updated successfully')),
                    );
                    Navigator.pop(context);
                  } else if (state is BlogUpdateError) {
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
