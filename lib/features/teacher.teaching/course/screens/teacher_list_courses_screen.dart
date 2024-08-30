import 'package:educhain/init_dependency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/course/teacher_course_bloc.dart';
import '../models/course_search_request.dart';
import '../widgets/course_list.dart';
import '../widgets/course_search_bar.dart';
import 'teacher_course_form_screen.dart';

class TeacherCourseListScreen extends StatefulWidget {
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
          title: const Text('My Teacher Courses'),
          actions: [
            _buildSortMenu(),
          ],
        ),
        body: Column(
          children: [
            CourseSearchBar(onSearch: _onSearchChanged),
            Expanded(
              child: BlocConsumer<TeacherCourseBloc, TeacherCourseState>(
                listener: _blocListener,
                builder: _blocBuilder,
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

  Widget _buildSortMenu() {
    return PopupMenuButton<String>(
      onSelected: _onSortOptionSelected,
      itemBuilder: (BuildContext context) {
        return const [
          PopupMenuItem(value: 'title', child: Text('Sort by Title')),
          PopupMenuItem(value: 'price', child: Text('Sort by Price')),
        ];
      },
      icon: const Icon(Icons.sort),
    );
  }

  void _onSearchChanged(String searchQuery) {
    _searchCourses(searchQuery: searchQuery);
  }

  void _blocListener(BuildContext context, TeacherCourseState state) {
    if (state is TeacherCoursesLoaded) {
      setState(() {
        _currentPage = state.courses.number;
      });
    }
  }

  Widget _blocBuilder(BuildContext context, TeacherCourseState state) {
    if (state is TeacherCoursesLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is TeacherCoursesError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Error: ${state.errors?['message']}',
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    } else if (state is TeacherCoursesLoaded) {
      final courses = state.courses.content;
      return Column(
        children: [
          Expanded(child: CourseList(courses: courses)),
          if (_hasMorePages(state)) _buildLoadMoreButton(),
        ],
      );
    } else {
      return const Center(child: Text('No courses available'));
    }
  }

  bool _hasMorePages(TeacherCoursesLoaded state) {
    return state.courses.number < state.courses.totalPages - 1;
  }

  Widget _buildLoadMoreButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: _loadMoreCourses,
        child: const Text('Load More'),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.blueAccent,
        ),
      ),
    );
  }

  void _searchCourses({String? searchQuery, bool isLoadingMore = false}) {
    _searchQuery = searchQuery ?? _searchQuery;

    final searchRequest = CourseSearchRequest(
      search: _searchQuery,
      page: isLoadingMore ? _currentPage + 1 : 0,
      sortBy: _sortBy,
    );

    _courseBloc
        .add(FetchTeacherCourses(searchRequest, isLoadingMore: isLoadingMore));
  }

  void _loadMoreCourses() {
    _searchCourses(isLoadingMore: true);
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
