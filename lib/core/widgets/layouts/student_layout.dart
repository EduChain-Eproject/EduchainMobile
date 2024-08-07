import 'package:educhain/Untitled-1.dart';
import 'package:educhain/features/profile/screens/profile_screen.dart';
import 'package:flutter/material.dart';

import 'package:educhain/features/student.learning/course/screens/list_courses_screen.dart';
import 'package:educhain/features/student/screens/student_home_screen.dart';

import '../authenticated_widget.dart';

class StudentLayout extends StatefulWidget {
  final int initialPage;
  final int? selectedCategory;

  static route({int initialPage = 0, int? selectedCategory}) =>
      MaterialPageRoute(
        builder: (context) => AuthenticatedWidget(
            child: StudentLayout(
                initialPage: initialPage, selectedCategory: selectedCategory)),
      );

  const StudentLayout(
      {Key? key, required this.initialPage, this.selectedCategory})
      : super(key: key);

  @override
  _StudentLayoutState createState() => _StudentLayoutState();
}

class _StudentLayoutState extends State<StudentLayout> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialPage);
    _currentIndex = widget.initialPage;
  }

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
          children: [
            StudentHomeScreen(),
            CourseListScreen(selectedCategory: widget.selectedCategory),
            ProfileScreen(),
            TestPage()
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
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.telegram),
              label: 'test',
            ),
          ],
        ));
  }
}
