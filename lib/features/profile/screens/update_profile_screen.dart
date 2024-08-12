import 'package:educhain/core/models/user.dart';
import 'package:educhain/core/widgets/authenticated_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  late String email;
  late String firstName;
  late String lastName;
  late String phone;
  late String address;

  @override
  void initState() {
    super.initState();
    email = widget.user.email!;
    firstName = widget.user.firstName!;
    lastName = widget.user.lastName!;
    phone = widget.user.phone ?? '';
    address = widget.user.address ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Profile')),
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
                  initialValue: email,
                  decoration: InputDecoration(labelText: 'Email'),
                  onChanged: (value) => email = value,
                  validator: (value) => value!.isEmpty ? 'Enter email' : null,
                ),
                TextFormField(
                  initialValue: firstName,
                  decoration: InputDecoration(labelText: 'First Name'),
                  onChanged: (value) => firstName = value,
                  validator: (value) =>
                      value!.isEmpty ? 'Enter first name' : null,
                ),
                TextFormField(
                  initialValue: lastName,
                  decoration: InputDecoration(labelText: 'Last Name'),
                  onChanged: (value) => lastName = value,
                  validator: (value) =>
                      value!.isEmpty ? 'Enter last name' : null,
                ),
                TextFormField(
                  initialValue: phone,
                  decoration: InputDecoration(labelText: 'Phone'),
                  onChanged: (value) => phone = value,
                ),
                TextFormField(
                  initialValue: address,
                  decoration: InputDecoration(labelText: 'Address'),
                  onChanged: (value) => address = value,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final request = UpdateUserRequest(
                        email: email,
                        firstName: firstName,
                        lastName: lastName,
                        phone: phone,
                        address: address,
                      );
                      context.read<ProfileBloc>().add(UpdateProfile(request));
                    }
                  },
                  child: Text('Update Profile'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
