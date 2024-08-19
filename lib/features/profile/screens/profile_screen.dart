import 'package:educhain/core/models/user.dart';
import 'package:educhain/core/widgets/layouts/teacher_layout.dart';
import 'package:educhain/features/student.personal/bloc/personal_bloc.dart';
import 'package:educhain/features/student.personal/screens/participated_courses.dart';
import 'package:educhain/features/student.personal/screens/user_homeworks.dart';
import 'package:educhain/features/student.personal/screens/user_interest.dart';
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
  User? user;

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(GetProfile());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              if (user != null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => UpdateProfileScreen(user!),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            user = state.user; // Cập nhật thông tin người dùng
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 5,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16.0),
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(user!.avatarPath ??
                            'https://via.placeholder.com/150'),
                      ),
                      title: Text(
                        '${user!.firstName} ${user!.lastName}',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(user!.email!),
                    ),
                  ),
                  SizedBox(height: 16),
                  Card(
                    elevation: 2,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16.0),
                      title: Text('Phone',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(user!.phone ?? 'N/A'),
                    ),
                  ),
                  SizedBox(height: 8),
                  Card(
                    elevation: 2,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16.0),
                      title: Text('Address',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(user!.address ?? 'N/A'),
                    ),
                  ),
                  SizedBox(height: 16),
                  if (user!.role == 'STUDENT') ...[
                    Card(
                      elevation: 2,
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16.0),
                        title: Text('My Courses'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider.value(
                                value: context.read<PersonalBloc>(),
                                child: FetchParticipatedCoursesPage(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 8),
                    Card(
                      elevation: 2,
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16.0),
                        title: Text('My Homeworks'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider.value(
                                value: context.read<PersonalBloc>(),
                                child: UserHomeworkPage(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 8),
                    Card(
                      elevation: 2,
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16.0),
                        title: Text('My Wishlist'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider.value(
                                value: context.read<PersonalBloc>(),
                                child: UserInterestsPage(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ] else if (user!.role == 'TEACHER') ...[
                    Card(
                      elevation: 2,
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16.0),
                        title: Text('My Courses'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TeacherLayout.route(
                                initialPage: 1,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                  SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => UpdateProfileScreen(user!),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        textStyle: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      child: Text('Update Profile'),
                    ),
                  ),
                ],
              ),
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
