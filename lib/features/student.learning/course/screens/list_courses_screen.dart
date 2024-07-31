import 'package:educhain/core/models/category.dart';
import 'package:educhain/init_dependency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/course_bloc.dart';
import '../models/course_search_request.dart';
import '../widgets/category_dropdown.dart';
import '../widgets/course_list.dart';
import '../widgets/course_search_bar.dart';

class CourseListScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  _CourseListScreenState createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  late CourseBloc _courseBloc;
  String _searchQuery = '';
  List<Category> _categories = [];
  int _currentPage = 0;
  String _sortBy = 'title';

  @override
  void initState() {
    super.initState();
    _courseBloc = getIt<CourseBloc>();
    _courseBloc.add(FetchCategories());
    _searchCourses();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _courseBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Courses'),
          actions: [
            PopupMenuButton<String>(
              onSelected: _onSortOptionSelected,
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(value: 'title', child: Text('Sort by Title')),
                  PopupMenuItem(value: 'price', child: Text('Sort by Price')),
                ];
              },
              icon: const Icon(Icons.sort),
            ),
          ],
        ),
        body: Column(
          children: [
            CourseSearchBar(onSearch: _searchCourses),
            CategoryDropdown(
              categories: _categories,
              onCategorySelected: _searchCourses,
            ),
            Expanded(
              child: BlocConsumer<CourseBloc, CourseState>(
                listener: (context, state) {
                  if (state is CategoriesLoaded) {
                    setState(() {
                      _categories = state.categories;
                    });
                  } else if (state is CoursesLoaded) {
                    // Update the page number for pagination
                    setState(() {
                      _currentPage = state.courses.number;
                    });
                  }
                },
                builder: (context, state) {
                  if (state is CategoriesLoading || state is CoursesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is CategoriesError) {
                    return Center(child: Text('Error: ${state.message}'));
                  } else if (state is CoursesError) {
                    return Center(child: Text('Error: ${state.message}'));
                  } else if (state is CoursesLoaded) {
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
      ),
    );
  }

  void _searchCourses(
      [String? searchQuery, int? selectedCategory, bool? isLoadingMore]) {
    setState(() {
      if (searchQuery != null) _searchQuery = searchQuery;
    });

    final selectedCategoryIds = <int>[];

    if (selectedCategory != null) {
      selectedCategoryIds.add(selectedCategory);
    } else {
      selectedCategoryIds.clear();
    }

    final searchRequest = CourseSearchRequest(
      search: _searchQuery,
      page: _currentPage,
      sortBy: _sortBy,
      categoryIds: selectedCategoryIds,
    );

    bool more = isLoadingMore != null ? true : false;

    _courseBloc.add(SearchCourses(searchRequest, isLoadingMore: more));
  }

  void _loadMoreCourses() {
    setState(() {
      _currentPage++;
    });
    _searchCourses('', null, true);
  }

  void _onSortOptionSelected(String sortOption) {
    setState(() {
      _sortBy = sortOption;
    });
    _searchCourses();
  }
}
