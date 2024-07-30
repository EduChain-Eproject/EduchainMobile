import 'package:educhain/core/models/category.dart';
import 'package:educhain/init_dependency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/course_bloc.dart';
import '../models/course_search_request.dart';
import 'course_detail_screen.dart';

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
        .add(SearchCourses(CourseSearchRequest(search: "", categoryIds: [])));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _courseBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Courses'),
        ),
        body: Column(
          children: [
            _buildSearchBar(),
            _buildCategoryDropdown(),
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
                  if (state is CategoriesLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is CategoriesError) {
                    return Center(child: Text('Error: ${state.message}'));
                  } else if (state is CoursesLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is CoursesLoaded) {
                    // for the first time, course not loaded here
                    final courses = state.courses.content;
                    return ListView.builder(
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        final course = courses[index];
                        return ListTile(
                          title: Text(course.title ?? ""),
                          subtitle: Text(course.description ?? ""),
                          onTap: () {
                            if (course.id != null) {
                              Navigator.push(
                                context,
                                CourseDetailScreen.route(course.id!),
                              );
                            }
                          },
                        );
                      },
                    );
                  } else {
                    return Center(child: Text('No courses available'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: 'Search Courses',
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
          _searchCourses(null);
        },
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<int>(
      hint: Text('Select Category'),
      items: _categories
          .map((category) => DropdownMenuItem<int>(
                value: category.id,
                child: Text(category.categoryName ?? ""),
              ))
          .toList(),
      onChanged: (selectedCategory) {
        _searchCourses(selectedCategory);
      },
    );
  }

  void _searchCourses(int? selectedCategory) {
    final selectedCategoryIds = <int>[];

    // Add selectedCategory to the list if it is not null
    if (selectedCategory != null) {
      selectedCategoryIds.add(selectedCategory);
    }

    final searchRequest = CourseSearchRequest(
      search: _searchQuery,
      categoryIds: selectedCategoryIds,
    );

    _courseBloc.add(SearchCourses(searchRequest));
  }
}
