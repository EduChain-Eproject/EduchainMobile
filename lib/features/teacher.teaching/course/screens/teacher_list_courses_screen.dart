import 'package:educhain/init_dependency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/teacher_course_bloc.dart';
import '../models/course_search_request.dart';
import '../widgets/course_list.dart';
import '../widgets/course_search_bar.dart';
import 'teacher_course_form_screen.dart';

class TeacherCourseListScreen extends StatefulWidget {
  static Route route() => MaterialPageRoute(
        builder: (context) => const TeacherCourseListScreen(),
      );

  const TeacherCourseListScreen({super.key});

  @override
  _TeacherCourseListScreenState createState() =>
      _TeacherCourseListScreenState();
}

class _TeacherCourseListScreenState extends State<TeacherCourseListScreen> {
  late TeacherCourseBloc _courseBloc;
  String _searchQuery = '';
  int _currentPage = 0;
  String _sortBy = 'title';

  @override
  void initState() {
    super.initState();
    _courseBloc = getIt<TeacherCourseBloc>();
    _searchCourses();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _courseBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My TeacherCourses'),
          actions: [
            PopupMenuButton<String>(
              onSelected: _onSortOptionSelected,
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem(
                      value: 'title', child: Text('Sort by Title')),
                  const PopupMenuItem(
                      value: 'price', child: Text('Sort by Price')),
                ];
              },
              icon: const Icon(Icons.sort),
            ),
          ],
        ),
        body: Column(
          children: [
            CourseSearchBar(onSearch: _searchCourses),
            Expanded(
              child: BlocConsumer<TeacherCourseBloc, TeacherCourseState>(
                listener: (context, state) {
                  if (state is TeacherCoursesLoaded) {
                    // Update the page number for pagination
                    setState(() {
                      _currentPage = state.courses.number;
                    });
                  }
                },
                builder: (context, state) {
                  if (state is TeacherCoursesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is TeacherCoursesError) {
                    return Center(child: Text('Error: ${state.message}'));
                  } else if (state is TeacherCoursesLoaded) {
                    final courses = state.courses.content;
                    return Column(
                      children: [
                        Expanded(child: CourseList(courses: courses)),
                        if (state.courses.number < state.courses.totalPages - 1)
                          TextButton(
                            onPressed: _loadMoreCourses,
                            child: const Text('Load More'),
                          ),
                      ],
                    );
                  } else {
                    return const Center(child: Text('No courses available'));
                  }
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _createNewCourse,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _searchCourses([String? searchQuery, bool? isLoadingMore]) {
    setState(() {
      if (searchQuery != null) _searchQuery = searchQuery;
    });

    final searchRequest = CourseSearchRequest(
      search: _searchQuery,
      page: _currentPage,
      sortBy: _sortBy,
      categoryIds: [],
    );

    _courseBloc.add(FetchTeacherCourses(searchRequest,
        isLoadingMore: isLoadingMore != null));
  }

  void _loadMoreCourses() {
    setState(() {
      _currentPage++;
    });
    _searchCourses('', true);
  }

  void _onSortOptionSelected(String sortOption) {
    setState(() {
      _sortBy = sortOption;
    });
    _searchCourses();
  }

  void _createNewCourse() {
    Navigator.push(context, TeacherCourseFormScreen.route(null));
  }
}
