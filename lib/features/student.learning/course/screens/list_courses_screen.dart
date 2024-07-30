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

  @override
  void initState() {
    super.initState();
    _courseBloc = getIt<CourseBloc>();
    _courseBloc.add(FetchCategories());
    _courseBloc
        .add(SearchCourses(CourseSearchRequest(search: '', categoryIds: [])));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _courseBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Courses'),
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
                    return CourseList(courses: courses);
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

  void _searchCourses(String searchQuery, int? selectedCategory) {
    setState(() {
      _searchQuery = searchQuery;
    });

    final selectedCategoryIds = <int>[];

    if (selectedCategory != null) {
      selectedCategoryIds.add(selectedCategory);
    } else {
      // If "all" is selected, use an empty array to represent all categories
      selectedCategoryIds.clear();
    }

    final searchRequest = CourseSearchRequest(
      search: _searchQuery,
      categoryIds: selectedCategoryIds,
    );

    _courseBloc.add(SearchCourses(searchRequest));
  }
}
