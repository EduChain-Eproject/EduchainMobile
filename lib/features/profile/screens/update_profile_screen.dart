import 'dart:io';

import 'package:educhain/core/models/user.dart';
import 'package:educhain/core/theme/app_pallete.dart';
import 'package:educhain/core/widgets/authenticated_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../bloc/profile_bloc.dart';
import '../models/update_user_request.dart';

class UpdateProfileScreen extends StatefulWidget {
  static Route route(User user) => MaterialPageRoute(
      builder: (context) =>
          AuthenticatedWidget(child: UpdateProfileScreen(user)));

  final User user;

  const UpdateProfileScreen(this.user);

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late String firstName;
  late String lastName;
  late String phone;
  late String address;

  final ImagePicker _picker = ImagePicker();
  XFile? _avatarFile;

  Map<String, dynamic>? _errors;

  @override
  void initState() {
    super.initState();
    firstName = widget.user.firstName!;
    lastName = widget.user.lastName!;
    phone = widget.user.phone ?? '';
    address = widget.user.address ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Update Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent, // Custom color instead of primary
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdated) {
            Navigator.of(context).pop();
          } else if (state is ProfileUpdateError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.error}')),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildAvatarSection(),
                const SizedBox(height: 20),
                _buildReadOnlyField(
                  label: 'Email',
                  value: widget.user.email ?? '',
                ),
                _buildTextField(
                  label: 'First Name',
                  initialValue: firstName,
                  onChanged: (value) => firstName = value,
                  validator: (value) =>
                      value!.isEmpty ? 'Enter first name' : null,
                ),
                _buildTextField(
                  label: 'Last Name',
                  initialValue: lastName,
                  onChanged: (value) => lastName = value,
                  validator: (value) =>
                      value!.isEmpty ? 'Enter last name' : null,
                ),
                _buildTextField(
                  label: 'Phone',
                  initialValue: phone,
                  onChanged: (value) => phone = value,
                ),
                _buildTextField(
                  label: 'Address',
                  initialValue: address,
                  onChanged: (value) => address = value,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final request = UpdateUserRequest(
                        firstName: firstName,
                        lastName: lastName,
                        phone: phone,
                        address: address,
                        avatarFile: _avatarFile,
                      );
                      context.read<ProfileBloc>().add(UpdateProfile(request));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Update Profile',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Column(
      children: [
        if (_avatarFile == null && widget.user.avatarPath != null)
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(widget.user.avatarPath ?? ""),
          ),
        if (_avatarFile != null)
          CircleAvatar(
            radius: 50,
            backgroundImage: FileImage(File(_avatarFile!.path)),
          ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: _pickAvatar,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(
                255, 207, 68, 58), // Custom color for avatar button
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text(
            'Select Avatar',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
        if (_errors?['avatarFile'] != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              _errors?['avatarFile'],
              style: const TextStyle(color: Colors.redAccent),
            ),
          ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
    required Function(String) onChanged,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.deepPurple),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.blue,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1.5,
            ),
          ),
        ),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }

  Widget _buildReadOnlyField({
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.deepPurple),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.blue,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1.5,
            ),
          ),
        ),
        readOnly: true, // Prevent editing
      ),
    );
  }

  Future<void> _pickAvatar() async {
    try {
      final XFile? avatar =
          await _picker.pickImage(source: ImageSource.gallery);
      if (avatar != null) {
        setState(() {
          _avatarFile = avatar;
          _errors?.remove('avatarFile');
        });
      }
    } catch (e) {
      setState(() {
        _errors = {'avatarFile': 'Failed to pick Avatar: $e'};
      });
    }
  }
}
