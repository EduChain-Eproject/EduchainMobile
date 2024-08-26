import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:educhain/init_dependency.dart';
import '../blocs/course/course_bloc.dart';
import '../models/course_search_request.dart';
import '../widgets/course_card.dart';
import '../widgets/filter_bar.dart';

class CourseListScreen extends StatefulWidget {
  final int? selectedCategory;

  const CourseListScreen({super.key, this.selectedCategory});

  @override
  _CourseListScreenState createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  late CourseBloc _courseBloc;
  bool _showFilter = false;
  String _searchQuery = '';
  int _currentPage = 0;
  String _sortBy = 'title';
  List<int> _selectedCategoryIds = [];

  @override
  void initState() {
    super.initState();
    _courseBloc = getIt<CourseBloc>();
    if (widget.selectedCategory != null) {
      _selectedCategoryIds.add(widget.selectedCategory!);
    }
    _searchCourses();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _courseBloc,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSearchBar(),
                    _buildTitleWithFilterButton(),
                    _buildCourseList(),
                  ],
                ),
              ),
            ),
            if (_showFilter) _buildFilterOverlay(),
            if (_showFilter) _buildFilterPanel(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
          _searchCourses();
        },
        decoration: InputDecoration(
          hintText: 'Find Course',
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildTitleWithFilterButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Choose Your Course',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.black),
            onPressed: () {
              setState(() {
                _showFilter = !_showFilter;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCourseList() {
    return BlocBuilder<CourseBloc, CourseState>(
      builder: (context, state) {
        if (state is CoursesLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is CoursesError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Error: ${state.message}',
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else if (state is CoursesLoaded) {
          final courses = state.courses.content;
          return Column(
            children: [
              ...courses.map((course) => CourseCard(course: course)).toList(),
              if (_currentPage < state.courses.totalPages - 1)
                TextButton(
                  onPressed: _loadMoreCourses,
                  child: const Text('Load More'),
                ),
            ],
          );
        } else {
          return const Center(
            child: Text(
              'No courses available',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }
      },
    );
  }

  Widget _buildFilterOverlay() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showFilter = false;
        });
      },
      child: Container(
        color: Colors.black.withOpacity(0.5),
      ),
    );
  }

  Widget _buildFilterPanel() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: FilterBar(
        onApplyFilter: (sortBy, selectedCategoryIds) {
          setState(() {
            _selectedCategoryIds = selectedCategoryIds;
            _sortBy = sortBy;
            _showFilter = false;
          });
          _searchCourses();
        },
        initialSelectedCategoryIds: _selectedCategoryIds,
      ),
    );
  }

  void _searchCourses([bool? isLoadingMore]) {
    final searchRequest = CourseSearchRequest(
      search: _searchQuery,
      page: _currentPage,
      sortBy: _sortBy,
      categoryIds: _selectedCategoryIds,
    );

    _courseBloc.add(
        SearchCourses(searchRequest, isLoadingMore: isLoadingMore != null));
  }

  void _loadMoreCourses() {
    setState(() {
      _currentPage++;
    });
    _searchCourses(true);
  }
}
