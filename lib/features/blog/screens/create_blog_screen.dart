// import 'dart:io';
// import 'package:educhain/features/blog/bloc/blog_bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:educhain/features/blog/models/create_blog_request.dart';

// class CreateBlogScreen extends StatefulWidget {
//   const CreateBlogScreen({Key? key}) : super(key: key);

//   @override
//   _CreateBlogScreenState createState() => _CreateBlogScreenState();
// }

// class _CreateBlogScreenState extends State<CreateBlogScreen> {
//   final _titleController = TextEditingController();
//   final _blogTextController = TextEditingController();
//   final _picker = ImagePicker();
//   File? _selectedPhoto;
//   int? _selectedCategory;

//   @override
//   void initState() {
//     super.initState();
//     // Fetch categories when the screen is initialized
//     context.read<BlogBloc>().add(FetchBlogCategories());
//   }

//   Future<void> _pickImage() async {
//     try {
//       final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//       if (pickedFile != null) {
//         setState(() {
//           _selectedPhoto = File(pickedFile.path);
//         });
//       } else {
//         print('No image selected.');
//       }
//     } catch (e) {
//       print('Error picking image: $e');
//     }
//   }

//   void _submit() {
//     if (_titleController.text.isEmpty ||
//         _blogTextController.text.isEmpty ||
//         _selectedCategory == null ||
//         _selectedPhoto == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please fill all fields')),
//       );
//       return;
//     }

//     final request = CreateBlogRequest(
//       title: _titleController.text,
//       userId: 1, // Replace with the actual user ID
//       blogCategoryId: _selectedCategory!,
//       blogText: _blogTextController.text,
//       // If your request object needs a photo path, include it here. Otherwise, handle the file upload separately.
//     );

//     // Dispatch the CreateBlog event with filePath and CreateBlogRequest
//     //context.read<BlogBloc>().add(CreateBlog(_selectedPhoto!.path, request));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Create Blog')),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: BlocConsumer<BlogBloc, BlogState>(
//             listener: (context, state) {
//               if (state is BlogCreated) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Blog created successfully')),
//                 );
//                 Navigator.of(context).pop();
//               } else if (state is BlogCreateError) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('Error: ${state.message}')),
//                 );
//               }
//             },
//             builder: (context, state) {
//               if (state is BlogCategoriesLoading) {
//                 return const Center(child: CircularProgressIndicator());
//               } else if (state is BlogCategoriesError) {
//                 return Center(child: Text('Error: ${state.message}'));
//               } else if (state is BlogCategoriesLoaded) {
//                 final categories = state.categories;
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     TextField(
//                       controller: _titleController,
//                       decoration: const InputDecoration(labelText: 'Title'),
//                     ),
//                     const SizedBox(height: 8.0),
//                     DropdownButtonFormField<int>(
//                       value: _selectedCategory,
//                       hint: const Text('Select Category'),
//                       items: categories.map((category) {
//                         return DropdownMenuItem<int>(
//                           value: category.id,
//                           child:
//                               Text(category.categoryName ?? 'Unknown Category'),
//                         );
//                       }).toList(),
//                       onChanged: (value) {
//                         setState(() {
//                           _selectedCategory = value;
//                         });
//                       },
//                     ),
//                     const SizedBox(height: 8.0),
//                     TextField(
//                       controller: _blogTextController,
//                       decoration: const InputDecoration(labelText: 'Blog Text'),
//                       maxLines: 5,
//                     ),
//                     const SizedBox(height: 8.0),
//                     _selectedPhoto == null
//                         ? const Text('No photo selected')
//                         : Image.file(_selectedPhoto!),
//                     ElevatedButton(
//                       onPressed: _pickImage,
//                       child: const Text('Pick Image'),
//                     ),
//                     const SizedBox(height: 16.0),
//                     state is BlogCreating
//                         ? const Center(child: CircularProgressIndicator())
//                         : ElevatedButton(
//                             onPressed: _submit,
//                             child: const Text('Submit'),
//                           ),
//                   ],
//                 );
//               } else {
//                 return const Center(child: Text('Unexpected state'));
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
