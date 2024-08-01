import 'package:flutter/material.dart';

class CourseSearchBar extends StatelessWidget {
  final Function(String, bool?) onSearch;

  const CourseSearchBar({Key? key, required this.onSearch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: const InputDecoration(
          labelText: 'Search Courses',
          border: OutlineInputBorder(),
        ),
        onChanged: (e) => onSearch(e, false),
      ),
    );
  }
}
