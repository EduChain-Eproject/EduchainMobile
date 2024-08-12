import 'package:educhain/core/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/profile_bloc.dart';
import 'update_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(GetProfile());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            User user = state.user;
            return Column(
              children: [
                // Display user information
                ListTile(
                  title: Text('${user.firstName} ${user.lastName}'),
                  subtitle: Text(user.email!),
                ),
                ListTile(
                  title: Text('Phone'),
                  subtitle: Text(user.phone ?? 'N/A'),
                ),
                ListTile(
                  title: Text('Address'),
                  subtitle: Text(user.address ?? 'N/A'),
                ),
                // Display different content based on user role
                if (user.role == 'STUDENT') ...[
                  ListTile(
                    title: Text('My Homeworks'),
                    onTap: () {
                      // Navigate to user's homework screen
                    },
                  ),
                  // Add other student-specific links
                ] else if (user.role == 'TEACHER') ...[
                  ListTile(
                    title: Text('My Courses'),
                    onTap: () {
                      // Navigate to teacher's courses screen
                    },
                  ),
                  // Add other teacher-specific links
                ],
                // Update profile button
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => UpdateProfileScreen(user),
                      ),
                    );
                  },
                  child: Text('Update Profile'),
                ),
              ],
            );
          } else if (state is ProfileError) {
            return Center(child: Text('Error: ${state.error}'));
          } else {
            return Center(child: Text('Unknown state'));
          }
        },
      ),
    );
  }
}
