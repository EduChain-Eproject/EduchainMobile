import 'package:flutter/material.dart';

import 'package:educhain/features/teacher/screens/teacher_home_screen.dart';

import '../authenticated_widget.dart';

class TeacherLayout extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const AuthenticatedWidget(
          child: TeacherLayout(),
        ),
      );

  const TeacherLayout({Key? key}) : super(key: key);

  @override
  _TeacherLayoutState createState() => _TeacherLayoutState();
}

class _TeacherLayoutState extends State<TeacherLayout> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: const [
            TeacherHomeScreen(),
            // ProfileScreen(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.grey,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
            _pageController.jumpToPage(index);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.person),
            //   label: 'Profile',
            // ),
          ],
        ));
  }
}
