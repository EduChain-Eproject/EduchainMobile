import 'dart:io';

import 'package:educhain/core/models/user.dart';
import 'package:educhain/core/theme/app_pallete.dart';
import 'package:educhain/core/widgets/authenticated_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../bloc/profile_bloc.dart';
import '../update_user_request.dart';

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
      appBar: AppBar(title: const Text('Update Profile')),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  initialValue: firstName,
                  decoration: const InputDecoration(labelText: 'First Name'),
                  onChanged: (value) => firstName = value,
                  validator: (value) =>
                      value!.isEmpty ? 'Enter first name' : null,
                ),
                TextFormField(
                  initialValue: lastName,
                  decoration: const InputDecoration(labelText: 'Last Name'),
                  onChanged: (value) => lastName = value,
                  validator: (value) =>
                      value!.isEmpty ? 'Enter last name' : null,
                ),
                TextFormField(
                  initialValue: phone,
                  decoration: const InputDecoration(labelText: 'Phone'),
                  onChanged: (value) => phone = value,
                ),
                TextFormField(
                  initialValue: address,
                  decoration: const InputDecoration(labelText: 'Address'),
                  onChanged: (value) => address = value,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final request = UpdateUserRequest(
                        firstName: firstName,
                        lastName: lastName,
                        phone: phone,
                        address: address,
                      );
                      context.read<ProfileBloc>().add(UpdateProfile(request));
                    }
                  },
                  child: const Text('Update Profile'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _pickAvatar,
                  child: const Text('Select Avatar'),
                ),
                if (_avatarFile != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Image.file(
                      File(_avatarFile!.path),
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                if (_avatarFile == null && widget.user.avatarPath != null)
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.user.avatarPath ?? ""),
                  ),
                if (_errors?['avatarFile'] != null)
                  Text(
                    _errors?['avatarFile'],
                    style: const TextStyle(color: AppPallete.lightErrorColor),
                  ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
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
