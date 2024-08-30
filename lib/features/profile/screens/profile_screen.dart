import 'package:educhain/core/auth/bloc/auth_bloc.dart';
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
        title: const Text('Profile'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(user!.avatarPath ??
                                'https://via.placeholder.com/150'),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            '${user!.firstName} ${user!.lastName}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.email,
                                      color: Colors.blue, size: 24),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(user!.email ?? 'N/A'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.phone,
                                      color: Colors.green, size: 24),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(user!.phone ?? 'N/A'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.home,
                                      color: Colors.red, size: 24),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(user!.address ?? 'N/A'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (user!.role == 'STUDENT') ...[
                    _buildActionCard(
                      context,
                      icon: Icons.book,
                      color: Colors.blue,
                      title: 'My Courses',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider.value(
                              value: context.read<PersonalBloc>(),
                              child: const FetchParticipatedCoursesPage(),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildActionCard(
                      context,
                      icon: Icons.assignment,
                      color: Colors.green,
                      title: 'My Homeworks',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider.value(
                              value: context.read<PersonalBloc>(),
                              child: const UserHomeworkPage(),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildActionCard(
                      context,
                      icon: Icons.favorite,
                      color: Colors.pink,
                      title: 'My Wishlist',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider.value(
                              value: context.read<PersonalBloc>(),
                              child: const UserInterestsPage(),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                  ] else if (user!.role == 'TEACHER') ...[
                    _buildActionCard(
                      context,
                      icon: Icons.book,
                      color: Colors.blue,
                      title: 'My Courses',
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          TeacherLayout.route(
                            initialPage: 0,
                          ),
                        );
                      },
                    ),
                  ],
                  ...[
                    const SizedBox(height: 8),
                    _buildActionCard(
                      context,
                      icon: Icons.logout,
                      color: Colors.red,
                      title: 'Logout',
                      onTap: () {
                        context.read<AuthBloc>().add(LogOutRequested());
                      },
                    ),
                  ]
                ],
              ),
            );
          } else if (state is ProfileError) {
            return Center(child: Text('Error: ${state.error}'));
          } else {
            return const Center(child: Text('Unknown state'));
          }
        },
      ),
    );
  }

  Widget _buildActionCard(BuildContext context,
      {required IconData icon,
      required Color color,
      required String title,
      required VoidCallback onTap}) {
    return Card(
      elevation: 2,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        leading: Icon(icon, color: color, size: 28),
        title: Text(title,
            style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        onTap: onTap,
      ),
    );
  }
}
