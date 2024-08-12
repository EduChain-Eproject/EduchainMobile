import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:educhain/core/theme/app_pallete.dart';
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
    _searchCourses();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _courseBloc,
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        onChanged: (value) {
                          _searchQuery = value;
                          _searchCourses();
                        },
                        decoration: const InputDecoration(
                          hintText: 'Find Course',
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text(
                          'Choice your course',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppPallete.lightWhiteColor,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.filter_list),
                          onPressed: () {
                            setState(() {
                              _showFilter = !_showFilter;
                            });
                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            child: Text('All'),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            child: Text('Popular'),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            child: Text('New'),
                          ),
                        ],
                      ),
                    ),
                    BlocBuilder<CourseBloc, CourseState>(
                      builder: (context, state) {
                        if (state is CoursesLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state is CoursesError) {
                          return Center(child: Text('Error: ${state.message}'));
                        } else if (state is CoursesLoaded) {
                          final courses = state.courses.content;
                          return Column(children: [
                            Column(
                              children: courses.map((course) {
                                return CourseCard(course: course);
                              }).toList(),
                            ),
                            if (_currentPage < state.courses.totalPages - 1)
                              TextButton(
                                onPressed: _loadMoreCourses,
                                child: const Text('Load More'),
                              ),
                          ]);
                        } else {
                          return const Center(
                              child: Text('No courses available'));
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            if (_showFilter)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showFilter = false;
                  });
                },
                child: Container(
                  color: Colors.grey.withOpacity(0.5),
                ),
              ),
            if (_showFilter)
              Positioned(
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
              ),
          ],
        ),
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
