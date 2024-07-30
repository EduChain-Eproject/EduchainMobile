import 'package:flutter/material.dart';

import 'package:educhain/features/student.learning/course/screens/list_courses_screen.dart';
import 'package:educhain/features/student/screens/student_home_screen.dart';

import '../authenticated_widget.dart';

class StudentLayout extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const AuthenticatedWidget(child: StudentLayout()),
      );

  const StudentLayout({Key? key}) : super(key: key);

  @override
  _StudentLayoutState createState() => _StudentLayoutState();
}

class _StudentLayoutState extends State<StudentLayout> {
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
            StudentHomeScreen(),
            CourseListScreen(),
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
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Courses',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.person),
            //   label: 'Profile',
            // ),
          ],
        ));
  }
}
